import 'package:flutter/material.dart';
import 'package:product_card_atlas/models/product.dart';
import 'package:product_card_atlas/theme/app_theme.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({required this.product, super.key});

  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;
  bool _isSaved = false;

  Product get product => widget.product;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: AppTheme.paper,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.line),
          boxShadow: _isHovered
              ? const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x1F172020),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ]
              : const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x0F172020),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _ProductArtwork(
                product: product,
                isSaved: _isSaved,
                onSave: () => setState(() => _isSaved = !_isSaved),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.category.toUpperCase(),
                        style: TextStyle(
                          color: Color(product.accentColor),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      _PriceAndAction(product: product),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductArtwork extends StatelessWidget {
  const _ProductArtwork({
    required this.product,
    required this.isSaved,
    required this.onSave,
  });

  final Product product;
  final bool isSaved;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final int? discount = product.discountPercentage;

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ColoredBox(
            color: Color(product.accentColor).withValues(alpha: 0.13),
            child: Semantics(
              image: true,
              label: '${product.name} product illustration',
              child: Image.asset(product.assetPath, fit: BoxFit.cover),
            ),
          ),
          if (discount != null)
            Positioned(
              left: 14,
              top: 14,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.ink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  child: Text(
                    'SAVE $discount%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 10,
            top: 10,
            child: IconButton.filledTonal(
              key: ValueKey<String>('save-${product.id}'),
              onPressed: onSave,
              tooltip: isSaved ? 'Remove from saved' : 'Save ${product.name}',
              icon: Icon(
                isSaved
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isSaved ? AppTheme.signal : AppTheme.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceAndAction extends StatelessWidget {
  const _PriceAndAction({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '\$${product.originalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppTheme.mutedInk,
                  fontSize: 13,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '\$${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          key: ValueKey<String>('add-${product.id}'),
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('${product.name} added to shortlist.')),
              );
          },
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.ink,
            foregroundColor: Colors.white,
            minimumSize: const Size(88, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
