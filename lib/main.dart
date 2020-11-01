import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(NotesApp());

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StreamProvider.value(
        initialData: CurrentUser.initial,
        value: FirebaseAuth.instance
            .authStateChanges()
            .map((user) => CurrentUser.create(user)),
        child: Consumer<CurrentUser>(
          builder: (context, user, _) => MaterialApp(
            title: 'Flutter Keep',
            home: user.isInitialValue
                ? Scaffold(body: const Text('Loading...'))
                : user.data != null
                    ? HomeScreen()
                    : LoginScreen(),
          ),
        ),
      );
}
