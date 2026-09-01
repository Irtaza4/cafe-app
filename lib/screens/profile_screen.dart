import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/fade_slide_entrance.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeSlideEntrance(
                delay: const Duration(milliseconds: 60),
                child: Text(
                  'My Profile',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.deepEspresso,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // User Info Card
              FadeSlideEntrance(
                delay: const Duration(milliseconds: 120),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/user_avatar.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jhon Anderson',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepEspresso,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'jhon.anderson@email.com',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.coffeeBrown,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warmBeige.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '☕ Gold Member • 480 Points',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Section 1: Ordering & Coffee Routine
              FadeSlideEntrance(
                delay: const Duration(milliseconds: 180),
                child: Text(
                  'Routine & Orders',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coffeeBrown,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeSlideEntrance(
                delay: const Duration(milliseconds: 220),
                child: _buildMenuTile(Icons.history_rounded, 'Order History', 'Past orders & receipts'),
              ),
              FadeSlideEntrance(
                delay: const Duration(milliseconds: 260),
                child: _buildMenuTile(Icons.alarm_rounded, 'Smart Coffee Reminders', 'Weekday 8:30 AM routine'),
              ),
              FadeSlideEntrance(
                delay: const Duration(milliseconds: 300),
                child: _buildMenuTile(Icons.card_giftcard_rounded, 'Loyalty Rewards', 'Free drink available!'),
              ),

              const SizedBox(height: 20),

              // Section 2: Account Settings
              FadeSlideEntrance(
                delay: const Duration(milliseconds: 340),
                child: Text(
                  'Preferences & Settings',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coffeeBrown,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeSlideEntrance(
                delay: const Duration(milliseconds: 380),
                child: _buildMenuTile(Icons.credit_card_rounded, 'Saved Payment Methods', 'Apple Pay, Visa ••4242'),
              ),
              FadeSlideEntrance(
                delay: const Duration(milliseconds: 420),
                child: _buildMenuTile(Icons.location_on_outlined, 'Delivery Addresses', 'Home, Office'),
              ),
              FadeSlideEntrance(
                delay: const Duration(milliseconds: 460),
                child: _buildMenuTile(Icons.notifications_outlined, 'Notification Settings', 'Order alerts, specials'),
              ),
              FadeSlideEntrance(
                delay: const Duration(milliseconds: 500),
                child: _buildMenuTile(Icons.help_outline_rounded, 'Help & Support', 'FAQ & Barista Chat'),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.warmBeige.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryOrange, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.deepEspresso,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.coffeeBrown),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFC4B8AD)),
        onTap: () {},
      ),
    );
  }
}
