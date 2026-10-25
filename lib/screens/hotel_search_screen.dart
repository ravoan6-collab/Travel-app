
import 'package:flutter/material.dart';
import 'hotel_detail_screen.dart';

class HotelSearchScreen extends StatefulWidget {
  final String? initialDestination;

  const HotelSearchScreen({
    super.key,
    this.initialDestination,
  });

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  static const Color primaryColor = Color(0xFF087F8C);
  static const Color backgroundColor = Color(0xFFF5F7FA);

  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  String selectedCategory = 'All';
  String sortBy = 'Recommended';

  double maximumPrice = 200;
  double minimumRating = 0;

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
    {
      'name': 'Luxury City Hotel',
      'location': 'Phnom Penh, Cambodia',
      'price': 120.0,
      'rating': 4.8,
      'image': 'assets/images/hotel_luxury.jpg',
      'category': 'Luxury',
      'description': 'A modern city hotel for a comfortable Cambodia visit.',
    },
    {
      'name': 'Skyline Hotel',
      'location': 'Phnom Penh, Cambodia',
      'price': 88.0,
      'rating': 4.5,
      'image': 'assets/images/hotel_lux2.jpg',
      'category': 'Luxury',
      'description': 'Enjoy city views and convenient access to local attractions.',
    },
    {
      'name': 'Garden Pool Hotel',
      'location': 'Siem Reap, Cambodia',
      'price': 72.0,
      'rating': 4.6,
      'image': 'assets/images/hotel_swim.jpg',
      'category': 'Luxury',
      'description': 'A relaxing stay with a pool and tropical surroundings.',
    },
    {
      'name': 'Koh Rong Island Resort',
      'location': 'Koh Rong, Cambodia',
      'price': 150.0,
      'rating': 4.7,
      'image': 'assets/images/resort_1.jpg',
      'category': 'Resort',
      'description': 'An island-style resort for a quiet beach holiday.',
    },
    {
      'name': 'Kampot Riverside Resort',
      'location': 'Kampot, Cambodia',
      'price': 58.0,
      'rating': 4.5,
      'image': 'assets/images/resort_kompot.jpg',
      'category': 'Resort',
      'description': 'A peaceful resort option near Kampot attractions.',
    },
    {
      'name': 'Bokor Mountain Stay',
      'location': 'Bokor, Cambodia',
      'price': 49.0,
      'rating': 4.4,
      'image': 'assets/images/bokor.jpg',
      'category': 'Budget',
      'description': 'A simple base for exploring the Bokor mountain area.',
    },
  ];

  final List<String> categories = [
    'All',
    'Luxury',
    'Resort',
    'Budget',
  ];

  @override
  void initState() {
    super.initState();

    final destination = widget.initialDestination?.trim() ?? '';

    if (destination.isNotEmpty) {
      searchQuery = destination;
      searchController.text = destination;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredHotels {
    final query = searchQuery.trim().toLowerCase();

    final results = hotels.where((hotel) {
      final name = hotel['name'].toString().toLowerCase();
      final location = hotel['location'].toString().toLowerCase();
      final category = hotel['category'].toString();

      final price = (hotel['price'] as num).toDouble();
      final rating = (hotel['rating'] as num).toDouble();

      final matchesSearch =
          query.isEmpty ||
              name.contains(query) ||
              location.contains(query) ||
              category.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == 'All' || category == selectedCategory;

      final matchesPrice = price <= maximumPrice;
      final matchesRating = rating >= minimumRating;

      return matchesSearch &&
          matchesCategory &&
          matchesPrice &&
          matchesRating;
    }).toList();

    switch (sortBy) {
      case 'Price: Low to High':
        results.sort(
              (a, b) => (a['price'] as num).compareTo(b['price'] as num),
        );
        break;

      case 'Price: High to Low':
        results.sort(
              (a, b) => (b['price'] as num).compareTo(a['price'] as num),
        );
        break;

      case 'Highest Rating':
        results.sort(
              (a, b) => (b['rating'] as num).compareTo(a['rating'] as num),
        );
        break;
    }

    return results;
  }

  void _resetFilters() {
    setState(() {
      searchController.clear();
      searchQuery = '';
      selectedCategory = 'All';
      sortBy = 'Recommended';
      maximumPrice = 200;
      minimumRating = 0;
    });
  }

  void _openHotelDetails(Map<String, dynamic> hotel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelDetailScreen(hotel: hotel),
      ),
    );
  }

  void _openFilterSheet() {
    String temporaryCategory = selectedCategory;
    String temporarySort = sortBy;
    double temporaryMaximumPrice = maximumPrice;
    double temporaryMinimumRating = minimumRating;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Filter & Sort',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setSheetState(() {
                                temporaryCategory = 'All';
                                temporarySort = 'Recommended';
                                temporaryMaximumPrice = 200;
                                temporaryMinimumRating = 0;
                              });
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Hotel Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories.map((category) {
                          final selected = temporaryCategory == category;

                          return ChoiceChip(
                            label: Text(category),
                            selected: selected,
                            onSelected: (_) {
                              setSheetState(() {
                                temporaryCategory = category;
                              });
                            },
                            selectedColor: primaryColor.withValues(
                              alpha: 0.15,
                            ),
                            checkmarkColor: primaryColor,
                            labelStyle: TextStyle(
                              color: selected
                                  ? primaryColor
                                  : Colors.black87,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Maximum Price per Night',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Budget'),
                          ),
                          Text(
                            '\$${temporaryMaximumPrice.round()}',
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: temporaryMaximumPrice,
                        min: 20,
                        max: 200,
                        divisions: 18,
                        activeColor: primaryColor,
                        label: '\$${temporaryMaximumPrice.round()}',
                        onChanged: (value) {
                          setSheetState(() {
                            temporaryMaximumPrice = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Minimum Rating',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [0.0, 4.0, 4.5, 4.7].map((rating) {
                          final selected = temporaryMinimumRating == rating;

                          return ChoiceChip(
                            label: Text(
                              rating == 0 ? 'Any' : '$rating+ ⭐',
                            ),
                            selected: selected,
                            onSelected: (_) {
                              setSheetState(() {
                                temporaryMinimumRating = rating;
                              });
                            },
                            selectedColor: primaryColor.withValues(
                              alpha: 0.15,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Sort By',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: temporarySort,
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Recommended',
                            child: Text('Recommended'),
                          ),
                          DropdownMenuItem(
                            value: 'Price: Low to High',
                            child: Text('Price: Low to High'),
                          ),
                          DropdownMenuItem(
                            value: 'Price: High to Low',
                            child: Text('Price: High to Low'),
                          ),
                          DropdownMenuItem(
                            value: 'Highest Rating',
                            child: Text('Highest Rating'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setSheetState(() {
                              temporarySort = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              selectedCategory = temporaryCategory;
                              sortBy = temporarySort;
                              maximumPrice = temporaryMaximumPrice;
                              minimumRating = temporaryMinimumRating;
                            });

                            Navigator.pop(sheetContext);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Show Results',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredHotels;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Find Your Hotel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _resetFilters,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset search and filters',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF087F8C),
                  Color(0xFF12A4A0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.travel_explore,
                  color: Colors.white,
                  size: 38,
                ),
                SizedBox(height: 14),
                Text(
                  'Find Your Perfect Stay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Explore hotels and resorts for your next adventure.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search hotel or destination...',
              prefixIcon: const Icon(
                Icons.search,
                color: primaryColor,
              ),
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
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _openFilterSheet,
                icon: const Icon(Icons.tune),
                label: const Text('Filter & Sort'),
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) =>
              const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final selected = selectedCategory == category;

                return ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  selectedColor: primaryColor.withValues(alpha: 0.15),
                  checkmarkColor: primaryColor,
                  labelStyle: TextStyle(
                    color: selected ? primaryColor : Colors.black87,
                    fontWeight: selected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: selected
                        ? primaryColor
                        : Colors.grey.shade300,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${results.length} ${results.length == 1 ? 'hotel' : 'hotels'} found',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (sortBy != 'Recommended')
                Flexible(
                  child: Text(
                    sortBy,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 12,
                      color: primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (results.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'No Hotels Found',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try another destination or change your filters.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Search'),
                  ),
                ],
              ),
            )
          else
            ...results.map((hotel) => _HotelCard(
              hotel: hotel,
              onTap: () => _openHotelDetails(hotel),
            )),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Demo hotel data • Prices and ratings are examples',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  final Map<String, dynamic> hotel;
  final VoidCallback onTap;

  const _HotelCard({
    required this.hotel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF087F8C);

    final String name = hotel['name']?.toString() ?? 'Hotel';
    final String location =
        hotel['location']?.toString() ?? 'Cambodia';
    final String image =
        hotel['image']?.toString() ?? 'assets/images/hotel.jpg';
    final String category =
        hotel['category']?.toString() ?? 'Hotel';

    final double price = hotel['price'] is num
        ? (hotel['price'] as num).toDouble()
        : double.tryParse(hotel['price']?.toString() ?? '') ?? 0;

    final double rating = hotel['rating'] is num
        ? (hotel['rating'] as num).toDouble()
        : double.tryParse(hotel['rating']?.toString() ?? '') ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 195,
                  width: double.infinity,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.hotel,
                          size: 65,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 17,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Starting from',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '\$${price.toStringAsFixed(0)}'
                                  ' / night',
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: onTap,
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
