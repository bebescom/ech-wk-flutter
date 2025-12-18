import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ech_workers/services/proxy_service.dart';
import 'package:ech_workers/models/server_config.dart';
import 'package:ech_workers/ui/widgets/server_config_form.dart';
import 'package:ech_workers/ui/widgets/server_list.dart';
import 'package:ech_workers/ui/widgets/log_viewer.dart';
import 'package:ech_workers/utils/logger.dart';

class HomeScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proxyService = ProxyService();
    final isRunning = useState(false);
    final currentConfig = useState<ServerConfig?>(null);
    final selectedTab = useState(0);
    
    // 监听代理状态变化
    useEffect(() {
      final statusSubscription = proxyService.statusStream.listen((status) {
        isRunning.value = status;
      });
      
      final configSubscription = proxyService.statusStream.listen((_) {
        currentConfig.value = proxyService.currentConfig;
      });
      
      // 初始化时获取当前状态
      isRunning.value = proxyService.isRunning;
      currentConfig.value = proxyService.currentConfig;
      
      return () {
        statusSubscription.cancel();
        configSubscription.cancel();
      };
    }, []);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('ECH Workers'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 打开设置页面
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 代理状态指示器
          _buildStatusIndicator(context, isRunning.value, currentConfig.value),
          
          // 主内容区域
          Expanded(
            child: IndexedStack(
              index: selectedTab.value,
              children: [
                // 服务器配置标签
                ServerList(
                  onConfigSelected: (config) async {
                    try {
                      await proxyService.startProxy(config);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('启动代理失败: $e')),
                      );
                    }
                  },
                ),
                
                // 日志标签
                LogViewer(),
              ],
            ),
          ),
        ],
      ),
      
      // 底部导航
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab.value,
        onTap: (index) => selectedTab.value = index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '服务器',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '日志',
          ),
        ],
      ),
      
      // 浮动操作按钮
      floatingActionButton: isRunning.value
          ? FloatingActionButton.extended(
              onPressed: () async {
                try {
                  await proxyService.stopProxy();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('停止代理失败: $e')),
                  );
                }
              },
              icon: Icon(Icons.stop),
              label: Text('停止代理'),
              backgroundColor: Colors.red,
            )
          : FloatingActionButton(
              onPressed: () => _showAddConfigDialog(context),
              child: Icon(Icons.add),
              tooltip: '添加服务器',
            ),
    );
  }
  
  Widget _buildStatusIndicator(BuildContext context, bool isRunning, ServerConfig? config) {
    return Container(
      padding: EdgeInsets.all(16),
      color: isRunning ? Colors.green[100] : Colors.grey[100],
      child: Row(
        children: [
          Icon(
            isRunning ? Icons.check_circle : Icons.error,
            color: isRunning ? Colors.green : Colors.grey,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              isRunning 
                  ? '代理已启动: ${config?.serverAddress ?? '未知服务器'}'
                  : '代理已停止',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isRunning ? Colors.green[800] : Colors.grey[800],
              ),
            ),
          ),
          if (isRunning)
            ElevatedButton(
              onPressed: () {
                // 显示当前配置详情
                _showConfigDetails(context, config!);
              },
              child: Text('详情'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
        ],
      ),
    );
  }
  
  void _showAddConfigDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('添加服务器配置'),
        content: ServerConfigForm(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
        ],
      ),
    );
  }
  
  void _showConfigDetails(BuildContext context, ServerConfig config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('当前配置详情'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('服务器地址', config.serverAddress),
              _buildDetailRow('监听地址', config.listenAddress),
              _buildDetailRow('分流模式', config.routingMode.displayName),
              if (config.token.isNotEmpty)
                _buildDetailRow('令牌', '******'),
              if (config.ip.isNotEmpty)
                _buildDetailRow('优选IP', config.ip),
              _buildDetailRow('DNS', config.dns),
              _buildDetailRow('ECH域名', config.echDomain),
              _buildDetailRow('系统代理', config.setSystemProxy ? '已设置' : '未设置'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}