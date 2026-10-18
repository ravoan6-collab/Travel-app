import 'package:flutter/material.dart';

class HotelSearchScreen extends StatefulWidget {
  const HotelSearchScreen({super.key});

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> hotels = [
    {
      'name': 'Sokha Phnom Penh Hotel',
      'location': 'Phnom Penh, Cambodia',
      'price': 95.0,
      'rating': 4.8,
      'image': 'assets/images/hotel.jpg',
      'category': 'Luxury',
      'description':
      'Enjoy a comfortable stay with excellent service and modern facilities.',
    },
    {
      'name': 'Island Resort',
      'location': 'Koh Rong, Cambodia',
      'price': 65.0,
      'rating': 4.6,
      'image': 'assets/images/resort.jpg',
      'category': 'Resort',
      'description':
      'Relax near beautiful beaches and enjoy a peaceful island getaway.',
    },
    {
      'name': 'Angkor Paradise Hotel',
      'location': 'Siem Reap, Cambodia',
      'price': 55.0,
      'rating': 4.7,
      'image': 'assets/images/angkor_wat.jpg',
      'category': 'Luxury',
      'description':
      'A comfortable base for exploring Angkor Wat and Siem Reap.',
    },
    {
      'name': 'Koh Rong Beach Stay',
      'location': 'Koh Rong, Cambodia',
      'price': 35.0,
      'rating': 4.4,
      'image': 'assets/images/budget.jpg',
      'category': 'Budget',
      'description':
      'A budget-friendly stay for travelers who love the beach.',
    },
  ];

  List<Map<String, dynamic>> get filteredHotels {
    return hotels.where((hotel) {
      final name = hotel['name'].toString().toLowerCase();
      final location = hotel['location'].toString().toLowerCase();
      final query = searchQuery.toLowerCase();

      final matchesSearch =
          name.contains(query) || location.contains(query);

      final matchesFilter = selectedFilter == 'All' ||
          hotel['category'] == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredHotels;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find Your Hotel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              searchController.clear();
              setState(() {
                searchQuery = '';
                selectedFilter = 'All';
              });
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset search',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Your next stay starts here.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // Search field
          TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search hotel or destination...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                onPressed: () {
                  searchController.clear();
                  setState(() {
                    searchQuery = '';
                  });
                },
                icon: const Icon(Icons.close),
              )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Choose your stay',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Filter buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Luxury', 'Resort', 'Budget'].map((filter) {
                final selected = selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '${results.length} hotels found',
            style: const TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 12),

          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No hotels found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Try another hotel name or destination.'),
                ],
              ),
            ),

          // Hotel cards
          ...results.map((hotel) => _hotelCard(hotel)),
        ],
      ),
    );
  }

  Widget _hotelCard(Map<String, dynamic> hotel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: () => _showHotelDetails(hotel),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  hotel['image'],
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 190,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.hotel,
                        size: 60,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      hotel['category'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Colors.teal,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotel['location'],
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${hotel['rating']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${hotel['price'].toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 21,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' / night',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _showHotelDetails(hotel),
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHotelDetails(Map<String, dynamic> hotel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    hotel['image'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  hotel['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('📍 ${hotel['location']}'),
                const SizedBox(height: 8),
                Text('⭐ ${hotel['rating']} rating'),
                const SizedBox(height: 12),
                Text(
                  hotel['description'],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  '\$${hotel['price'].toStringAsFixed(0)} per night',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Booking will be available after backend integration.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Continue to Booking'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}