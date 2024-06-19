import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShareMemoryPage extends StatelessWidget {
  final List<String> selectedUsernames;
  const ShareMemoryPage({Key? key, required this.selectedUsernames})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SharedTextBox(
                selectedUsernames: selectedUsernames,
              ),
              // Text(selectedUsernames[0])
            ],
          ),
        ),
      )),
    );
  }
}

class SharedTextBox extends StatefulWidget {
  final List<String> selectedUsernames;
  const SharedTextBox({Key? key, required this.selectedUsernames})
      : super(key: key);

  @override
  State<SharedTextBox> createState() => _SharedTextBoxState();
}

class _SharedTextBoxState extends State<SharedTextBox> {
  String email = "";

  void addUser(String name) {
    final username = name;

    if (username.isNotEmpty && !widget.selectedUsernames.contains(username)) {
      setState(() {
        widget.selectedUsernames.add(username);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (value) => setState(() {
            email = value;
          }),
          decoration: const InputDecoration(
            hintText: "Who do you want to share this memory with?",
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
        if (widget.selectedUsernames.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 60, // Specify the desired height of the row
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.selectedUsernames.length,
              itemBuilder: (context, index) {
                String text = widget.selectedUsernames[index];
                return Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 8, 10),
                  child: Chip(
                    backgroundColor: Color(0xff9FBDF9),
                    label: Text(
                      text,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontSize: 11,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          ),
        if (email.isNotEmpty)
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final docs = snapshots.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                // itemCount: docs.length,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var data = docs[index].data() as Map<String, dynamic>;

                  if (data['email']
                      .toString()
                      .toLowerCase()
                      .startsWith(email.toLowerCase())) {
                    return GestureDetector(
                      onTap: () => {addUser(data['email'])},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            data['email'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black54,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data['profile_img']),
                          ),
                        ),
                      ),
                    );
                  }

                  return Container(); // Default return statement
                },
              );
            },
          ),
      ],
    );
  }
}
