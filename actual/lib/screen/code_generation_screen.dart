import 'package:actual/layout/default_layout.dart';
import 'package:actual/riverpod/code_generation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CodeGenerationScreen extends ConsumerWidget {
  const CodeGenerationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state1 = ref.watch(gStateProvider);
    final state2 = ref.watch(gStateFutureProvider);
    final state3 = ref.watch(gStateFuture2Provider);
    final state4 = ref.watch(gStateMultiplyProvider(
      number1: 10,
      number2: 20,
    ));
    final state5 = ref.watch(gStateNotifierProvider);

    return DefaultLayout(
      title: 'CodeGenerationScreen',
      body: Column(
        children: [
          Text('State1 : $state1'),
          state2.when(
            data: (data) {
              return Text(
                'State2 : $data',
                textAlign: TextAlign.center,
              );
            },
            error: (err, stack) => Text(
              err.toString(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          state3.when(
            data: (data) {
              return Text(
                'State3 : $data',
                textAlign: TextAlign.center,
              );
            },
            error: (err, stack) => Text(
              err.toString(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          Text('State4: $state4'),
          //아래 StateFiveWidget과 동일한 기능을 하는것 riverpod에서 제공
          //아래 child는 단한번만 rendering되는 것임!! 아주좋음
          Consumer(
            builder: (context, ref, child) {
              return Text('State5: $state5');
            },
          ),
          //StateFiveWidget(),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(gStateNotifierProvider.notifier).increment();
                },
                child: Text('Increment'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(gStateNotifierProvider.notifier).decrement();
                },
                child: Text('decrement'),
              ),
            ],
          ),
          //invalidate() = 유효하지 않게 하다. 초기값으로 되돌림..ㄷㄷ
          ElevatedButton(
              onPressed: () {
                ref.invalidate(gStateNotifierProvider);
              },
              child: Text('Invalidate'))
        ],
      ),
    );
  }
}

//하위 위젯으로 바꿔주면 watch가 계속되도 해당되는 하위위젯만 build되고 나머지는 build되지 않음
class StateFiveWidget extends ConsumerWidget {
  const StateFiveWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state5 = ref.watch(gStateNotifierProvider);
    return Text('State5: $state5');
  }
}
