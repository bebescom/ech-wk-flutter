import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ech_workers/utils/logger.dart';

class IpListService {
  static final IpListService _instance = IpListService._internal();
  factory IpListService() => _instance;
  
  static const String _ipv4ListUrl = 'https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt';
  static const String _ipv6ListUrl = 'https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ipv6_list.txt';
  
  IpListService._internal();
  
  static Future<void> initialize() async {
    Logger.info('IpListService initialized');
  }
  
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  
  Future<File> _getIpListFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }
  
  Future<bool> _isIpListValid(String filename) async {
    try {
      final file = await _getIpListFile(filename);
      if (!await file.exists()) {
        return false;
      }
      
      final length = await file.length();
      if (length < 1024) { // 文件太小，可能不完整
        return false;
      }
      
      // 检查文件修改时间，超过7天需要更新
      final lastModified = await file.lastModified();
      final sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));
      if (lastModified.isBefore(sevenDaysAgo)) {
        return false;
      }
      
      return true;
    } catch (e) {
      Logger.error('Error checking IP list validity: $e');
      return false;
    }
  }
  
  Future<void> downloadIpList(String url, String filename) async {
    try {
      Logger.info('Downloading $filename from $url');
      
      final dio = Dio();
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final file = await _getIpListFile(filename);
        await file.writeAsBytes(response.data!);
        Logger.info('Successfully downloaded $filename');
      } else {
        throw Exception('Failed to download $filename: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Error downloading $filename: $e');
      throw e;
    }
  }
  
  Future<void> downloadIpListsIfNeeded() async {
    try {
      // 检查IPv4列表
      final ipv4Valid = await _isIpListValid('chn_ip.txt');
      if (!ipv4Valid) {
        await downloadIpList(_ipv4ListUrl, 'chn_ip.txt');
      } else {
        Logger.info('IPv4 list is valid, no need to download');
      }
      
      // 检查IPv6列表
      final ipv6Valid = await _isIpListValid('chn_ip_v6.txt');
      if (!ipv6Valid) {
        await downloadIpList(_ipv6ListUrl, 'chn_ip_v6.txt');
      } else {
        Logger.info('IPv6 list is valid, no need to download');
      }
      
    } catch (e) {
      Logger.error('Error checking/downloading IP lists: $e');
      // 这里可以选择不抛出异常，让用户继续使用，只是可能没有最新的IP列表
    }
  }
  
  Future<void> forceUpdateIpLists() async {
    await downloadIpList(_ipv4ListUrl, 'chn_ip.txt');
    await downloadIpList(_ipv6ListUrl, 'chn_ip_v6.txt');
  }
}