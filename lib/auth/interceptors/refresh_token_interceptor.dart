import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_graphql_auth/auth/refresh_token_handler.dart';

class RefreshTokenInterceptor extends QueuedInterceptor {
  final RefreshTokenHandler refreshTokenHandler;

  final Dio _retryDio = Dio();
  final VoidCallback logout;

  RefreshTokenInterceptor({
    required this.refreshTokenHandler,
    required this.logout,
  });

  Future<Response> _retryTheFailedRequest(Response response, String token) {
    return _retryDio.post(
      response.requestOptions.path,
      data: response.requestOptions.data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    if (RefreshTokenHandler.isTokenExpired(response)) {
      print("Token expired!");
      try {
        if (await refreshTokenHandler.refreshToken()) {
          print("Token refreshed!");
          String? token = await refreshTokenHandler.store.getToken();
          Response retriedResponse =
              await _retryTheFailedRequest(response, token!);
          return super.onResponse(retriedResponse, handler);
        }
      } catch (error) {
        // TODO: Clear the queue.
        print("Token refresh error!");
      }
      logout();
    }
    return super.onResponse(response, handler);
  }
}
