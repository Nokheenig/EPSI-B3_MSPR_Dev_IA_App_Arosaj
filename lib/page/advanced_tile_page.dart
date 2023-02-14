import '../data/advanced_tiles.dart';
import '../main.dart';
import '../model/advanced_tile.dart';
import 'package:flutter/material.dart';

class AdvancedTilePage extends StatefulWidget {
  @override
  _AdvancedTilePageState createState() => _AdvancedTilePageState();
}

class _AdvancedTilePageState extends State<AdvancedTilePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: ExpansionPanelList.radio(
            expansionCallback: (index, isExpanded) {
              final tile = advancedTiles[index];
              setState(() => tile.isExpanded = isExpanded);

            },
            children: advancedTiles
                .map((tile) => ExpansionPanelRadio(
                      value: tile.title,
                      canTapOnHeader: true,
                      headerBuilder: (context, isExpanded) => buildTile(tile),
                      body: Column(
                        children: tile.tiles.map(buildTile).toList(),
                      ),
                    ))
                .toList(),
          ),
        ),
      );

  Widget buildTile(AdvancedTile tile) => ListTile(
        leading: tile.icon != null ? Icon(tile.icon) : null,
        title: Text(tile.title),
        onTap: null,
      );
}
