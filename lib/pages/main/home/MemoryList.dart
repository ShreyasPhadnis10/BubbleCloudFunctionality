import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import "../../../functions/GetMemories.dart";

import './MemoryBox.dart';

class MemoryList extends StatefulWidget {
  const MemoryList({Key? key});

  @override
  State<MemoryList> createState() => _MemoryListState();
}

class _MemoryListState extends State<MemoryList> {
  List<List<String?>> values = [];
  List<List<String?>> receivedValues = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getMemories();
    getReceivedMemories();
  }

  Future<void> getMemories() async {
    values = await GetMemories.getMemories();
    loading = false;
    setState(() {}); // Trigger a rebuild to reflect the fetched values
  }

  Future<void> getReceivedMemories() async {
    receivedValues = await GetMemories.getReceivedMemories();
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your memories",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (values.isNotEmpty)
                if (values.length > 1)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        values.length,
                        (index) {
                          String url =
                              values[index][0] ?? 'There was an error loading';
                          String name =
                              values[index][1] ?? 'There was an error loading';
                          String id =
                              values[index][3] ?? 'There was an error loading';
                          return MemoryBox(
                            id: id,
                            imageUrl: url,
                            memoryName: name,
                          );
                        },
                      ),
                    ),
                  )
                else
                  Container(
                    alignment: Alignment.centerLeft,
                    child: MemoryBox(
                      id: values[0][3] ?? "There was an error loading",
                      imageUrl: values[0][0] ?? "There was an error loading",
                      memoryName: values[0][1] ?? "There was an error loading",
                    ),
                  )
              else if (loading == true & values.isEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            height: 190,
                            width: 190,
                            color: Colors.grey,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            height: 190,
                            width: 190,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (values.isEmpty & loading == false)
                Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 190,
                      width: 190,
                      color: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sentiment_dissatisfied,
                            size: 80,
                            color: Colors.white,
                          ),
                          Text(
                            "No memories...",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Received memories",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (receivedValues.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      receivedValues.length,
                      (index) {
                        String url = receivedValues[index][0] ??
                            'There was an error loading';
                        String name = receivedValues[index][1] ??
                            'There was an error loading';
                        String id = receivedValues[index][3] ??
                            'There was an error loading';
                        return MemoryBox(
                          id: id,
                          imageUrl: url,
                          memoryName: name,
                        );
                      },
                    ),
                  ),
                )
              else if (loading == true & receivedValues.isEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            height: 190,
                            width: 190,
                            color: Colors.grey,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            height: 190,
                            width: 190,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (receivedValues.isEmpty & loading == false)
                Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 190,
                      width: 190,
                      color: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sentiment_dissatisfied,
                            size: 80,
                            color: Colors.white,
                          ),
                          Text(
                            "No memories...",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
