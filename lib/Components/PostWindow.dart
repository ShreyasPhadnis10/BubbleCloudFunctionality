import "package:flutter/material.dart";
import "../functions/PostWindowFunctions.dart";
import '../pages/main/camera/CameraScreen.dart';

class PostWindow extends StatelessWidget {
  const PostWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30), // added for spacing
          Text(
            "Create memories",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            // added Expanded widget
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PostOptions(
                      color: Color(0xff34495E),
                      iconImage: Icons.photo_camera,
                      postFunction: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraScreen()))
                      },
                    ),
                    PostOptions(
                      color: Color(0xff1F618D),
                      iconImage: Icons.image,
                      postFunction: () =>
                          {PostWindowFunctions.openGallery(context)},
                    ),
                    PostOptions(
                      color: Color(0xffE74C3C),
                      iconImage: Icons.videocam,
                      postFunction: () => {PostWindowFunctions.openVideos()},
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PostOptions(
                      color: Color(0xffABB2B9),
                      iconImage: Icons.description,
                      postFunction: () => debugPrint("camera"),
                    ),
                    PostOptions(
                      color: Color(0xff1DB954),
                      iconImage: Icons.music_note,
                    ),
                    PostOptions(
                        color: Color(0xffE67E22), iconImage: Icons.link),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10), // added for spacing
        ],
      ),
    );
  }
}

class PostOptions extends StatelessWidget {
  final Color color;
  final IconData iconImage;
  final void Function()? postFunction;

  const PostOptions(
      {required this.color, required this.iconImage, this.postFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: postFunction,
      child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 240, 239, 239),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: Icon(
                iconImage,
                size: 50,
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
