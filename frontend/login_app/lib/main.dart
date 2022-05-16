// @dart=2.9
import 'package:flutter/material.dart';
import 'LoginPage.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const SignInScreen(),
      },
    );
  }
}
