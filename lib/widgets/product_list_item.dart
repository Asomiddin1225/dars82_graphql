import 'package:dars82_graphql/utils/constants/products_graphql_queries.dart';
import 'package:dars82_graphql/widgets/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProductListItem extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          product['images'][0],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(
          product['title'],
          style: TextStyle(color: Colors.red),
        ),
        subtitle: Text(product['description']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProductScreen(product: product),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                GraphQLProvider.of(context).value.mutate(
                      MutationOptions(
                        document: gql(deleteProduct),
                        variables: {"id": product['id']},
                        onCompleted: (data) {
                          print("Product deleted: $data");
                        },
                        onError: (error) {
                          print(
                              "Error deleting product: ${error!.linkException}");
                        },
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
