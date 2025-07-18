import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ProductRemoteDataSource {
  static const _baseUrl = 'https://api.escuelajs.co/api/v1/products';

  Future<List<Product>> getAllProducts() async {
    final res = await http.get(Uri.parse(_baseUrl));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Failed to load products');
  }

  Future<Product> getProductDetail(int id) async {
    final res = await http.get(Uri.parse('$_baseUrl/$id'));
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return Product.fromJson(json);
    }
    throw Exception('Failed to get product detail');
  }

  Future<Product> createProduct(Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (res.statusCode == 201) {
      final json = jsonDecode(res.body);
      return Product.fromJson(json);
    }
    throw Exception('Failed to create product');
  }

  Future<Product> updateProduct(int id, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return Product.fromJson(json);
    }
    throw Exception('Failed to update product');
  }

  Future<bool> deleteProduct(int id) async {
    final res = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (res.statusCode == 200) {
      return true;
    } else if (res.statusCode == 404) {
      throw Exception('Product not found');
    }
    throw Exception('Failed to delete product');
  }

  Future<List<Product>> getProductsWithPaging(int offset, int limit) async {
    final res = await http.get(
      Uri.parse('$_baseUrl?offset=$offset&limit=$limit'),
    );
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Failed to load paged products');
  }
}
