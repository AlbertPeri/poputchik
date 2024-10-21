// ignore_for_file: strict_raw_type

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l/l.dart';

extension on StringBuffer {
  /// Writes the type of the object in debug mode to make logs **readable** and
  /// write the object's [toString] in release mode to make logs
  /// **informative**.
  void writeInfo(Object? object) {
    Type? type;

    // ignore: prefer_asserts_with_message
    assert(
      () {
        type = object.runtimeType;

        return true;
      }(),
    );

    write(type ?? object);
  }
}

class AppBlocObserver extends BlocObserver {
  void _log(void Function(StringBuffer buffer) assemble) {
    final buffer = StringBuffer('AppBlocObserver | ');

    assemble(buffer);

    l.d(buffer.toString());
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _log(
      (buffer) => buffer
        ..write('Created ')
        ..writeInfo(bloc),
    );
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (event != null) {
      _log(
        (buffer) => buffer
          ..write('Event ')
          ..writeInfo(event)
          ..write(' in ')
          ..writeInfo(bloc),
      );
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    final event = transition.event;

    if (event != null) {
      _log(
        (buffer) => buffer
          ..write('Transition in ')
          ..writeInfo(bloc)
          ..write(' with ')
          ..writeInfo(event)
          ..write(': ')
          ..writeInfo(transition.currentState)
          ..write(' -> ')
          ..writeInfo(transition.nextState),
      );
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _log(
      (buffer) => buffer
        ..write('Error ')
        ..writeInfo(error)
        ..write(' in ')
        ..writeInfo(bloc),
    );

    l.e(error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _log(
      (buffer) => buffer
        ..write('Closed ')
        ..writeInfo(bloc),
    );
  }
}
