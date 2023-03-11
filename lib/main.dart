import 'package:expandable_listview_example/objectbox.g.dart';
import 'package:expandable_listview_example/screens/camera/camera_screen.dart';
import 'package:path_provider/path_provider.dart';

//import 'screens/tiles/page/text_tile_page.dart';
import 'screens/tiles/page/pageView.dart';
import 'screens/map/MapsView.dart';
import 'screens/classifier/MyModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart'; 
import 'screens/settings/SettingsView.dart';
import 'package:faker/faker.dart';
import 'package:path/path.dart';
import 'entities.dart';
import 'dart:math' hide log;
import 'orm/orm_ObjectBox.dart';
import 'session/session.dart';

List<CameraDescription> cameras = [];
Map mainPages = {
  0:{"page":MyHomePage(),
      "title":"My plants",
      "show":1,
      "icon":Icon(Icons.fire_truck)},
  1:{"page":MapPage(),
      "title":"Map",
      "show":1,
      "icon":Icon(Icons.map)},
  2:{"page":SettingsPage(),
      "title":"Settings",
      "show":1,
      "icon":Icon(Icons.settings)},
  3:{"page":MyModel(title: 'My classifier'),
      "title":"Gallery Classifier",
      "show":1,
      "icon":Icon(Icons.sort)},
  4:{"page":CameraScreen(),
      "title":"Camera",
      "show":1,
      "icon":Icon(Icons.camera)},
}; 

late orm_ObjectBox orm;


Future main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  orm = await orm_ObjectBox.create();
  //final Classifier cls = new Classifier();
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
  int startingPage;

  MainPage({this.startingPage = 0});
  
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int indexBottomNavBar = 0;

  @override
  void initState(){
    super.initState();
    indexBottomNavBar = widget.startingPage;
    //orm _orm = new orm();
  }

  @override
  void dispose(){
    //_store.close();
    super.dispose();
  }

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
      items: /*mainPages.entries.map((mainPage) {
        return BottomNavigationBarItem(icon: mainPage["icon"],
        );
        },).toList(),*/
      [
        if (1+1 == 2) BottomNavigationBarItem(
          icon: Icon(Icons.fire_truck),//Image.asset('images/BottomNavBar/leaf.png'),//Text('', style: style),
          label: 'My plants',
        ),
        if (1+1 == 2) BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        if (1+1 == 2) BottomNavigationBarItem(
          icon: Icon(Icons.settings),//Text('', style: style),
          label: 'Settings',
        ),
        if (1+1 == 2) BottomNavigationBarItem(
          icon: Text('', style: style),
          label: 'Predict',
        ),
        if (1+1 == 2) BottomNavigationBarItem(
          icon: Icon(Icons.camera),//Text('', style: style),
          label: 'Camera',
        ),
        if (1+1 == 2) BottomNavigationBarItem(
          icon: Text('ExpansionTile', style: style),
          label: 'Other',
        ),
      ],
      onTap: (int index) => setState(() => this.indexBottomNavBar = index),
    );
  }

  Widget buildPages() {
    if(mainPages[indexBottomNavBar]["show"] != 0) {
      return mainPages[indexBottomNavBar]["page"];
    }else{
      return Container();
    }
    /*switch (indexBottomNavBar) {
      case 0:
        return MyHomePage(); //Homepage (My plants)
      case 1:
        return MapPage(); //Map
      case 2:
        return SettingsPage(); //Settings
      case 3:
        return MyModel(title: 'My classifier'); //Classifier
      case 4:
        return CameraScreen();//MyCamera(); //Hidden: Camera
      default:
        return Container();
    }*/
  }

  
  void createNewUser(){
    String firstName = faker.person.firstName();
    String lastName = faker.person.lastName();
    currentUser = User(username: firstName + rndInt(10,999).toString(), email: "${firstName}.${lastName}@${emailProvider[rndInt(0,emailProvider.length-1)]}");
  }

}