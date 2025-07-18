// lib/data/repositories/product_repository.dart

import 'product_model.dart';
import 'product_datasource.dart';

class ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepository({required this.remoteDataSource});

  Future<List<Product>> getAllProducts() {
    return remoteDataSource.getAllProducts();
  }

  Future<Product> getProductDetail(int id) {
    return remoteDataSource.getProductDetail(id);
  }

  Future<Product> createProduct({
    required String title,
    required int price,
    required String description,
    required int categoryId,
    required List<String> images,
  }) {
    final body = {
      'title': title,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'images': images,
    };
    return remoteDataSource.createProduct(body);
  }

  Future<Product> updateProduct({
    required int id,
    String? title,
    int? price,
    String? description,
    List<String>? images,
  }) {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (price != null) body['price'] = price;
    if (description != null) body['description'] = description;
    if (images != null) body['images'] = images;

    return remoteDataSource.updateProduct(id, body);
  }

  Future<bool> deleteProduct(int id) {
    return remoteDataSource.deleteProduct(id);
  }

  Future<List<Product>> getProductsWithPaging(int offset, int limit) {
    return remoteDataSource.getProductsWithPaging(offset, limit);
  }
}
