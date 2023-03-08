import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Classifier {

  File? _image;// = Image.asset('assets/dummyImage.JPG');//File('assets/dummyImage.JPG');
  List? _results;//= [{"label":"","confidence":0.0},{"label":"","confidence":0.0}];
  String cmodel = "assets/mobilenet_v1_1.0_224_1_default_1.tflite";
  String clabels = "assets/imagenet_labels.txt";
  bool busy = false;

  Classifier({String model = "", String labels = ""} ){
    
    if (model != "" && labels != ""){
      this.cmodel = model;
      this.clabels = labels;
    }
    this.loadModel();

  }

  Future loadModel() async {
    log("hey, it's me : loadModel");
    this.busy = true;
    Tflite.close();
    String? res;
    res = await Tflite.loadModel(
      model: this.cmodel,
      labels: this.clabels,
    );
    print(res);
    this.busy = false;
  }

  Future pickAnImage() async {
    log("hey, it's me : pickAnImage");
    this.busy = true;
    // pick image and...
    XFile? image;
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    // Perform image classification on the selected image.
    imageClassification(File(image.path));
    this.busy = false;
  }

  Future<Map> imageClassification(File image) async {
    log("hey, it's me : imageCLassification");
    this.busy = true;
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
      this._image = image;
      this._results = results!;
      this.busy = false;

      return {'prediction':results, 'image':image};
  }

  Future getImage() async {
    log("hey, it's me : getImage");
    var _startTime = DateTime.now();
    var _now = _startTime;
    int iter = 0;
    int _elapsedTime = 0;

    do {
      iter +=1;
      _now = DateTime.now();
      _elapsedTime = _now.millisecondsSinceEpoch - _startTime.millisecondsSinceEpoch;
    } while (this.busy == true && _elapsedTime < 1000);
    return this._image;
  }

  Future getResults() async {
    log("hey, it's me : getResults");
    var _startTime = DateTime.now();
    var _now = _startTime;
    int iter = 0;
    int _elapsedTime = 0;

    do {
      iter +=1;
      _now = DateTime.now();
      _elapsedTime = _now.millisecondsSinceEpoch - _startTime.millisecondsSinceEpoch;
    } while (this.busy == true && _elapsedTime < 1000);

    return this._results;
  }
}