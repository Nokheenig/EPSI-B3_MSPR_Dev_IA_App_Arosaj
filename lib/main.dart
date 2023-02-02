import 'page/text_tile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Expansion Tile';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int indexBottomNavBar = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: buildBottomBar(),
        body: buildPages(),
      );

  Widget buildBottomBar() {
    final style = TextStyle(color: Colors.white);

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: indexBottomNavBar,
      items: [
        BottomNavigationBarItem(
          icon: Text('ExpansionTile', style: style),
          label: 'My plants',
        ),
        BottomNavigationBarItem(
          icon: Text('ExpansionTile', style: style),
          label: 'Map',
        ),
        /*
        BottomNavigationBarItem(
          icon: Text('ExpansionTile', style: style),
          label: 'Terms of Use',
        ),
        BottomNavigationBarItem(
          icon: Text('ExpansionTile', style: style),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: Text('ExpansionTile', style: style),
          label: 'Other',
        ),
         */
      ],
      onTap: (int index) => setState(() => this.indexBottomNavBar = index),
    );
  }

  Widget buildPages() {
    switch (indexBottomNavBar) {
      case 0:
        return TextTilePage(); //Homepage (My plants)
      case 1:
        return TextTilePage(); //Map
      case 3:
        return TextTilePage(); //Hidden: Terms of Use Screen
      case 4:
        return TextTilePage(); //Hidden: Camera
      case 5:
        return TextTilePage(); //Hidden:
      default:
        return Container();
    }
  }
}
