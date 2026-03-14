import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_local_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [UserLocalModelSchema],
        directory: dir.path,
      );
    }
    return Isar.getInstance()!;
  }

  Future<void> saveUserLocally(UserLocalModel user) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.userLocalModels.put(user);
    });
  }

  Future<void> saveUser(UserLocalModel newUser) async {
    await saveUserLocally(newUser);
  }

  Future<UserLocalModel?> getUser() async {
    final isar = await db;
    return await isar.userLocalModels.filter().uidIsNotEmpty().findFirst();
  }

  Future<void> clearDB() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }
}
