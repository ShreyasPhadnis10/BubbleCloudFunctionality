import "package:bubblecloud/pages/VerifyEmail.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:fluttertoast/fluttertoast.dart";
import "package:google_sign_in/google_sign_in.dart";
import 'package:flutter/material.dart';
import "package:sign_in_button/sign_in_button.dart";
import "./Login.dart";
import "../Components/Navbar.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String error = "";
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> userDatabaseEntry() async {
      final user = FirebaseAuth.instance.currentUser;
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);

      try {
        await userRef.set({
          "email": user.email,
          // "name": "shreyas",
          "profile_img":
              "https://firebasestorage.googleapis.com/v0/b/bubble-cloud-fcf2a.appspot.com/o/defaultProfilePhoto%2Fprofile_photo_default.jpg?alt=media&token=9b4446f0-406a-4f17-af67-2f00792deaf1",
          "signup_method": "emailSignUp",
          "received_memories": [],
          "liked_images": [],
          "memories": []
        });
      } catch (e) {
        debugPrint("THere was an error while writing to cloud firestore");
      }
    }

    Future SignUp(String email, String password) async {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        await userDatabaseEntry();
        // Navigator.pushReplacementNamed(context, "/home");

        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => VerifyEmail()));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          setState(() {
            error = "The email is already in use";
          });
        } else if (e.code == 'invalid-email') {
          setState(() {
            error = "Invalid email format";
          });
        } else if (e.code == 'weak-password') {
          setState(() {
            error = "The password was weak";
          });
        } else if (e.code == 'operation-not-allowed') {
          setState(() {
            error = "operation not allowed";
          });
        } else if (e.code == 'user-disabled') {
          setState(() {
            error = "User account is disable";
          });
        } else if (e.code == 'user-not-found') {
          setState(() {
            error = "User not found";
          });
        } else {
          setState(() {
            error = "There was an error while signing you up";
          });
        }
      } catch (e) {
        setState(() {
          error = "Unexpected error, please check your internet connection";
        });
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
          Navbar(pageName: "Signup"),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 40, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome to BubbleCloud!",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            color: Colors.grey),
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
                          hintStyle: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  error.isNotEmpty
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            error,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                color: Colors.redAccent),
                          ),
                        )
                      : SizedBox(),
                  // Container(
                  //   margin: EdgeInsets.only(top: 10),
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     child: Text("forgot password?"),
                  //     onPressed: () {},
                  //   ),
                  // ),

                  Container(
                    margin: EdgeInsets.only(top: 20),
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
                            SignUp(
                                emailController.text, passwordController.text);
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1, // Line thickness
                              color: Colors.grey, // Line color
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20), // Space between lines and text
                            child: Text(
                              'Or login with',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1, // Line thickness
                              color: Colors.grey, // Line color
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        margin: EdgeInsets.only(top: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: SignInButton(Buttons.googleDark, onPressed: () {
                          Fluttertoast.showToast(
                            msg:
                                "There is a bug with google sign in, will be available soon.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 14.0,
                          );
                        }),
                      )
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account ?",
                          style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Text("Log in."))
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
