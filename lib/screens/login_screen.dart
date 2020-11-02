import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  String _errorMessage;
  bool _loggingIn = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: _signInWithGoogle,
                child: const Text('Continue with Google'),
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      );

  void _signInWithGoogle() async {
    _setLoggingIn(); // show progress
    String errMsg;

    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      errMsg = 'Login failed, please try again later.';
    } finally {
      _setLoggingIn(false, errMsg); // always stop the progress indicator
    }
  }

  /// update the logging-in indicator, & show error message if any
  void _setLoggingIn([bool loggingIn = true, String errMsg]) {
    if (mounted) {
      setState(() {
        _loggingIn = loggingIn;
        _errorMessage = errMsg;
      });
    }
  }
}
