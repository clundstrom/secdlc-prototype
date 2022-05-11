import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_app/homePage.dart';
import 'package:login_app/signUpPage.dart';
import 'package:login_app/testPage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _SignInFormState createState() => _SignInFormState();
}

class SignInScreen extends StatelessWidget {
  const SignInScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Colors.white,
                child: const LoginPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignInFormState extends State<LoginPage> {
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String currentTextUsername = "";
  String currentTextPW = "";

  void postData() async {
    http.post(Uri.parse('http://localhost:2022/login'), //något liknande här
        body: {"username": currentTextUsername, "password": currentTextPW});
  }

  // http://localhost:2022/api/getInventory

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text(
              'Fancy title',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 190, top: 40),
            child: Text("Username"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 15, right: 40),
            child: TextFormField(
              controller: usernameTextController,
              decoration: const InputDecoration(
                hintText: 'Type your username',
                border: OutlineInputBorder(),
                icon: Icon(
                  Icons.person,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Email can\'t be empty' : null,
              onSaved: (value) => currentTextUsername = value!.trim(),
              onChanged: (val) {
                setState(() => currentTextUsername = val);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 190),
            child: Text("Password"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 40, right: 40),
            child: TextFormField(
              controller: passwordTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type your password',
                icon: Icon(
                  Icons.lock,
                ),
              ),
              obscureText: true,
              validator: (value) =>
                  value!.isEmpty ? 'Password can\'t be empty' : null,
              onSaved: (value) => currentTextPW = value!.trim(),
              onChanged: (val) {
                setState(() => currentTextPW = val);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 40, right: 40),
            child: Material(
              color: Colors.grey,
              elevation: 5.0,
              borderRadius: BorderRadius.circular(5.0),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                onPressed: () {
                  //skicka data från textfields här
                  if (1 == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TestPage()),
                    );
                  }
                },
                child: const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.0,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 40, right: 40),
            child: RichText(
              text: TextSpan(children: [
                const TextSpan(
                  text: 'New User? ',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                    text: 'Register',
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      }),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
