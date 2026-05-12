import 'app/bootstrap.dart';
import 'core/config/env_config.dart';

const _flavor = String.fromEnvironment('APP_FLAVOR', defaultValue: 'mock');

Future<void> main() async {
  await bootstrap(_resolveEnvConfig(_flavor));
}

EnvConfig _resolveEnvConfig(String flavor) {
  return switch (flavor) {
    'prod' || 'production' => const EnvConfig.prod(),
    'dev' || 'development' => const EnvConfig.dev(),
    _ => const EnvConfig.mock(),
  };
}
