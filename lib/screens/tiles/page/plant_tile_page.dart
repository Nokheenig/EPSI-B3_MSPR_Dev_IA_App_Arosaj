import '../../../main.dart';
import 'package:flutter/material.dart';
import 'package:arosaj/entities.dart';

class PlantTilePage extends StatefulWidget {
  final Plant plantObject;

  const PlantTilePage({
    required this.plantObject,
     super.key
}) : assert(plantObject != null);

  @override
  State<StatefulWidget> createState() {
    return _PlantTilePageState();
  }
}

class _PlantTilePageState extends State<PlantTilePage> {
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
            widget.plantObject.nickname,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          children: [
            Text(
              "Common name: ${widget.plantObject.commonName}",
              style: TextStyle(fontSize: 18, height: 1.4),
            ),
            Text(
              "Description: ${widget.plantObject.description}",
              style: TextStyle(fontSize: 18, height: 1.4),
            ),
            Text(
              "Flower/fruit season: ${widget.plantObject.fruitPeriod_start} - ${widget.plantObject.fruitPeriod_end}",
              style: TextStyle(fontSize: 18, height: 1.4),
            ),
            Text(
              "Temperature range: ${widget.plantObject.tempC_min.toString()} - ${widget.plantObject.tempC_max.toString()} oC",
              style: TextStyle(fontSize: 18, height: 1.4),
            ),
            Text(
              "Care advice: ${widget.plantObject.careAdvice}",
              style: TextStyle(fontSize: 18, height: 1.4),
            ),

          ],
        ),
      );
}
