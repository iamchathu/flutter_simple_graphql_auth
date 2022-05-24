import 'package:flutter/widgets.dart';
import 'package:flutter_simple_graphql_auth/auth/type_def.dart';
import 'package:flutter_simple_graphql_auth/screens/home.dart';
import 'package:flutter_simple_graphql_auth/screens/login.dart';
import 'package:flutter_simple_graphql_auth/screens/page_2.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter getRouter(BuildContext context) {
  MyAuthManager authManager = context.read<MyAuthManager>();
  return GoRouter(
    routes: [
      GoRoute(
        path: Home.routePath,
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: Page2.routePath,
        builder: (context, state) => const Page2(),
      ),
      GoRoute(
        path: Login.routePath,
        builder: (context, state) => const Login(),
      ),
    ],
    redirect: (state) {
      final bool loggedIn = authManager.isLoggedIn;
      final bool loggingIn = state.subloc == Login.routePath;

      if (!loggedIn) return loggingIn ? null : Login.routePath;

      if (loggingIn) return '/';

      return null;
    },
    initialLocation: Login.routePath,
    refreshListenable: authManager,
  );
}
