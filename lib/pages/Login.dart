import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "../Components/Navbar.dart";
import "./Signup.dart";

class Login extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    Future SignIn(String email, String password) async {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException {
        debugPrint("Error");
      } catch (e) {
        debugPrint("$e is the error");
      }
    }

    String hexColor = "#9FBDF9";
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // SizedBox(
          //   height: 90,
          // ),
          Navbar(pageName: "Log in"),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 40, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome back!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 2))),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: Text("forgot password?"),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Color(
                                  int.parse(hexColor.substring(1, 7),
                                          radix: 16) +
                                      0xFF000000)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ))),
                          onPressed: () {
                            SignIn(
                                emailController.text, passwordController.text);
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("New to bubblecloud ?"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signup()));
                            },
                            child: Text("Sign up."))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
