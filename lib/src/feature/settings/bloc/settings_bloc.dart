import 'package:companion/src/feature/settings/enum/theme_type.dart';
import 'package:companion/src/feature/settings/model/settings_data.dart';
import 'package:companion/src/feature/settings/repository/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_bloc.freezed.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required ISettingsRepository settingsRepository,
  })  : _settingsRepository = settingsRepository,
        super(
          SettingsState.idle(
            data: settingsRepository.currentData(),
          ),
        ) {
    on<SettingsEvent>(
      (event, emit) => event.map<Future<void>>(
        setTheme: (event) => _setTheme(event, emit),
      ),
    );
  }

  final ISettingsRepository _settingsRepository;

  SettingsData get _data => state.data;

  Future<void> _setTheme(
    _SettingsEventSetTheme event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      SettingsState.updatedSuccessfully(
        data: _settingsRepository.currentData(),
      ),
    );
    try {
      await _settingsRepository.setTheme(event.themeType);

      emit(
        SettingsState.updatedSuccessfully(
          data: _settingsRepository.currentData(),
        ),
      );
    } on Object catch (e) {
      emit(
        SettingsState.error(data: _data, description: e.toString()),
      );
    } finally {
      emit(SettingsState.idle(data: _data));
    }
  }
}
