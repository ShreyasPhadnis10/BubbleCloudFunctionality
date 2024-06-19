import 'package:bubblecloud/Components/Navbar.dart';
import 'package:bubblecloud/pages/main/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NoResults extends StatelessWidget {
  final String message;
  final String buttonMessage;
  final Function buttonFunction;
  const NoResults(
      {super.key,
      required this.message,
      required this.buttonMessage,
      required this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/thunder.png",
                height: 230,
                width: 230,
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      message,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 60.0),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        buttonFunction();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff9FBDF9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          buttonMessage,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
