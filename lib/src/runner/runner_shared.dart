import 'package:companion/src/feature/app/app.dart';
import 'package:companion/src/feature/app/logic/logic.dart';

void sharedRun(InitializationHooks initializationHooks) => MainRunner.run(
      appBuilder: (initializationData) => App(
        initializationData: initializationData,
      ),
      hooks: initializationHooks,
    );
