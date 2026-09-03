import 'package:flutter_test/flutter_test.dart';
import 'package:product_card_atlas/models/product.dart';

void main() {
  const Product discountedProduct = Product(
    id: 'test',
    name: 'Test product',
    category: 'Test',
    description: 'Test description',
    price: 80,
    originalPrice: 100,
    assetPath: 'test.svg',
    accentColor: 0xFF000000,
  );

  test('calculates a rounded discount percentage', () {
    expect(discountedProduct.discountPercentage, 20);
  });

  test('returns no discount when price is not lower', () {
    const Product fullPriceProduct = Product(
      id: 'full-price',
      name: 'Full price',
      category: 'Test',
      description: 'Test description',
      price: 100,
      originalPrice: 100,
      assetPath: 'test.svg',
      accentColor: 0xFF000000,
    );

    expect(fullPriceProduct.discountPercentage, isNull);
  });
}
