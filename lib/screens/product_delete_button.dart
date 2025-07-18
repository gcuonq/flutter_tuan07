import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../product_provider.dart';

class ProductDeleteButton extends ConsumerWidget {
  final int productId;

  const ProductDeleteButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text('Xoa san pham'),
      onPressed: () async {
        try {
          final delete = ref.read(deleteProductDirectProvider);
          final result = await delete(productId);
          if (result) {
            ref.invalidate(productListProvider);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Xoa thanh cong')));
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Xoa khong dc')));
          }
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Loi roi: $e')));
        }
      },
    );
  }
}
