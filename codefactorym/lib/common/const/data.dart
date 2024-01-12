import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';

const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// 기존로직 Provider에서 똑같은값을 가져오기위해 dio쪽으로 옮김
// const storage = FlutterSecureStorage();

//emulator 기본 ip 세팅(안드로이드일때 이렇게 됨)
const emulatorIp = '10.0.2.2:3000';
//simulator 기본 ip세팅(ios는 이렇게됨)
const simulatorIp = '127.0.0.1:3000';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;
