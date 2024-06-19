import "dart:io";
import "package:bubblecloud/pages/main/HomeScreen.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_storage/firebase_storage.dart";
import 'package:path/path.dart' as path;

import "../pages/VerifyEmail.dart";

class CreateMemoryFunctions {
  static Future<String> saveMemoryThumbnail(
      String filePath, String memoryId) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    late String fileName;

    fileName = path.basename(filePath);

    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    String userId = user?.uid ?? '';

    Reference reference =
        storage.ref().child('memoryThumbnail/$userId/$memoryId/$fileName');

    UploadTask uploadTask = reference.putFile(File(filePath));
    await uploadTask.whenComplete(() => null);

    String downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
  }

  static Future<void> shareMemory(String email, String memoryId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      String documentId = documentSnapshot.id;

      await firestore.collection('users').doc(documentId).update({
        'received_memories': FieldValue.arrayUnion([memoryId])
      });
    } else {
      return null;
    }
  }

  static Future<void> saveMemory(
      String memoryName,
      List<String> sharedWith,
      String location,
      String filePath,
      String date,
      BuildContext context) async {
    String memoryId = Uuid().v4();

    String thumbnailURL =
        await CreateMemoryFunctions.saveMemoryThumbnail(filePath, memoryId);

    final user = FirebaseAuth.instance.currentUser;

    final MemoryRef =
        FirebaseFirestore.instance.collection('memory').doc(memoryId);

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    try {
      await MemoryRef.set({
        "memoryId": memoryId,
        "thumbnail": thumbnailURL,
        "MakerName": user?.email,
        "userID": user?.uid,
        "memoryName": memoryName,
        "sharedWith": sharedWith,
        "date": date,
        "location": "",
        "memory": [],
      });

      userRef.update({
        'memories': FieldValue.arrayUnion([memoryId])
      });

      for (int i = 0; i < sharedWith.length; i++) {
        await CreateMemoryFunctions.shareMemory(sharedWith[i], memoryId);
      }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      debugPrint("There was an error while creating memory");
    }
  }
}
