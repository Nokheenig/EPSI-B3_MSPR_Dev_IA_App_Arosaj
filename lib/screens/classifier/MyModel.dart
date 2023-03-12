import 'dart:developer';
import '../../screens/classifier/classifier.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'classifier.dart';

class MyModel extends StatefulWidget {
  const MyModel({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyModel> createState() => _MyModelState();
}

class _MyModelState extends State<MyModel> {

  File? _image;// = Image.asset('assets/dummyImage.JPG');//File('assets/dummyImage.JPG');
  List? _results;//= [{"label":"","confidence":0.0},{"label":"","confidence":0.0}];
  final Classifier cls = new Classifier();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Image classification'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: predictImageFromGallery,
        tooltip: 'Select Image',
        child: const Icon(Icons.image),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      body: Column(
        children: [
          if (_image != null)
            Container(margin: EdgeInsets.all(10), child: Image.file(_image!))
          else
            Container(
              margin: EdgeInsets.all(40),
              child: Opacity(
                opacity: 0.6,
                child: Center(
                  child: Text('No Image Selected!'),
                ),
              ),
            ),
          SingleChildScrollView(
            child: Column(
              children: _results != null
                  ? _results!.map((result) {
                return Card(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "${result["label"]} -  ${result["confidence"].toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList()
                  : [],
            ),
          ),
        ],
      ),

    );
  }

    Future predictImageFromGallery() async {
      log("hey, it's me : pickAnImage");
      // pick image and...
      XFile? image;
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      // Perform image classification on the selected image.
      final res = await cls.imageClassification(File(image.path));
      setState(() {
        _results = res['prediction'];
        _image = res['image'];
      });
    }

}