import 'package:bubblecloud/Components/Navbar.dart';
import 'package:bubblecloud/Components/NoResults.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

// // class MemoryByDate extends StatefulWidget {
// //   final Map<String, dynamic> allMemories;
// //   final String date;
// //   const MemoryByDate(
// //       {super.key, required this.allMemories, required this.date});

// //   @override
// //   State<MemoryByDate> createState() => _MemoryByDateState();
// // }

// // class _MemoryByDateState extends State<MemoryByDate> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Column(children: [
// //         Navbar(pageName: "Calender"),
// //         if (widget.allMemories.containsKey(widget.date))
// //           Container(
// //             padding: EdgeInsets.symmetric(horizontal: 20),
// //             margin: EdgeInsets.only(top: 30),
// //             child: Column(
// //               children: [
// //                 Align(
// //                   alignment: Alignment.centerLeft,
// //                   child: Text(
// //                     "Your memories on ${widget.date}",
// //                     style: TextStyle(
// //                         fontFamily: "Poppins",
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.w700),
// //                   ),
// //                 ),
// //                 // SingleChildScrollView(
// //                 //   scrollDirection: Axis.vertical,

// //                 // )
// //               ],
// //             ),
// //           )
// //         else
// //           Text("Sad world")
// //       ]),
// //     );
// //   }
// // }
// class MemoryByDate extends StatefulWidget {
//   final Map<String, dynamic> allMemories;
//   final String date;

//   const MemoryByDate({
//     Key? key,
//     required this.allMemories,
//     required this.date,
//   }) : super(key: key);

//   @override
//   State<MemoryByDate> createState() => _MemoryByDateState();
// }

// class _MemoryByDateState extends State<MemoryByDate> {
//   late Stream<DocumentSnapshot<Map<String, dynamic>>> _memoryStream;

//   @override
//   void initState() {
//     super.initState();
//     // Create a reference to the "memoryPost" collection and "memoryId" document
//     final memoryRef =
//         FirebaseFirestore.instance.collection('memoryPosts').doc('memoryId');

//     // Listen to changes in the document
//     _memoryStream = memoryRef.snapshots();

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Navbar(pageName: "Calendar"),
//           if (widget.allMemories.containsKey(widget.date))
//             StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//               stream: _memoryStream,
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Text('Loading...');
//                 }

//                 if (!snapshot.hasData || !snapshot.data!.exists) {
//                   return Text('No data found!');
//                 }

//                 final memoryData = snapshot.data!.data();

//                 final url = memoryData!['url'];
//                 final caption = memoryData['caption'];

//                 return Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Your memories on ${widget.date}",
//                         style: TextStyle(
//                           fontFamily: "Poppins",
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     Image.network(url),
//                     Text(caption),
//                   ],
//                 );
//               },
//             )
//           else
//             Text("No memories found for ${widget.date}"),
//         ],
//       ),
//     );
//   }
// }
class MemoryByDate extends StatefulWidget {
  final Map<String, dynamic> allMemories;
  final String date;

  const MemoryByDate({
    Key? key,
    required this.allMemories,
    required this.date,
  }) : super(key: key);

  @override
  State<MemoryByDate> createState() => _MemoryByDateState();
}

class _MemoryByDateState extends State<MemoryByDate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Navbar(pageName: "Calendar"),
          if (widget.allMemories.containsKey(widget.date))
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(top: 30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your memories on ${widget.date}",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          for (var memoryId in widget.allMemories[widget.date])
                            StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('memoryPosts')
                                  .doc(memoryId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return Text('No data found!');
                                }

                                final memoryData = snapshot.data!.data();
                                final url = memoryData!['url'];
                                final caption = memoryData['caption'];

                                return Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        child: Image.network(
                                          url,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Container(
                                                height: 300,
                                                width: double.infinity,
                                                color: Colors.grey,
                                              );
                                            }
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey,
                                              height: 300,
                                              width: double.infinity,
                                            );
                                          },
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        child: Text(
                                          caption,
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        height: 1,
                                        width:
                                            300, // Adjust the width as needed
                                        color: Color(
                                            0xffc4c4c4), // Set the color of the line
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            NoResults(
                message: "There are no images posted on this day.",
                buttonMessage: "Go back",
                buttonFunction: () {
                  Navigator.pop(context);
                })
        ],
      ),
    );
  }
}
