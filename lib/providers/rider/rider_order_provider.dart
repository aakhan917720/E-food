import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../models/food_item.dart';

class RiderOrder {
  final String orderId;
  final String restaurantName;
  final String customerName;
  final String pickupAddress;
  final String deliveryAddress;
  final double payout;
  final String status; // 'available', 'accepted', 'picked_up', 'delivered'

  const RiderOrder({
    required this.orderId,
    required this.restaurantName,
    required this.customerName,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.payout,
    this.status = 'available',
  });

  RiderOrder copyWith({
    String? orderId,
    String? restaurantName,
    String? customerName,
    String? pickupAddress,
    String? deliveryAddress,
    double? payout,
    String? status,
  }) {
    return RiderOrder(
      orderId: orderId ?? this.orderId,
      restaurantName: restaurantName ?? this.restaurantName,
      customerName: customerName ?? this.customerName,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      payout: payout ?? this.payout,
      status: status ?? this.status,
    );
  }
}

final riderOrderProvider =
StateNotifierProvider<RiderOrderNotifier, List<RiderOrder>>((ref) {
  return RiderOrderNotifier();
});

class RiderOrderNotifier extends StateNotifier<List<RiderOrder>> {
  RiderOrderNotifier() : super(_initializeMockJobs());

  static List<RiderOrder> _initializeMockJobs() {
    return [
      const RiderOrder(
        orderId: 'RID-001',
        restaurantName: 'Pizza Palace',
        customerName: 'Sarah Johnson',
        pickupAddress: '123 Main St, Downtown',
        deliveryAddress: '456 Park Ave, Uptown',
        payout: 8.50,
      ),
      const RiderOrder(
        orderId: 'RID-002',
        restaurantName: 'Burger Joint',
        customerName: 'Mike Williams',
        pickupAddress: '789 Oak St, Midtown',
        deliveryAddress: '321 Pine Rd, Suburbs',
        payout: 6.75,
      ),
      const RiderOrder(
        orderId: 'RID-003',
        restaurantName: 'Sushi Express',
        customerName: 'Emily Chen',
        pickupAddress: '567 Maple Blvd, Eastside',
        deliveryAddress: '890 Cedar Ln, Westside',
        payout: 9.25,
      ),
    ];
  }

  // FIREBASE GATEWAY BLUEPRINT:
  // Jobs sync to Firestore collection: deliveries/{deliveryId}
  // Real-time listener pushes updates to Customer tracking screen
  // when status changes

  void acceptJob(String orderId) {
    final index = state.indexWhere((job) => job.orderId == orderId);
    if (index != -1) {
      final updatedJob = state[index].copyWith(status: 'accepted');
      state = [
        ...state.sublist(0, index),
        updatedJob,
        ...state.sublist(index + 1),
      ];
      // FIREBASE GATEWAY BLUEPRINT:
      // await FirebaseFirestore.instance
      //     .collection('deliveries')
      //     .doc(orderId)
      //     .update({
      //       'status': 'accepted',
      //       'riderId': riderId,
      //       'assignedAt': FieldValue.serverTimestamp(),
      //     });
      // Trigger push notification to customer
    }
  }

  void updateDeliveryStatus(String orderId, String newStatus) {
    final index = state.indexWhere((job) => job.orderId == orderId);
    if (index != -1) {
      final updatedJob = state[index].copyWith(status: newStatus);
      state = [
        ...state.sublist(0, index),
        updatedJob,
        ...state.sublist(index + 1),
      ];
      // FIREBASE GATEWAY BLUEPRINT:
      // await FirebaseFirestore.instance
      //     .collection('deliveries')
      //     .doc(orderId)
      //     .update({'status': newStatus});
      // Real-time listener pushes update to Customer tracking screen
    }
  }

  List<RiderOrder> get availableJobs {
    return state.where((job) => job.status == 'available').toList();
  }

  List<RiderOrder> get acceptedJobs {
    return state.where((job) => job.status != 'available').toList();
  }
}