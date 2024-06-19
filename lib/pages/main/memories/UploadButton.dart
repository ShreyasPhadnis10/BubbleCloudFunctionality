import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:firebase_storage/firebase_storage.dart";
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:uuid/uuid.dart';
import "../HomeScreen.dart";

class UploadButton extends StatefulWidget {
  final String filePath;
  final String caption;
  final String location;

  final List<String?> selectedMemories;

  UploadButton(
      {super.key,
      required this.location,
      required this.filePath,
      required this.selectedMemories,
      required this.caption});

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  FirebaseStorage storage = FirebaseStorage.instance;

  late String fileName;

  @override
  void initState() {
    super.initState();
    fileName = path.basename(widget.filePath);
  }

  Future<void> uploadFile() async {
    if (widget.selectedMemories.isNotEmpty) {
      try {
        FirebaseAuth auth = FirebaseAuth.instance;

        User? user = auth.currentUser;

        String userId = user?.uid ?? '';

        Reference reference =
            storage.ref().child('memoryImages/$userId/$fileName');

        UploadTask uploadTask = reference.putFile(File(widget.filePath));
        await uploadTask.whenComplete(() => null);

        String downloadUrl = await reference.getDownloadURL();

        var uuid = Uuid();
        String memoryPostId = uuid.v4(); // Generate a version 4 (random) UUID

        //firebase function
        DateTime date = DateTime.now();

        String formattedDate = DateFormat('d MMMM').format(date);

        String formattedYear = DateFormat('yyyy').format(date);

        final MemoryPostRef = FirebaseFirestore.instance
            .collection('memoryPosts')
            .doc(memoryPostId);

        await MemoryPostRef.set({
          "type": "image",
          "url": downloadUrl,
          "caption": widget.caption,
          "date": formattedDate,
          "location": widget.location,
          "year": formattedYear,
          "liked": false,
          "memoryId": memoryPostId
        });

        if (widget.selectedMemories.isNotEmpty) {
          for (int i = 0; i < widget.selectedMemories.length; i++) {
            final MemoryRef = FirebaseFirestore.instance
                .collection('memory')
                .doc(widget.selectedMemories[i]);

            try {
              await MemoryRef.update({
                "memory": FieldValue.arrayUnion([memoryPostId])
              });
            } catch (e) {
              debugPrint(e.toString());
            }
          }
        }
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        Fluttertoast.showToast(
          msg: "There was an error while uploading.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 14.0,
        );

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));

        return;
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please select one memory",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
//widget.selectedMemories[i] == memeoryId
  }

  // String fileName = path.basename(filePath);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          uploadFile();
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
            'Upload Memory',
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
