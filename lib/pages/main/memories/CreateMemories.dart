import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import "../../../Components/Navbar.dart";
import 'package:intl/intl.dart';
import '../../../functions/PostWindowFunctions.dart';
import "../../../functions/CreateMemoryFunction.dart";
import "./memoryComponents/ShareMemoryPage.dart";

class CreateMemories extends StatefulWidget {
  @override
  _CreateMemoriesState createState() => _CreateMemoriesState();
}

class _CreateMemoriesState extends State<CreateMemories> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  List<String> selectedUsernames = [];
  bool loading = false;
  String imageUrl = "";
  double opacity = 1;

  String title = 'Image Title';
  String description = 'Image Description';

  void changeImage() {
    setState(() {
      imageUrl = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(selectedUsernames.toString());
    DateTime now = DateTime.now();
    String formattedMonth = DateFormat('MMMM').format(DateTime.now());
    String formattedDate = "${now.day} $formattedMonth, ${now.year}";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: opacity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Navbar(pageName: "Create memory"),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      if (imageUrl == "")
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey),
                        )
                      else
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(imageUrl),
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            String galleryImage =
                                await PostWindowFunctions.setGalleryImage();
                            setState(() {
                              imageUrl = galleryImage;
                            });
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EnterDetails(
                        hint: "Enter memory name",
                        controller: nameController,
                      ),
                      EnterDetails(
                        hint: "Where is this memory from?",
                        controller: locationController,
                      ),
                      // EnterDetails(
                      //   hint: "Who do you want to share this memory with?",
                      //   controller,
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShareMemoryPage(
                                              selectedUsernames:
                                                  selectedUsernames,
                                            )));
                              },
                              child: const Text(
                                "Share this memory?",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              )),
                        ],
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
                      setState(() {
                        loading = true;
                        opacity = 0.3;
                      });
                      CreateMemoryFunctions.saveMemory(
                          nameController.text,
                          selectedUsernames,
                          locationController.text,
                          imageUrl,
                          formattedDate,
                          context);
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
                ),
              ],
            ),
          ),
          loading
              ? Container(
                  child: LoadingAnimationWidget.prograssiveDots(
                    color: Color(0xff9FBDF9),
                    size: 110,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class EnterDetails extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  const EnterDetails({Key? key, required this.hint, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: "Poppins",
              fontSize: 13,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
