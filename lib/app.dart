import 'package:flutter/material.dart';
import 'package:product_card_atlas/data/demo_product_repository.dart';
import 'package:product_card_atlas/screens/showcase_page.dart';
import 'package:product_card_atlas/theme/app_theme.dart';

class ProductCardAtlasApp extends StatelessWidget {
  const ProductCardAtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Card Atlas',
      theme: AppTheme.light,
      home: ShowcasePage(products: DemoProductRepository.products),
    );
  }
}
