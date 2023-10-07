// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  // final List<Product> _items = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];
  // // var _showFavorites = false;
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);
  List<Product> _items = [];
  List<Product> get items {
    // if (_showFavorites) {
    //   return _items.where((productItem) => productItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  // void showFavorites() {
  //   _showFavorites = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavorites = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser=false]) async {
    final filterString=filterByUser?'orderBy="creatorId"&equalTo="$userId':'';
    var url = Uri.parse(
        'https://flutter-1d3e8-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString"');
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) != null
          ? json.decode(response.body) as Map<String, dynamic>
          : null;
      final List<Product> loadedProducts = [];
      if (json.decode(response.body) == null) {
        return;
      }
      url = Uri.parse(
          'https://flutter-1d3e8-default-rtdb.firebaseio.com/userFavourite/$userId.json?auth=$authToken');

      final favoriteResponse = await http.get(url);
      final favData = json.decode(favoriteResponse.body);
      extractedData?.forEach((productId, productData) {
        loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: favData == null ? false : favData[productId] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-1d3e8-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'creatorId': userId
          }));
      final newProduct = Product(
          title: product.title,
          price: product.price,
          description: product.description,
          isFavorite: product.isFavorite,
          imageUrl: product.imageUrl,

          id: json.decode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
    //     .then((response) {
    //   final newProduct = Product(
    //       title: product.title,
    //       price: product.price,
    //       description: product.description,
    //       isFavorite: product.isFavorite,
    //       imageUrl: product.imageUrl,
    //       id: json.decode(response.body)['name']);
    //   _items.add(newProduct);
    //   notifyListeners();
    // }).catchError((error) {

    //   throw error;
    // });
  }

  Future<void> updateProduct(String productId, Product product) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == productId);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-1d3e8-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken');
      http.patch(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          }));
      _items[prodIndex] = product;
      notifyListeners();
    } else {}
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
        'https://flutter-1d3e8-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken');
    final existingProductIndex =
        _items.indexWhere((prod) => prod.id == productId);
    Product? existingProduct = _items[existingProductIndex];
    // _items.removeAt(existingProductIndex);
    // _items.removeWhere((prod) => prod.id == productId);
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('could not delete product');
    }
    // existingProduct = null;
    existingProduct = null;
  }

// _items.removeAt(existingProductIndex);
//     notifyListeners();
//     final response = await http.delete(url);
//     if (response.statusCode >= 400) {
//       _items.insert(existingProductIndex, existingProduct);
//       notifyListeners();
//       throw HttpException('Could not delete product.');
//     }
//     existingProduct = null;
}
