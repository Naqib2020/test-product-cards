import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;

// The typedef must be a top-level declaration, not inside a class.
typedef ProductCardBuilder = Widget Function(Product product);

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

// ====================================================================
// Data Model & Service for API fetching
// ====================================================================

// Data model to match the API response
class Product {
  final String name;
  final String imageUrl;
  final double price;
  final double originalPrice;
  final String category;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.category,
  });

  double? get discountPercentage {
    if (originalPrice > 0) {
      return (1 - price / originalPrice) * 100;
    }
    return null;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse string prices to double
    double safeParse(String? value) {
      return double.tryParse(value ?? '0.0') ?? 0.0;
    }

    // Handle the '##' separated image string
    String firstImage = 'https://picsum.photos/400'; // Fallback image
    String imageString = json['product_images'] ?? '';
    if (imageString.isNotEmpty) {
      firstImage = imageString.split('##').first;
    }

    return Product(
      name: json['product_name'] ?? 'No Name',
      imageUrl: firstImage,
      price: safeParse(json['retail_price']),
      originalPrice: safeParse(json['unit_cost']),
      category: json['gl_desc']?.replaceAll('gl_', '') ?? 'General',
    );
  }
}

// Service to fetch products from the API
class ProductService {
  static const String apiUrl = 'https://scanprox.de/scanprox/api/client/342/products_list';

  Future<List<Product>> fetchProducts({int limit = 8}) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "shop_id": 38,
          "limit": limit,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> productList = data['data']['data'];
        return productList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: Status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API fetch failed: $e. Using dummy data.');
      return List.generate(limit, (index) => Product(
          name: "Sample Product ${index + 1}",
          imageUrl: "https://picsum.photos/seed/${index + 1}/400/400",
          price: (50 + index * 10).toDouble(),
          originalPrice: (80 + index * 10).toDouble(),
          category: "Sample Category"
      ));
    }
  }
}

// ====================================================================
// Home Page - Product Showcase
// ====================================================================

class ProductShowcasePage extends StatefulWidget {
  const ProductShowcasePage({super.key});

  @override
  State<ProductShowcasePage> createState() => _ProductShowcasePageState();
}

class _ProductShowcasePageState extends State<ProductShowcasePage> {
  late Future<List<Product>> _productsFuture;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.fetchProducts(limit: 8);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;

          final List<ProductCardBuilder> cardBuilders = [
                (p) => ProductCardFinal(product: p),
                (p) => ProductCardNeon(product: p),
                (p) => ProductCardDiagonal(product: p),
                (p) => ProductCardInspired(product: p),
                (p) => ProductCardMorphic(product: p),
                (p) => ProductCardHolographic(product: p),
                (p) => ProductCardVintage(product: p),
                (p) => ProductCardFuturistic(product: p),
          ];

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.68,
            ),
            itemCount: cardBuilders.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final cardBuilder = cardBuilders[index];
              final card = cardBuilder(product);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardDetailPage(
                        cardBuilder: cardBuilder,
                        products: products,
                        cardName: card.runtimeType.toString(),
                      ),
                    ),
                  );
                },
                child: card,
              );
            },
          );
        },
      ),
    );
  }
}

// ====================================================================
// Card Detail Page
// ====================================================================
class CardDetailPage extends StatelessWidget {
  final Widget Function(Product product) cardBuilder;
  final List<Product> products;
  final String cardName;

  const CardDetailPage({
    super.key,
    required this.cardBuilder,
    required this.products,
    required this.cardName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cardName.replaceAll('ProductCard', ''),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.68,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return cardBuilder(products[index]);
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
      mainAxisSize: MainAxisSize.min,
      children: [
        if (product.originalPrice > 0 && product.originalPrice > product.price)
          Text(
            '€${product.originalPrice.toStringAsFixed(2)}',
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
// DESIGN 1: The Final Creative Card (REDESIGNED)
// ====================================================================
class ProductCardFinal extends StatelessWidget {
  final Product product;
  const ProductCardFinal({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.grey[200], // Fallback color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildProductImage(),
            _buildGradientOverlay(),
            _buildDiscountBadge(context),
            _buildFavoriteIcon(),
            _buildInfoOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Image.network(
      product.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
      const Icon(Icons.error, color: Colors.red),
    );
  }

  Widget _buildGradientOverlay() {
    // MODIFIED: Using a dark, warm gold derived from the brand color for a premium feel.
    const darkBrandColor = Color(0xFF665200);

    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              darkBrandColor.withOpacity(0.6),
              darkBrandColor.withOpacity(0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.4, 0.7, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountBadge(BuildContext context) {
    if (product.discountPercentage == null || product.discountPercentage! <= 0) {
      return const SizedBox.shrink();
    }
    return Positioned(
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
    );
  }

  Widget _buildFavoriteIcon() {
    return Positioned(
      top: 4,
      right: 4,
      child: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.favorite_border,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
        ),
      ),
    );
  }

  Widget _buildInfoOverlay(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14, // Reduced font size
                shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PriceWidget(
                  product: product,
                  mainPriceColor: Theme.of(context).primaryColor,
                  originalPriceColor: Colors.white70,
                  mainPriceSize: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
// DESIGN 4: Inspired by your screenshot
// ====================================================================
class ProductCardInspired extends StatelessWidget {
  final Product product;
  const ProductCardInspired({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(context),
          Expanded(
            child: _buildProductInformation(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 150,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, color: Colors.red),
            ),
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
                    fontSize: 11),
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
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInformation(BuildContext context) {
    final priceString = product.price.toStringAsFixed(2);
    final parts = priceString.split('.');
    final mainPart = parts[0];
    final centsPart = parts.length > 1 ? parts[1] : '00';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0).copyWith(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            product.category,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const Spacer(),
          if (product.originalPrice != null)
            Text(
              '€${product.originalPrice!.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.grey[500],
                decoration: TextDecoration.lineThrough,
                fontSize: 13,
              ),
            ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: mainPart,
                  style: const TextStyle(fontSize: 20),
                ),
                TextSpan(
                  text: '.',
                  style: const TextStyle(fontSize: 20),
                ),
                TextSpan(
                  text: centsPart,
                  style: const TextStyle(
                    fontSize: 10,
                    fontFeatures: [FontFeature.subscripts()],
                  ),
                ),
                const TextSpan(
                  text: ' €',
                  style: TextStyle(
                    fontSize: 16,
                    fontFeatures: [FontFeature.superscripts()],
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
// DESIGN 7: Vintage Paper Card (REDESIGNED)
// ====================================================================
class ProductCardVintage extends StatelessWidget {
  final Product product;
  const ProductCardVintage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.01,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F4E6),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(2, 4),
            ),
          ],
          border: Border.all(
            color: Colors.brown.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                SizedBox(
                  height: constraints.maxHeight * 0.55,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.brown.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.5),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        color: Colors.brown.withOpacity(0.05),
                        colorBlendMode: BlendMode.overlay,
                      ),
                    ),
                  ),
                ),
                // Content Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Product Name
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: Colors.brown[800],
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Category Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            'home',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[700],
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Price Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '€14.02',
                                  style: TextStyle(
                                    color: Colors.brown[500],
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 9,
                                  ),
                                ),
                                Text(
                                  '€4.00',
                                  style: TextStyle(
                                    color: Colors.brown[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ====================================================================
// DESIGN 8: Futuristic Card (REDESIGNED)
// ====================================================================
class ProductCardFuturistic extends StatefulWidget {
  final Product product;
  const ProductCardFuturistic({super.key, required this.product});

  @override
  State<ProductCardFuturistic> createState() => _ProductCardFuturisticState();
}

class _ProductCardFuturisticState extends State<ProductCardFuturistic>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _borderController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _borderController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _borderAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _borderController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _borderAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0D0D0D),
                  Color(0xFF1A1A1A),
                  Color(0xFF0D0D0D),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF111111),
                        Color(0xFF1F1F1F),
                        Color(0xFF111111),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Image Section
                      SizedBox(
                        height: constraints.maxHeight * 0.55,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.network(
                              widget.product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      // Info Section
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Product name
                              Text(
                                widget.product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              // Category chip
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  'HOME',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // Price and action button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '€11.74',
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          decoration: TextDecoration.lineThrough,
                                          fontSize: 9,
                                        ),
                                      ),
                                      Text(
                                        '€5.00',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColor.withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.shopping_cart_outlined,
                                      color: Colors.black,
                                      size: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// Custom painter for futuristic grid effect
class FuturisticGridPainter extends CustomPainter {
  final Color color;
  final double animation;

  FuturisticGridPainter({required this.color, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.3;

    const spacing = 15.0;
    final animatedOpacity = (0.3 + (animation * 0.4));

    // Vertical lines
    for (double x = 0; x <= size.width; x += spacing) {
      paint.color = color.withOpacity(animatedOpacity * ((x / size.width).abs()));
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += spacing) {
      paint.color = color.withOpacity(animatedOpacity * ((y / size.height).abs()));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Legacy GridPainter for backward compatibility
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