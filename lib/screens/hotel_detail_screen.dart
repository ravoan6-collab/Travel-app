
import 'package:flutter/material.dart';
import 'booking_screen.dart';

class HotelDetailScreen extends StatelessWidget {
  final Map<String, dynamic> hotel;

  const HotelDetailScreen({
    super.key,
    required this.hotel,
  });

  @override
  Widget build(BuildContext context) {
    final String name = hotel['name']?.toString() ?? 'Hotel';
    final String location =
        hotel['location']?.toString() ?? 'Cambodia';
    final String image =
        hotel['image']?.toString() ?? 'assets/images/hotel.jpg';
    final String description = hotel['description']?.toString() ??
        'Enjoy a comfortable stay and explore your destination.';
    final double price = hotel['price'] is num
        ? (hotel['price'] as num).toDouble()
        : double.tryParse(hotel['price']?.toString() ?? '') ?? 0.0;
    final double rating = hotel['rating'] is num
        ? (hotel['rating'] as num).toDouble()
        : double.tryParse(hotel['rating']?.toString() ?? '') ?? 0.0;
    final String category =
        hotel['category']?.toString() ?? 'Hotel';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF087F8C),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.hotel,
                          size: 80,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel name and category
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF087F8C)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Color(0xFF087F8C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF087F8C),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 23,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Sample rating',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'About this hotel',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _AmenityItem(
                        icon: Icons.wifi,
                        label: 'Free Wi-Fi',
                      ),
                      _AmenityItem(
                        icon: Icons.ac_unit,
                        label: 'Air conditioning',
                      ),
                      _AmenityItem(
                        icon: Icons.pool,
                        label: 'Swimming pool',
                      ),
                      _AmenityItem(
                        icon: Icons.restaurant,
                        label: 'Restaurant',
                      ),
                      _AmenityItem(
                        icon: Icons.local_parking,
                        label: 'Parking',
                      ),
                      _AmenityItem(
                        icon: Icons.room_service,
                        label: 'Room service',
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Price summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sample price',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '\$${price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF087F8C),
                                ),
                              ),
                              const Text('per night'),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xFF087F8C),
                          size: 32,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Book Now button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(
                              hotel: hotel,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: const Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF087F8C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      'Demo information only. Verify prices and amenities '
                          'before making a real reservation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenityItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AmenityItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF087F8C),
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
