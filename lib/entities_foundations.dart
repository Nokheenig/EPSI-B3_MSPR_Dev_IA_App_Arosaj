import 'entities.dart';
import 'package:faker/faker.dart';
import 'dart:math' hide log;
import 'dart:developer';


List<String> emailProvider = ["gmail.com","yahoo.fr","caramail.com"];
class defaultContent {
  static List<String> plantNames = <String>['Absinthe','bambou','bougainvillier','capucine','ficus','glycine','hibiscus'];
  static List<String> yearMonths = <String>['Jan','Feb','Mar','Apr','May','June','July','Aug','Sept','Oct','Nov','Dec'];

  static List<Plant> plants () {
    log("hey its me, default content : plants");
    List<Plant> plantList = <Plant>[];
    var plantName = 'default';
    var nickName = 'default';

    for (var i=0; i<5; i++){
      plantName = plantNames[Random().nextInt(plantNames.length)];
      if(i%2 == 0){
        nickName = faker.person.firstName();
      }else{
        nickName = plantName;
      }
      plantList.add(
        Plant(
          nickname: nickName,
          commonName: plantName,
          tempC_min: faker.randomGenerator.integer(8, min:3).toDouble(),
          tempC_max: faker.randomGenerator.integer(38, min:25).toDouble(),
          description: faker.lorem.sentences(3).toString(),
          careAdvice: faker.lorem.sentences(4).toString(),
          fruitPeriod_start: yearMonths[faker.randomGenerator.integer(11,min:0)],
          fruitPeriod_end: yearMonths[faker.randomGenerator.integer(11,min:0)]
              )
      );
    }//List<Plant> plats = <Plant>[];
    return plantList;
  } 
}