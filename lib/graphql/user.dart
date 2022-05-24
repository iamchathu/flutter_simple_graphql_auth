import 'package:graphql/client.dart';

const String loginMutation = '''
  mutation Login(\$userName:String!,\$password:String!){
    auth:login(userName:\$userName,password:\$password){
     token
     refreshToken
    }
  }
''';

MutationOptions loginMutationOptions({
  required String userName,
  required String password,
}) =>
    MutationOptions(
      document: gql(loginMutation),
      variables: {
        "userName": userName,
        "password": password,
      },
      fetchPolicy: FetchPolicy.networkOnly,
      errorPolicy: ErrorPolicy.all,
    );

const String refreshTokenMutation = '''
  mutation RefreshToken(\$refreshToken: String!){
      auth: refreshToken(refreshToken: \$refreshToken){
      token
      refreshToken
   }
  }
''';

MutationOptions refreshTokenMutationOptions({required String refreshToken}) =>
    MutationOptions(
      document: gql(refreshTokenMutation),
      variables: {
        "refreshToken": refreshToken,
      },
      fetchPolicy: FetchPolicy.noCache,
    );

class UserGQL {
  static Future<TokenResponse> login(
    GraphQLClient client, {
    required String userName,
    required String password,
  }) async {
    final QueryResult result = await client.mutate(
      loginMutationOptions(
        userName: userName,
        password: password,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    return TokenResponse.fromMap(result.data!['auth']);
  }

  static Future<TokenResponse?> refreshToken(
    GraphQLClient client, {
    required String refreshToken,
  }) async {
    final QueryResult result = await client.mutate(
      refreshTokenMutationOptions(
        refreshToken: refreshToken,
      ),
    );
    if (result.hasException) {
      throw result.exception!;
    }
    return TokenResponse.fromMap(result.data!['auth']);
  }
}

class TokenResponse {
  late final String token;

  final String? refreshToken;

  TokenResponse({required this.token, this.refreshToken});

  factory TokenResponse.fromMap(Map<String, dynamic> data) {
    return TokenResponse(
      token: data['token'],
      refreshToken: data['refreshToken'],
    );
  }
}
