import 'package:flutter/material.dart';
import '../models/coffee_product.dart';

class CartItem {
  final String id;
  final CoffeeProduct product;
  final String size; // Small, Medium, Large
  final String sugar; // Normal, Less, No
  final String ice; // Normal, Less, No
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    this.size = 'Medium',
    this.sugar = 'Normal',
    this.ice = 'Normal',
    this.quantity = 1,
  });

  double get unitPrice {
    double base = product.price;
    if (size == 'Small') base -= 2.0;
    if (size == 'Large') base += 3.5;
    return base;
  }

  double get totalPrice => unitPrice * quantity;
}

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal() {
    // Seed initial cart item for immediate exploration
    _cart.add(
      CartItem(
        id: 'init_1',
        product: CoffeeProduct.sampleProducts[2], // Velvet Cappuccino
        size: 'Medium',
        sugar: 'Normal',
        ice: 'Less',
        quantity: 1,
      ),
    );
  }

  final List<CartItem> _cart = [];
  final Set<String> _favoriteProductIds = {'1', '3'};
  int _activeTabIndex = 0;

  // Active Order State for live tracking simulation
  bool _hasActiveOrder = false;
  final String _activeOrderId = '#2048';
  int _orderStep = 1; // 0: Confirmed, 1: Preparing, 2: Ready, 3: Completed

  List<CartItem> get cart => _cart;
  Set<String> get favoriteProductIds => _favoriteProductIds;
  int get activeTabIndex => _activeTabIndex;
  bool get hasActiveOrder => _hasActiveOrder;
  String get activeOrderId => _activeOrderId;
  int get orderStep => _orderStep;

  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _cart.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get discount => subtotal > 0 ? 3.0 : 0.0;
  double get tax => subtotal * 0.08;
  double get total => (subtotal - discount + tax).clamp(0.0, double.infinity);

  void setTabIndex(int index) {
    _activeTabIndex = index;
    notifyListeners();
  }

  void addToCart(
    CoffeeProduct product, {
    String size = 'Medium',
    String sugar = 'Normal',
    String ice = 'Normal',
    int quantity = 1,
  }) {
    final existingIndex = _cart.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.size == size &&
          item.sugar == sugar &&
          item.ice == ice,
    );

    if (existingIndex >= 0) {
      _cart[existingIndex].quantity += quantity;
    } else {
      _cart.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          product: product,
          size: size,
          sugar: sugar,
          ice: ice,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String cartItemId, int newQty) {
    final index = _cart.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      if (newQty <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index].quantity = newQty;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }

  bool isFavorite(String productId) => _favoriteProductIds.contains(productId);

  void placeOrder() {
    _hasActiveOrder = true;
    _orderStep = 1;
    clearCart();
    notifyListeners();
  }
}
