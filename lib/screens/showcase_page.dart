import 'package:flutter/material.dart';
import 'package:product_card_atlas/models/product.dart';
import 'package:product_card_atlas/theme/app_theme.dart';
import 'package:product_card_atlas/widgets/product_card.dart';

class ShowcasePage extends StatefulWidget {
  const ShowcasePage({required this.products, super.key});

  final List<Product> products;

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  static const String _allCategory = 'All';

  String _selectedCategory = _allCategory;

  List<String> get _categories {
    final Set<String> categories = widget.products
        .map((Product product) => product.category)
        .toSet();

    return <String>[_allCategory, ...categories];
  }

  List<Product> get _visibleProducts {
    if (_selectedCategory == _allCategory) {
      return widget.products;
    }

    return widget.products
        .where((Product product) => product.category == _selectedCategory)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _ShowcaseHeader(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (String category) {
                setState(() => _selectedCategory = category);
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 56),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: _ProductCollection(products: _visibleProducts),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShowcaseHeader extends StatelessWidget {
  const _ShowcaseHeader({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool isCompact = width < 720;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            isCompact ? 36 : 64,
            20,
            isCompact ? 34 : 48,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppTheme.ink,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'PRODUCT CARD ATLAS',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(letterSpacing: 1.4),
                  ),
                ],
              ),
              SizedBox(height: isCompact ? 30 : 42),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Text(
                  'Six products.\nOne clear system.',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: isCompact ? 42 : 64,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  'A responsive Flutter study in hierarchy, pricing, '
                  'interaction, and resilient local-first presentation.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categories
                    .map((String category) {
                      return ChoiceChip(
                        label: Text(category),
                        selected: category == selectedCategory,
                        onSelected: (_) => onCategorySelected(category),
                      );
                    })
                    .toList(growable: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCollection extends StatelessWidget {
  const _ProductCollection({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const _EmptyCollection();
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxExtent = constraints.maxWidth < 520 ? 520 : 360;

        return GridView.builder(
          key: ValueKey<int>(products.length),
          shrinkWrap: true,
          primary: false,
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxExtent,
            mainAxisExtent: 432,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
          ),
          itemBuilder: (BuildContext context, int index) {
            final Product product = products[index];
            return ProductCard(
              key: ValueKey<String>(product.id),
              product: product,
            );
          },
        );
      },
    );
  }
}

class _EmptyCollection extends StatelessWidget {
  const _EmptyCollection();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.paper,
        border: Border.all(color: AppTheme.line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            const Icon(Icons.inventory_2_outlined, size: 36),
            const SizedBox(height: 14),
            Text(
              'No products in this collection.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
