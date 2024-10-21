import 'package:drift/drift.dart';

@DataClassName('UserDB')
class Users extends Table {
  IntColumn get id => integer()();

  IntColumn get userId => integer()();

  TextColumn get name => text().nullable()();

  TextColumn get surname => text().nullable()();

  TextColumn get patronymic => text().nullable()();

  BoolColumn get hidePhone => boolean().withDefault(const Constant(false))();

  TextColumn get phoneNumber => text().nullable()();

  TextColumn get imageUrl => text().nullable()();

  RealColumn get averageRating => real().nullable()();

  TextColumn get reviewReceiver => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
