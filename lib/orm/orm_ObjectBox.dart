
import 'package:objectbox/objectbox.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import '../entities.dart';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../objectbox.g.dart';
import '../entities_foundations.dart';

class orm_ObjectBox {
  //final _random = new Random();
  //int rndInt(int min, int max) => min + _random.nextInt(max - min);
  


  final faker = Faker();

  late final Store store;
  bool bStoreHasBeenInitialized = false;

  //late final Box plantBox;
  //late final Box userBox;

  orm_ObjectBox._create (Store astore) {
      log("Box constructor start");
      store = astore;
      log("Store affected:");
      log(store.toString());
      //plantBox =  Box(astore);
      //this.userBox = Box(this.store);
      log("Box constructor end");
  }

  
  static Future<orm_ObjectBox> create() async {
    // Future<store> openStore() {...} is defined in the generated objectbox.g.dart
    log("Hey, it's me orm_ObjectBox_create");
    var dir = await getApplicationDocumentsDirectory();
    log("Application Documents Directory:");
    log(dir.path.toString());
    final store = Store(
          getObjectBoxModel(),
          directory: join(dir.path, 'objectbox')
        );
    log("Store has been created.");
    return orm_ObjectBox._create(store);
    /*
    getApplicationDocumentsDirectory().then((dir) {
    });
    log('Error during storz creation');//throw ObjectBoxException('Error during storz creation');
    */
  }

  void addDefaultContent() {
    log("hey its me, addDefaultContent (orm)");
    List<Plant> plants = defaultContent.plants();
    //plants[1].commonName;
    //plants[0].nickname;
    plants.forEach((element) {
      this.store.box<Plant>().put(element);
    });
  }

}
