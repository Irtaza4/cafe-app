import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/coffee_product.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';

class DetailsScreen extends StatefulWidget {
  final CoffeeProduct product;

  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  late final AppState _appState;
  int _quantity = 1;
  String _selectedSize = 'Medium';
  String _selectedSugar = 'Normal';
  String _selectedIce = 'Normal';
  bool _isDescriptionExpanded = false;

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

  double get _currentPrice {
    double base = widget.product.price;
    if (_selectedSize == 'Small') base -= 2.0;
    if (_selectedSize == 'Large') base += 3.5;
    return base * _quantity;
  }

  void _onAddToCart() {
    HapticFeedback.mediumImpact();
    _appState.addToCart(
      widget.product,
      size: _selectedSize,
      sugar: _selectedSugar,
      ice: _selectedIce,
      quantity: _quantity,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.deepEspresso,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.greenAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Added $_quantity× ${widget.product.name} to Cart',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isFav = _appState.isFavorite(widget.product.id);

    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  _buildCircleBtn(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.pop(context),
                  ),

                  // "Details" Title
                  Text(
                    'Details',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepEspresso,
                    ),
                  ),

                  // Favorite Button
                  _buildCircleBtn(
                    icon: isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    iconColor: isFav ? Colors.redAccent : AppColors.deepEspresso,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _appState.toggleFavorite(widget.product.id);
                    },
                  ),
                ],
              ),
            ),

            // 2. Scrollable Body Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Hero Coffee Cup with Arched Background
                    Center(
                      child: SizedBox(
                        width: size.width * 0.85,
                        height: size.width * 0.72,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Arched curved warm beige background
                            Positioned(
                              top: 20,
                              child: Container(
                                width: size.width * 0.78,
                                height: size.width * 0.62,
                                decoration: BoxDecoration(
                                  color: AppColors.warmBeige.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(size.width * 0.39),
                                ),
                              ),
                            ),

                            // Hero Top-down Coffee Cup
                            Hero(
                              tag: 'coffee_hero_${widget.product.id}',
                              createRectTween: (begin, end) =>
                                  MaterialRectArcTween(begin: begin, end: end),
                              child: Image.asset(
                                widget.product.image,
                                width: size.width * 0.74,
                                height: size.width * 0.74,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.coffee_rounded,
                                  size: 160,
                                  color: AppColors.burntOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Product Name, Rating & Quantity Stepper
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepEspresso,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 18,
                                    color: AppColors.starGold,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.product.rating}/5',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.coffeeBrown,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Quantity Stepper: [ - ] 1 [ + ]
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EBE1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              _buildStepBtn(
                                icon: Icons.remove_rounded,
                                isPrimary: false,
                                onTap: () {
                                  if (_quantity > 1) {
                                    HapticFeedback.selectionClick();
                                    setState(() => _quantity--);
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  '$_quantity',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepEspresso,
                                  ),
                                ),
                              ),
                              _buildStepBtn(
                                icon: Icons.add_rounded,
                                isPrimary: true,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _quantity++);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Size Customization
                    _buildOptionRow(
                      title: 'Size',
                      options: const ['Small', 'Medium', 'Large'],
                      selected: _selectedSize,
                      onSelect: (val) => setState(() => _selectedSize = val),
                    ),

                    const SizedBox(height: 14),

                    // Sugar Customization
                    _buildOptionRow(
                      title: 'Sugar',
                      options: const ['Normal', 'Less', 'No'],
                      selected: _selectedSugar,
                      onSelect: (val) => setState(() => _selectedSugar = val),
                    ),

                    const SizedBox(height: 14),

                    // Ice Customization
                    _buildOptionRow(
                      title: 'Ice',
                      options: const ['Normal', 'Less', 'No'],
                      selected: _selectedIce,
                      onSelect: (val) => setState(() => _selectedIce = val),
                    ),

                    const SizedBox(height: 22),

                    // Description Section
                    Text(
                      'Description',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepEspresso,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
                      child: Text.rich(
                        TextSpan(
                          text: _isDescriptionExpanded
                              ? widget.product.description
                              : (widget.product.description.length > 110
                                  ? '${widget.product.description.substring(0, 110)}...'
                                  : widget.product.description),
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.coffeeBrown,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: _isDescriptionExpanded ? ' Show less' : ' See more.......',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // 3. Sticky Bottom Bar ($20.99  [ Add to Cart ])
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              decoration: BoxDecoration(
                color: AppColors.creamBg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Dynamic Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${_currentPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.deepEspresso,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 24),

                  // Add to Cart Button
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _onAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Add to Cart',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

  Widget _buildCircleBtn({
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? AppColors.deepEspresso,
        ),
      ),
    );
  }

  Widget _buildStepBtn({
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryOrange : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 16,
          color: isPrimary ? Colors.white : AppColors.deepEspresso,
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelect,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 52,
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.deepEspresso,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: options.map((opt) {
              final isSel = opt == selected;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onSelect(opt);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: isSel
                            ? AppColors.warmBeige.withValues(alpha: 0.28)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSel
                              ? AppColors.primaryOrange.withValues(alpha: 0.5)
                              : const Color(0xFFEFE9E0),
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          opt,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel ? AppColors.primaryOrange : AppColors.coffeeBrown,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
