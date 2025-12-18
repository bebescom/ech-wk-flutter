import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ech_workers/ui/screens/home_screen.dart';
import 'package:ech_workers/ui/theme/app_theme.dart';
import 'package:ech_workers/services/proxy_service.dart';
import 'package:ech_workers/services/ip_list_service.dart';
import 'package:ech_workers/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化日志
  Logger.init();
  
  // 初始化服务
  await ProxyService.initialize();
  await IpListService.initialize();
  
  // 锁定竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECH Workers',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}