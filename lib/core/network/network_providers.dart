import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_client.dart';
import 'retrofit_client.dart';

const baseUrl = 'http://0.0.0.0:8000/api';

final dioProvider = Provider<Dio>((ref) {
  return DioClient(baseUrl: baseUrl).dio;
});

final retrofitClientProvider = Provider<RetrofitClient>((ref) {
  final dio = ref.watch(dioProvider);

  return RetrofitClient(dio, baseUrl: baseUrl);
});
