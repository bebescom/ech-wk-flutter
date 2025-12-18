import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:ech_workers/services/proxy_service.dart';

class ServerConfig extends Equatable {
  final String id;
  final String serverAddress;
  final String listenAddress;
  final String token;
  final String ip;
  final String dns;
  final String echDomain;
  final RoutingMode routingMode;
  final bool setSystemProxy;
  final bool autoStart;
  
  ServerConfig({
    String? id,
    required this.serverAddress,
    this.listenAddress = '127.0.0.1:30001',
    this.token = '',
    this.ip = '',
    this.dns = 'dns-query',
    this.echDomain = 'cloudflare-ech.com',
    this.routingMode = RoutingMode.global,
    this.setSystemProxy = true,
    this.autoStart = false,
  }) : id = id ?? Uuid().v4();
  
  ServerConfig copyWith({
    String? id,
    String? serverAddress,
    String? listenAddress,
    String? token,
    String? ip,
    String? dns,
    String? echDomain,
    RoutingMode? routingMode,
    bool? setSystemProxy,
    bool? autoStart,
  }) {
    return ServerConfig(
      id: id ?? this.id,
      serverAddress: serverAddress ?? this.serverAddress,
      listenAddress: listenAddress ?? this.listenAddress,
      token: token ?? this.token,
      ip: ip ?? this.ip,
      dns: dns ?? this.dns,
      echDomain: echDomain ?? this.echDomain,
      routingMode: routingMode ?? this.routingMode,
      setSystemProxy: setSystemProxy ?? this.setSystemProxy,
      autoStart: autoStart ?? this.autoStart,
    );
  }
  
  String toJson() {
    return '{'
        '"id":"$id",'
        '"serverAddress":"$serverAddress",'
        '"listenAddress":"$listenAddress",'
        '"token":"$token",'
        '"ip":"$ip",'
        '"dns":"$dns",'
        '"echDomain":"$echDomain",'
        '"routingMode":"${routingMode.name}",'
        '"setSystemProxy":$setSystemProxy,'
        '"autoStart":$autoStart'
        '}';
  }
  
  static ServerConfig fromJson(String json) {
    // 简单的JSON解析，实际项目中可以使用json_serializable
    final map = _parseJson(json);
    return ServerConfig(
      id: map['id'],
      serverAddress: map['serverAddress'],
      listenAddress: map['listenAddress'] ?? '127.0.0.1:30001',
      token: map['token'] ?? '',
      ip: map['ip'] ?? '',
      dns: map['dns'] ?? 'dns-query',
      echDomain: map['echDomain'] ?? 'cloudflare-ech.com',
      routingMode: RoutingMode.values.firstWhere(
        (e) => e.name == map['routingMode'],
        orElse: () => RoutingMode.global,
      ),
      setSystemProxy: map['setSystemProxy'] ?? true,
      autoStart: map['autoStart'] ?? false,
    );
  }
  
  static Map<String, dynamic> _parseJson(String json) {
    // 简单的JSON解析实现
    final result = <String, dynamic>{};
    final cleaned = json.replaceAll('{', '').replaceAll('}', '').trim();
    final pairs = cleaned.split(',');
    
    for (final pair in pairs) {
      final parts = pair.split(':');
      if (parts.length >= 2) {
        final key = parts[0].trim().replaceAll('"', '');
        final value = parts.sublist(1).join(':').trim().replaceAll('"', '');
        
        if (value == 'true') {
          result[key] = true;
        } else if (value == 'false') {
          result[key] = false;
        } else {
          result[key] = value;
        }
      }
    }
    
    return result;
  }
  
  @override
  List<Object?> get props => [
        id,
        serverAddress,
        listenAddress,
        token,
        ip,
        dns,
        echDomain,
        routingMode,
        setSystemProxy,
        autoStart,
      ];
}