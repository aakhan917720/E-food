import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageUrl;
  final bool isAvailable;
  final List<String>? variations; // FUTURE-PROOF: Extensible customization mapping

  const FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
    this.variations,
  });

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      variations: map['variations'] != null
          ? List<String>.from(map['variations'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'variations': variations,
    };
  }

  FoodItem copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    String? imageUrl,
    bool? isAvailable,
    List<String>? variations,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      variations: variations ?? this.variations,
    );
  }

  @override
  List<Object?> get props => [id, name, price, category, imageUrl, isAvailable, variations];
}