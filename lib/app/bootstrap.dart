import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../core/config/env_config.dart';
import 'bindings/app_binding.dart';
import 'sports_app.dart';

Future<void> bootstrap(EnvConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('zh_CN');
  await GetStorage.init();
  await AppBinding().dependencies(config);
  runApp(const SportsApp());
}
