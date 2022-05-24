import 'package:dio/dio.dart' as dio;
import 'package:flutter_auth_provider/flutter_auth_provider.dart';
import 'package:flutter_simple_graphql_auth/config/config.dart';
import 'package:flutter_simple_graphql_auth/graphql/user.dart';
import 'package:graphql/client.dart';

class RefreshTokenHandler {
  final TokenStore store;
  final GraphQLClient client = GraphQLClient(
    link: HttpLink(
      Config.BACKEND_URL,
    ),
    cache: GraphQLCache(),
  );

  RefreshTokenHandler({required this.store});

  static bool isTokenExpired(dio.Response response) =>
      response.data['errors'] != null &&
      response.data['errors'][0]['message'].contains('Access denied!');

  Future<bool> refreshToken() async {
    try {
      final String? refreshToken = await store.getRefreshToken();
      if (refreshToken != null) {
        TokenResponse? response =
            await UserGQL.refreshToken(client, refreshToken: refreshToken);
        if (response != null) {
          await store.saveTokens(
            token: response.token,
            refreshToken: response.refreshToken,
          );
          return true;
        }
      }
    } catch (error) {
      print(error);
    }
    return false;
  }
}
