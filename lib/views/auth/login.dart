import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../helper/analyticsHelper.dart';
import '../../views/home.dart';
import '../../service/authentication.dart';
import '../auth/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  MyAnalyticsHelper analyticsHelper = MyAnalyticsHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email = "";
  String _password = "";

  bool _signInStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: LoginPageWidget(context),
      ),
    );
  }

  Column LoginPageWidget(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 90, bottom: 50),
          alignment: Alignment.center,
          child: Text(
            "DidaPedia",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xff186F65),
              // letterSpacing: 1=,
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Text(
              "Login to your Account",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, bottom: 20),
                  child: SizedBox(
                    width: 350,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffFCFDF5),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: Offset(2, 2),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Email";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, bottom: 20),
                  child: SizedBox(
                    width: 350,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffFCFDF5),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: Offset(2, 2),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Password',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Password";
                          } else if (value.length < 6) {
                            return "Password should be at least 6 characters";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, bottom: 20),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          analyticsHelper.loginLog(_email);
                          _handleSignIn(_email, _password);
                        }
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff186F65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text("- Or sign in with -"),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OtherSignin(
                icon: FontAwesomeIcons.google,
                onPressed: () {},
              ),
              SizedBox(width: 20),
              OtherSignin(
                icon: FontAwesomeIcons.facebookF,
                onPressed: () {},
              ),
              SizedBox(width: 20),
              OtherSignin(
                icon: FontAwesomeIcons.twitter,
                onPressed: () {},
              ),
            ],
          ),
        ),
        SizedBox(height: 50),
        Text.rich(
          TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: "Sign up",
                style: TextStyle(
                  color: Color(0xff186F65),
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleSignIn(String email, String password) async {
    bool signIn = await authSignIn(email, password);

    setState(() {
      _signInStatus = signIn;
    });

    if (!_signInStatus) {
      Text("Login Invalid");
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MyHome(),
        ),
      );
    }
  }
}

class OtherSignin extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const OtherSignin({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xffFCFDF5),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: Offset(2, 2),
              blurRadius: 3,
              spreadRadius: 1,
            )
          ],
        ),
        child: Icon(
          icon,
          size: 30,
          color: Color(0xff186F65),
        ),
      ),
    );
  }
}
