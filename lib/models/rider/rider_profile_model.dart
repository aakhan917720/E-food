class RiderProfileModel {
  final String riderId;
  final String name;
  final String vehicleNumber;
  final double todaysEarnings;

  const RiderProfileModel({
    required this.riderId,
    required this.name,
    required this.vehicleNumber,
    this.todaysEarnings = 0.0,
  });

  factory RiderProfileModel.empty() {
    return const RiderProfileModel(
      riderId: '',
      name: '',
      vehicleNumber: '',
      todaysEarnings: 0.0,
    );
  }

  RiderProfileModel copyWith({
    String? riderId,
    String? name,
    String? vehicleNumber,
    double? todaysEarnings,
  }) {
    return RiderProfileModel(
      riderId: riderId ?? this.riderId,
      name: name ?? this.name,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      todaysEarnings: todaysEarnings ?? this.todaysEarnings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'riderId': riderId,
      'name': name,
      'vehicleNumber': vehicleNumber,
      'todaysEarnings': todaysEarnings,
    };
  }

  factory RiderProfileModel.fromMap(Map<String, dynamic> map) {
    return RiderProfileModel(
      riderId: map['riderId'] ?? '',
      name: map['name'] ?? '',
      vehicleNumber: map['vehicleNumber'] ?? '',
      todaysEarnings: (map['todaysEarnings'] ?? 0.0).toDouble(),
    );
  }
}