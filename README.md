# ECH Workers Flutter 版

ECH Workers 代理客户端的 Flutter 实现，支持 Android 平台，提供现代化的用户界面和稳定的性能。

##  功能特性

###  核心功能
- ✅ **ECH 加密** - 基于 TLS 1.3 ECH 技术，加密 SNI 信息
- ✅ **多协议支持** - 同时支持 SOCKS5 和 HTTP CONNECT 代理协议
- ✅ **智能分流** - 三种分流模式：全局代理、跳过中国大陆、直连模式
- ✅ **IPv4/IPv6 双栈** - 完整支持 IPv4 和 IPv6 地址的分流判断

###  界面功能
- ✅ **多服务器管理** - 支持多个服务器配置，快速切换
- ✅ **一键系统代理** - 自动设置系统代理，支持分流模式
- ✅ **实时日志** - 查看代理运行状态和日志
- ✅ **配置持久化** - 自动保存配置，下次启动自动加载

###  高级功能
- ✅ **自动 IP 列表更新** - 自动下载并应用完整的中国 IP 列表
- ✅ **DNS 优选** - 支持自定义 DoH 服务器进行 ECH 查询
- ✅ **IP 直连** - 支持指定服务端 IP，绕过 DNS 解析

##  技术栈

- **Flutter 3.22+** - 跨平台 UI 框架
- **Dart 3.0+** - 编程语言
- **Riverpod** - 状态管理
- **Material Design 3** - UI 设计系统

##  快速开始

###  开发环境要求
- Flutter SDK 3.22+
- Dart SDK 3.0+
- Android Studio 或 VS Code
- Android 设备或模拟器（API 21+）

###  构建 APK

####  本地构建
```bash
# 克隆仓库
git clone https://github.com/yourusername/ech-wk-flutter.git
cd ech-wk-flutter

# 安装依赖
flutter pub get

# 构建 Android APK (arm-v7a)
flutter build apk --release --target-platform android-arm

# 构建结果在 build/app/outputs/flutter-apk/ 目录下
```

####  GitHub Actions 自动构建
项目已配置 GitHub Actions，每次推送到 main 分支都会自动构建 arm-v7a APK 并发布到 Releases。

##  使用说明

###  添加服务器配置
1. 点击右下角的 "+" 按钮
2. 填写服务器信息：
   - **服务器地址** - 您的 Workers 地址（如：your-worker.workers.dev:443）
   - **监听地址** - 本地代理监听地址（默认：127.0.0.1:30001）
   - **分流模式** - 选择代理模式
   - **高级选项** - 令牌、优选 IP、DNS 服务器等

###  启动代理
1. 在服务器列表中选择一个配置
2. 点击配置项即可启动代理
3. 代理启动后会显示在状态栏

###  查看日志
1. 点击底部导航栏的 "日志" 标签
2. 查看实时的代理运行日志

##  项目结构

```
ech-wk-flutter/
├── lib/
│   ├── main.dart                # 主入口
│   ├── models/                  # 数据模型
│   ├── services/                # 服务层
│   │   ├── proxy_service.dart   # 代理服务
│   │   ├── system_proxy.dart    # 系统代理设置
│   │   └── ip_list_service.dart # IP列表管理
│   ├── ui/                      # UI组件
│   │   ├── screens/             # 屏幕
│   │   ├── widgets/             # 小部件
│   │   └── theme/               # 主题
│   └── utils/                   # 工具类
├── android/                     # Android配置
├── .github/workflows/           # GitHub Actions
└── pubspec.yaml                 # 依赖配置
```

##  常见问题

###  Q: 为什么需要 Go 环境？
A: 目前版本的代理核心功能仍使用 Go 实现，通过 Flutter 的 MethodChannel 调用。未来计划完全迁移到 Dart。

###  Q: 如何设置开机自启？
A: Android 平台的开机自启需要特殊权限，目前版本暂不支持，将在后续版本中添加。

###  Q: 支持哪些 Android 版本？
A: 支持 Android 5.0 (API 21) 及以上版本。

##  贡献

欢迎提交 PR 或提出 issues。在提交 PR 前，请确保代码符合 Flutter 代码规范。

##  许可证

本项目采用 MIT 许可证，详情请见 LICENSE 文件。