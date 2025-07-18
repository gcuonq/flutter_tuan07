import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/product_model.dart';
import 'data/product_repository.dart';
import 'data/product_datasource.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(remoteDataSource: ProductRemoteDataSource());
});

final productListProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getAllProducts();
});

final productPagingProvider = FutureProvider.family<List<Product>, int>((
  ref,
  page,
) async {
  final repo = ref.watch(productRepositoryProvider);
  final offset = page * 10;
  return repo.getProductsWithPaging(offset, 10);
});

final productDetailProvider = FutureProvider.family<Product, int>((
  ref,
  productId,
) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductDetail(productId);
});

final createProductProvider =
    FutureProvider.family<Product, Map<String, dynamic>>((ref, data) async {
      final repo = ref.watch(productRepositoryProvider);
      return repo.createProduct(
        title: data['title'],
        price: data['price'],
        description: data['description'],
        categoryId: data['categoryId'],
        images: data['images'],
      );
    });

final updateProductProvider =
    FutureProvider.family<Product, Map<String, dynamic>>((ref, data) async {
      final repo = ref.watch(productRepositoryProvider);
      return repo.updateProduct(
        id: data['id'],
        title: data['title'],
        price: data['price'],
        description: data['description'],
        images: data['images'],
      );
    });

final deleteProductDirectProvider = Provider((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.deleteProduct;
});
