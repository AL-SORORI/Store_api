import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getCategoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'electronics':
        return Icons.electrical_services_rounded;
      case 'fashion':
        return Icons.checkroom_rounded;
      case 'sports':
        return Icons.sports_basketball_rounded;
      case 'perfumes':
        return Icons.opacity_rounded; // Or simple drop/flower icon for perfume
      case 'books':
        return Icons.menu_book_rounded;
      case 'others':
        return Icons.dashboard_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }

  Color _getCategoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'electronics':
        return AppTheme.accentBlue;
      case 'fashion':
        return AppTheme.accentPink;
      case 'sports':
        return const Color(0xFF10B981);
      case 'perfumes':
        return Colors.amber;
      case 'books':
        return AppTheme.accentPurple;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _getCategoryColor(category);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? catColor.withOpacity(0.2) : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? catColor : Colors.grey.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: catColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getCategoryIcon(category),
              color: isSelected ? catColor : AppTheme.textMuted,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? AppTheme.textMain : AppTheme.textMuted,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
