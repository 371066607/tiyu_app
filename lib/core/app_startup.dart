import 'package:flutter/material.dart';
import '../core/config/env_config.dart';
import '../core/app_theme.dart';
import '../presentation/ui/ui_bindings.dart';

class SportsApp extends StatelessWidget {
  final EnvConfig config;

  const SportsApp({required this.config, super.key});

  @override
  Widget build(BuildContext context) {
    initUIBindings();
    return MaterialApp(
      title: 'TiYu App',
      theme: AppTheme.currentTheme,
      home: const Placeholder(), // Replace with RootPage when ready
    );
  }
}