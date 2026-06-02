import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      CategoriesScreen(onCategorySelect: () {
        setState(() {
          _currentIndex = 0; // Switch to Home tab
        });
      }),
      FavoritesScreen(onGoShopping: () {
        setState(() {
          _currentIndex = 0; // Switch to Home tab
        });
      }),
      CartScreen(onGoShopping: () {
        setState(() {
          _currentIndex = 0; // Switch to Home tab
        });
      }),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.08),
              width: 1,
            ),
          ),
        ),
        child: Consumer<ShopProvider>(
          builder: (context, shop, _) => BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabChange,
            backgroundColor: const Color(0xFF0F0F12),
            selectedItemColor: AppTheme.accentBlue,
            unselectedItemColor: AppTheme.textMuted,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                activeIcon: Icon(Icons.grid_view_rounded, color: AppTheme.accentBlue),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category_rounded, color: AppTheme.accentBlue),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Consumer<ShopProvider>(
                  builder: (ctx, sp, _) => sp.favoriteProducts.isEmpty
                      ? const Icon(Icons.favorite_border_rounded)
                      : Badge(
                          backgroundColor: AppTheme.accentPink,
                          label: Text('${sp.favoriteProducts.length}'),
                          child: const Icon(Icons.favorite_rounded),
                        ),
                ),
                activeIcon: const Icon(Icons.favorite_rounded, color: AppTheme.accentPink),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Consumer<ShopProvider>(
                  builder: (ctx, sp, _) => sp.cartItemCount == 0
                      ? const Icon(Icons.shopping_cart_outlined)
                      : Badge(
                          backgroundColor: AppTheme.accentBlue,
                          label: Text('${sp.cartItemCount}'),
                          child: const Icon(Icons.shopping_cart_rounded),
                        ),
                ),
                activeIcon: const Icon(Icons.shopping_cart_rounded, color: AppTheme.accentBlue),
                label: 'Cart',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
