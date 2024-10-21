import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/// Формат вводимого текста
extension TextInputFormatterX on TextInputFormatter {
  /// Только текст
  static FilteringTextInputFormatter get onlyText => FilteringTextInputFormatter.allow(RegExp(r'\D'));

  /// Числовая маска номера телефона
  static MaskTextInputFormatter get phoneMask => MaskTextInputFormatter(
        mask: '+7 (###) ### ## ##',
        filter: {'#': RegExp('[0-9]')},
        type: MaskAutoCompletionType.eager,
      );
}
