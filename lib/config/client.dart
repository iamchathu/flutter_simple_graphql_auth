import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_graphql_auth/auth/interceptors/refresh_token_interceptor.dart';
import 'package:flutter_simple_graphql_auth/auth/interceptors/token_interceptor.dart';
import 'package:flutter_simple_graphql_auth/auth/refresh_token_handler.dart';
import 'package:flutter_simple_graphql_auth/auth/secure_store.dart';
import 'package:flutter_simple_graphql_auth/auth/type_def.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final SecureStore _secureStore = SecureStore();

List<Interceptor> interceptors(
  VoidCallback logout,
) {
  return [
    RefreshTokenInterceptor(
      refreshTokenHandler: RefreshTokenHandler(
        store: _secureStore,
      ),
      logout: logout,
    ),
    TokenInterceptor(
      _secureStore,
    )
  ];
}

class MyGraphQLClient {
  final String endpoint;
  final DedupeLink _dedupeLink = DedupeLink();
  late final Dio _dio;
  late final DioLink _dioLink;
  late final GraphQLClient _client;

  GraphQLClient get client => _client;

  MyGraphQLClient({
    required this.endpoint,
  }) {
    _dio = Dio();
    _dioLink = DioLink(
      endpoint,
      client: _dio,
    );
    _client = GraphQLClient(
      link: Link.from(
        [
          _dedupeLink,
          _dioLink,
        ],
      ),
      cache: GraphQLCache(),
    );
  }

  void initializeWithInterceptors({
    required List<Interceptor> interceptors,
  }) {
    _dio.interceptors.clear();
    _dio.interceptors.addAll(interceptors);
  }
}

class GraphQLProvider extends SingleChildStatelessWidget {
  final String endpoint;

  const GraphQLProvider({
    super.key,
    required this.endpoint,
  });

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    final MyGraphQLClient myGraphQLClient = MyGraphQLClient(endpoint: endpoint)
      ..initializeWithInterceptors(
        interceptors: interceptors(
          context.read<MyAuthManager>().logout,
        ),
      );
    final GraphQLClient client = myGraphQLClient.client;
    return Provider<GraphQLClient>.value(
      value: client,
      child: child,
    );
  }
}
