import 'package:projeto_game_quiz/core/api/api_constant.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;
  final String url;
  final Function(String) onMessageReceived;
  final void Function(Object)? onError;
  final void Function()? onDone;
  
  late final String _baseUrl = (() {
    final uri = Uri.parse(BASE_URL);

    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';

    return Uri(
      scheme: scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
      path: '/ws',
    ).toString();
  })();

  WebSocketService({
    required this.url,
    required this.onMessageReceived,
    this.onError,
    this.onDone,
  });

  void connect() {
    var uri = Uri.parse("$_baseUrl$url");
    _channel = WebSocketChannel.connect(uri);
    _channel.stream.listen((message) {
      onMessageReceived(message);
    }, onError: onError, onDone: onDone);
  }

  void sendMessage(String message) {
    _channel.sink.add(message);
  }

  void disconnect() {
    _channel.sink.close();
  }
}
