import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  const channel = MethodChannel('pingpong');
  final pongCompleter = Completer<String>();
  final pong = pongCompleter.future;

  channel.setMethodCallHandler((MethodCall methodCall) {
    final message = 'Flutter: ${methodCall.method}';
    print(message);
    pongCompleter.complete(message);
  });
  channel.invokeMethod('ping');

  // Doing some more work here, during which Android might have already called "pong"...
  await Future.delayed(Duration(seconds: 2));
  // NOTE: If you remove the line above, "Flutter: pong" gets displayed as expected.

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Ping Pong Test'),
      ),
      body: Center(
        child: FutureBuilder(
          future: pong,
          builder: (context, snapshot) => Text(snapshot.data ?? 'Nothing yet'),
        ),
      ),
    ),
  ));
}
