// ignore_for_file: subtype_of_sealed_class

import 'dart:convert';
import 'dart:io';

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
  ..post('/cart/removeToCartByOne', myRouter.removeProductByOne)
  ..get('/getAddress', myRouter.getAddress)
  ..post('/addAddress', myRouter.addAddress)
  ..delete('/deleteAddress', myRouter.deleteAddress)
  ..put('/updateAdress', myRouter.updateAddress);

class MyRouter {
  final APIs _apIs = APIs();
  final FileOperation operation = FileOperation();

  Object myJson(String filename, {Object? obj}) {
    Map<String, dynamic> myOperation =
        operation.readJsonFile(filename, object: obj);
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
    return Response.ok(myJson('cart.json'),
        headers: {'content-type': 'application/json'});
  }

  Response getAddress(Request req) {
    return Response.ok(
      myJson('address.json', obj: {
        "id": 1,
        "userId": 1,
        "address": [
          {"id": 2, "name": "Pawan", "address": "B-58", "phone": 6464465456},
          {"id": 3, "name": "Pawan", "address": "B-62", "phone": 545512556}
        ]
      }),
      headers: {'content-type': 'application/json'},
    );
  }

  Future<Response> addAddress(Request req) async {
    if (req.method == 'POST') {
      try {
        String requestBody = await req.readAsString();
        Map<String, dynamic> jsonBody =
            operation.addAddressJsonFile('address.json', requestBody);
        print('data provided: $jsonBody');
        return Response.ok(jsonEncode(jsonBody),
            headers: {'content-type': 'application/json'});
      } catch (e) {
        print('Error $e');
        return Response.badRequest(body: 'Error $e');
      }
    } else {
      return Response.internalServerError(body: 'Server Error');
    }
  }

  Future<Response> updateAddress(Request req) async {
    Map<String, dynamic> queryParams = req.url.queryParameters;
    int? id = int.tryParse(queryParams['id'].toString());
    if (id == null) {
      return Response.badRequest(body: 'Oop! id not found');
    } else {
      String? newAddress = queryParams['address'];
      int? newPhone = int.tryParse(queryParams['phone'].toString());
      String? newName = queryParams['name'];

      String res = await operation.updateAddress(
          'address.json', id, newAddress, newPhone, newName);

      return Response.ok(res, headers: {'content-type': 'application/json'});
    }
  }

  Response deleteAddress(Request req) {
    int? id = int.tryParse(req.url.queryParameters['id'].toString());
    if (id == null) {
      return Response.badRequest(
          body: "error", headers: {'content-type': 'application/json'});
    } else {
      return Response.ok(operation.deleteAddress('address.json', id),
          headers: {'content-type': 'application/json'});
    }
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
