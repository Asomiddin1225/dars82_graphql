import 'package:dars82_graphql/utils/constants/products_graphql_queries.dart';
import 'package:dars82_graphql/widgets/product_list_item.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'add_product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToAddProduct(BuildContext context, Function refetch) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddProductScreen(
          onAddProduct: (title, description, price, categoryId, images) {
            GraphQLProvider.of(ctx).value.mutate(
                  MutationOptions(
                    document: gql(addProduct),
                    variables: {
                      "title": title,
                      "description": description,
                      "categoryId": categoryId,
                      "price": price,
                      "images": images,
                    },
                    onCompleted: (data) {
                      print("Product added: $data");
                      refetch();
                    },
                    onError: (error) {
                      print("Error adding product: ${error!.linkException}");
                    },
                  ),
                );
          },
          refetch: refetch,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Products",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          Query(
            options: QueryOptions(
              document: gql(getProducts),
            ),
            builder: (result, {fetchMore, refetch}) {
              return IconButton(
                onPressed: () => _navigateToAddProduct(context, refetch!),
                icon: const Icon(Icons.add),
              );
            },
          ),
        ],
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getProducts),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (result.hasException) {
            return Center(
              child: Text(result.exception.toString()),
            );
          }

          List products = result.data!['products'];

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (ctx, index) {
              return ProductListItem(product: products[index]);
            },
          );
        },
      ),
    );
  }
}
