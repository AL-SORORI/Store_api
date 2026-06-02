import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';

class CategoriesScreen extends StatelessWidget {
  final VoidCallback onCategorySelect;

  const CategoriesScreen({
    super.key,
    required this.onCategorySelect,
  });

  Widget _buildCategoryCard(
    BuildContext context,
    String name,
    IconData icon,
    List<Color> gradientColors,
    int count,
    ShopProvider shop,
  ) {
    return GestureDetector(
      onTap: () {
        shop.setSelectedCategory(name);
        onCategorySelect();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              bottom: -15,
              child: Opacity(
                opacity: 0.15,
                child: Icon(
                  icon,
                  size: 110,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$count items',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ShopProvider>(
          builder: (context, shop, _) {
            // Calculate item counts for each category
            final allProducts = shop.allProductsRaw;
            int countFor(String cat) => allProducts.where((p) => p.category == cat).length;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categories',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Browse products by category',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95,
                    children: [
                      _buildCategoryCard(
                        context,
                        'Electronics',
                        Icons.electrical_services_rounded,
                        [AppTheme.accentBlue, const Color(0xFF0072FF)],
                        countFor('Electronics'),
                        shop,
                      ),
                      _buildCategoryCard(
                        context,
                        'Fashion',
                        Icons.checkroom_rounded,
                        [AppTheme.accentPink, const Color(0xFFC70039)],
                        countFor('Fashion'),
                        shop,
                      ),
                      _buildCategoryCard(
                        context,
                        'Sports',
                        Icons.sports_basketball_rounded,
                        [const Color(0xFF11998E), const Color(0xFF38EF7D)],
                        countFor('Sports'),
                        shop,
                      ),
                      _buildCategoryCard(
                        context,
                        'Perfumes',
                        Icons.opacity_rounded,
                        [const Color(0xFFF39C12), const Color(0xFFD35400)],
                        countFor('Perfumes'),
                        shop,
                      ),
                      _buildCategoryCard(
                        context,
                        'Books',
                        Icons.menu_book_rounded,
                        [AppTheme.accentPurple, const Color(0xFF6F32A1)],
                        countFor('Books'),
                        shop,
                      ),
                      _buildCategoryCard(
                        context,
                        'Others',
                        Icons.dashboard_rounded,
                        [const Color(0xFF4CA1AF), const Color(0xFF2C3E50)],
                        countFor('Others'),
                        shop,
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
