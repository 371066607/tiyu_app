import 'app/bootstrap.dart';
import 'core/config/env_config.dart';

Future<void> main() async {
  await bootstrap(const EnvConfig.dev());
}
