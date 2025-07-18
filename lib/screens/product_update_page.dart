import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../product_provider.dart';

class ProductUpdatePage extends ConsumerStatefulWidget {
  final int productId;

  const ProductUpdatePage({super.key, required this.productId});

  @override
  ConsumerState<ProductUpdatePage> createState() => _ProductUpdatePageState();
}

class _ProductUpdatePageState extends ConsumerState<ProductUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late int price;
  late List<String> images;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProductData();
  }

  void _loadProductData() async {
    final product = await ref.read(
      productDetailProvider(widget.productId).future,
    );
    setState(() {
      title = product.title;
      description = product.description;
      price = product.price;
      images =
          product.images.isNotEmpty
              ? product.images
              : ['https://via.placeholder.com/150'];
    });
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    final data = {
      'id': widget.productId,
      'title': title,
      'price': price,
      'description': description,
      'images': images,
    };

    try {
      await ref.read(updateProductProvider(data).future);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Product updated successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed to update product: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Product')),
      body:
          (title == null)
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: title,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Enter title'
                                    : null,
                        onSaved: (val) => title = val ?? '',
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: description,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Enter description'
                                    : null,
                        onSaved: (val) => description = val ?? '',
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: price.toString(),
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          final parsed = int.tryParse(val ?? '');
                          if (parsed == null || parsed <= 0) {
                            return 'Enter a valid price';
                          }
                          return null;
                        },
                        onSaved: (val) => price = int.tryParse(val ?? '0') ?? 0,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: images.first,
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                        ),
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Enter image URL'
                                    : null,
                        onSaved: (val) => images = [val ?? ''],
                      ),
                      const SizedBox(height: 20),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Update'),
                          ),
                    ],
                  ),
                ),
              ),
    );
  }
}
