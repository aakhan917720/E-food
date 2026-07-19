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
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 12),

            // Map Placeholder
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 200,
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

            const SizedBox(height: 12),

            // Status Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),  // ✅ REDUCED from 20 to 16
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
                mainAxisSize: MainAxisSize.min,  // ✅ ADDED
                children: [
                  const Text(
                    'Order Status',
                    style: TextStyle(
                      fontSize: 16,  // ✅ REDUCED from 18 to 16
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 12),  // ✅ REDUCED from 16 to 12
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
          ],
        ),
      ),
    );
  }

  // ✅ 6 Small Cards with 20px height

  Widget _buildMapPlaceholder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map,
            size: 50,  // ✅ REDUCED from 60 to 50
            color: Colors.grey,
          ),
          SizedBox(height: 6),  // ✅ REDUCED from 8 to 6
          Text(
            'Live Map Display Area',
            style: TextStyle(
              fontSize: 13,  // ✅ REDUCED from 14 to 13
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 3),  // ✅ REDUCED from 4 to 3
          Text(
            'Rider location will appear here',
            style: TextStyle(
              fontSize: 11,  // ✅ REDUCED from 12 to 11
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
      padding: const EdgeInsets.symmetric(vertical: 4),  // ✅ REDUCED from 6 to 4
      child: Row(
        children: [
          Container(
            width: 24,  // ✅ REDUCED from 28 to 24
            height: 24,  // ✅ REDUCED from 28 to 24
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isComplete ? const Color(0xFF2ECC71) : Colors.grey[300],
            ),
            child: Center(
              child: isComplete
                  ? const Icon(Icons.check, size: 14, color: Colors.white)  // ✅ REDUCED from 18 to 14
                  : Text(
                step.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,  // ✅ ADDED
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),  // ✅ REDUCED from 16 to 12
          Text(
            label,
            style: TextStyle(
              fontSize: 14,  // ✅ REDUCED from 16 to 14
              color: isComplete ? const Color(0xFF222222) : Colors.grey,
              fontWeight: isComplete ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}