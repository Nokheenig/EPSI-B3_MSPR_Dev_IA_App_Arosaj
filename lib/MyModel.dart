import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  void initState() {
    super.initState();
    loadModel();
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
        onPressed: pickAnImage,
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

  Future loadModel() async {
    log("hey, it's me : loadModel");
    Tflite.close();
    String? res;
    res = await Tflite.loadModel(
      model: "assets/mobilenet_v1_1.0_224_1_default_1.tflite",
      labels: "assets/imagenet_labels.txt",
    );
    print(res);
  }

  Future pickAnImage() async {
    log("hey, it's me : pickAnImage");
    // pick image and...
    XFile? image;
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    // Perform image classification on the selected image.
    imageClassification(File(image.path));
  }

  Future imageClassification(File image) async {
    log("hey, it's me : imageCLassification");
    // Run tensorflowlite image classification model on the image
    final List? results = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    log("results:");
    if (results != null) results.forEach(print);
// save the values in the variable we created and setstate
    setState(() {
      _results = results!;
      _image = image;
    });

  }

}