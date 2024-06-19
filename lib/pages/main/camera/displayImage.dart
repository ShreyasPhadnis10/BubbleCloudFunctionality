// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import "../memories/SelectMemories.dart";

// class DisplayImage extends StatelessWidget {
//   final String filePath;
//   const DisplayImage({Key? key, required this.filePath}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final desiredHeight = screenHeight * 0.9;

//     final caption = TextEditingController();
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Stack(
//             children: [
//               Column(
//                 children: [
//                   Container(
//                     height: desiredHeight,
//                     width: screenWidth,
//                     child: Container(
//                       margin: EdgeInsets.only(top: 40),
//                       child: Center(
//                         child: Image.file(
//                           File(filePath),
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: caption,
//                               decoration: InputDecoration(
//                                 hintText: "Caption...",
//                                 hintStyle: TextStyle(fontSize: 13),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                   borderSide: BorderSide(width: 2),
//                                 ),
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(12, 16, 12, 8),
//                                 alignLabelWithHint: true,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(left: 10),
//                             height: 45,
//                             width: 45,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Color(0xff9FBDF9),
//                             ),
//                             child: Center(
//                               child: GestureDetector(
//                                 onTap: () => {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => SelectMemories(
//                                               filePath: filePath,
//                                               caption: caption.text)))
//                                 },
//                                 child: Icon(
//                                   Icons.chevron_right,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Positioned(
//                 top: 70,
//                 left: 20,
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.black.withOpacity(0.4),
//                     ),
//                     child: Icon(
//                       Icons.close,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "../memories/SelectMemories.dart";

class DisplayImage extends StatefulWidget {
  final String filePath;
  const DisplayImage({Key? key, required this.filePath}) : super(key: key);

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  final captionController = TextEditingController();

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final desiredHeight = screenHeight * 0.9;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: desiredHeight,
                    width: screenWidth,
                    child: Container(
                      margin: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Image.file(
                          File(widget.filePath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: captionController,
                              decoration: InputDecoration(
                                hintText: "Caption...",
                                hintStyle: TextStyle(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(width: 2),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 16, 12, 8),
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            height: 45,
                            width: 45,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff9FBDF9),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelectMemories(
                                        filePath: widget.filePath,
                                        caption: captionController.text,
                                      ),
                                    ),
                                  ),
                                },
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 70,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.4),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
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
