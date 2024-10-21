import 'package:companion/src/feature/app/logic/logic.dart';
import 'package:companion/src/runner/runner_shared.dart';

class WebInitializationHooks extends InitializationHooks {
  const WebInitializationHooks();
}

void run() => sharedRun(const WebInitializationHooks());
