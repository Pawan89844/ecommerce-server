import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

class APIs {
  Response getProducts(Request request) {
    var products = _loadData('products.json');
    return Response.ok(jsonEncode(products),
        headers: {'content-type': 'application/json'});
  }

  Response getProductDetails(Request request, String productId) {
    var products = _loadData('products.json');
    Map<String, dynamic>? product = products
        .firstWhere((p) => p['id'] == int.parse(productId), orElse: () => {});

    if (product != null) {
      return Response.ok(jsonEncode(product),
          headers: {'content-type': 'application/json'});
    } else {
      return Response.notFound('Product not found');
    }
  }

  Response getCart(Request request) {
    var cart = _loadData('cart.json');
    return Response.ok(jsonEncode(cart),
        headers: {'content-type': 'application/json'});
  }

  Response addToCart(Request request) {
    var cart = _loadData('cart.json');
    var newItem = jsonDecode(utf8.decode(request.read() as List<int>));
    cart.add(newItem);
    _saveData('cart.json', cart);
    return Response.ok('Item added to cart');
  }

  Response removeFromCart(Request request) {
    var cart = _loadData('cart.json');
    var itemToRemove = jsonDecode(utf8.decode(request.read() as List<int>));
    cart.remove(itemToRemove);
    _saveData('cart.json', cart);
    return Response.ok('Item removed from cart');
  }

  Response addToCartByOne(Request request) {
    var cart = _loadData('cart.json');
    var newItem = jsonDecode(utf8.decode(request.read() as List<int>));
    var existingItem = cart.firstWhere(
        (item) => item['productId'] == newItem['productId'],
        orElse: () => {});

    if (existingItem != null) {
      existingItem['quantity'] = existingItem['quantity'] + 1;
    }

    _saveData('cart.json', cart);
    return Response.ok('One item added to cart');
  }

  Response removeFromCartByOne(Request request) {
    var cart = _loadData('cart.json');
    var itemToRemove = jsonDecode(utf8.decode(request.read() as List<int>));
    Map<String, dynamic>? existingItem = cart.firstWhere(
        (item) => item['productId'] == itemToRemove['productId'],
        orElse: () => {'msg': 'something went wrong'});

    if (existingItem != null && existingItem['quantity'] > 1) {
      existingItem['quantity'] = existingItem['quantity'] - 1;
    } else {
      cart.remove(existingItem);
    }

    _saveData('cart.json', cart);
    return Response.ok('One item removed from cart');
  }

  List<Map<String, dynamic>> _loadData(String fileName) {
    File file = File(fileName);

    if (file.existsSync()) {
      var content = file.readAsStringSync();
      return jsonDecode(content).cast<Map<String, dynamic>>();
    } else {
      print('File name: $fileName');
      _saveData(fileName, [
        {'id': 1, 'msg': 'sample'}
      ]); // Create an empty JSON file
      return [];
    }
  }

  void _saveData(String fileName, List<Map<String, dynamic>> data) {
    var file = File(fileName);
    file.writeAsStringSync(jsonEncode(data));
  }
}
