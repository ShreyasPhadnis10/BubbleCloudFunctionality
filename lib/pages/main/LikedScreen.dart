import 'package:bubblecloud/Components/Navbar.dart';
import 'package:bubblecloud/Components/NoResults.dart';
import "../../Components/BottomNavigationBar.dart";
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import "../../functions/GetMemories.dart";
import 'HomeScreen.dart';

class LikedScreen extends StatefulWidget {
  const LikedScreen({Key? key});

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  List<String> likedImages = [];

  @override
  void initState() {
    super.initState();
    getLikedImage();
  }

  Future<void> getLikedImage() async {
    likedImages = await GetMemories.getLikedImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const errorImage = "assets/google.png";
    return Scaffold(
      body: Column(
        children: [
          Navbar(pageName: "Liked"),
          likedImages.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      itemCount: likedImages.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Container(
                                          height: 200,
                                          width: 200,
                                          color: Colors.grey,
                                        );
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey,
                                        height: 300,
                                        width: double.infinity,
                                      );
                                    },
                                    likedImages[index],
                                    fit: BoxFit.cover,
                                  )),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                )
              : NoResults(
                  message: "There are no liked images",
                  buttonMessage: "Go to home",
                  buttonFunction: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                )
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 2,
      ),
    );
  }
}
