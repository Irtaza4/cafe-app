import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/coffee_product.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/fade_slide_entrance.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _appState.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProducts = CoffeeProduct.sampleProducts
        .where((p) => _appState.isFavorite(p.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Text(
                'My Favorites ❤️',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.deepEspresso,
                ),
              ),
            ),
            if (favoriteProducts.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.warmBeige.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 38,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Favorites Yet',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepEspresso,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tap the heart on any drink to save it here.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.coffeeBrown,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: favoriteProducts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final p = favoriteProducts[index];
                    return FadeSlideEntrance(
                      delay: Duration(milliseconds: 60 + (index * 50)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(product: p),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Hero(
                                tag: 'coffee_hero_${p.id}',
                                child: Image.asset(
                                  p.image,
                                  width: 65,
                                  height: 65,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.deepEspresso,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    p.category,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.coffeeBrown,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${p.price.toStringAsFixed(2)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.favorite_rounded,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => _appState.toggleFavorite(p.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
