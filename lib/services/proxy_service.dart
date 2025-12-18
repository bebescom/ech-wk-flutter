import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:ech_workers/models/server_config.dart';
import 'package:ech_workers/utils/logger.dart';
import 'package:ech_workers/services/ip_list_service.dart';

class ProxyService {
  static final ProxyService _instance = ProxyService._internal();
  factory ProxyService() => _instance;
  
  static const MethodChannel _channel = MethodChannel('ech_workers/proxy');
  
  bool _isRunning = false;
  ServerConfig? _currentConfig;
  StreamController<bool> _statusController = StreamController.broadcast();
  StreamController<String> _logController = StreamController.broadcast();
  
  Stream<bool> get statusStream => _statusController.stream;
  Stream<String> get logStream => _logController.stream;
  bool get isRunning => _isRunning;
  ServerConfig? get currentConfig => _currentConfig;
  
  ProxyService._internal();
  
  static Future<void> initialize() async {
    // 初始化时可以做一些准备工作
    Logger.info('ProxyService initialized');
  }
  
  Future<void> startProxy(ServerConfig config) async {
    try {
      if (_isRunning) {
        await stopProxy();
      }
      
      _currentConfig = config;
      _logController.add('Starting proxy with config: ${config.serverAddress}');
      
      // 保存当前配置
      await _saveCurrentConfig(config);
      
      // 下载IP列表（如果需要）
      if (config.routingMode == RoutingMode.bypassCn) {
        await IpListService().downloadIpListsIfNeeded();
      }
      
      // 调用原生代码启动代理
      await _channel.invokeMethod('startProxy', {
        'serverAddress': config.serverAddress,
        'listenAddress': config.listenAddress,
        'token': config.token,
        'ip': config.ip,
        'dns': config.dns,
        'echDomain': config.echDomain,
        'routingMode': config.routingMode.name,
      });
      
      _isRunning = true;
      _statusController.add(true);
      _logController.add('Proxy started successfully');
      
      // 设置系统代理
      if (config.setSystemProxy) {
        await setSystemProxy(config.listenAddress);
      }
      
    } catch (e) {
      _logController.add('Failed to start proxy: $e');
      throw e;
    }
  }
  
  Future<void> stopProxy() async {
    try {
      if (!_isRunning) return;
      
      _logController.add('Stopping proxy');
      
      // 调用原生代码停止代理
      await _channel.invokeMethod('stopProxy');
      
      // 清理系统代理
      await clearSystemProxy();
      
      _isRunning = false;
      _statusController.add(false);
      _logController.add('Proxy stopped');
      
    } catch (e) {
      _logController.add('Failed to stop proxy: $e');
      throw e;
    }
  }
  
  Future<void> setSystemProxy(String listenAddress) async {
    try {
      _logController.add('Setting system proxy to: $listenAddress');
      
      // 解析监听地址
      final parts = listenAddress.split(':');
      final host = parts[0];
      final port = parts.length > 1 ? parts[1] : '30001';
      
      // 调用原生代码设置系统代理
      await _channel.invokeMethod('setSystemProxy', {
        'host': host,
        'port': port,
      });
      
      _logController.add('System proxy set successfully');
      
    } catch (e) {
      _logController.add('Failed to set system proxy: $e');
      // 这里可以选择不抛出异常，因为即使系统代理设置失败，代理本身可能仍然在运行
    }
  }
  
  Future<void> clearSystemProxy() async {
    try {
      _logController.add('Clearing system proxy');
      
      // 调用原生代码清理系统代理
      await _channel.invokeMethod('clearSystemProxy');
      
      _logController.add('System proxy cleared');
      
    } catch (e) {
      _logController.add('Failed to clear system proxy: $e');
      // 这里可以选择不抛出异常
    }
  }
  
  Future<void> restartProxy() async {
    if (_currentConfig != null) {
      await startProxy(_currentConfig!);
    }
  }
  
  Future<List<ServerConfig>> getSavedConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = prefs.getStringList('saved_configs') ?? [];
    return configsJson.map((json) => ServerConfig.fromJson(json)).toList();
  }
  
  Future<void> saveConfig(ServerConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final configs = await getSavedConfigs();
    
    // 检查是否已存在
    final index = configs.indexWhere((c) => c.id == config.id);
    if (index != -1) {
      configs[index] = config;
    } else {
      configs.add(config);
    }
    
    await prefs.setStringList('saved_configs', configs.map((c) => c.toJson()).toList());
  }
  
  Future<void> deleteConfig(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final configs = await getSavedConfigs();
    final newConfigs = configs.where((c) => c.id != id).toList();
    await prefs.setStringList('saved_configs', newConfigs.map((c) => c.toJson()).toList());
  }
  
  Future<ServerConfig?> getLastUsedConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('last_used_config');
    if (json != null) {
      return ServerConfig.fromJson(json);
    }
    return null;
  }
  
  Future<void> _saveCurrentConfig(ServerConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_used_config', config.toJson());
  }
}

enum RoutingMode {
  global,
  bypassCn,
  direct,
}

extension RoutingModeExtension on RoutingMode {
  String get displayName {
    switch (this) {
      case RoutingMode.global:
        return '全局代理';
      case RoutingMode.bypassCn:
        return '跳过中国大陆';
      case RoutingMode.direct:
        return '直连模式';
    }
  }
  
  String get description {
    switch (this) {
      case RoutingMode.global:
        return '所有流量都走代理';
      case RoutingMode.bypassCn:
        return '中国IP直连，其他走代理';
      case RoutingMode.direct:
        return '所有流量直连，不设置代理';
    }
  }
}