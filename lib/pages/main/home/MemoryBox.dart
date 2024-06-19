import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import "../memories/DisplayMemories.dart";

class MemoryBox extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String memoryName;
  const MemoryBox(
      {super.key,
      required this.id,
      required this.imageUrl,
      required this.memoryName});

  @override
  Widget build(BuildContext context) {
    debugPrint(imageUrl);
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DisplayMemories(id: id)));
      },
      child: Stack(children: [
        Container(
          margin: EdgeInsets.only(right: 20),
          height: 190,
          width: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: GestureDetector(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: imageUrl != "There was an error loading"
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Container(
                                height: 190,
                                width: 190,
                                color: Colors.grey,
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 190,
                              width: 190,
                              color: Colors.grey,
                            );
                          },
                        )
                      : Container(
                          height: 190,
                          width: 190,
                          color: Colors.grey,
                        ))),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Text(
            memoryName != "There was an error loading" ? memoryName : "error",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
          ),
        ),
      ]),
    );
  }
}
