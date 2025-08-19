import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

// Main entry point for the Flutter application
void main() {
  runApp(const ProductShowcaseApp());
}

// The root widget of the application
class ProductShowcaseApp extends StatelessWidget {
  const ProductShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Card Showcase',
      theme: ThemeData(
        primaryColor: const Color(0xFFFFCC00),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFCC00),
          primary: const Color(0xFFFFCC00),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const ProductShowcasePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Data model for a product
class Product {
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final String category;
  final double? rating;
  final bool isNew;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.category,
    this.rating,
    this.isNew = false,
  });

  // Helper to calculate discount percentage
  double? get discountPercentage {
    if (originalPrice != null && originalPrice! > 0) {
      return (1 - price / originalPrice!) * 100;
    }
    return null;
  }
}

// The main page that displays the grid of product cards
class ProductShowcasePage extends StatelessWidget {
  const ProductShowcasePage({super.key});

  // Updated sample data with new, reliable image URLs
  static final List<Product> _sampleProducts = [
    Product(
        name: "Urban Explorer Sneakers",
        imageUrl: "https://picsum.photos/seed/sneakers/400/400",
        price: 89.99,
        originalPrice: 120.00,
        category: "Footwear",
        rating: 4.8),
    Product(
        name: "Galaxy Smartwatch Pro",
        imageUrl: "https://picsum.photos/seed/watch/400/400",
        price: 299.50,
        originalPrice: 399.99,
        category: "Electronics",
        rating: 4.9,
        isNew: true),
    Product(
        name: "Executive Leather Briefcase",
        imageUrl: "https://picsum.photos/seed/briefcase/400/400",
        price: 180.00,
        originalPrice: 250.00,
        category: "Accessories",
        rating: 4.7),
    Product(
        name: "Aurora Table Lamp",
        imageUrl: "https://picsum.photos/seed/lamp/400/400",
        price: 65.75,
        category: "Home & Living",
        rating: 4.5,
        isNew: true),
    Product(
        name: "Titanium Aviators",
        imageUrl: "https://picsum.photos/seed/sunglasses/400/400",
        price: 195.00,
        originalPrice: 280.00,
        category: "Eyewear",
        rating: 4.6),
    Product(
        name: "Cinema Pro Camera",
        imageUrl: "https://picsum.photos/seed/camera/400/400",
        price: 1299.99,
        originalPrice: 1599.00,
        category: "Photography",
        rating: 4.9),
    Product(
        name: "Mountain Peak Coffee",
        imageUrl: "https://picsum.photos/seed/coffee/400/400",
        price: 28.50,
        category: "Gourmet",
        rating: 4.4),
    Product(
        name: "Nomad Adventure Pack",
        imageUrl: "https://picsum.photos/seed/backpack/400/400",
        price: 125.00,
        originalPrice: 175.00,
        category: "Travel",
        rating: 4.8),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = [
      ProductCardFinal(product: _sampleProducts[0]),
      ProductCardNeon(product: _sampleProducts[1]),
      ProductCardDiagonal(product: _sampleProducts[2]),
      ProductCardCircular(product: _sampleProducts[3]),
      ProductCardMorphic(product: _sampleProducts[4]),
      ProductCardHolographic(product: _sampleProducts[5]),
      ProductCardVintage(product: _sampleProducts[6]),
      ProductCardFuturistic(product: _sampleProducts[7]),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Premium Card Collection',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.68,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return cards[index];
        },
      ),
    );
  }
}

// ====================================================================
// Reusable Price Widget for consistency
// ====================================================================
class PriceWidget extends StatelessWidget {
  final Product product;
  final Color mainPriceColor;
  final Color originalPriceColor;
  final double mainPriceSize;
  const PriceWidget({
    super.key,
    required this.product,
    required this.mainPriceColor,
    required this.originalPriceColor,
    required this.mainPriceSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.originalPrice != null)
          Text(
            '€${product.originalPrice!.toStringAsFixed(2)}',
            style: TextStyle(
              color: originalPriceColor,
              decoration: TextDecoration.lineThrough,
              fontSize: 12,
            ),
          ),
        Text(
          '€${product.price.toStringAsFixed(2)}',
          style: TextStyle(
            color: mainPriceColor,
            fontWeight: FontWeight.bold,
            fontSize: mainPriceSize,
          ),
        ),
      ],
    );
  }
}

// ====================================================================
// DESIGN 1: The Final Creative Card (Original - Unchanged)
// ====================================================================
class ProductCardFinal extends StatelessWidget {
  final Product product;
  const ProductCardFinal({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(context),
            Expanded(
              child: _buildProductInformation(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 140,
          width: double.infinity,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, color: Colors.red),
          ),
        ),
        if (product.discountPercentage != null)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '-${product.discountPercentage!.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.favorite_border,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInformation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 8),
          child: Text(
            product.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        _buildPriceFooter(context),
      ],
    );
  }

  Widget _buildPriceFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: PriceWidget(
              product: product,
              mainPriceColor: Colors.black,
              originalPriceColor: Colors.black.withOpacity(0.7),
              mainPriceSize: 20,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// DESIGN 2: Neon Glow Card
// ====================================================================
class ProductCardNeon extends StatefulWidget {
  final Product product;
  const ProductCardNeon({super.key, required this.product});

  @override
  State<ProductCardNeon> createState() => _ProductCardNeonState();
}

class _ProductCardNeonState extends State<ProductCardNeon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.grey[900]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(_glowAnimation.value * 0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                _buildImageSection(),
                _buildInfoSection(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection() {
    return Expanded(
      flex: 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            widget.product.imageUrl,
            fit: BoxFit.cover,
            color: Colors.white.withOpacity(0.9),
            colorBlendMode: BlendMode.overlay,
          ),
          if (widget.product.isNew)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                shadows: [
                  Shadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            if (widget.product.rating != null)
              Row(
                children: [
                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    widget.product.rating!.toString(),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            const Spacer(),
            PriceWidget(
              product: widget.product,
              mainPriceColor: Colors.white,
              originalPriceColor: Colors.white54,
              mainPriceSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// DESIGN 3: Diagonal Split Card
// ====================================================================
class ProductCardDiagonal extends StatelessWidget {
  final Product product;
  const ProductCardDiagonal({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: ClipPath(
                clipper: DiagonalClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.95),
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  PriceWidget(
                    product: product,
                    mainPriceColor: Colors.black,
                    originalPriceColor: Colors.black54,
                    mainPriceSize: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.lineTo(size.width * 0.8, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// ====================================================================
// DESIGN 4: Circular Image Card
// ====================================================================
class ProductCardCircular extends StatelessWidget {
  final Product product;
  const ProductCardCircular({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        Theme.of(context).primaryColor.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                if (product.isNew)
                  Positioned(
                    top: 0,
                    right: 20,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fiber_new,
                        color: Colors.black,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  product.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                if (product.rating != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < product.rating!.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: Theme.of(context).primaryColor,
                        size: 16,
                      );
                    }),
                  ),
                const Spacer(),
                PriceWidget(
                  product: product,
                  mainPriceColor: Colors.black,
                  originalPriceColor: Colors.grey,
                  mainPriceSize: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// DESIGN 5: Morphic/Neumorphic Card
// ====================================================================
class ProductCardMorphic extends StatelessWidget {
  final Product product;
  const ProductCardMorphic({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(5, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-3, -3),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(3, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    product.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: PriceWidget(
                      product: product,
                      mainPriceColor: Colors.black,
                      originalPriceColor: Colors.black54,
                      mainPriceSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// DESIGN 6: Holographic Card
// ====================================================================
class ProductCardHolographic extends StatefulWidget {
  final Product product;
  const ProductCardHolographic({super.key, required this.product});

  @override
  State<ProductCardHolographic> createState() => _ProductCardHolographicState();
}

class _ProductCardHolographicState extends State<ProductCardHolographic>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1a1a2e),
            Color(0xFF16213e),
            Color(0xFF0f3460),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AnimatedBuilder(
                animation: _shimmerAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(_shimmerAnimation.value - 1, 0),
                        end: Alignment(_shimmerAnimation.value, 0),
                        colors: [
                          Colors.transparent,
                          Theme.of(context).primaryColor.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: PriceWidget(
                              product: widget.product,
                              mainPriceColor: Theme.of(context).primaryColor,
                              originalPriceColor: Colors.white54,
                              mainPriceSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// DESIGN 7: Vintage Paper Card
// ====================================================================
class ProductCardVintage extends StatelessWidget {
  final Product product;
  const ProductCardVintage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.02,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(3, 3),
            ),
          ],
          border: Border.all(
            color: Colors.brown.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.brown.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    color: Colors.brown.withOpacity(0.1),
                    colorBlendMode: BlendMode.overlay,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 12),
                child: Column(
                  children: [
                    Text(
                      product.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.brown[800],
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    PriceWidget(
                      product: product,
                      mainPriceColor: Colors.brown[800]!,
                      originalPriceColor: Colors.brown[600]!,
                      mainPriceSize: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// DESIGN 8: Futuristic Card
// ====================================================================
class ProductCardFuturistic extends StatefulWidget {
  final Product product;
  const ProductCardFuturistic({super.key, required this.product});

  @override
  State<ProductCardFuturistic> createState() => _ProductCardFuturisticState();
}

class _ProductCardFuturisticState extends State<ProductCardFuturistic>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [ Color(0xFF0A0A0A), Color(0xFF1A1A1A), Color(0xFF2A2A2A) ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridPainter(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network( widget.product.imageUrl, fit: BoxFit.cover ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // ▼▼▼ FIX ▼▼▼
                        // Wrapped the Column in an Expanded widget to resolve the overflow error.
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                widget.product.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).primaryColor,
                                      Color.lerp(Theme.of(context).primaryColor, Colors.orange, 0.5)!
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: PriceWidget(
                                  product: widget.product,
                                  mainPriceColor: Colors.black,
                                  originalPriceColor: Colors.black54,
                                  mainPriceSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;
    const spacing = 20.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}