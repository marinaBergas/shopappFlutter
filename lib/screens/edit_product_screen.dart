import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products_providers.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descripeFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: '',
      title: '',
      imageUrl: '',
      description: '',
      price: 0,
      isFavorite: false);
  var _initValues = {
    'id': '',
    'title': '',
    'imageUrl': '',
    'description': '',
    'price': '',
  };
  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        _initValues = {
          'id': _editedProduct.id,
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descripeFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (((_imageUrlController.text.isEmpty) ||
              (!_imageUrlController.text.startsWith('http')) &&
                  !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('jpg') &&
              !_imageUrlController.text.endsWith('jpeg') &&
              !_imageUrlController.text.endsWith('png'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isvalid = _form.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState!.save();
    if (_editedProduct.id.isNotEmpty) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            //validate on every key stroke
            // autovalidateMode: ,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_priceFocusNode),
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        title: value ?? '',
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'this is invalid.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'],
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_descripeFocusNode),
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value ?? ''),
                        imageUrl: _editedProduct.imageUrl);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter the price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'please enter valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'please enter number greater than zero';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descripeFocusNode,
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        title: _editedProduct.title,
                        description: value ?? '',
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'this is invalid.';
                    }
                    if (value.length < 10) {
                      return 'should be at least 10 characters.';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1), color: Colors.grey),
                      child: _imageUrlController.text.isEmpty
                          ? const Text('Enter a Url')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'ImageUrl',
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) => _saveForm(),
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value ?? '');
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter url';
                            }
                            if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'please enter avalid url';
                            }
                            if (!value.endsWith('jpg') &&
                                !value.endsWith('jpeg') &&
                                !value.endsWith('png')) {
                              return 'please enter avalid url';
                            }
                            return null;
                          }),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
