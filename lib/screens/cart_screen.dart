import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onGoShopping;

  const CartScreen({
    super.key,
    this.onGoShopping,
  });

  void _showCheckoutSuccess(BuildContext context, ShopProvider shop) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.accentBlue,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Confirmed!',
                style: TextStyle(
                  color: AppTheme.textMain,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Thank you for shopping with us. Your premium items will be dispatched shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    shop.clearCart();
                    Navigator.pop(ctx);
                    if (onGoShopping != null) {
                      onGoShopping!();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentBlue,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Back to Shop',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ShopProvider>(
          builder: (context, shop, _) {
            final cartItems = shop.cartItems;

            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shopping Cart',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${shop.cartItemCount} items in your cart',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      if (cartItems.isNotEmpty)
                        TextButton(
                          onPressed: () => shop.clearCart(),
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: AppTheme.accentPink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Cart list or empty state
                Expanded(
                  child: cartItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentBlue.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.shopping_cart_outlined,
                                    color: AppTheme.accentBlue,
                                    size: 64,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Your Cart is Empty',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textMain,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Looks like you haven\'t added anything to your cart yet. Go back and select some products.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textMuted,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                if (onGoShopping != null)
                                  ElevatedButton(
                                    onPressed: onGoShopping,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.accentBlue,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      'Start Shopping',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            return CartItemTile(cartItem: cartItems[index]);
                          },
                        ),
                ),

                // Order summary container
                if (cartItems.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Subtotal',
                              style: TextStyle(color: AppTheme.textMuted),
                            ),
                            Text(
                              '\$${shop.cartSubtotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppTheme.textMain,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Shipping Fee',
                              style: TextStyle(color: AppTheme.textMuted),
                            ),
                            Text(
                              shop.shippingFee == 0.0
                                  ? 'FREE'
                                  : '\$${shop.shippingFee.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: shop.shippingFee == 0.0
                                    ? const Color(0xFF10B981)
                                    : AppTheme.textMain,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (shop.shippingFee > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline_rounded, color: AppTheme.accentGold, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'Add \$${(100 - shop.cartSubtotal).toStringAsFixed(2)} more for FREE shipping',
                                  style: const TextStyle(
                                    color: AppTheme.accentGold,
                                    fontSize: 10.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          child: Divider(color: Colors.white10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Price',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textMain,
                              ),
                            ),
                            Text(
                              '\$${shop.cartTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentGold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _showCheckoutSuccess(context, shop),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentBlue,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'CHECKOUT NOW',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
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
