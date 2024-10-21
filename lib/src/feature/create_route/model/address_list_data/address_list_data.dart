import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_list_data.freezed.dart';

@freezed
class AddressListData with _$AddressListData {
  const factory AddressListData({
    required String? title,
    required String? subtitle,
    required String? full,
  }) = _AddressListData;

  const AddressListData._();

  bool get isEmpty => title == null && subtitle == null;
}
