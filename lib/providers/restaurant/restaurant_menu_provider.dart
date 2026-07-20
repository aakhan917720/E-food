import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../models/food_item.dart';

final restaurantMenuProvider = StateNotifierProvider<RestaurantMenuNotifier, List<FoodItem>>((ref) {
  return RestaurantMenuNotifier();
});

class RestaurantMenuNotifier extends StateNotifier<List<FoodItem>> {
  RestaurantMenuNotifier() : super(_initializeMockMenu());

  static List<FoodItem> _initializeMockMenu() {
    return [
      const FoodItem(
        id: 'r1',
        name: 'Signature Burger',
        price: 12.99,
        category: 'Burgers',
        imageUrl: '',
        isAvailable: true,
      ),
      const FoodItem(
        id: 'r2',
        name: 'Truffle Pizza',
        price: 16.99,
        category: 'Pizza',
        imageUrl: '',
        isAvailable: true,
      ),
      const FoodItem(
        id: 'r3',
        name: 'Pasta Primavera',
        price: 13.99,
        category: 'Pasta',
        imageUrl: '',
        isAvailable: false,
      ),
    ];
  }
  // ✅ ADD FOOD ITEM
  void addFoodItem(FoodItem item) {
    state = [...state, item];
    // 🔥 FIREBASE BLUEPRINT:
    // await FirebaseFirestore.instance
    //     .collection('restaurants')
    //     .doc(restaurantId)
    //     .collection('menu')
    //     .doc(item.id)
    //     .set(item.toMap());
  }

  // ✅ DELETE FOOD ITEM
  void deleteFoodItem(String id) {
    state = state.where((item) => item.id != id).toList();
    // 🔥 FIREBASE BLUEPRINT:
    // await FirebaseFirestore.instance
    //     .collection('restaurants')
    //     .doc(restaurantId)
    //     .collection('menu')
    //     .doc(id)
    //     .delete();
  }

  // ✅ TOGGLE AVAILABILITY
  void toggleAvailability(String id) {
    final index = state.indexWhere((item) => item.id == id);
    if (index != -1) {
      final updatedItem = state[index].copyWith(
        isAvailable: !state[index].isAvailable,
      );
      state = [
        ...state.sublist(0, index),
        updatedItem,
        ...state.sublist(index + 1),
      ];
      // 🔥 FIREBASE BLUEPRINT:
      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(restaurantId)
      //     .collection('menu')
      //     .doc(id)
      //     .update({'isAvailable': updatedItem.isAvailable});
    }
  }
}