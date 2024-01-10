import 'package:actual/riverpod/provider_observer.dart';
import 'package:actual/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    //ProviderScope가 맨 최상위에 있어야 provider가 동작함 아니면 인식을 안함
    ProviderScope(
      observers: [
        Logger(),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}
