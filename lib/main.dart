import 'package:flutter/material.dart';
import 'package:flutter_auth_provider/flutter_auth_provider.dart';
import 'package:flutter_simple_graphql_auth/auth/secure_store.dart';
import 'package:flutter_simple_graphql_auth/config/client.dart';
import 'package:flutter_simple_graphql_auth/config/config.dart';
import 'package:flutter_simple_graphql_auth/routes.dart';
import 'package:flutter_simple_graphql_auth/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  SecureStore store = SecureStore();
  runApp(
    MultiProvider(
      providers: [
        AuthProvider(
          store: store,
        ),
        const GraphQLProvider(
          endpoint: Config.BACKEND_URL,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter routes = getRouter(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: routes.routerDelegate,
      routeInformationParser: routes.routeInformationParser,
      title: 'Simple Auth',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      // home: const MyHomePage(title: 'Simple Auth'),
    );
  }
}
