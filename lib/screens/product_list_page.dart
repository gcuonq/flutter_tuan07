import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../product_provider.dart';

const int itemsPerPage = 10;

final _isPagingModeProvider = StateProvider<bool>((ref) => false);
final _currentPageProvider = StateProvider<int>((ref) => 0);

final productTotalProvider = FutureProvider<int>((ref) async {
  final products = await ref.watch(productListProvider.future);
  return products.length;
});

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaging = ref.watch(_isPagingModeProvider);
    final currentPage = ref.watch(_currentPageProvider);
    final productAsync =
        isPaging
            ? ref.watch(productPagingProvider(currentPage))
            : ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sản phẩm'),
        actions: [
          PopupMenuButton<bool>(
            onSelected: (isPaged) {
              ref.read(_isPagingModeProvider.notifier).state = isPaged;
              ref.read(_currentPageProvider.notifier).state = 0;
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: false,
                    child: Text('Hiển thị toàn bộ'),
                  ),
                  const PopupMenuItem(
                    value: true,
                    child: Text('Hiển thị phân trang'),
                  ),
                ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: productAsync.when(
              data:
                  (products) => ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final imageUrl =
                          product.images.isNotEmpty
                              ? product.images[0]
                              : 'https://via.placeholder.com/100';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  'https://via.placeholder.com/60',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          title: Text(product.title),
                          subtitle: Text('\$${product.price}'),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: product.id,
                            );
                          },
                        ),
                      );
                    },
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Lỗi: $err')),
            ),
          ),
          if (isPaging)
            Consumer(
              builder: (context, ref, _) {
                final totalAsync = ref.watch(productTotalProvider);
                return totalAsync.when(
                  data: (total) {
                    final totalPages = (total / itemsPerPage).ceil();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Wrap(
                        spacing: 8,
                        children: List.generate(totalPages, (index) {
                          final isSelected = index == currentPage;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected ? Colors.blue : null,
                            ),
                            onPressed: () {
                              ref.read(_currentPageProvider.notifier).state =
                                  index;
                            },
                            child: Text('${index + 1}'),
                          );
                        }),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (err, _) => Text('Lỗi tổng sản phẩm: $err'),
                );
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
