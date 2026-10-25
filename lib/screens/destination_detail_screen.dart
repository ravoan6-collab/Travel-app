
import 'package:flutter/material.dart';
import 'hotel_search_screen.dart';

class DestinationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> destination;

  const DestinationDetailScreen({
    super.key,
    required this.destination,
  });

  String get name => destination['name']?.toString() ?? 'Destination';

  String get city =>
      destination['city']?.toString() ?? 'Cambodia';

  String get category =>
      destination['category']?.toString() ?? 'Destination';

  String get description =>
      destination['description']?.toString() ??
          'Explore this destination and plan your next trip.';

  String get imagePath =>
      destination['image']?.toString() ?? '';

  Color get categoryColor {
    switch (category) {
      case 'Hotel':
        return Colors.orange;
      case 'Restaurant':
        return Colors.deepOrange;
      case 'Beach':
        return Colors.blue;
      case 'Temple':
        return Colors.purple;
      case 'Culture':
        return Colors.teal;
      case 'Nature':
        return Colors.green;
      default:
        return const Color(0xFF006D77);
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case 'Hotel':
        return Icons.hotel;
      case 'Restaurant':
        return Icons.restaurant;
      case 'Beach':
        return Icons.beach_access;
      case 'Temple':
        return Icons.account_balance;
      case 'Culture':
        return Icons.castle;
      case 'Nature':
        return Icons.park;
      default:
        return Icons.place;
    }
  }

  void _openHotelSearch(BuildContext context, String city) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => HotelSearchScreen(
          initialDestination: city,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Destination Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF15343B),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Destination image
          SizedBox(
            height: 260,
            width: double.infinity,
            child: imagePath.isNotEmpty
                ? Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _imagePlaceholder();
              },
            )
                : _imagePlaceholder(),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        categoryIcon,
                        size: 18,
                        color: categoryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        category,
                        style: TextStyle(
                          color: categoryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Destination name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF15343B),
                  ),
                ),

                const SizedBox(height: 10),

                // City
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF006D77),
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        city,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'About this destination',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 24),

                // Coordinates
                if (destination['latitude'] != null &&
                    destination['longitude'] != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.map_outlined,
                              color: Color(0xFF006D77),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Location coordinates',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Latitude: ${destination['latitude']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Longitude: ${destination['longitude']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 28),

                // Explore Hotels button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: () =>
                        _openHotelSearch(context, city),
                    icon: const Icon(Icons.hotel),
                    label: const Text(
                      'Explore Hotels',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF006D77),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Back to Map button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.map_outlined),
                    label: const Text(
                      'Back to Map',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF006D77),
                      side: const BorderSide(
                        color: Color(0xFF006D77),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
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

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFE0E7EA),
      child: const Center(
        child: Icon(
          Icons.landscape_outlined,
          size: 80,
          color: Colors.grey,
        ),
      ),
    );
  }
}
