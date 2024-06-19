import 'package:flutter/material.dart';
import '../pages/main/Profile.dart';
import '../functions/GetMemories.dart';

class HomePageNavbar extends StatefulWidget {
  final String pageName;
  final String profileUrl;

  const HomePageNavbar({required this.pageName, required this.profileUrl});

  @override
  State<HomePageNavbar> createState() => _HomePageNavbarState();
}

class _HomePageNavbarState extends State<HomePageNavbar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 30, left: 20),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Icon(
                  Icons.notifications,
                  size: 35,
                  color: Colors.black54,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.pageName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  )
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: widget.profileUrl.isNotEmpty
                        ? Image.network(
                            widget.profileUrl,
                            height: 45,
                            width: 45,
                            errorBuilder: (context, error, stackTrace) {
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    color: Colors.grey,
                                  ));
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      color: Colors.grey,
                                    ));
                              }
                            },
                          )
                        : CircularProgressIndicator(), // Show a loading indicator if profileUrl is empty
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
