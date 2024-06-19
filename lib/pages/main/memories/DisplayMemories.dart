import 'package:bubblecloud/pages/main/memories/memoryComponents/MemoryByYear.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../../../Components/Navbar.dart';
import '../../../functions/GetMemories.dart';
import 'dart:math';
import "../../../Components/NoResults.dart";

class DisplayMemories extends StatefulWidget {
  final String id;
  const DisplayMemories({super.key, required this.id});

  @override
  State<DisplayMemories> createState() => _DisplayMemoriesState();
}

class _DisplayMemoriesState extends State<DisplayMemories> {
  Map<String, List<Map<String, dynamic>>> values = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getMemory();
  }

  Future<void> getMemory() async {
    values = await GetMemories.displayMemoriesByYear(widget.id);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Navbar(
        pageName: "Memories",
      ),
      if (values.isNotEmpty)
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(values.keys.length, (index) {
                final key = values.keys.elementAt(index);
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: MemoryByYear(
                      memoryArray: values[key], length: values.keys.length),
                );
              }),
            ),
          ),
        )
      else if (values.isEmpty && loading == false)
        NoResults(
            message: "There are no images in this memory.",
            buttonMessage: "Go back",
            buttonFunction: () {
              Navigator.pop(context);
            })
    ]));
  }
}
