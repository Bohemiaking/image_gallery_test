import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlScreen extends StatefulWidget {
  const GraphQlScreen({super.key});

  @override
  State<GraphQlScreen> createState() => _GraphQlScreenState();
}

class _GraphQlScreenState extends State<GraphQlScreen> {
  final HttpLink httpLink = HttpLink('https://api.github.com/graphql');
  Link? link;
  ValueNotifier<GraphQLClient>? client;
  @override
  void initState() {
    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer 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',
    );

    link = authLink.concat(httpLink);
    client = ValueNotifier(
      GraphQLClient(
        link: link!,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    super.initState();
  }

  String readRepositories = """
  query ReadRepositories(\$nRepositories: Int!) {
    viewer {
      repositories(last: \$nRepositories) {
        nodes {
          id
          name
          viewerHasStarred
        }
      }
    }
  }
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GraphQLProvider(
        client: client,
        child: Query(
          options: QueryOptions(
            document: gql(
                readRepositories), // this is the query string you just created
            variables: const {'nRepositories': 50},
            pollInterval: const Duration(seconds: 10),
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Text('Loading');
            }

            List? repositories =
                result.data?['viewer']?['repositories']?['nodes'];

            if (repositories == null) {
              return const Text('No repositories');
            }

            return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: repositories.length,
                itemBuilder: (context, index) {
                  final repository = repositories[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(repository['id'] ?? ''),
                      Text(repository['name'] ?? ''),
                      Text(repository['viewerHasStarred'].toString()),
                      const Divider()
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
