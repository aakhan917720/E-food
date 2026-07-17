import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Live Order Tracking',
          style: TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
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
              child: _buildMapPlaceholder(),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatusStep(
                    step: 1,
                    label: 'Order Placed',
                    isComplete: true,
                  ),
                  _buildStatusStep(
                    step: 2,
                    label: 'Restaurant Preparing',
                    isComplete: true,
                  ),
                  _buildStatusStep(
                    step: 3,
                    label: 'Rider En Route',
                    isComplete: true,
                  ),
                  _buildStatusStep(
                    step: 4,
                    label: 'Delivered',
                    isComplete: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    // MAPS LAT-LNG STREAMING BLUEPRINT:
    // Google Maps integration with live rider tracking
    // 1. Initialize GoogleMapController with initialCameraPosition
    // 2. Subscribe to Firestore real-time updates for rider location
    //    stream: FirebaseFirestore.instance
    //            .collection('deliveries')
    //            .doc(orderId)
    //            .snapshots()
    // 3. Update marker position based on latitude/longitude updates
    // 4. Add polyline showing route from restaurant to customer
    // 5. Calculate ETA based on current position

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Live Map Display Area',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Rider location will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStep({
    required int step,
    required String label,
    required bool isComplete,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isComplete ? const Color(0xFF2ECC71) : Colors.grey[300],
            ),
            child: Center(
              child: isComplete
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : Text(
                step.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isComplete ? const Color(0xFF222222) : Colors.grey,
              fontWeight: isComplete ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}