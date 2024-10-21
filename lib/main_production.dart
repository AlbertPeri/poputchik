import 'package:companion/src/runner/runner_stub.dart'
    if (dart.library.io) 'package:companion/src/runner/runner_io.dart'
    if (dart.library.html) 'package:companion/src/runner/runner_web.dart'
    as runner;

void main() => runner.run();
