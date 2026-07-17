import '../food_item.dart';

class OrderModel {
  final String orderId;
  final String customerName;
  final List<FoodItem> itemsList;
  final double totalBill;
  final String orderStatus; // 'pending', 'preparing', 'ready'

  const OrderModel({
    required this.orderId,
    required this.customerName,
    required this.itemsList,
    required this.totalBill,
    required this.orderStatus,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      customerName: map['customerName'] ?? '',
      itemsList: (map['itemsList'] as List<dynamic>?)
          ?.map((item) => FoodItem.fromMap(item))
          .toList() ?? [],
      totalBill: (map['totalBill'] ?? 0.0).toDouble(),
      orderStatus: map['orderStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerName': customerName,
      'itemsList': itemsList.map((item) => item.toMap()).toList(),
      'totalBill': totalBill,
      'orderStatus': orderStatus,
    };
  }

  OrderModel copyWith({
    String? orderId,
    String? customerName,
    List<FoodItem>? itemsList,
    double? totalBill,
    String? orderStatus,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      customerName: customerName ?? this.customerName,
      itemsList: itemsList ?? this.itemsList,
      totalBill: totalBill ?? this.totalBill,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }
}