import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  final Function(String, String, double, int, List<String>) onAddProduct;

  const AddProductScreen({Key? key, required this.onAddProduct, required Function refetch})
      : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _price = 0.0;
  int _categoryId = 0;
  List<String> _images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                onSaved: (value) {
                  _title = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                onSaved: (value) {
                  _description = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _price = double.tryParse(value ?? '0') ?? 0.0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Category ID"),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _categoryId = int.tryParse(value ?? '0') ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category ID';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Image URL"),
                onSaved: (value) {
                  _images = [value ?? ''];
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onAddProduct(
                        _title, _description, _price, _categoryId, _images);
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Add Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
