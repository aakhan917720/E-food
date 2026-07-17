class AdminOrderModel {
  final String orderId;
  final String customerName;
  final String customerPhone;
  final String restaurantName;
  final String restaurantPhone;
  final String riderName;
  final String riderPhone;
  final double totalBill;
  final String orderStatus;

  const AdminOrderModel({
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.restaurantName,
    required this.restaurantPhone,
    required this.riderName,
    required this.riderPhone,
    required this.totalBill,
    required this.orderStatus,
  });

  factory AdminOrderModel.fromMap(Map<String, dynamic> map) {
    return AdminOrderModel(
      orderId: map['orderId'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      restaurantName: map['restaurantName'] ?? '',
      restaurantPhone: map['restaurantPhone'] ?? '',
      riderName: map['riderName'] ?? '',
      riderPhone: map['riderPhone'] ?? '',
      totalBill: (map['totalBill'] ?? 0.0).toDouble(),
      orderStatus: map['orderStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'restaurantName': restaurantName,
      'restaurantPhone': restaurantPhone,
      'riderName': riderName,
      'riderPhone': riderPhone,
      'totalBill': totalBill,
      'orderStatus': orderStatus,
    };
  }

  AdminOrderModel copyWith({
    String? orderId,
    String? customerName,
    String? customerPhone,
    String? restaurantName,
    String? restaurantPhone,
    String? riderName,
    String? riderPhone,
    double? totalBill,
    String? orderStatus,
  }) {
    return AdminOrderModel(
      orderId: orderId ?? this.orderId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantPhone: restaurantPhone ?? this.restaurantPhone,
      riderName: riderName ?? this.riderName,
      riderPhone: riderPhone ?? this.riderPhone,
      totalBill: totalBill ?? this.totalBill,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }
}