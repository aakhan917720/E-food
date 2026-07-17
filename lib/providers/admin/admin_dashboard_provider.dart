import 'package:flutter_riverpod/legacy.dart';

import '../../models/admin/admin_order_model.dart';

class RestaurantPartner {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isApproved;

  const RestaurantPartner({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.isApproved = false,
  });

  RestaurantPartner copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    bool? isApproved,
  }) {
    return RestaurantPartner(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isApproved: isApproved ?? this.isApproved,
    );
  }
}

final adminDashboardProvider =
StateNotifierProvider<AdminDashboardNotifier, AdminDashboardState>((ref) {
  return AdminDashboardNotifier();
});

class AdminDashboardState {
  final List<AdminOrderModel> orders;
  final List<RestaurantPartner> restaurants;
  final double totalSales;
  final int activeOrders;
  final int totalPartners;

  const AdminDashboardState({
    this.orders = const [],
    this.restaurants = const [],
    this.totalSales = 0,
    this.activeOrders = 0,
    this.totalPartners = 0,
  });

  AdminDashboardState copyWith({
    List<AdminOrderModel>? orders,
    List<RestaurantPartner>? restaurants,
    double? totalSales,
    int? activeOrders,
    int? totalPartners,
  }) {
    return AdminDashboardState(
      orders: orders ?? this.orders,
      restaurants: restaurants ?? this.restaurants,
      totalSales: totalSales ?? this.totalSales,
      activeOrders: activeOrders ?? this.activeOrders,
      totalPartners: totalPartners ?? this.totalPartners,
    );
  }
}

class AdminDashboardNotifier extends StateNotifier<AdminDashboardState> {
  AdminDashboardNotifier() : super(const AdminDashboardState());

  // FIREBASE GATEWAY BLUEPRINT:
  // Syncs with Firestore collections:
  // - restaurants/{restaurantId}
  // - orders/{orderId}
  // - users/{userId}
  // Real-time listeners for admin dashboard

  void toggleRestaurantApproval(String id) {
    final index = state.restaurants.indexWhere((r) => r.id == id);
    if (index != -1) {
      final updated = state.restaurants[index].copyWith(
        isApproved: !state.restaurants[index].isApproved,
      );
      state = state.copyWith(
        restaurants: [
          ...state.restaurants.sublist(0, index),
          updated,
          ...state.restaurants.sublist(index + 1),
        ],
      );
      // FIREBASE GATEWAY BLUEPRINT:
      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(id)
      //     .update({'isApproved': updated.isApproved});
    }
  }

  void forceCompleteOrder(String orderId) {
    final index = state.orders.indexWhere((order) => order.orderId == orderId);
    if (index != -1) {
      final updatedOrder = state.orders[index].copyWith(orderStatus: 'completed');
      state = state.copyWith(
        orders: [
          ...state.orders.sublist(0, index),
          updatedOrder,
          ...state.orders.sublist(index + 1),
        ],
      );
      // FIREBASE GATEWAY BLUEPRINT:
      // await FirebaseFirestore.instance
      //     .collection('orders')
      //     .doc(orderId)
      //     .update({
      //       'orderStatus': 'completed',
      //       'completedAt': FieldValue.serverTimestamp(),
      //     });

      // Update all relevant providers and send notifications
    }
  }

  // COMMUNICATION STUB ENDPOINTS:
  // url_launcher implementation blueprint

  void initiateCall(String phoneNumber) {
    // url_launcher BLUEPRINT:
    // final url = 'tel:$phoneNumber';
    // if (await canLaunch(url)) {
    //   await launch(url);
    // }
    print('Initiating call to: $phoneNumber');
  }

  void openAdminChat(String entityId) {
    // url_launcher BLUEPRINT:
    // Open chat interface with entityId
    print('Opening admin chat for: $entityId');
  }

  void initializeMockData() {
    state = state.copyWith(
      orders: [
        AdminOrderModel(
          orderId: 'ADMIN-001',
          customerName: 'Alice Brown',
          customerPhone: '+1-555-0101',
          restaurantName: 'Pizza Palace',
          restaurantPhone: '+1-555-0201',
          riderName: 'John Rider',
          riderPhone: '+1-555-0301',
          totalBill: 32.50,
          orderStatus: 'preparing',
        ),
        AdminOrderModel(
          orderId: 'ADMIN-002',
          customerName: 'Bob White',
          customerPhone: '+1-555-0102',
          restaurantName: 'Sushi Express',
          restaurantPhone: '+1-555-0202',
          riderName: 'Sarah Rider',
          riderPhone: '+1-555-0302',
          totalBill: 45.75,
          orderStatus: 'en_route',
        ),
      ],
      restaurants: [
        const RestaurantPartner(
          id: 'r1',
          name: 'Pizza Palace',
          email: 'pizza@example.com',
          phone: '+1-555-0201',
          isApproved: true,
        ),
        const RestaurantPartner(
          id: 'r2',
          name: 'Burger Joint',
          email: 'burger@example.com',
          phone: '+1-555-0203',
          isApproved: false,
        ),
        const RestaurantPartner(
          id: 'r3',
          name: 'Sushi Express',
          email: 'sushi@example.com',
          phone: '+1-555-0202',
          isApproved: true,
        ),
      ],
      totalSales: 15243.50,
      activeOrders: 12,
      totalPartners: 45,
    );
  }
}