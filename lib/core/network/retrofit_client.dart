import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_client.g.dart';

@RestApi()
abstract class RetrofitClient {
  factory RetrofitClient(Dio dio, {String? baseUrl}) = _RetrofitClient;

  @GET('/health')
  Future<void> healthCheck();
}
