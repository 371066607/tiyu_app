# tiyu_app

Flutter 实时赛事 App MVP，按项目内 `realtime_sports_flutter_app_prd_task_plan.xlsx` 推进，当前优先完成了 `Foundation + Data Layer + Home/Detail/Favorites/Settings` 主链路。

## MVP 范围

- 首页赛事流：推荐分类、日期切换、实时/未开赛/完场卡片展示
- 比赛详情：比分头部、事件时间线、统计 Tab、阵容占位
- 关注体系：首页和详情统一收藏，`GetStorage` 本地持久化
- 设置中心：主题模式、通知偏好、隐私说明、测试通知
- 多环境入口：`mock / dev / prod`

当前默认使用 `mock` 数据源，`dev/prod` 入口已接好远端仓储结构，方便后续切换真实接口。

## 架构说明

项目严格按 MVVM 落层：

- `domain/models`：纯数据模型
- `domain/repositories`：仓储接口
- `data/*`：仓储实现、API 客户端、本地存储
- `presentation/**/**/*_controller.dart`：ViewModel / Controller
- `presentation/**/**/*_page.dart`、`widgets/`：View
- `app/bindings`：依赖注入
- `app/routes`：路由定义

技术选型：

- 状态管理与路由：`GetX`
- 轻量持久化：`GetStorage`
- 网络层：`Dio`
- 本地通知：`flutter_local_notifications`
- 实时通道预留：`web_socket_channel`

## 运行方式

安装依赖：

```bash
flutter pub get
```

默认 Mock 环境：

```bash
flutter run
```

Dev 环境：

```bash
flutter run -t lib/main_dev.dart
```

Prod 环境：

```bash
flutter run -t lib/main_prod.dart
```

Web 构建：

```bash
flutter build web
```

Android Debug 包：

```bash
flutter build apk --debug
```

## 已验证

- `flutter analyze`
- `flutter test`
- `flutter build web`

Android 构建已补齐本地通知依赖需要的 desugaring 配置。

## 后续建议

- 把 `WebSocketService` 升级为真正的订阅、心跳、断线重连与事件去重链路
- 为 `dev/prod` 对接真实赛事接口和字段映射测试
- 继续补 PRD 中的通知策略、弱网兜底、更多 Widget/集成测试
