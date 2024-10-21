import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/user/database/table/user_db.dart';
import 'package:drift/drift.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  Selectable<UserDB> get dbUsers => select(users);

  void upsertUser(UserDB userDb) =>
      batch((batch) => batch.insertAllOnConflictUpdate(users, [userDb]));

  void deleteAllUsers() => delete(users).go();

  void deleteUserById(int id) =>
      (delete(users)..where((tbl) => tbl.id.equals(id))).go();
}
