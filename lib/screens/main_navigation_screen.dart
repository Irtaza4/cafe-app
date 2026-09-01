import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/coffee_product.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  late final AppState _appState;
  late AnimationController _cartBounceController;
  late Animation<double> _cartBounceAnim;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _appState.addListener(_onStateChanged);

    _cartBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _cartBounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(
      parent: _cartBounceController,
      curve: Curves.easeInOut,
    ));
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChanged);
    _cartBounceController.dispose();
    super.dispose();
  }

  void _handleCartDrop(CoffeeProduct product) {
    HapticFeedback.heavyImpact();
    _appState.addToCart(product);
    _cartBounceController.forward(from: 0.0);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.deepEspresso,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 90),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(milliseconds: 2200),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Dropped ${product.name} into Cart!',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return const HomeScreen(key: ValueKey('tab_home'));
      case 1:
        return const CartScreen(key: ValueKey('tab_cart'));
      case 2:
        return const FavoritesScreen(key: ValueKey('tab_fav'));
      case 3:
      default:
        return const ProfileScreen(key: ValueKey('tab_profile'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _appState.activeTabIndex;
    final cartCount = _appState.cartCount;

    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.03, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _getScreenForIndex(currentIndex),
      ),
      bottomNavigationBar: Container(
        height: 78,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Tab
            _buildNavItem(
              index: 0,
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: currentIndex == 0,
            ),

            // Cart Tab with DragTarget support
            DragTarget<CoffeeProduct>(
              onWillAcceptWithDetails: (details) {
                HapticFeedback.selectionClick();
                return true;
              },
              onAcceptWithDetails: (details) => _handleCartDrop(details.data),
              builder: (context, candidateData, rejectedData) {
                final isHovered = candidateData.isNotEmpty;

                return AnimatedScale(
                  scale: isHovered ? 1.28 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: ScaleTransition(
                    scale: _cartBounceAnim,
                    child: Container(
                      padding: EdgeInsets.all(isHovered ? 6 : 0),
                      decoration: BoxDecoration(
                        color: isHovered
                            ? AppColors.primaryOrange.withValues(alpha: 0.15)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: _buildNavItem(
                        index: 1,
                        icon: isHovered
                            ? Icons.shopping_bag_rounded
                            : Icons.shopping_bag_outlined,
                        label: isHovered ? 'Drop Here' : 'Cart',
                        isSelected: currentIndex == 1 || isHovered,
                        badgeCount: cartCount,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Favorite Tab
            _buildNavItem(
              index: 2,
              icon: Icons.favorite_border_rounded,
              label: 'Favorite',
              isSelected: currentIndex == 2,
            ),

            // Profile Tab
            _buildNavItem(
              index: 3,
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              isSelected: currentIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    int badgeCount = 0,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        _appState.setTabIndex(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected ? AppColors.primaryOrange : const Color(0xFF9E8E81),
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryOrange,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primaryOrange : const Color(0xFF9E8E81),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
