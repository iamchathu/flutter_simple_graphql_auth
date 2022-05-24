import 'package:flutter/material.dart';
import 'package:flutter_simple_graphql_auth/graphql/hello.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

class Page2 extends StatelessWidget {
  static const String routePath = '/page-2';

  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page 2"),
      ),
      body: Center(
        child: FutureBuilder<String?>(
          initialData: "",
          future: HelloGQL.hello(
            client: context.read<GraphQLClient>(),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }
            return Text(snapshot.data ?? "");
          },
        ),
      ),
    );
  }
}
