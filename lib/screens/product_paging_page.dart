import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../product_provider.dart';

class ProductPagingPage extends ConsumerWidget {
  final int page;

  const ProductPagingPage({super.key, required this.page});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productPagingProvider(page));

    return Scaffold(
      appBar: AppBar(title: Text('Page $page')),
      body: productAsync.when(
        data:
            (products) => ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text('\$${product.price}'),
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
