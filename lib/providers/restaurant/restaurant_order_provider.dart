import 'package:flutter_riverpod/legacy.dart';
import '../../models/restaurant/order_model.dart';
import '../../models/food_item.dart';

final restaurantOrderProvider =
StateNotifierProvider<RestaurantOrderNotifier, List<OrderModel>>((ref) {
  return RestaurantOrderNotifier();
});

class RestaurantOrderNotifier extends StateNotifier<List<OrderModel>> {
  RestaurantOrderNotifier() : super(_initializeMockOrders());

  static List<OrderModel> _initializeMockOrders() {
    return [
      OrderModel(
        orderId: 'ORD-001',
        customerName: 'Jane Smith',
        itemsList: [
          const FoodItem(
            id: 'r1',
            name: 'Signature Burger',
            price: 12.99,
            category: 'Burgers',
            imageUrl: 'assets/images/burger.jpg',
          ),
          const FoodItem(
            id: 'r2',
            name: 'Truffle Pizza',
            price: 16.99,
            category: 'Pizza',
            imageUrl: 'assets/images/pizza.jpg',
          ),
        ],
        totalBill: 29.98,
        orderStatus: 'pending',
      ),
      OrderModel(
        orderId: 'ORD-002',
        customerName: 'John Doe',
        itemsList: [
          const FoodItem(
            id: 'r3',
            name: 'Pasta Primavera',
            price: 13.99,
            category: 'Pasta',
            imageUrl: 'assets/images/pasta.jpg',
          ),
        ],
        totalBill: 13.99,
        orderStatus: 'preparing',
      ),
    ];
  }

  // FIREBASE GATEWAY BLUEPRINT:
  // Orders sync to Firestore collection: restaurants/{restaurantId}/orders
  // Listens to real-time updates via snapshotStream

  void acceptOrder(String orderId) {
    final index = state.indexWhere((order) => order.orderId == orderId);
    if (index != -1) {
      final updatedOrder = state[index].copyWith(orderStatus: 'preparing');
      state = [
        ...state.sublist(0, index),
        updatedOrder,
        ...state.sublist(index + 1),
      ];
      // FIREBASE GATEWAY BLUEPRINT:
      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(restaurantId)
      //     .collection('orders')
      //     .doc(orderId)
      //     .update({'orderStatus': 'preparing'});
    }
  }

  void markAsReady(String orderId) {
    final index = state.indexWhere((order) => order.orderId == orderId);
    if (index != -1) {
      final updatedOrder = state[index].copyWith(orderStatus: 'ready');
      state = [
        ...state.sublist(0, index),
        updatedOrder,
        ...state.sublist(index + 1),
      ];
      // FIREBASE GATEWAY BLUEPRINT:
      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(restaurantId)
      //     .collection('orders')
      //     .doc(orderId)
      //     .update({'orderStatus': 'ready'});
    }
  }

  void addOrder(OrderModel order) {
    state = [...state, order];
  }
}