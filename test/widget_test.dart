import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_8_app/models/product.dart';
import 'package:lesson_8_app/providers/shop_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ShopProvider Tests', () {
    late ShopProvider provider;
    late Product sampleProduct;

    setUp(() {
      provider = ShopProvider();
      sampleProduct = Product(
        id: 'test_p1',
        name: 'Test Product',
        description: 'Test Description',
        price: 10.0,
        imageUrl: 'https://example.com/image.png',
        category: 'Electronics',
      );
    });

    test('Initial state check', () {
      expect(provider.cartItems.isEmpty, true);
      expect(provider.cartItemCount, 0);
      expect(provider.favoriteProducts.isEmpty, true);
    });

    test('Add to Cart increases quantity and count', () {
      provider.addToCart(sampleProduct);
      expect(provider.cartItems.length, 1);
      expect(provider.cartItemCount, 1);
      expect(provider.cartSubtotal, 10.0);

      // Add same product again
      provider.addToCart(sampleProduct);
      expect(provider.cartItems.length, 1);
      expect(provider.cartItemCount, 2);
      expect(provider.cartSubtotal, 20.0);
    });

    test('Remove from Cart clears item', () {
      provider.addToCart(sampleProduct);
      expect(provider.cartItemCount, 1);

      provider.removeFromCart(sampleProduct.id);
      expect(provider.cartItems.isEmpty, true);
      expect(provider.cartItemCount, 0);
    });

    test('Toggle favorite updates in-memory favoriteProducts', () {
      // Create a test product that is in provider's initial list to test toggle
      // Since fetchProducts is asynchronous, we can directly add to loadedFavorites
      provider.toggleFavorite('p1');
      expect(provider.favoriteProducts.any((p) => p.id == 'p1'), true);

      // Toggle again to remove
      provider.toggleFavorite('p1');
      expect(provider.favoriteProducts.any((p) => p.id == 'p1'), false);
    });
  });
}
