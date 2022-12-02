import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/models/product.dart';
import 'package:shopelt/src/providers/productList.dart';

class ProductFormManagerPage extends StatefulWidget {
  const ProductFormManagerPage({super.key});

  @override
  State<ProductFormManagerPage> createState() => _ProductFormManagerPageState();
}

class _ProductFormManagerPageState extends State<ProductFormManagerPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageURLFocus = FocusNode();
  final _imageURLController = TextEditingController();

  final _formKEY = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageURLFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null) {
        final product = arguments as Product;
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;
        _imageURLController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageURLFocus.dispose();
    _imageURLFocus.removeListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  Future<void> _submitForm() async {
    final validForm = _formKEY.currentState?.validate() ?? false;
    if (validForm) {
      _formKEY.currentState?.save();
      setState(() => _isLoading = true);

      try {
        await Provider.of<ProductList>(
          context,
          listen: false,
        ).saveProduct(_formData);
        Navigator.of(context).pop();
      } catch (err) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).errorColor,
                ),
                const Text('Error'),
              ],
            ),
            content: const Text('Error on Save Product.'),
            actions: [
              TextButton(
                child: const Text('ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  formValidator(value, String field) {
    final _value = value ?? '';
    switch (field) {
      case 'title':
        if (_value.trim().isEmpty) {
          return 'The field title is required';
        }
        if (_value.trim().length < 5) {
          return 'The min length is 5 characters';
        }
        return null;
      case 'price':
        final _valueNum = double.tryParse(_value) ?? -1;
        return _valueNum <= 0 ? 'Price is invalid' : null;
      case 'description':
        if (_value.trim().isEmpty) {
          return 'The field description is required';
        }
        if (_value.trim().length < 10) {
          return 'The min length is 10 characters';
        }
        break;
      case 'imageURL':
        bool validURL = Uri.tryParse(_value)?.hasAbsolutePath ?? false;
        return validURL ? null : 'The image URL is invalid';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Manager Form'),
        actions: [
          IconButton(onPressed: _submitForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                padding: const EdgeInsets.all(15),
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Form(
                  key: _formKEY,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _formData['title']?.toString(),
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_priceFocus),
                        onSaved: (value) => _formData['title'] = value ?? '',
                        validator: (value) => formValidator(value, 'title'),
                      ),
                      TextFormField(
                        initialValue: _formData['price']?.toString(),
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocus,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_descriptionFocus),
                        onSaved: (value) =>
                            _formData['price'] = double.parse(value ?? '0'),
                        validator: (value) => formValidator(value, 'price'),
                      ),
                      TextFormField(
                        initialValue: _formData['description']?.toString(),
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descriptionFocus,
                        validator: (value) =>
                            formValidator(value, 'description'),
                        onSaved: (value) =>
                            _formData['description'] = value ?? '',
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageURLFocus,
                              controller: _imageURLController,
                              onSaved: (value) =>
                                  _formData['imageUrl'] = value ?? '',
                              validator: (value) =>
                                  formValidator(value, 'imageURL'),
                              onFieldSubmitted: (_) => _submitForm(),
                            ),
                          ),
                          Container(
                            height: 80,
                            width: 80,
                            margin: const EdgeInsets.only(top: 15, left: 15),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: _imageURLController.text.isEmpty
                                ? Center(
                                    child: Icon(Icons.image,
                                        size: 44,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageURLController.text,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 44,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
