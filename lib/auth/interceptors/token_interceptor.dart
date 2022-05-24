import 'package:dio/dio.dart';
import 'package:flutter_auth_provider/flutter_auth_provider.dart';

class TokenInterceptor extends QueuedInterceptor {
  final TokenStore _store;

  TokenInterceptor(this._store);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _store.getToken();

    options.headers['Authorization'] = 'Bearer $token';

    return super.onRequest(options, handler);
  }
}
