import 'package:flutter/material.dart';
import 'package:flutter_auth_provider/flutter_auth_provider.dart';
import 'package:flutter_simple_graphql_auth/auth/type_def.dart';
import 'package:flutter_simple_graphql_auth/auth/user.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  static const String routePath = '/';

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userName =
        context.select<MyAuthManager, String?>((auth) => auth.user?.userName);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthManager<User>>().logout();
            },
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Text(
            "Welcome, $userName",
            style: Theme.of(context).textTheme.headline4,
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/page-2');
            },
            child: const Text("Page 2"),
          ),
        ],
      ),
    );
  }
}
