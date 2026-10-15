
import 'package:flutter/material.dart';

class HotelSearchScreen extends StatefulWidget {
  const HotelSearchScreen({super.key});

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> hotels = [
    {
      'name': 'Angkor Paradise Hotel',
      'location': 'Siem Reap',
      'price': 45,
      'rating': 4.5,
    },
    {
      'name': 'Phnom Penh City Hotel',
      'location': 'Phnom Penh',
      'price': 35,
      'rating': 4.2,
    },
    {
      'name': 'Koh Rong Beach Resort',
      'location': 'Koh Rong',
      'price': 60,
      'rating': 4.8,
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.toLowerCase();

    final filteredHotels = hotels.where((hotel) {
      return hotel['name'].toString().toLowerCase().contains(query) ||
          hotel['location'].toString().toLowerCase().contains(query);
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Find your hotel',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Search places to stay in Cambodia.'),
        const SizedBox(height: 20),
        TextField(
          controller: searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Hotel name or city',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '${filteredHotels.length} hotels found',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (filteredHotels.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('No hotels found. Try another search.'),
          ),
        ...filteredHotels.map((hotel) {
          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F3F3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.hotel,
                  color: Color(0xFF087F8C),
                ),
              ),
              title: Text(
                hotel['name'].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${hotel['location']} • ⭐ ${hotel['rating']}',
              ),
              trailing: Text(
                '\$${hotel['price']}/night',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }),
      ],
    );
  }
}
