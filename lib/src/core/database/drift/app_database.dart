// ignore_for_file: lines_longer_than_80_chars

import 'package:companion/src/core/database/drift/connection/open_connection_stub.dart'
    if (dart.library.io) 'package:companion/src/core/database/drift/connection/open_connection_io.dart'
    if (dart.library.html) 'package:companion/src/core/database/drift/connection/open_connection_web.dart'
    as connection;
import 'package:companion/src/feature/user/database/dao/users_dao.dart';
import 'package:companion/src/feature/user/database/table/user_db.dart';
import 'package:drift/drift.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
  ],
  daos: [
    UsersDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({required String name}) : super(connection.openConnection(name));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            // Если версия базы данных ниже 2, выполняем соответствующую миграцию.
            await migrator.addColumn(users, users.hidePhone);
          }

          // Добавляем проверку на наличие нужного поля, если версия не совпадает
          final columnExists = await customSelect(
            'PRAGMA table_info(users);',
            variables: [],
          ).get().then((rows) {
            return rows.any((row) => row.data['name'] == 'hide_phone');
          });

          if (!columnExists) {
            // Если поле не найдено, добавляем его вручную.
            await migrator.addColumn(users, users.hidePhone);
          }
        },
        onCreate: (Migrator m) {
          // Создание таблицы
          return m.createAll();
        },
      );

  //       // onUpgrade: (m, from, to) async {
  //       //   if (to > 4) {
  //       //     // Проверка наличия столбца 'hidePhone'
  //       //     final hasHidePhoneColumn = await customSelect(
  //       //       'PRAGMA table_info(users);',
  //       //       readsFrom: {users},
  //       //     ).get().then((rows) {
  //       //       return rows.any((row) => row.data['name'] == 'hide_phone');
  //       //     });

  //       //     if (!hasHidePhoneColumn) {
  //       //       // Добавляем столбец hidePhone, если его нет
  //       //       await m.addColumn(users, users.hidePhone);
  //       //     }
  //       //   }
  //       // },
  //       // if (from == 2 && to == 3) {
  //       //
  //       // }
  //     );
}
