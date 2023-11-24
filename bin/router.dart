// ignore_for_file: subtype_of_sealed_class

import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:test/test.dart';

import 'apis.dart';
import 'operation.dart';

MyRouter myRouter = MyRouter();

Router router = Router()
  ..get('/carts/1', myRouter.cart)
  ..delete('/cart/deletProduct', myRouter.deleteProduct)
  ..post('/cart/addToCart', myRouter.addProduct)
  ..post('/cart/addToCartByOne', myRouter.addProductByOne)
  ..post('/cart/removeToCartByOne', myRouter.removeProductByOne);

class MyRouter {
  final APIs _apIs = APIs();
  final FileOperation operation = FileOperation();

  Object myJson() {
    Map<String, dynamic> myOperation = operation.readJsonFile('cart.json');
    return jsonEncode(myOperation);
  }

  Object _removeJson(int prodId) {
    return operation.deleteObjectFromJsonFile('cart.json', prodId);
  }

  Object _addProductJson(int prodId, int quantity) {
    return operation.addProductsJsonFile('cart.json', prodId, quantity);
  }

  Object _addProductByOneJson(int prodId, int quantity) {
    return operation.addProductsByOneJsonFile('cart.json', prodId, quantity);
  }

  Object _removeProductByOneJson(int prodId, int quantity) {
    return operation.removeProductsByOneJsonFile('cart.json', prodId, quantity);
  }

  Response cart(Request req) {
    return Response.ok(myJson(), headers: {'content-type': 'application/json'});
  }

  Response deleteProduct(Request req) {
    int? productId =
        int.tryParse(req.url.queryParameters['productId'].toString());
    if (productId == null) {
      return Response.badRequest(
          body: {'error': 'Inavid Product Id'},
          headers: {'content-type': 'application/json'});
    } else {
      return Response.ok(_removeJson(productId),
          headers: {'content-type': 'application/json'});
    }
  }

  Response addProduct(Request req) {
    int? productId =
        int.tryParse(req.url.queryParameters['productId'].toString());
    if (productId == null) {
      return Response.badRequest(
          body: {'error': 'Inavid Product Id'},
          headers: {'content-type': 'application/json'});
    } else {
      return Response.ok(_addProductJson(productId, 1),
          headers: {'content-type': 'application/json'});
    }
  }

  Response addProductByOne(Request req) {
    int? productId =
        int.tryParse(req.url.queryParameters['productId'].toString());
    if (productId == null) {
      return Response.badRequest(
          body: {'error': 'Inavid Product Id'},
          headers: {'content-type': 'application/json'});
    } else {
      return Response.ok(_addProductByOneJson(productId, 1),
          headers: {'content-type': 'application/json'});
    }
  }

  Response removeProductByOne(Request req) {
    int? productId =
        int.tryParse(req.url.queryParameters['productId'].toString());

    if (productId == null) {
      return Response.badRequest(
          body: {'error': 'Inavid Product Id'},
          headers: {'content-type': 'application/json'});
    } else {
      return Response.ok(_removeProductByOneJson(productId, 1),
          headers: {'content-type': 'application/json'});
    }
  }
}




// {
//     "id": 1,
//     "userId": 1,
//     "date": "2020-03-02T00:00:00.000Z",
//     "products": [
//       {"productId": 1, "quantity": 4},
//       {"productId": 2, "quantity": 1},
//       {"productId": 3, "quantity": 6}
//     ],
//     "__v": 0
// }
