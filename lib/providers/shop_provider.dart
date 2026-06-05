import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class ShopProvider with ChangeNotifier {
  String _selectedCategory = 'All';
  bool _isLoading = false;
  bool _isOffline = false;
  bool _simulateOffline = false;
  List<Product> _loadedFavorites = [];

  ShopProvider() {
    _initData();
  }

  Future<void> _initData() async {
    await loadFavoritesLocally();
    await fetchProducts();
  }

  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  bool get simulateOffline => _simulateOffline;

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleSimulateOffline() {
    _simulateOffline = !_simulateOffline;
    notifyListeners();
    fetchProducts();
  }

  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'Aura Headphones',
      description: 'Experience immersive audio with noise-canceling technology and plush earcups for ultimate comfort.',
      price: 149.99,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&auto=format&fit=crop&q=60',
      category: 'Electronics',
    ),
    Product(
      id: 'p2',
      name: 'Nova Smart Watch',
      description: 'Stay connected with notifications, fitness tracking, and a sleek, customizable digital display.',
      price: 129.99,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=60',
      category: 'Electronics',
    ),
    Product(
      id: 'p3',
      name: 'Luxe Leather Bag',
      description: 'Handcrafted premium leather handbag with spacious compartments and a timeless aesthetic.',
      price: 89.99,
      imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=500&auto=format&fit=crop&q=60',
      category: 'Fashion',
    ),
    Product(
      id: 'p4',
      name: 'Velvet Bloom Perfume',
      description: 'A luxurious signature scent featuring notes of rich velvet, fresh roses, and warm amber.',
      price: 74.99,
      imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683601?w=500&auto=format&fit=crop&q=60',
      category: 'Perfumes',
    ),
    Product(
      id: 'p5',
      name: 'Air Pegasus Sneakers',
      description: 'High-performance athletic running shoes with lightweight cushioning and durable grip.',
      price: 110.00,
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=60',
      category: 'Sports',
    ),
    Product(
      id: 'p6',
      name: 'Classic Leather Journal',
      description: 'Elegant ruled notebook with a premium bound cover, perfect for sketching or daily writing.',
      price: 24.50,
      imageUrl: 'https://images.unsplash.com/photo-1531346878377-a5be20888e57?w=500&auto=format&fit=crop&q=60',
      category: 'Books',
    ),
    Product(
      id: 'p7',
      name: 'Ceramic Coffee Mug',
      description: 'Artisanal ceramic mug finished in a rustic, textured matte glaze, dishwasher safe.',
      price: 18.00,
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500&auto=format&fit=crop&q=60',
      category: 'Others',
    ),
  ];

  final Map<String, CartItem> _cartItems = {};

  List<Product> get products {
    if (_selectedCategory == 'All') {
      return [..._products];
    }
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  List<Product> get allProductsRaw => [..._products];

  List<Product> get favoriteProducts => _loadedFavorites;

  List<CartItem> get cartItems => _cartItems.values.toList();

  int get cartItemCount {
    int totalCount = 0;
    _cartItems.forEach((key, item) {
      totalCount += item.quantity;
    });
    return totalCount;
  }

  double get cartSubtotal {
    double total = 0.0;
    _cartItems.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  double get cartTotal {
    double sub = cartSubtotal;
    if (sub == 0) return 0.0;
    return sub + (sub > 100 ? 0.0 : 9.99);
  }

  double get shippingFee {
    double sub = cartSubtotal;
    if (sub == 0 || sub > 100) return 0.0;
    return 9.99;
  }

  void toggleFavorite(String productId) {
    final prodIndex = _products.indexWhere((p) => p.id == productId);
    final favIndex = _loadedFavorites.indexWhere((p) => p.id == productId);

    if (favIndex >= 0) {
      _loadedFavorites.removeAt(favIndex);
      if (prodIndex >= 0) {
        _products[prodIndex].isFavorite = false;
      }
    } else {
      if (prodIndex >= 0) {
        final product = _products[prodIndex];
        product.isFavorite = true;
        _loadedFavorites.add(product);
      } else {
        // Fallback if not found in current products (e.g. from favorites screen directly)
      }
    }
    saveFavoritesLocally();
    notifyListeners();
  }

  // File Persistence Helpers
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _favoritesFile async {
    final path = await _localPath;
    return File('$path/favorites.json');
  }

  Future<File> get _cacheFile async {
    final path = await _localPath;
    return File('$path/cached_products.json');
  }

  Future<void> saveFavoritesLocally() async {
    try {
      final file = await _favoritesFile;
      final data = _loadedFavorites.map((p) => p.toFavoriteJson()).toList();
      await file.writeAsString(json.encode(data));
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  Future<void> loadFavoritesLocally() async {
    try {
      final file = await _favoritesFile;
      if (!await file.exists()) return;
      final content = await file.readAsString();
      final List<dynamic> data = json.decode(content);
      _loadedFavorites = data.map((item) => Product.fromFavoriteJson(item)).toList();
      
      // Sync with currently in-memory products
      for (var product in _products) {
        product.isFavorite = _loadedFavorites.any((fav) => fav.id == product.id);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> saveCacheLocally() async {
    try {
      final file = await _cacheFile;
      final data = _products.map((p) => p.toJson()).toList();
      await file.writeAsString(json.encode(data));
    } catch (e) {
      debugPrint('Error saving cache: $e');
    }
  }

  Future<void> loadCacheLocally() async {
    try {
      final file = await _cacheFile;
      if (!await file.exists()) return;
      final content = await file.readAsString();
      final List<dynamic> data = json.decode(content);
      final cachedProducts = data.map((item) => Product.fromJson(item)).toList();
      
      _products.clear();
      _products.addAll(cachedProducts);
      
      // Sync with favorites
      for (var product in _products) {
        product.isFavorite = _loadedFavorites.any((fav) => fav.id == product.id);
      }
    } catch (e) {
      debugPrint('Error loading cache: $e');
      rethrow;
    }
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _isOffline = false;
    notifyListeners();

    if (_simulateOffline) {
      await Future.delayed(const Duration(milliseconds: 600));
      _handleFetchError(Exception('Simulated Offline Mode'));
      return;
    }

    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products?limit=100'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'];
        
        final List<Product> fetchedProducts = [];
        for (var item in productsJson) {
          final rawCategory = item['category']?.toString() ?? 'Others';
          String category = 'Others';
          
          if (['laptops', 'mobile-accessories', 'smartphones', 'tablets'].contains(rawCategory)) {
            category = 'Electronics';
          } else if (['mens-shirts', 'mens-watches', 'womens-dresses', 'womens-shoes', 'womens-watches', 'womens-bags', 'womens-jewellery', 'sunglasses'].contains(rawCategory)) {
            category = 'Fashion';
          } else if (['sports-accessories', 'mens-shoes'].contains(rawCategory)) {
            category = 'Sports';
          } else if (['fragrances', 'beauty', 'skin-care'].contains(rawCategory)) {
            category = 'Perfumes';
          } else {
            category = 'Others';
          }

          final title = item['title']?.toString() ?? '';
          final desc = item['description']?.toString() ?? '';
          if (title.toLowerCase().contains('book') || 
              title.toLowerCase().contains('journal') ||
              title.toLowerCase().contains('notebook') ||
              desc.toLowerCase().contains('book') ||
              desc.toLowerCase().contains('journal') ||
              desc.toLowerCase().contains('notebook')) {
            category = 'Books';
          }

          final product = Product.fromJson(item).copyWith(category: category);
          fetchedProducts.add(product);
        }

        final booksCount = fetchedProducts.where((p) => p.category == 'Books').length;
        if (booksCount == 0) {
          int count = 0;
          for (int i = 0; i < fetchedProducts.length; i++) {
            if (fetchedProducts[i].category == 'Others' && count < 3) {
              fetchedProducts[i] = fetchedProducts[i].copyWith(
                category: 'Books',
                name: count == 0 
                  ? 'Classic Leather Journal' 
                  : count == 1 
                    ? 'The Art of Cooking Book' 
                    : 'Ultimate Guide to Design Book',
              );
              count++;
            }
          }
        }

        _products.clear();
        _products.addAll(fetchedProducts);

        for (var product in _products) {
          product.isFavorite = _loadedFavorites.any((fav) => fav.id == product.id);
        }

        _isOffline = false;
        _isLoading = false;
        notifyListeners();
        
        saveCacheLocally();
      } else {
        _handleFetchError(Exception('Failed with status: ${response.statusCode}'));
      }
    } catch (e) {
      _handleFetchError(e);
    }
  }

  void _handleFetchError(dynamic error) async {
    debugPrint('Fetch products error: $error');
    try {
      await loadCacheLocally();
      _isOffline = true;
    } catch (cacheError) {
      debugPrint('Failed to load cache: $cacheError');
      _isOffline = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  void addToCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id]!.quantity += 1;
    } else {
      _cartItems[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int delta) {
    if (!_cartItems.containsKey(productId)) return;
    
    final item = _cartItems[productId]!;
    final newQuantity = item.quantity + delta;
    
    if (newQuantity <= 0) {
      _cartItems.remove(productId);
    } else {
      item.quantity = newQuantity;
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
