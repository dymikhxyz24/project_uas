import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uas_project/helper/firestoreHelper.dart';
import 'package:uas_project/service/background_service.dart';
import '../models/product.dart';
import 'cart/carts_product.dart';
import '../helper/analyticsHelper.dart';
import '../views/auth/login.dart';
import '../helper/formatHelper.dart';
import '../helper/httpHelper.dart';
import 'details/detail_product.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late HttpHelper helper;
  List<Product> dataProducts = [];
  late RewardedAd _rewardedAd;
  bool _isRewardedReady = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MyAnalyticsHelper analyticsHelper = MyAnalyticsHelper();
  FirestoreHelper firestoreHelper = FirestoreHelper();

  @override
  void initState() {
    super.initState();
    helper = HttpHelper();
    getProducts();
    FirebaseAnalytics.instance.setUserProperty(name: "MyHome", value: "Home");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var cartProvider = Provider.of<CartProviderV2>(context);
    // cartProvider.setUserEmail(_email!);

    return Scaffold(
      appBar: AppBar(
        title: Text("DidaPedia"),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Color(0xff186F65),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                print(DateTime.now());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartsDetails(),
                  ),
                );
              },
              icon: Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: productList(),
      drawer: drawerBurger(context),
    );
  }

  Padding productList() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 12),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 12),
            elevation: 5,
            child: ListTile(
              leading: Image.network(
                dataProducts[index].image,
                width: 50,
                height: 50,
              ),
              title: Text(
                dataProducts[index].title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              subtitle: Text(CurrencyFormat.convertToIdr(
                  dataProducts[index].price * 15000, 0)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: Color(0xff186F65),
                  ),
                  Text(
                    dataProducts[index].rating.rate.toString(),
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailProduct(
                      product: dataProducts[index],
                      email: _auth.currentUser!.email!,
                    ),
                  ),
                );
              },
            ),
          );
        },
        itemCount: dataProducts.length,
      ),
    );
  }

  Drawer drawerBurger(BuildContext context) {
    String? _email = _auth.currentUser!.email;
    return Drawer(
      child: FutureBuilder<int>(
          future: _loadCoinCount(_email),
          builder: (context, snapshot) {
            int? coinCount = snapshot.data;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Color(0xff186F65)),
                  currentAccountPicture: Image.network(
                      "https://seeklogo.com/images/D/d-p-letter-logo-E428C66ABB-seeklogo.com.png"),
                  accountName: Text(
                    "DidaPedia",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(
                    _email!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.coins),
                  title: Text(coinCount.toString()),
                  onTap: () {
                    _loadRewardedAd();
                    if (_isRewardedReady) {
                      _rewardedAd.show(onUserEarnedReward:
                          (AdWithoutView ad, RewardItem reward) {
                        setState(() {
                          _updateCoinCount(_email, coinCount! + 5);
                        });
                      });
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text("Contact Us"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.abc),
                //   title: Text("Test"),
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (builder) => HomeScreen()));
                //   },
                // ),
                AboutListTile(
                  icon: Icon(Icons.info),
                  child: Text("About app"),
                  applicationIcon: Icon(
                    Icons.shopping_bag,
                    size: 35,
                  ),
                  applicationName: "Dida Pedia",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "@didapediacompany",
                  aboutBoxChildren: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Under Development"),
                    )
                  ],
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.rightFromBracket),
                  title: Text("Log Out"),
                  onTap: () {
                    analyticsHelper.logoutLog(_email);
                    _auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginPage(),
                      ),
                    );
                  },
                )
              ],
            );
          }),
    );
  }

  Future getProducts() async {
    dataProducts = await helper.getProducts();
    setState(() {
      dataProducts = dataProducts;
    });
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: "ca-app-pub-3940256099942544/5224354917",
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _isRewardedReady = false;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _isRewardedReady = true;
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          _isRewardedReady = false;
          _rewardedAd.dispose();
        },
      ),
    );
  }

  Future<int> _loadCoinCount(String? email) async {
    if (email == null) {
      return 0;
    }

    try {
      DocumentSnapshot document =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      if (document.exists) {
        return document['coins'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error loading coin count: $e');
      return 0;
    }
  }

  void _updateCoinCount(String? email, int newCoinCount) {
    if (email != null) {
      firestoreHelper.updateCoins(email, newCoinCount);
    }
  }
}
