import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'code_generation_provider.g.dart';

//1) 어떤 Provider를 사용할지 결정할 고민을 하지 않도록 자동으로 Provider를 결정해줌

final _testProvider = Provider<String>((ref) => 'Hello Code Generation');

@riverpod
String gState(GStateRef ref) {
  return 'Hello Code Generation';
}

//gstateFuture를 build할려면 안의 파라미터에 맨앞 대문자를적은후 맨뒤에 Ref를 넣어주면됨
@riverpod
Future<int> gStateFuture(GStateFutureRef ref) async {
  await Future.delayed(Duration(seconds: 3));

  return 10;
}

//대문자 Riverpod은 autoDipose를 사용하지 않기 위해 씀
//keppAlive의 default는 false이고 이건 autoDipose를 사용하겠다는뜻 안쓸려면 keepAlive를 true로 바꿔주면 build될때 autoDispose가 없음
@Riverpod(
  keepAlive: true,
)
Future<int> gStateFuture2(GStateFuture2Ref ref) async {
  await Future.delayed(Duration(seconds: 3));

  return 10;
}

//2) Paramerter > Family(추가 파라미터) 파라미터를 일반 함수처럼 사용할 수 있도록 해준다.
//바로 아래는 기존방식에서 여러가지 parameter를 넣을때 쓰는 방식
class Parameter {
  final int number1;
  final int number2;
  Parameter({
    required this.number1,
    required this.number2,
  });
}

final _testFamilyProvider = Provider.family<int, Parameter>(
  (ref, parameter) => parameter.number1 * parameter.number2,
);
//revierpod을 사용하는 방식
@riverpod
int gStateMultiply(
  GStateMultiplyRef ref, {
  required int number1,
  required int number2,
}) {
  return number1 * number2;
}

//StateNotifierProvider
@riverpod
class GStateNotifier extends _$GStateNotifier {
  //무조건 build를 override를 해줘야한다.
  //build안에 초기 설정값만 넣어주자.
  @override
  int build() {
    return 0;
  }

  increment() {
    state++;
  }

  decrement() {
    state--;
  }
}
