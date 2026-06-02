import 'package:flutter/material.dart';
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

  String get selectedCategory => _selectedCategory;

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
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

  List<Product> get favoriteProducts => _products.where((p) => p.isFavorite).toList();

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
    final index = _products.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      _products[index].isFavorite = !_products[index].isFavorite;
      notifyListeners();
    }
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
