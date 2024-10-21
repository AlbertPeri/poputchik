import 'package:flutter/material.dart';

class BottomSheetService {
  PersistentBottomSheetController? _bottomSheetController;

  void setController(PersistentBottomSheetController controller) {
    _bottomSheetController = controller;
  }

  void closeBottomSheet() {
    if (_bottomSheetController != null) {
      _bottomSheetController?.close();
      _bottomSheetController = null;
    }
  }

  bool get isBottomSheetOpen => _bottomSheetController != null;
}

final bottomSheetService = BottomSheetService();
