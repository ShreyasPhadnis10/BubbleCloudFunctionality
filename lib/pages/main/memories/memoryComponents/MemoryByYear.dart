import 'package:bubblecloud/pages/main/memories/memoryComponents/DisplayMemoryImage.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MemoryByYear extends StatefulWidget {
  final List<Map<String, dynamic>>? memoryArray;
  final int length;

  const MemoryByYear(
      {Key? key, required this.memoryArray, required this.length});

  @override
  State<MemoryByYear> createState() => _MemoryByYearState();
}

class _MemoryByYearState extends State<MemoryByYear> {
  List<String> likedImages = [];
  @override
  Widget build(BuildContext context) {
    // debugPrint("the memoryArray is: " + widget.memoryArray.toString());
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 50.0,
              height: double.infinity,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffC4C4C4),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 1.0,
                        color: Color(0xffC4C4C4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.chevron_left),
                            Align(
                                child: Text(
                                  widget.memoryArray![0]['year'],
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                alignment: Alignment.center),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            List.generate(widget.memoryArray!.length, (index) {
                          return DisplayMemoryImage(
                            memoryArray: widget.memoryArray,
                            index: index,
                            likedImages: likedImages,
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
