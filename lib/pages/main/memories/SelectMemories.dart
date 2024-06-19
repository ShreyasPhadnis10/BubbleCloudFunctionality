import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './ImageBox.dart';
import "./UploadButton.dart";
import "./CreateMemories.dart";
import "../../../functions/GetMemories.dart";
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SelectMemories extends StatefulWidget {
  final String filePath;
  final String caption;

  SelectMemories({required this.filePath, required this.caption});

  @override
  State<SelectMemories> createState() => _SelectMemoriesState();
}

class _SelectMemoriesState extends State<SelectMemories> {
  List<List<String?>> values = [];
  List<String> selectedMemories = [];
  bool loading = false;
  double opacity = 1;

  @override
  void initState() {
    super.initState();
    getMemories();
  }

  final location = TextEditingController();

  Future<void> getMemories() async {
    values = await GetMemories.getMemories();

    setState(() {}); // Trigger a rebuild to reflect the fetched values
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Opacity(
              opacity: opacity,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Select a memory...",
                              style: TextStyle(
                                color: Color(0xff595959),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateMemories()));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: location,
                              decoration: InputDecoration(
                                hintText: 'Where was this memory',
                                alignLabelWithHint: true,
                                hintStyle:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.location_on_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Expanded(
                      child: SizedBox(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                          ),
                          itemCount: values.length,
                          itemBuilder: (context, index) {
                            String url = values[index].length > 0
                                ? values[index][0] ??
                                    'There was an error loading'
                                : 'There was an error loading';
                            String name = values[index].length > 1
                                ? values[index][1] ??
                                    'There was an error loading'
                                : 'There was an error loading';

                            return ImageBox(
                                imageUrl: url,
                                label: name,
                                id: values[index][3],
                                selectedMemories: selectedMemories);
                          },
                        ),
                      ),
                    ),
                    Align(
                      child: UploadButton(
                          location: location.text,
                          caption: widget.caption,
                          filePath: widget.filePath,
                          selectedMemories: selectedMemories),
                      alignment: Alignment.bottomCenter,
                    )
                  ],
                ),
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
      ),
    );
  }
}
