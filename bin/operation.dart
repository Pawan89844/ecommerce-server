import 'dart:convert';
import 'dart:io';

import 'model/cartmodel.dart';

class FileOperation {
  Map<String, dynamic> readJsonFile(String fileName) {
    try {
      String currentDirectory = Directory.current.path;
      String filePath = '$currentDirectory/bin/$fileName';
      File file = File(filePath);

      // Check if the file exists
      if (!file.existsSync()) {
        throw Exception('File not found: $filePath');
      }

      // Read the contents of the file
      String contents = file.readAsStringSync();

      // Decode the JSON data
      Map<String, dynamic> jsonData = jsonDecode(contents);

      return jsonData;
    } catch (e) {
      print('Error reading JSON file: $e');
      return jsonDecode(
          "error: something went wrong $e"); // Or handle the error according to your needs
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

      // Decode the JSON data
      Map<String, dynamic> jsonData = jsonDecode(contents);

      // Find and remove the object with the specified ID
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
