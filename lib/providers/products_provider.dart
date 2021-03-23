import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
// import 'package:http/http.dart';
import 'package:myshop/models/http_exception.dart';
import 'dart:convert';
import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  // var _showFavoriteOnly = false;

  List<Product> get items {
    // if (_showFavoriteOnly) {
    //   return _items.where((prodId) => prodId.isFavorite).toList();
    // }
    return [..._items];
  }

  final String authToken;
  final String userId;
  ProductsProvider(this.authToken, this.userId, this._items);

  List<Product> get favoriteItem {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  void favorite() {}

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  Future<void> addProduct(Product product) async {
    try {
      final urls = Uri.https('shopappbyanas-default-rtdb.firebaseio.com',
          '/products.json', {'auth': authToken});

      final response = await http.post(
        urls,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'createrId': userId,
          // 'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      // print(error);
      throw error;
    }

    //   },
    // ).catchError((error) {
    //   print(error);
    //   throw error;
    // }); // return Future.value();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    // Show All product
    var urls = Uri.https('shopappbyanas-default-rtdb.firebaseio.com',
        '/products.json', {'auth': '$authToken'});
    // filter Only user created products
    // var header = {
    //   'orderBy': '"createrId"',
    //   'equalTo': '"$userId"',
    // };
    try {
      final response = await http.get(urls); //
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // extractedData.removeWhere((key, value) => userId  != 'createrId');

      if (extractedData == null) {
        return;
      }
      urls = Uri.https('shopappbyanas-default-rtdb.firebaseio.com',
          '/userFavorites/$userId.json', {'auth': '$authToken'});
      final favoriteResponse = await http.get(urls);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];

      if (filterByUser)
        extractedData
            .removeWhere((prodId, prodData) => prodData['createrId'] != userId);

      print(extractedData);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final urls = Uri.https('shopappbyanas-default-rtdb.firebaseio.com',
          '/products/$id.json', {'auth': authToken});
      await http.patch(urls,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else
      print('...');
  }

  Future<Response> deleteProduct(String id) async {
    final urls = Uri.https('shopappbyanas-default-rtdb.firebaseio.com',
        '/products/$id.json', {'auth': authToken});
    final http.Response response = await http.delete(urls);
    if (response.statusCode != 200) {
      throw HttpException('Could Not Delete Product.');
    }
    final existingProductIndex = _items.indexWhere(((prod) => prod.id == id));
    print(response.statusCode);
    _items.removeAt(existingProductIndex);
    // existingProduct = null;
    notifyListeners();
    return response;

    // var existingProduct = _items[existingProductIndex];
    // http.delete(urls);
    // .then((response) {
    //   print(response.statusCode);
    //   existingProduct = null;
    // }).catchError((_) {
    //   _items.insert(existingProductIndex, existingProduct);
    //   notifyListeners();
    // });
    // _items.removeAt(existingProductIndex);
    // notifyListeners();
  }
}
