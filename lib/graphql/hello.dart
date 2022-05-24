import 'package:graphql/client.dart';

const String helloQuery = '''
  query Hello{
    hello: helloProtected
  }
''';

final QueryOptions helloQueryOptions = QueryOptions(
  document: gql(helloQuery),
);

class HelloGQL {
  static Future<String?> hello({required GraphQLClient client}) async {
    final QueryResult response = await client.query(helloQueryOptions);

    if (!response.hasException) {
      return response.data?['hello'];
    } else {
      throw response.exception!;
    }
  }
}
