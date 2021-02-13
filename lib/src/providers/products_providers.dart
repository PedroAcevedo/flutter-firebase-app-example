import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:test_app/src/models/product_model.dart';
import 'package:test_app/src/preferences/user_preferences.dart';

class ProductsProvider {
  final String _url =
      'https://flutter-practice-2b549-default-rtdb.firebaseio.com';

  final _prefs = UserPreference();

  Future<bool> createProduct(Product product) async {
    final url = '$_url/products.json?auth=${ _prefs.token }';

    final resp = await http.post(url, body: productToJson(product));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<Product>> getProducts() async {
    final url = '$_url/products.json?auth=${ _prefs.token }';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<Product> products = new List();

    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = Product.fromJson(prod);
      prodTemp.id = id;
      products.add(prodTemp);
    });

    print(products);

    return products;
  }

  Future<int> deleteProducts(String id) async {
    final url = '$_url/products/$id.json?auth=${ _prefs.token }';
    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;
  }

  Future<bool> editProduct(Product product) async {
    final url = '$_url/products/${product.id}.json?auth=${ _prefs.token }';

    final resp = await http.put(url, body: productToJson(product));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<String> uploadImage(File image) async {
    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/dg3tvox9c/image/upload?upload_preset=h8j8eiy1");
    final mimeType = mime(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url,
    );

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);
     
     final streamResponse = await imageUploadRequest.send();
     
     final resp = await http.Response.fromStream(streamResponse);

    if( resp.statusCode != 200 && resp.statusCode != 201){
      print('Se ha presentado un error');
      print( resp.body ); 
      return null;

    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];


  }
}
