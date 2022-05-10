import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_app/LoginPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage();

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen();

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
              //height: 600,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Colors.white,
                child: const SignUpPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignUpFormState extends State<SignUpPage> {
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String currentText = "";
  String currentTextPW = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text(
              'Sign Up',
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
              onSaved: (value) => currentText = value!.trim(),
              onChanged: (val) {
                setState(() => currentText = val);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 190),
            child: Text("Password"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 15, right: 40),
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
          const Padding(
            padding: EdgeInsets.only(right: 145),
            child: Text("Repeat Password"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 40, right: 40),
            child: TextFormField(
              controller: passwordTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Repeat password',
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
                  //skicka data från textfields
                  if ((currentText == "123") && (currentTextPW == "123")) {}
                },
                child: const Text(
                  "Sign Up",
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
                  text: 'Already have an account? ',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                    text: 'Login',
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()),
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
