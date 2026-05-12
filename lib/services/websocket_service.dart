import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketService({required this.url});

  final String url;
  late WebSocketChannel _channel;
  final _streamController = StreamController<dynamic>.broadcast();

  Stream<dynamic> get stream => _streamController.stream;

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel.stream.listen((message) {
      _streamController.add(message);
    }, onError: (error) {
      reconnect();
    }, onDone: () {
      reconnect();
    });
  }

  void reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      connect();
    });
  }

  void subscribe(String matchId) {
    _channel.sink.add({'action': 'subscribe', 'matchId': matchId}.toString());
  }

  void dispose() {
    _channel.sink.close();
    _streamController.close();
  }
}