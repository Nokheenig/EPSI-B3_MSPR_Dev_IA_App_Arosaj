import 'page/text_tile_page.dart';
import 'page/pageView.dart';
import 'MapsView.dart';
import 'MyModel.dart';
import 'camera.dart';
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
    final style = TextStyle(color: Colors.blue);

    return BottomNavigationBar(
      type:BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).primaryColor,// Color.fromARGB(255, 61, 107, 145),//Theme.of(context).primaryColor,
      selectedItemColor: Color.fromARGB(255, 255, 255, 255),
      unselectedItemColor: Color.fromARGB(255, 200, 200, 200),
      currentIndex: indexBottomNavBar,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),//Text('', style: style),
          label: 'Card',
        ),
        BottomNavigationBarItem(
          icon: Text('', style: style),
          label: 'Screen',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_travel),//Text('', style: style),
          label: 'Map',
        ),

        BottomNavigationBarItem(
          icon: Text('', style: style),
          label: 'Predict',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.camera),//Text('', style: style),
          label: 'Camera',
        ),
        /*
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
        return TextTilePage(text:"Tulipe"); //Homepage (My plants)
      case 1:
        return MyHomePage(); //Hidden: Terms of Use Screen
      case 2:
        return MapPage(); //Map
      case 3:
        return MyModel(title: 'My classifier'); //Classifier
      case 4:
        return MyCamera(); //Hidden: Camera
      default:
        return Container();
    }
  }
}
