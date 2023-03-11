
import 'package:objectbox/objectbox.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:expandable_listview_example/entities.dart';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:expandable_listview_example/objectbox.g.dart';
import 'package:expandable_listview_example/entities_foundations.dart';

class orm_ObjectBox {
  //final _random = new Random();
  //int rndInt(int min, int max) => min + _random.nextInt(max - min);
  


  final faker = Faker();

  late final Store store;
  bool bStoreHasBeenInitialized = false;

  late final Box plantBox;
  late final Box userBox;

  orm_ObjectBox._create (this.store) {
      this.plantBox =  Box(store);
      this.userBox = Box(store);
  }

  
  static Future<orm_ObjectBox> create() async {
    // Future<store> openStore() {...} is defined in the generated objectbox.g.dart
    getApplicationDocumentsDirectory().then((dir) async{
      final store = await Store(
            getObjectBoxModel(),
            directory: join(dir.path, 'objectbox')
          );
      return orm_ObjectBox._create(store);
    });
    throw ObjectBoxException('Error during store creation');
  }

  Future<void> addDefaultContent() async {
    List<Plant> plants = defaultContent.plants();
    //plants[1].commonName;
    //plants[0].nickname;
    plantBox.put(plants);
  }

}
