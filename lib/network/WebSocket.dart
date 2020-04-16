import 'dart:typed_data';

import 'package:web_socket_channel/io.dart';

class WebSocket {
  IOWebSocketChannel wsChannel;

  void connect(String url) {
    wsChannel = IOWebSocketChannel.connect(url);
  }

  void send(Uint8List data) {
    wsChannel.sink.add(data);
  }

  void close() async {
    await wsChannel.sink.close();
  }
}

enum WebSocketMessageType { DATA, CONNECT, DISCONNECT }

WebSocketMessageType getWebSocketMessageType(int byte) {
  switch (byte) {
    case 0:
      return WebSocketMessageType.DATA;
    case 1:
      return WebSocketMessageType.CONNECT;
    case 2:
      return WebSocketMessageType.DISCONNECT;
    default:
      return null;
  }
}

extension wsGetTypeByte on WebSocketMessageType {
  int get byte {
    switch (this) {
      case WebSocketMessageType.DATA:
        return 0;
      case WebSocketMessageType.CONNECT:
        return 1;
      case WebSocketMessageType.DISCONNECT:
        return 2;
      default:
        return null;
    }
  }
}