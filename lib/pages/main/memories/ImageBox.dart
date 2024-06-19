import "package:flutter/material.dart";

class ImageBox extends StatefulWidget {
  final String imageUrl;
  final String label;
  final String? id;
  final List<String?> selectedMemories;

  const ImageBox(
      {required this.imageUrl,
      required this.label,
      required this.id,
      required this.selectedMemories});

  @override
  State<ImageBox> createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  double opacity = 1.0;
  bool selected = false;

  void handleTap() {
    setState(() {
      selected = true;
      opacity = 0.5;
      widget.selectedMemories.add(widget.id);
    });
  }

  void handleUnTap() {
    setState(() {
      selected = false;
      opacity = 1.0;
      widget.selectedMemories.remove(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageBoxWidth = screenWidth * 0.5;

    return Stack(
      children: [
        Opacity(
          opacity: opacity,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: imageBoxWidth,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                if (selected) {
                  handleUnTap();
                } else {
                  handleTap();
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Container(
                          height: 200,
                          width: imageBoxWidth,
                          color: Colors.grey);
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 20,
                      width: imageBoxWidth,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 15,
          child: Text(
            widget.label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
          ),
        ),
      ],
    );
  }
}
