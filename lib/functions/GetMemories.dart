import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetMemories {
  static Future<List<dynamic>> getUserData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      User? user = auth.currentUser;
      String userId = user?.uid ?? '';

      DocumentSnapshot userSnapShot =
          await firestore.collection("users").doc(userId).get();

      if (userSnapShot.exists) {
        Map<String, dynamic>? data =
            userSnapShot.data() as Map<String, dynamic>?;

        if (data != null) {
          String profilePhoto = data['profile_img'];
          dynamic memoriesData = data['memories'];
          dynamic receivedMemories = data['received_memories'];

          List<dynamic>? memoryIdArray =
              (memoriesData is List<dynamic>) ? memoriesData : null;

          List<dynamic>? receivedIdArray =
              (receivedMemories is List<dynamic>) ? receivedMemories : null;

          return [profilePhoto, memoryIdArray, receivedIdArray];
        }
      }
    } catch (e) {
      debugPrint("The error is: " + e.toString());
    }

    return [];
  }

  static Future<Map<String, dynamic>> getMemoryByDate() async {
    List<String> collectedMemoryPost = [];
    Map<String, dynamic> datedMemories = {};

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userId = user?.uid ?? '';

    DocumentSnapshot userSnapshot =
        await firestore.collection("users").doc(userId).get();

    if (userSnapshot.exists) {
      for (String memoryId in List<String>.from(
          (userSnapshot.data() as Map<String, dynamic>)['memories'])) {
        DocumentSnapshot memoryPost =
            await firestore.collection('memory').doc(memoryId).get();

        if (memoryPost.exists) {
          List<dynamic> memoryPostId = List<dynamic>.from(
              (memoryPost.data() as Map<String, dynamic>)['memory']);

          for (String memoryPost in memoryPostId) {
            DocumentSnapshot memoryPostSnapshot =
                await firestore.collection('memoryPosts').doc(memoryPost).get();

            String date =
                (memoryPostSnapshot.data() as Map<String, dynamic>)['date'];

            if (datedMemories.containsKey(date)) {
              datedMemories[date]!.add(memoryPost);
            } else {
              datedMemories[date] = [memoryPost];
            }
          } // collectedMemoryPost.addAll(List<String>.from(memoryPostId));
        }
      }

      return datedMemories;
    }

    return {};
  }

  static Future<Map<String, dynamic>> getProfileDetails() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userId = user?.uid ?? '';

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot profileSnapshot =
        await firestore.collection("users").doc(userId).get();

    if (profileSnapshot.exists) {
      String email = (profileSnapshot.data() as Map<String, dynamic>)['email'];

      String profile_img =
          (profileSnapshot.data() as Map<String, dynamic>)['profile_img'];

      int memoryLength =
          (profileSnapshot.data() as Map<String, dynamic>)['memories'].length;

      Map<String, dynamic> profileDetails = {
        "email": email,
        "profile_img": profile_img,
        "memoryLength": memoryLength
      };

      return profileDetails;
    }

    return {};
  }

  static Future<List<List<String?>>> getMemories() async {
    List<List<String?>> finalValues = [];

    try {
      List<dynamic> userData = await getUserData();

      List<dynamic>? memoryIdArray = userData[1] as List<dynamic>?;
      if (memoryIdArray != null) {
        for (dynamic memoryId in memoryIdArray) {
          if (memoryId != null) {
            List<String?> memoryDate =
                await GetMemories.displayMemory(memoryId);

            finalValues.add(memoryDate);
            // return memoryDate;
          } else {
            debugPrint("there is no int");
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return finalValues;
  }

  static Future<List<List<String?>>> getReceivedMemories() async {
    List<List<String?>> finalReceivedMemories = [];

    try {
      List<dynamic> userData = await getUserData();

      List<dynamic>? receivedArray = userData[2] as List<dynamic>?;

      if (receivedArray != null) {
        for (dynamic memoryId in receivedArray) {
          if (memoryId != null) {
            List<String?> memoryDate =
                await GetMemories.displayMemory(memoryId);

            finalReceivedMemories.add(memoryDate);
            // return memoryDate;
          } else {
            debugPrint("there is no int");
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return finalReceivedMemories;
  }

  static Future<List<String>> getLikedImages() async {
    List<String> likedImageUrl = [];

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userId = user?.uid ?? '';

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot likedSnapshot =
        await firestore.collection("likedImages").doc(userId).get();

    if (likedSnapshot.exists) {
      List<dynamic> likedPostsId =
          (likedSnapshot.data() as Map<String, dynamic>)['liked'];

      for (int i = 0; i < likedPostsId.length; i++) {
        final PostId = likedPostsId[i];

        DocumentSnapshot memorySnapshot =
            await firestore.collection("memoryPosts").doc(PostId).get();

        if (memorySnapshot.exists) {
          String url = (memorySnapshot.data() as Map<String, dynamic>)['url'];

          likedImageUrl.add(url);
        }
      }

      return likedImageUrl;
    }

    return [];
  }

  static Future<Map<String, List<Map<String, dynamic>>>> displayMemoriesByYear(
      String memoryId) async {
    Map<String, List<Map<String, dynamic>>> memoriesByYear = {};

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot memoryParentSnapshot =
        await firestore.collection('memory').doc(memoryId).get();

    if (memoryParentSnapshot.exists) {
      //error here
      List<dynamic> memoryPostIDS =
          (memoryParentSnapshot.data() as Map<String, dynamic>)['memory'];

      for (int i = 0; i < memoryPostIDS.length; i++) {
        DocumentSnapshot memorySnapshot = await firestore
            .collection('memoryPosts')
            .doc(memoryPostIDS[i])
            .get();

        String? year = (memorySnapshot.data() as Map<String, dynamic>)['year'];

        if (memoriesByYear.containsKey(year)) {
          memoriesByYear[year]!
              .add(memorySnapshot.data() as Map<String, dynamic>);
        } else {
          memoriesByYear[year!] = [
            memorySnapshot.data() as Map<String, dynamic>
          ];
        }
      }
      debugPrint(memoryPostIDS.toString());
    }

    if (memoriesByYear.isEmpty) {
      return {};
    }

    return memoriesByYear;
  }

  // static Future<Map<String, dynamic>> displayMemoriesByYear(
  //     String memoryId) async {
  //   debugPrint("the memory is invoked");
  //   Map<String, dynamic> memoriesByYear = {};

  //   FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   DocumentSnapshot memoryParentSnapshot =
  //       await firestore.collection('memory').doc(memoryId).get();

  //   if (memoryParentSnapshot.exists) {
  //     List<dynamic> memoryPostIDS =
  //         (memoryParentSnapshot.data() as Map<String, dynamic>)['memory'];

  //     for (int i = 0; i < memoryPostIDS.length; i++) {
  //       DocumentSnapshot memorySnapshot = await firestore
  //           .collection('memoryPosts')
  //           .doc(memoryPostIDS[i])
  //           .get();

  //       String? year = (memorySnapshot.data() as Map<String, dynamic>)['year'];

  //       if (memoriesByYear.containsKey(year)) {
  //         int newIndex = memoriesByYear[year]!.length + 1;
  //         memoriesByYear[year]![newIndex] =
  //             memorySnapshot.data() as Map<String, dynamic>;
  //         // memoriesByYear[year]!
  //         //     .add(memorySnapshot.data() as Map<String, dynamic>);
  //       } else {
  //         // memoriesByYear[year!] = [
  //         //   memorySnapshot.data() as Map<String, dynamic>
  //         // ];

  //         memoriesByYear[year!][1] =
  //             memorySnapshot.data() as Map<String, dynamic>;
  //       }
  //     }
  //     debugPrint(memoryPostIDS.toString());
  //   }

  //   return memoriesByYear;
  //   // }

  //   // return {};

  //   //   Map<String, dynamic> memoriesByYear = {};
  //   // FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   // DocumentSnapshot memorySnapshot =
  //   //     await firestore.collection('memory').doc(memoryId).get();

  //   // if (memorySnapshot.exists) {
  //   //   Map<String, List<Map<String, dynamic>>> memoriesByYear = {};

  //   //   List<dynamic> memories =
  //   //       (memorySnapshot.data() as Map<String, dynamic>)['memory'];

  //   //   memories.forEach((memory) {
  //   //     String year = memory['year'];

  //   //     if (memoriesByYear.containsKey(year)) {
  //   //       memoriesByYear[year]!.add(memory as Map<String, dynamic>);
  //   //     } else {
  //   //       memoriesByYear[year] = [memory as Map<String, dynamic>];
  //   //     }
  //   //   });

  //   //   return memoriesByYear;
  //   // }

  //   // return {};
  // }

  static Future<List<String?>> displayMemory(String memoryId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot memorySnapshot =
        await firestore.collection('memory').doc(memoryId).get();

    if (memorySnapshot.exists) {
      Map<String, dynamic>? data =
          memorySnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        String? thumbnail = data['thumbnail'];

        String? author = data['memoryName'];

        String? date = data['date'];

        String? id = memoryId;

        return [thumbnail, author, date, id];
      }
    }

    return [];
  }
}
