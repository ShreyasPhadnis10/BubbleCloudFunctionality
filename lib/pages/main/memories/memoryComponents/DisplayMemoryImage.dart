import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../../../functions/GetMemories.dart';

class DisplayMemoryImage extends StatefulWidget {
  final List<Map<String, dynamic>>? memoryArray;
  final int index;
  final List<String> likedImages;

  const DisplayMemoryImage(
      {super.key,
      required this.memoryArray,
      required this.index,
      required this.likedImages});

  @override
  State<DisplayMemoryImage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DisplayMemoryImage> {
  bool liked = false;
  @override
  void initState() {
    // Initialize the list here
    setLikedState();
    super.initState();
  }

  Future<void> RemoveLikedImages() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    String userId = user?.uid ?? '';
    final LikedRef =
        FirebaseFirestore.instance.collection('likedImages').doc(userId);

    // final PostSnapshot = FirebaseFirestore.instance
    //     .collection("memoryPosts")
    //     .doc(widget.memoryArray![widget.index]['memoryId']);

    try {
      LikedRef.update({
        "liked": FieldValue.arrayRemove(
            [widget.memoryArray![widget.index]['memoryId']])
      });

      // PostSnapshot.update({"liked": false});
    } catch (e) {
      debugPrint("There was an error while disliking");
    }
  }

  Future<void> AddLikedImages() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    String userId = user?.uid ?? '';

    final LikedRef =
        FirebaseFirestore.instance.collection('likedImages').doc(userId);

    // final PostSnapshot = FirebaseFirestore.instance
    //     .collection("memoryPosts")
    //     .doc(widget.memoryArray![widget.index]['memoryId']);

    try {
      final documentSnapshot = await LikedRef.get();

      if (documentSnapshot.exists) {
        for (int i = 0; i < widget.likedImages.length; i++) {
          await LikedRef.update({
            "liked": FieldValue.arrayUnion([widget.likedImages[i]])
          });
        }
      } else {
        await LikedRef.set({
          "liked": widget.likedImages,
        });
      }

      // debugPrint("Post liked");

      // await PostSnapshot.update({"liked": true});
    } catch (e) {
      debugPrint("There was an error while liking the post");
      debugPrint(e.toString());
    }
  }

  Future<void> setLikedState() async {
    // final snapshot = await FirebaseFirestore.instance
    //     .collection("memoryPosts")
    //     .doc(widget.memoryArray![widget.index]['memoryId'])
    //     .get();

    // setState(() {
    //   liked = snapshot.data()?['liked'] ?? false;
    // });

    List<String> likedImages = await GetMemories.getLikedImages();

    if (likedImages.contains(widget.memoryArray![widget.index]['url'])) {
      setState(() {
        liked = true;
      });
    } else {
      setState(() {
        liked = false;
      });
    }
  }

  @override
  void dispose() {
    if (widget.likedImages.isNotEmpty) {
      AddLikedImages();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 20, 20),
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(widget.memoryArray![widget.index]['url'],
              loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Container(
                color: Colors.grey,
                height: 400,
                width: double.infinity,
              );
            }
          }, errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey,
              height: 400,
              width: double.infinity,
            );
          }),
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            widget.memoryArray![widget.index]['caption'],
            style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.memoryArray![widget.index]['date'],
              style:
                  TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w400),
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Color(0xff960A0A),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  widget.memoryArray![widget.index]['location'] == ''
                      ? "not available"
                      : widget.memoryArray![widget.index]['location'],
                  style: TextStyle(
                      fontFamily: "Poppins", fontWeight: FontWeight.w400),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => setState(() {
                liked = !liked;
                String url = widget.memoryArray![widget.index]['memoryId'];
                if (liked) {
                  widget.likedImages.add(url);
                }

                if (!liked) {
                  if (widget.likedImages.contains(url)) {
                    widget.likedImages.remove(url);
                  } else {
                    RemoveLikedImages();
                  }
                }
              }),
              child: Icon(
                liked ? Icons.favorite : Icons.favorite_border,
                color: liked ? Colors.red[400] : null,
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 1,
          width: 300, // Adjust the width as needed
          color: Color(0xffc4c4c4), // Set the color of the line
        ),
      ]),
    );
  }
}
