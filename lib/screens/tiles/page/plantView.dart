import 'dart:developer';

import 'package:flutter/material.dart';
import 'plant_tile_page.dart';
import '../../../main.dart';
import '../../../entities.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  PageController controller=PageController();
  List<Widget> _plantWidgetList=<Widget>[
/*
    new Center(child:new Pages(
      text: "Tulipe",
      display: ({@required final String? text}) {
        assert(text != null);
        return TextTilePage(text: text!);
      })),

      new Center(child:new Pages(
      text: "Rose",
      display: ({@required final String? text}) {
        assert(text != null);
        return TextTilePage(text: text!);
      })),

      new Center(child:new Pages(
      text: "Oeillet",
      display: ({@required final String? text}) {
        assert(text != null);
        return TextTilePage(text: text!);
      })),

    new Center(child:new Pages(
      text: "Jasmin",
      display: ({@required final String? text}) {
        assert(text != null);
        return TextTilePage(text: text!);
      })),
*/
  ];
  List<Plant> _plantObjectList = <Plant>[];
  int _curr=0;

  @override
  void initState(){
    log("my homepage init");
    _plantWidgetList = <Widget>[];
    _plantObjectList = <Plant>[];
    List plantList = orm.store.box<Plant>().getAll();//List plantList = orm.plantBox.getAll();
    for (var i=0; i<plantList.length; i++){
      _plantWidgetList.add(
        Page(
          object: plantList[i],
          display: ({@required  var object}) {
            assert(object != null);
            return PlantTilePage(plantObject: object!);
          })
      );
      _plantObjectList.add(plantList[i]);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar:AppBar(
          title: Text("Plant: "),
          backgroundColor: Colors.green,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                (
                    _curr+1).toString()+"/"+_plantWidgetList.length.toString(),textScaleFactor: 2,),
            )
          ],),
        body: PageView(
          children:
          _plantWidgetList,
          scrollDirection: Axis.horizontal,

          // reverse: true,
          // physics: BouncingScrollPhysics(),
          controller: controller,
          onPageChanged: (num){
            setState(() {
              _curr=num;
            });
          },
        ),
        floatingActionButton:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:<Widget>[
              FloatingActionButton(
                  onPressed: () {

                    Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MainPage(startingPage: 4),
                            ),
                          );
                    /*setState(() {
                      _plantWidgetList.add(
                        new Center(child: new Text(
                            "New page", style: new TextStyle(fontSize: 35.0))),
                      );
                    })
                    if(_curr!=_plantWidgetList.length-1)
                      controller.jumpToPage(_curr+1);
                    else
                      controller.jumpToPage(0);*/
                  },
                  child:Icon(Icons.add)),
              FloatingActionButton(
                  onPressed: (){
                    //orm.store.box<Plant>().remove(_plantWidgetList[_curr].)
                    //log(_plantWidgetList[_curr].toString());
                    final int indexToDelete = _curr;
                    orm.store.box<Plant>().remove(_plantObjectList[indexToDelete].id);
                    _plantObjectList.removeAt(indexToDelete);
                    
                    _plantWidgetList.removeAt(indexToDelete);
                    //orm.store.box()
                    setState(() {
                      controller.jumpToPage(indexToDelete-1);
                    });
                    
                  },
                  child:Icon(Icons.delete)),
            ]
        )
    );
  }
}

class MyTextWidget extends StatelessWidget {
  final String text;

  MyTextWidget({required this.text}) : assert(text != null);

  @override
  Widget build(final BuildContext context) {
    return Text(this.text);
  }
}

typedef Widget DisplayType({@required var object});

class Page extends StatefulWidget {
  final DisplayType display;
  var object;

  Page({
    required this.display,
    required this.object
  }) :  assert(display != null),
        assert(object != null);

  @override
  State<StatefulWidget> createState() {
    return PageState();
  }
}

class PageState extends State<Page> {
  @override
  Widget build(final BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget>[
              SizedBox(
                height: 675.0,
                child: widget.display(object: widget.object)),
                Container(height: 150)
              /*Text(widget.text,textAlign: TextAlign.center,style: TextStyle(
                  fontSize: 30,fontWeight:FontWeight.bold),),*/
            ]
        ),
      ),
    );




    //this.widget.display(text: this.widget.text);
  }
}
