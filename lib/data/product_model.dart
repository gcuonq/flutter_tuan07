class Product {
  final int id;
  final String title;
  final int price;
  final String description;
  final List<String> images;
  final Category category;
  final DateTime creationAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
    required this.creationAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List<dynamic>?)?.cast<String>() ?? [];

    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      images: images,
      category: Category.fromJson(json['category']),
      creationAt: DateTime.parse(json['creationAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Category {
  final int id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name'], image: json['image']);
  }
}
