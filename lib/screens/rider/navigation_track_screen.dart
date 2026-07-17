import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/rider/rider_order_provider.dart';

class NavigationTrackScreen extends ConsumerStatefulWidget {
  final String orderId;
  final String restaurantName;
  final String customerName;
  final String deliveryAddress;

  const NavigationTrackScreen({
    super.key,
    required this.orderId,
    required this.restaurantName,
    required this.customerName,
    required this.deliveryAddress,
  });

  @override
  ConsumerState<NavigationTrackScreen> createState() => _NavigationTrackScreenState();
}

class _NavigationTrackScreenState extends ConsumerState<NavigationTrackScreen> {
  int _currentStep = 0;
  final List<String> _steps = [
    'Arrived at Store',
    'Pick Up Food',
    'Complete Delivery',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Delivery #${widget.orderId}',
          style: const TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _steps.asMap().entries.map((entry) {
                return _buildStepIndicator(entry.key, entry.value);
              }).toList(),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: _buildMapGridLayout(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDeliveryInfo(),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStep < 2) {
                        setState(() {
                          _currentStep++;
                        });
                        // GEOLOCATOR COORDINATE BROADCAST ENGINE BLUEPRINT:
                        // 1. Get current location using Geolocator
                        // final position = await Geolocator.getCurrentPosition();
                        //
                        // 2. Stream to Firestore with real-time updates
                        // FirebaseFirestore.instance
                        //     .collection('deliveries')
                        //     .doc(widget.orderId)
                        //     .update({
                        //       'riderLat': position.latitude,
                        //       'riderLng': position.longitude,
                        //       'status': _getStatusForStep(_currentStep),
                        //       'lastUpdate': FieldValue.serverTimestamp(),
                        //     });
                        //
                        // 3. Push notification to customer tracking screen
                        // Send FCM push notification to customer
                        //
                        // 4. If last step, complete delivery and update earnings
                        // if (_currentStep == 2) {
                        //   await FirebaseFirestore.instance
                        //       .collection('deliveries')
                        //       .doc(widget.orderId)
                        //       .update({'status': 'delivered'});
                        //   // Update rider earnings
                        // }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${_steps[_currentStep]} ✓'),
                            backgroundColor: const Color(0xFF2ECC71),
                          ),
                        );
                      } else {
                        // Complete delivery
                        ref.read(riderOrderProvider.notifier)
                            .updateDeliveryStatus(widget.orderId, 'delivered');
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delivery Complete!'),
                            content: const Text('Order has been successfully delivered.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE21B70),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentStep == 2 ? 'Complete Delivery' : 'Update Status',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int index, String label) {
    final isActive = index <= _currentStep;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF2ECC71) : Colors.grey[300],
          ),
          child: Center(
            child: isActive
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : Text(
              (index + 1).toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xFF222222) : Colors.grey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildMapGridLayout() {
    // MAPS LAT-LNG STREAMING BLUEPRINT:
    // 1. Initialize GoogleMapController with initialCameraPosition
    //    centered at restaurant location
    // 2. Subscribe to Firestore real-time updates for rider location
    //    stream: FirebaseFirestore.instance
    //            .collection('deliveries')
    //            .doc(widget.orderId)
    //            .snapshots()
    // 3. Update marker position based on latitude/longitude updates
    // 4. Add polyline showing route from restaurant to customer
    // 5. Display ETA and distance calculations
    // 6. Use Geolocator for background location tracking
    // 7. Implement Geofencing for auto-status updates

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Live Navigation Map',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222222),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'GPS tracking and route optimization',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Icon(
            Icons.gps_fixed,
            color: Color(0xFFE21B70),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant, size: 20, color: Color(0xFFE21B70)),
              const SizedBox(width: 8),
              Text(
                widget.restaurantName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF222222),
                ),
              ),
              const Spacer(),
              Text(
                _currentStep >= 1 ? '✓' : '⏳',
                style: TextStyle(
                  fontSize: 20,
                  color: _currentStep >= 1 ? const Color(0xFF2ECC71) : Colors.grey,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(Icons.person, size: 20, color: Color(0xFFE21B70)),
              const SizedBox(width: 8),
              Text(
                'Deliver to: ${widget.customerName}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF222222),
                ),
              ),
              const Spacer(),
              Text(
                _currentStep >= 2 ? '✓' : '⏳',
                style: TextStyle(
                  fontSize: 20,
                  color: _currentStep >= 2 ? const Color(0xFF2ECC71) : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}