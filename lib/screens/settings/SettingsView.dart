import 'dart:async';
import 'package:flutter/material.dart';
import '../classifier/classifier.dart';
import '../classifier/MyModel.dart';
import '../camera/camera_screen.dart';
import '../../main.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Widget> _otherViews = [
    MyModel(title: 'My classifier'),
    CameraScreen()
  ];
  final List<String> names = <String>["Gallery Classifier",
                                      "Camera"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0F9D58),
        // on below line we have given title of app
        title: Text("Maps"),
      ),
      body: Container(
        child: SafeArea(
          // on below line creating google maps
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: 
            mainPages.entries.map((entry) {
                int idx = entry.key;
                Map pageMap = entry.value;
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MainPage(startingPage: idx,),
                            ),
                          );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         ListTile(
                          leading: Icon(Icons.album),
                          title: Text(pageMap["title"]),
                        ),
                      ]),
                  ),
                );
              }).toList()
            ),
        ),
      ),
    );
  }
}