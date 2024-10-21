import 'dart:async';

import 'package:companion/firebase_options.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/app/bloc/app_bloc_observer.dart';
import 'package:companion/src/feature/app/bloc/initialization/initialization_bloc.dart';
import 'package:companion/src/feature/app/logic/logic.dart';
import 'package:companion/src/feature/notification/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

typedef AppBuilder = Widget Function(InitializationData initializationData);

abstract class InitializationHooks {
  const InitializationHooks();

  @mustCallSuper
  @protected
  void onStarted() {}

  @mustCallSuper
  @protected
  void onProgress(InitializationProgress progress) {}

  @mustCallSuper
  @protected
  void onInitialized(InitializationData initializationData) {}

  @mustCallSuper
  @protected
  void onFailed(
    InitializationProgress lastProgress,
    Object error,
    StackTrace stackTrace,
  ) {}
}

mixin MainRunner {
  static void _amendFlutterError() {
    const log = Logger.logFlutterError;

    FlutterError.onError = FlutterError.onError?.amend(log) ?? log;
  }

  static T? _runZoned<T>(T Function() body) => Logger.runLogging(
        () => runZonedGuarded(
          body,
          Logger.logZoneError,
        ),
      );

  static void _runApp({
    required bool shouldSend,
    required AppBuilder appBuilder,
    required InitializationHooks? hooks,
  }) {
    final initializationBloc = InitializationBloc()
      ..add(
        InitializationEvent.initialize(shouldSendSentry: shouldSend),
      );
    StreamSubscription<InitializationState>? initializationSubscription;

    void terminate() {
      initializationSubscription?.cancel();
      initializationBloc.close();
    }

    void processInitializationState(InitializationState state) {
      state.map(
        notInitialized: (_) => hooks?.onStarted(),
        initializing: (state) => hooks?.onProgress(state.progress),
        initialized: (state) {
          terminate();
          Future<void>(() => hooks?.onInitialized(state));
          runApp(
            appBuilder(state),
          );
        },
        error: (state) {
          terminate();
          hooks?.onFailed(state.progress, state.error, state.stackTrace);
        },
      );
    }

    initializationSubscription = initializationBloc.stream
        .startWith(initializationBloc.state)
        .listen(processInitializationState, cancelOnError: false);
  }

  static void run({
    required AppBuilder appBuilder,
    bool shouldSend = !kDebugMode,
    InitializationHooks? hooks,
  }) {
    _runZoned(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        await NotificationService.setup();
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        _amendFlutterError();
        Bloc.observer = AppBlocObserver();
        _runApp(
          shouldSend: shouldSend,
          appBuilder: appBuilder,
          hooks: hooks,
        );
      },
    );
  }
}
