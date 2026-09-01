import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final int _activeStep = 1; // 0: Confirmed, 1: Preparing, 2: Ready for Pickup, 3: Completed

  final List<Map<String, String>> _steps = [
    {
      'title': 'Order Confirmed',
      'subtitle': 'Order #2048 received by Downtown Café',
    },
    {
      'title': 'Barista is Preparing',
      'subtitle': 'Crafting your velvety espresso & steamed milk',
    },
    {
      'title': 'Ready for Pickup',
      'subtitle': 'Your coffee is hot and waiting at the counter',
    },
    {
      'title': 'Enjoy your Coffee',
      'subtitle': 'Have a wonderful & energized day!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      appBar: AppBar(
        backgroundColor: AppColors.creamBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Live Order Status',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.deepEspresso,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.deepEspresso),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Status Header Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.promoCardBg,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.warmBeige.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.coffee_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Ready Time',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.coffeeBrown,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '8:42 AM (in ~6 min)',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepEspresso,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Vertical Timeline Steps
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                final isDone = index <= _activeStep;
                final isCurrent = index == _activeStep;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dot and Connecting Line
                    Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isDone ? AppColors.primaryOrange : const Color(0xFFDED7CD),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: isDone
                                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                : Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                          ),
                        ),
                        if (index < _steps.length - 1)
                          Container(
                            width: 2.5,
                            height: 54,
                            color: isDone ? AppColors.primaryOrange : const Color(0xFFDED7CD),
                          ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // Step Text
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _steps[index]['title']!,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                                color: isDone ? AppColors.deepEspresso : const Color(0xFF9E8E81),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _steps[index]['subtitle']!,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.coffeeBrown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // Pickup Café Location Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warmBeige.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.location_on_rounded, color: AppColors.primaryOrange),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Downtown Specialty Café',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepEspresso,
                          ),
                        ),
                        Text(
                          '420 Grand Avenue • 0.8 km away',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.coffeeBrown,
                          ),
                        ),
                      ],
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
}
