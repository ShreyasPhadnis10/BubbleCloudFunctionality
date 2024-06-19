// import 'dart:io';

// import 'package:bubblecloud/Components/Navbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// import '../../functions/PostWindowFunctions.dart';

// class EditProfile extends StatefulWidget {
//   final String imageUrl;
//   const EditProfile({Key? key, required this.imageUrl});

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
//   String NewimageUrl = ""; // Update imageUrl as non-final variable

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           const Navbar(pageName: "Edit profile"),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
//             child: Stack(
//               alignment: Alignment.bottomRight,
//               children: [
//                 // Container(
//                 //   decoration: BoxDecoration(shape: BoxShape.circle),
//                 //   child: Image.network(
//                 //     NewimageUrl.isNotEmpty ? NewimageUrl : widget.imageUrl,
//                 //     width: double.infinity,
//                 //     height: 300,
//                 //     fit: BoxFit.cover,
//                 //   ),
//                 // ),

//                 if (NewimageUrl.isEmpty)
//                   CircleAvatar(
//                     radius: 150,
//                     backgroundImage: NetworkImage(
//                       NewimageUrl.isNotEmpty ? NewimageUrl : widget.imageUrl,
//                     ),
//                   ),
//                 else
//                   Text("")
//                 Container(
//                   height: 70,
//                   width: 70,
//                   margin: EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.grey,
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     color: Colors.white,
//                     onPressed: () async {
//                       String galleryImage =
//                           await PostWindowFunctions.setGalleryImage();

//                       setState(() {
//                         NewimageUrl = galleryImage;
//                       });
//                     },
//                     icon: Icon(Icons.edit),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:bubblecloud/Components/Navbar.dart';
import 'package:bubblecloud/pages/main/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../functions/PostWindowFunctions.dart';

class EditProfile extends StatefulWidget {
  final String imageUrl;

  const EditProfile({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String NewimageUrl = '';

  bool loading = false;
  double opacity = 1;

  Future<void> uploadProfilePhoto() async {
    setState(() {
      opacity = 0.3;
      loading = true;
    });
    FirebaseStorage storage = FirebaseStorage.instance;

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (NewimageUrl.isNotEmpty) {
      try {
        //find something to delete the previous dp
        Reference newRef = storage.ref().child('profilePhotos/$NewimageUrl');

        UploadTask uploadTask = newRef.putFile(File(NewimageUrl));

        await uploadTask.whenComplete(() => null);

        String downloadUrl = await newRef.getDownloadURL();

        debugPrint(downloadUrl);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({"profile_img": downloadUrl});

        debugPrint("Profile photo updated");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please change the image",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: Column(
              children: [
                const Navbar(pageName: "Edit profile"),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      if (NewimageUrl.isEmpty)
                        CircleAvatar(
                          radius: 150,
                          backgroundImage: NetworkImage(
                            NewimageUrl.isNotEmpty
                                ? NewimageUrl
                                : widget.imageUrl,
                          ),
                        )
                      else
                        Column(
                          children: [
                            SizedBox(
                              height: 300,
                              child: ClipOval(
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  child: Image.file(File(NewimageUrl)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      Container(
                        height: 70,
                        width: 70,
                        margin: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () async {
                            String galleryImage =
                                await PostWindowFunctions.setGalleryImage();

                            setState(() {
                              NewimageUrl = galleryImage;
                            });
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      uploadProfilePhoto();
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
                        'Upload Photo',
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
          ),
          loading
              ? Center(
                  child: Container(
                    child: LoadingAnimationWidget.prograssiveDots(
                      color: Color(0xff9FBDF9),
                      size: 110,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
