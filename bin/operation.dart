import 'dart:convert';
import 'dart:io';

import 'model/cartmodel.dart';

class FileOperation {
  Map<String, dynamic> readJsonFile(String fileName) {
    try {
      String currentDirectory = Directory.current.path;
      String filePath = '$currentDirectory/bin/$fileName';
      File file = File(filePath);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
        file.writeAsStringSync(jsonEncode({
          "id": 1,
          "userId": 1,
          "date": "2020-03-02T00:00:00.000Z",
          "products": [
            {"productId": 1, "quantity": 4},
            {"productId": 2, "quantity": 1},
            {"productId": 3, "quantity": 6}
          ],
          "__v": 0
        }));
      }

      String contents = file.readAsStringSync();

      Map<String, dynamic> jsonData = jsonDecode(contents);

      return jsonData;
    } catch (e) {
      print('Error reading JSON file: $e');
      return jsonDecode("error: something went wrong $e");
    }
  }

  String deleteObjectFromJsonFile(String fileName, int objectIdToRemove) {
    try {
      String currentDirectory = Directory.current.path;
      String filePath = '$currentDirectory/bin/$fileName';
      File file = File(filePath);
      if (!file.existsSync()) {
        throw Exception('File not found: $filePath');
      }

      String contents = file.readAsStringSync();

      Map<String, dynamic> jsonData = jsonDecode(contents);

      if (jsonData.containsKey("products") && jsonData["products"] is List) {
        (jsonData["products"] as List)
            .removeWhere((product) => product["productId"] == objectIdToRemove);
      }
      String jsonFile = jsonEncode(jsonData);
      file.writeAsStringSync(jsonFile);

      print('Object with ID $objectIdToRemove deleted successfully.');
      print('Json File: $jsonFile');
      return jsonFile;
    } catch (e) {
      print('Error deleting object from JSON file: $e');
      return jsonDecode("error: something went wrong $e");
    }
  }

  String addProductsJsonFile(String fileName, int productId, int quantity) {
    try {
      String currentDirectory = Directory.current.path;
      String filePath = '$currentDirectory/bin/$fileName';
      File file = File(filePath);
      if (!file.existsSync()) {
        throw Exception('File not found: $filePath');
      }

      String contents = file.readAsStringSync();
      Map<String, dynamic> jsonData = jsonDecode(contents);

      bool productAlreadyExists = jsonData["products"]
          .any((product) => product["productId"] == productId);
      if (!productAlreadyExists) {
        (jsonData["products"] as List)
            .add({"productId": productId, "quantity": quantity});
      }
      String jsonFile = jsonEncode(jsonData);
      file.writeAsStringSync(jsonFile);
      print('Json File: $jsonFile');
      return jsonFile;
    } catch (e) {
      print('Error deleting object from JSON file: $e');
      return jsonDecode("error: something went wrong $e");
    }
  }

  String addProductsByOneJsonFile(
      String fileName, int productId, int quantity) {
    try {
      String currentDirectory = Directory.current.path;
      String filePath = '$currentDirectory/bin/$fileName';
      File file = File(filePath);
      if (!file.existsSync()) {
        throw Exception('File not found: $filePath');
      }

      String contents = file.readAsStringSync();
      Map<String, dynamic> jsonData = jsonDecode(contents);
      for (var product in jsonData['products']) {
        if (product["productId"] == productId) {
          // Increment the quantity by one if the product exists
          product["quantity"] = (product["quantity"] ?? 0) + 1;
          break;
        }
      }
      String jsonFile = jsonEncode(jsonData);
      file.writeAsStringSync(jsonFile);
      print('Json File: $jsonFile');
      return jsonFile;
    } catch (e) {
      print('Error deleting object from JSON file: $e');
      return jsonDecode("error: something went wrong $e");
    }
  }

  String removeProductsByOneJsonFile(
      String fileName, int productId, int quantity) {
    try {
      String currentDirectory = Directory.current.path;
      String filePath = '$currentDirectory/bin/$fileName';
      File file = File(filePath);
      if (!file.existsSync()) {
        throw Exception('File not found: $filePath');
      }

      String contents = file.readAsStringSync();
      Map<String, dynamic> jsonData = jsonDecode(contents);

      for (var product in jsonData['products']) {
        if (product["productId"] == productId) {
          product["quantity"] = (product["quantity"] ?? 0) - 1;

          if (product["quantity"] < 1) {
            (jsonData["products"] as List).remove(product);
          }
          break;
        }
      }
      String jsonFile = jsonEncode(jsonData);
      file.writeAsStringSync(jsonFile);
      print('Json File: $jsonFile');
      return jsonFile;
    } catch (e) {
      print('Error deleting object from JSON file: $e');
      return jsonDecode("error: something went wrong $e");
    }
  }
}
