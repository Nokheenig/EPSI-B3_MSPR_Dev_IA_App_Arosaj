import '../../../main.dart';
import 'package:flutter/material.dart';

class TextTilePage extends StatefulWidget {
  final String text;

  TextTilePage({
    required this.text
}) : assert(text != null);

  @override
  State<StatefulWidget> createState() {
    return _TextTilePageState();
  }
}

class _TextTilePageState extends State<TextTilePage> {
  static final double radius = 20;

  UniqueKey? keyTile;
  bool isExpanded = false;

  void expandTile() {
    setState(() {
      isExpanded = true;
      keyTile = UniqueKey();
    });
  }

  void shrinkTile() {
    setState(() {
      isExpanded = false;
      keyTile = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        /*appBar: AppBar(
          title: Text(MyApp.title),
          centerTitle: true,
        ),*/
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(color: Colors.black, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => isExpanded ? shrinkTile() : expandTile(),
                      child: buildImage(),
                    ),
                    buildText(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildImage() => Image.network(
        'https://picsum.photos/200',
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      );

  Widget buildText(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: keyTile,
          initiallyExpanded: isExpanded,
          childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
          title: Text(
            widget.text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          children: [
            Text(
              "La tulipe craint l'humidité stagnante et n'aime pas le vent, surtout les variétés qui ont une hampe florale élevée. Coupez les fleurs fanées après la floraison et attendez que les feuilles jaunissent pour arracher les bulbes qui pourront ainsi se reconstituer.",
              style: TextStyle(fontSize: 18, height: 1.4),
            ),
          ],
        ),
      );
}
