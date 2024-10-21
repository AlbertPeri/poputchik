import 'package:companion/src/feature/app/logic/logic.dart';
import 'package:companion/src/runner/runner_shared.dart';

class IoInitializationHooks extends InitializationHooks {
  const IoInitializationHooks();
}

void run() => sharedRun(const IoInitializationHooks());
