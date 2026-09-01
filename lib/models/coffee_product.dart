import 'package:flutter/material.dart';

class CoffeeProduct {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewsCount;
  final double price;
  final double? originalPrice;
  final String? tag; // e.g., 'TOP SALE', '9% OFF'
  final Color? tagColor;
  final String image;
  final String description;
  final int calories;
  final int caffeine;

  const CoffeeProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    this.reviewsCount = 128,
    required this.price,
    this.originalPrice,
    this.tag,
    this.tagColor,
    required this.image,
    required this.description,
    this.calories = 180,
    this.caffeine = 120,
  });

  static List<CoffeeProduct> get sampleProducts => const [
        CoffeeProduct(
          id: '1',
          name: 'Cappuccino',
          category: 'Hot Coffee',
          rating: 4.9,
          reviewsCount: 340,
          price: 40.0,
          originalPrice: 46.0,
          tag: 'TOP SALE',
          image: 'assets/images/product_cappuccino.png',
          description:
              'Indulge in the smooth elegance of Velvet Cappuccino, where rich espresso meets perfectly steamed milk to create a luxurious harmony of flavor.',
          calories: 150,
          caffeine: 130,
        ),
        CoffeeProduct(
          id: '2',
          name: 'Americano',
          category: 'Hot Coffee',
          rating: 4.8,
          reviewsCount: 210,
          price: 40.0,
          originalPrice: 46.0,
          tag: '9% OFF',
          image: 'assets/images/product_americano.png',
          description:
              'Bold, rich shots of pure espresso extended with hot water, producing a dense layer of golden crema and nuanced roasted notes.',
          calories: 15,
          caffeine: 150,
        ),
        CoffeeProduct(
          id: '3',
          name: 'Velvet Cappuccino',
          category: 'Milk Coffee',
          rating: 4.9,
          reviewsCount: 520,
          price: 20.99,
          originalPrice: 24.99,
          tag: 'TOP SALE',
          image: 'assets/images/product_velvet.png',
          description:
              'Indulge in the smooth elegance of Velvet Cappuccino, where rich espresso meets perfectly steamed milk to create a luxurious harmony of flavor.',
          calories: 180,
          caffeine: 120,
        ),
        CoffeeProduct(
          id: '4',
          name: 'Caramel Latte',
          category: 'Milk Coffee',
          rating: 4.8,
          reviewsCount: 290,
          price: 24.50,
          originalPrice: 28.00,
          tag: 'POPULAR',
          image: 'assets/images/product_latte.png',
          description:
              'Freshly steamed silky milk infused with vanilla and layered in a glass mug with rich golden caramel drizzle over dark espresso.',
          calories: 220,
          caffeine: 110,
        ),
        CoffeeProduct(
          id: '5',
          name: 'Iced Mocha',
          category: 'Cold Coffee',
          rating: 4.9,
          reviewsCount: 180,
          price: 26.00,
          originalPrice: 30.00,
          tag: '15% OFF',
          image: 'assets/images/product_mocha.png',
          description:
              'Chilled dark espresso swirled with bittersweet artisan chocolate ganache and cold milk poured over crystal clear ice.',
          calories: 260,
          caffeine: 140,
        ),
        CoffeeProduct(
          id: '6',
          name: 'Vanilla Cold Brew',
          category: 'Cold Coffee',
          rating: 4.7,
          reviewsCount: 160,
          price: 22.00,
          originalPrice: 25.00,
          image: 'assets/images/product_coldbrew.png',
          description:
              'Slow-steeped 20-hour cold brew infused with delicate French vanilla bean extract and topped with a velvety sweet cream foam over ice.',
          calories: 90,
          caffeine: 175,
        ),
      ];
}
