import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ta/network/WebSocket.dart';
import 'package:ta/network/network.dart';

Future remoteFetch() async {
  final ws = WebSocket();
  ws.connect(baseWsUrl + 'remote_fetch/v10');
  Socket socket;

  var byteCount = 0;
  final socketDataCallback = (targetData) async {
    final gziped = gzip.encode(targetData);
    final message = Uint8List.fromList([0, ...gziped]);

    byteCount += message.length;
    print('To remote: ' + message.length.toString() + ' Bytes');

    ws.send(message);
  };

  final buffer = <int>[];

  ws.wsChannel.stream.listen((rawMessage) async {
    print('From remote: ' + rawMessage.length.toString() + ' Bytes');
    byteCount += rawMessage.length;

    final type = getWebSocketMessageType(rawMessage[0]);
    final message = rawMessage.sublist(1);

    if (type == WebSocketMessageType.CONNECT) {
      final target = utf8.decode(message).split(':');
      socket = await Socket.connect(target[0], int.parse(target[1]));
      socket.listen(
        socketDataCallback,
        onDone: () async {
          print('socket on done');
          socket.destroy();
          ws.send(Uint8List.fromList([WebSocketMessageType.DISCONNECT.byte]));
        },
        onError: (error) {
          print('socket on error ${error}');
          socket.destroy();
          ws.close();
        },
      );
      print('socket connected');
      if (buffer.isNotEmpty) {
        socket.add(buffer);
        await socket.flush();
        print('sent server from buffer ${buffer.length} bytes');
        buffer.clear();
      }
    } else if (type == WebSocketMessageType.DATA) {
      if (socket == null) {
        buffer.addAll(gzip.decode(message));
      } else {
        socket.add(gzip.decode(message));
      }
    } else if (type == WebSocketMessageType.DISCONNECT) {
      final tempSocket = socket;
      socket = null;
      await tempSocket.flush();
      tempSocket.destroy();
      await ws.send(Uint8List.fromList([WebSocketMessageType.DISCONNECT.byte]));

      print('Total bytes: ' + byteCount.toString());
      byteCount = 0;
    }
  }, onDone: () {
    print('ws on done');
    socket?.destroy();
    ws.close();
  }, onError: (error) {
    print('ws on error $error');
    socket?.destroy();
    ws.close();
  });
}
