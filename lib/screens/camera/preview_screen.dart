import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import '../classifier/classifier.dart';

import 'captures_screen.dart';

class PreviewScreen extends StatefulWidget {
  final File imageFile;
  final List<File> fileList;

   PreviewScreen({
    required this.imageFile,
    required this.fileList,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  List? _results;
  //File? _image;
  final Classifier cls = new Classifier();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),//.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => CapturesScreen(
                            imageFileList: widget.fileList,
                          ),
                        ),
                      );
                    },
                    child: Text('Go to all captures'),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: predictImageFromPreview,
                    child: Text('Predict'),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              firstChild: Expanded(
                            child: Image.file(widget.imageFile),
                          ),
              secondChild: Column(
                children: [
                  Image(image: ResizeImage(FileImage(widget.imageFile), height: 400)),
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
                  )
              ]),
              crossFadeState: _results != null ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            ),
            
          ],
        ),
      ),
    );
  }

  Future predictImageFromPreview() async {
    log("hey, it's me : predictImageFromPreview");
    // Perform image classification on the preview image.
    final res = await cls.imageClassification(widget.imageFile);
    setState(() {
      _results = res['prediction'];
      //_image = res['image'];
    });
  }

}
