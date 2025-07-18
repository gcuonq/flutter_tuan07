import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../product_provider.dart';

class ProductCreatePage extends ConsumerStatefulWidget {
  const ProductCreatePage({super.key});

  @override
  ConsumerState<ProductCreatePage> createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends ConsumerState<ProductCreatePage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  int price = 0;
  int categoryId = 1;
  List<String> images = [];
  final TextEditingController imageUrlController = TextEditingController();

  bool isLoading = false;

  void _addImageUrl() {
    final url = imageUrlController.text.trim();
    if (url.isNotEmpty) {
      setState(() {
        images.add(url);
        imageUrlController.clear();
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❗ Vui lòng thêm ít nhất một liên kết ảnh'),
        ),
      );
      return;
    }

    _formKey.currentState!.save();
    setState(() => isLoading = true);

    final data = {
      'title': title,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'images': images,
    };

    try {
      await ref.read(createProductProvider(data).future);
      ref.invalidate(productListProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Tạo sản phẩm thành công')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Tạo sản phẩm thất bại: $e')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo Sản Phẩm')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? 'Vui lòng nhập tên sản phẩm'
                            : null,
                onSaved: (val) => title = val ?? '',
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mô tả'),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? 'Vui lòng nhập mô tả'
                            : null,
                onSaved: (val) => description = val ?? '',
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Giá tiền'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  final parsed = int.tryParse(val ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Vui lòng nhập giá hợp lệ';
                  }
                  return null;
                },
                onSaved: (val) => price = int.tryParse(val ?? '0') ?? 0,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: categoryId,
                decoration: const InputDecoration(labelText: 'Danh mục'),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Quần áo')),
                  DropdownMenuItem(value: 2, child: Text('Điện tử')),
                  DropdownMenuItem(value: 3, child: Text('Nội thất')),
                  DropdownMenuItem(value: 4, child: Text('Giày dép')),
                  DropdownMenuItem(value: 5, child: Text('Khác')),
                ],
                onChanged: (val) => setState(() => categoryId = val ?? 1),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Đường dẫn ảnh',
                        hintText: 'https://example.com/image.jpg',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addImageUrl,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    images.map((url) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              url,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () {
                              setState(() => images.remove(url));
                            },
                          ),
                        ],
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Tạo sản phẩm'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
