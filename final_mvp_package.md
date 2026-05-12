# TiYu App MVP 完整提交预览

## 提交内容概览

### Repository 层
- SportsRepositoryImpl（真实 API + Mock + WebSocket 支持）
- JSON → Model 映射方法完善
- ApiClient 封装 GET/POST/Query参数处理

### Controllers
- HomeController / StandingsController / FavoritesController / SettingsController
- 支持 StateMixin、RxStatus、刷新、错误处理、空状态

### UI 页面
- RootPage + BottomNavigationBar
- HomePage / StandingsPage / FavoritesPage / SettingsPage
- AsyncStateView + EmptyView / ErrorView / RefreshIndicator

### 全局配置
- EnvConfig（mock/dev/prod）
- FeatureFlags（暗黑模式、通知、进阶统计等）
- AppTheme（动态浅/深色）
- HttpUtils（网络请求、全局错误、Token刷新）

### 启动逻辑
- SportsApp 初始化 Theme + UI Bindings + EnvConfig

### 单元测试
- Repository 基础测试覆盖

## 提交说明
- 一次性提交全部文件
- 分支：`main`
- 功能完整可编译运行
- 包含核心模块绑定、状态管理、数据接口、全局配置

## 下一步
- 由你确认是否执行提交，我将统一推送到 `main` 分支