import 'package:objectbox/objectbox.dart';

@Entity()
class Plant {
  int id = 0;
  String nickname;
  String commonName;
  double tempC_min;
  double tempC_max;
  String description;
  String careAdvice;
  String fruitPeriod_start;
  String fruitPeriod_end;

  final owner = ToOne<User>();

  Plant({
    required this.nickname,
    required this.commonName,
    required this.tempC_min,
    required this.tempC_max,
    required this.description,
    required this.careAdvice,
    required this.fruitPeriod_start,
    required this.fruitPeriod_end,
  });
}

@Entity()
class User {
  int id = 0;
  String username;
  String email;

  @Backlink()
  final plants = ToMany<Plant>();

  User({
    required this.username,
    required this.email,
  });
}