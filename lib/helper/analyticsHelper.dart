import 'package:firebase_analytics/firebase_analytics.dart';

class MyAnalyticsHelper {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> loginLog(_value) async {
    await analytics.logEvent(name: "login_user", parameters: {'Value': _value});
  }

  Future<void> signupLog(_value) async {
    await analytics
        .logEvent(name: "signup_user", parameters: {'Value': _value});
  }

  Future<void> logoutLog(_value) async {
    await analytics
        .logEvent(name: "logout_user", parameters: {'Value': _value});
  }
}
