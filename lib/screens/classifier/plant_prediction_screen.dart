import 'dart:developer';
import 'package:expandable_listview_example/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import '../classifier/classifier.dart';

//import 'captures_screen.dart';

class PlantPredictionScreen extends StatefulWidget {
  final File imageFile;

   PlantPredictionScreen({
    required this.imageFile
  });

  @override
  State<PlantPredictionScreen> createState() => _PlantPredictionScreenState();
}

class _PlantPredictionScreenState extends State<PlantPredictionScreen> {
  List? _results;
  bool pictureValidated = false;
  //int? radioListChoice = 0;
  String? radioListChoice = "default";
  //File? _image;
  final Classifier cls = new Classifier();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 158, 255, 171),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              firstChild: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*Expanded(
                                child: Image.file(widget.imageFile),
                              )*/
                              Image(image: ResizeImage(FileImage(widget.imageFile), height: 600)),
                  Text("Your plant must be clear and take most of the screen to be identified.\nDo you want to keep this picture of your plant ?", textAlign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MainPage(startingPage: 4),
                            ),
                          );
                        },
                        child: Text("No,\nlet's take another!"),
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: predictImageFromCamera,
                        child: Text('Yes,\nidentifiy it!'),
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                      )
                    ],
                  )
                ],
              ),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(image: ResizeImage(FileImage(widget.imageFile), height: 400)),
                  Text(radioListChoice!),
                  SingleChildScrollView(
                    child: Column(
                      children: _results != null
                          ? _results!.map((result) {
                        return RadioListTile<dynamic>(
                          title: Text('${result["label"]} -  ${result["confidence"].toStringAsFixed(2)}'),
                          value: result["label"], 
                          groupValue: radioListChoice,
                           onChanged: (value) {
                                                setState(() {
                                                  radioListChoice = value.toString();
                                                });
                                              }
                           ) 
                        
                        /*Card(
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
                        )*/;
                      }).toList()
                          : [],
                        
                    ),
                  )
              
              ]),
              crossFadeState: _results != null ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }

  Future predictImageFromCamera() async {
    log("hey, it's me : predictImageFromPreview");
    // Perform image classification on the preview image.
    final res = await cls.imageClassification(widget.imageFile);
    setState(() {
      _results = res['prediction'];
      //_image = res['image'];
    });
  }

}
