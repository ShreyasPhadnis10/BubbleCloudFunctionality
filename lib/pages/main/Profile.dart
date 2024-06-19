import 'package:bubblecloud/Components/Navbar.dart';
import 'package:bubblecloud/pages/main/CalenderTable.dart/CalenderTable.dart';
import 'package:bubblecloud/pages/main/EditProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Components/BottomNavigationBar.dart';
import "../DefaultRegistration.dart";
import 'package:flutter/material.dart';
import "../../functions/GetMemories.dart";

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> profileDetails = {};

  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  Future<void> getProfileDetails() async {
    profileDetails = await GetMemories.getProfileDetails();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigation(
          selectedIndex: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Navbar(pageName: "Profile"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              profileDetails['profile_img'] ?? "",
                              height: 80,
                              width: 80,
                              errorBuilder: (context, error, stackTrace) {
                                return ClipRRect(
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return ClipRRect(
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      color: Colors.grey,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                profileDetails['email'] != null
                                    ? Text(
                                        profileDetails['email'] ?? "Error",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      )
                                    : Container(
                                        height: 40,
                                        width: 220,
                                        color:
                                            Color.fromARGB(255, 213, 212, 212),
                                      ),
                                Text(
                                  "only for close people",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w100,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                            imageUrl:
                                                profileDetails['profile_img'] ??
                                                    "",
                                          )));
                            },
                            child: Icon(
                              Icons.edit,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bubbles added: x",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Memories: " +
                                  profileDetails['memoryLength'].toString(),
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              profileDetails.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: CalenderTable())
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                      ),
                      height: 400,
                      width: 400,
                      margin: EdgeInsets.symmetric(horizontal: 20)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextButton(
                    onPressed: () async {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainRegistration()));
                    },
                    child: Text(
                      "Sign Out from this account",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700),
                    )),
              )
            ],
          ),
        ));
  }
}
