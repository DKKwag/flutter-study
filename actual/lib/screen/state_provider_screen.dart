import 'package:actual/layout/default_layout.dart';
import 'package:actual/riverpod/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StateProviderScreen extends ConsumerWidget {
  const StateProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(numberProvier);
    return DefaultLayout(
        title: 'StateProviderScreen',
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                provider.toString(),
              ),
              ElevatedButton(
                onPressed: () {
                  //provider의 값을 바꾸고싶을때는 .notifier를 써준다.
                  ref.read(numberProvier.notifier).update((state) => state + 1);
                },
                child: const Text(
                  'UP',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //provider의 값을 바꾸고싶을때는 .notifier를 써준다.
                  ref.read(numberProvier.notifier).state =
                      ref.read(numberProvier.notifier).state - 1;
                },
                child: const Text(
                  'DOWN',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const _NextScreen(),
                    ),
                  );
                },
                child: const Text(
                  'NextScreen',
                ),
              ),
            ],
          ),
        ));
  }
}

class _NextScreen extends ConsumerWidget {
  const _NextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(numberProvier);
    return DefaultLayout(
        title: 'StateProviderScreen',
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                provider.toString(),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(numberProvier.notifier).update((state) => state + 1);
                },
                child: const Text(
                  'UP',
                ),
              ),
            ],
          ),
        ));
  }
}
