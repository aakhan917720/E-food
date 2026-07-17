import 'package:flutter_riverpod/legacy.dart';
import '../../models/customer/cart_item.dart';
import '../../models/food_item.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  double get grandTotal {
    return state.fold(0.0, (sum, item) => sum + item.totalItemPrice);
  }

  // FIREBASE GATEWAY BLUEPRINT:
  // Cart syncs to Firestore subcollection:
  // users/{userId}/cart/{itemId}
  // Each cart item update triggers Firestore write

  void addToCart(FoodItem food) {
    final existingIndex = state.indexWhere((item) => item.foodItem.id == food.id);
    if (existingIndex != -1) {
      final updatedItem = state[existingIndex].copyWith(
        quantity: state[existingIndex].quantity + 1,
      );
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, CartItem(foodItem: food)];
    }
    // FIREBASE GATEWAY BLUEPRINT:
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId)
    //     .collection('cart')
    //     .doc(food.id)
    //     .set(cartItem.toMap());
  }

  void decrementQuantity(String foodId) {
    final existingIndex = state.indexWhere((item) => item.foodItem.id == foodId);
    if (existingIndex != -1) {
      final currentItem = state[existingIndex];
      if (currentItem.quantity > 1) {
        final updatedItem = currentItem.copyWith(quantity: currentItem.quantity - 1);
        state = [
          ...state.sublist(0, existingIndex),
          updatedItem,
          ...state.sublist(existingIndex + 1),
        ];
      } else {
        removeFromCart(foodId);
      }
    }
  }

  void removeFromCart(String foodId) {
    state = state.where((item) => item.foodItem.id != foodId).toList();
    // FIREBASE GATEWAY BLUEPRINT:
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId)
    //     .collection('cart')
    //     .doc(foodId)
    //     .delete();
  }

  void clearCart() {
    state = [];
    // FIREBASE GATEWAY BLUEPRINT:
    // Clear all cart items from Firestore
  }
}