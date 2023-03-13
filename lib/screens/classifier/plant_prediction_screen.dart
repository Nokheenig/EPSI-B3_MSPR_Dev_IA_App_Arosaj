import 'dart:developer';
import '../../main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import '../classifier/classifier.dart';
import '../../entities.dart';
import 'package:faker/faker.dart';
import 'dart:math' hide log;
import 'package:arosaj/entities_foundations.dart';

enum month {
  january, february, march, april, may, june, july, august, september, october, november, december
}
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
  String? plantName = "Eg.: Hercules Poireau";
  //File? _image;
  final Classifier cls = new Classifier();

  late TextEditingController _controller;

  final _random = new Random();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


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
                  Image(image: ResizeImage(FileImage(widget.imageFile), height: 280)),
                  radioListChoice! == "None of the above" ?
                  Text("Name the plant and help the community by sharing your care recommendations!")
                  : Text("Give a nickname to your plant!"),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        //border: InputBorder.none,
                        hintText: plantName
                      ),
                    onSubmitted: (String value) async {
                    },
                  ),
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
                                                  if(value != "None of the above"){
                                                  plantName = value;
                                                  }else{
                                                    plantName = "Eg.: Hercules Poireau";
                                                  }
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
                          : [Container()])
                
                    ),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MainPage(startingPage: 0),
                            ),
                          );
                        },
                        child: Text("Cancel,\nand go back to my plants"),
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: (() {
                          final String nickname = _controller.text != "" ? _controller.text : plantName!;
                          log("Plant Nickname (textfield) ${nickname}");
                          final commonName = plantName == "Eg.: Hercules Poireau" ? nickname : plantName;
                          final Plant newPlant = Plant(
                            nickname: nickname,
                            commonName: commonName!,
                            tempC_min: faker.randomGenerator.integer(8, min:3).toDouble(),
                            tempC_max: faker.randomGenerator.integer(38, min:25).toDouble(),
                            description: faker.lorem.sentences(3).join(".").toString(),
                            careAdvice: faker.lorem.sentences(4).join(".").toString(),
                            fruitPeriod_start: defaultContent.yearMonths[faker.randomGenerator.integer(11,min:0)],
                            fruitPeriod_end: defaultContent.yearMonths[faker.randomGenerator.integer(11,min:0)]
                                );
                          log("adding Plant to db...");
                          orm.store.box<Plant>().put(newPlant);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MainPage(startingPage: 0),
                            ),
                          );
                        }),
                        child: Text('Add this plant,\nin my garden'),
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                      )
                    ],
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
    var predictions = [];
    //predictions.addAll(res);
    //List predictions = res['prediction'];
    if (res.length > 3){
      for(var i=0; i<3; i+=1){
        predictions.add(res['prediction'][i]);
      }
      //predictions.removeRange(3, predictions.length -1);
    }else{
      for(var i=0; i<res.length; i+=1){
        predictions.add(res['prediction'][i]);
      }
    }
    predictions.add({
      "label":"None of the above",
      "confidence":0.0
    });
    log("res:");
    log(res.toString());
    log("predictions: ");
    log(predictions.toString());
    setState(() {
      _results = predictions;//res['prediction'];
      //_image = res['image'];
    });
  }

  Future addPlant() async {
    log("hey, it's me : addPlant");
    String nickname = plantName!;
    if(radioListChoice != "None of the above"){
      String commonName = radioListChoice!;
    }else{
      String commonName = plantName!;
    }
    int next(int min, int max) => min + _random.nextInt(max - min);
    double tempC_min = next(3,8).toDouble();
    double tempC_max = next(25,38).toDouble();
    String desc = faker.lorem.sentences(3).toString();
    String careAdvice = faker.lorem.sentences(4).toString();
    int fruitPeriod_start = next(1, 12);
    int fruitPeriod_end = next(1,12);
    

  }

}
