import 'package:flutter/foundation.dart';

@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.assetPath,
    required this.accentColor,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final double originalPrice;
  final String assetPath;
  final int accentColor;

  int? get discountPercentage {
    if (originalPrice <= 0 || price >= originalPrice) {
      return null;
    }

    return ((1 - (price / originalPrice)) * 100).round().clamp(0, 100);
  }
}
