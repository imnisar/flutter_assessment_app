import 'package:isar/isar.dart';

part 'user_local_model.g.dart';

@collection
class UserLocalModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  late String email;
  late String username;
  late String birthday;

  UserLocalModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.birthday,
  });
}
