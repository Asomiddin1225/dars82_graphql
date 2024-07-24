import 'package:dars82_graphql/utils/constants/products_graphql_queries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductScreen({super.key, required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late double _price;

  @override
  void initState() {
    super.initState();
    _title = widget.product['title'];
    _description = widget.product['description'];
    _price = widget.product['price'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: "Title"),
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    GraphQLProvider.of(context).value.mutate(
                          MutationOptions(
                            document: gql(editProduct),
                            variables: {
                              "id": widget.product['id'],
                              "title": _title,
                              "description": _description,
                              "price": _price,
                            },
                            onCompleted: (data) {
                              print("Product updated: $data");
                              Navigator.pop(context);
                            },
                            onError: (error) {
                              print(
                                  "Error updating product: ${error!.linkException}");
                            },
                          ),
                        );
                  }
                },
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
