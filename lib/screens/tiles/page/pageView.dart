import 'package:flutter/material.dart';
import 'text_tile_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PageController controller=PageController();
  List<Widget> _list=<Widget>[

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
  ];
  int _curr=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar:AppBar(
          title: Text("Plant: "),
          backgroundColor: Colors.green,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                (
                    _curr+1).toString()+"/"+_list.length.toString(),textScaleFactor: 2,),
            )
          ],),
        body: PageView(
          children:
          _list,
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
            children:<Widget>[
              FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _list.add(
                        new Center(child: new Text(
                            "New page", style: new TextStyle(fontSize: 35.0))),
                      );
                    });
                    if(_curr!=_list.length-1)
                      controller.jumpToPage(_curr+1);
                    else
                      controller.jumpToPage(0);
                  },
                  child:Icon(Icons.add)),
              FloatingActionButton(
                  onPressed: (){
                    _list.removeAt(_curr);
                    setState(() {
                      controller.jumpToPage(_curr-1);
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

typedef Widget DisplayType({@required final String text});

class Pages extends StatefulWidget {
  final DisplayType display;
  final String text;

  Pages({
    required this.display,
    required this.text
  }) :  assert(display != null),
        assert(text != null);

  @override
  State<StatefulWidget> createState() {
    return PagesState();
  }
}

class PagesState extends State<Pages> {
  @override
  Widget build(final BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget>[
              SizedBox(
                height: 760.0,
                child: widget.display(text: widget.text)),
              /*Text(widget.text,textAlign: TextAlign.center,style: TextStyle(
                  fontSize: 30,fontWeight:FontWeight.bold),),*/
            ]
        ),
      ),
    );




    //this.widget.display(text: this.widget.text);
  }
}
