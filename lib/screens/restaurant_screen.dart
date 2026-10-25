
import 'package:flutter/material.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _restaurants = [
    {
      'name': 'Khmer Traditional Restaurant',
      'location': 'Siem Reap, Cambodia',
      'category': 'Khmer Food',
      'price': '\$5 - \$15',
      'rating': 4.8,
      'image': 'assets/images/resturant.jpg',
      'description':
      'Enjoy traditional Cambodian dishes and local flavors.',
      'open': 'Open daily',
    },
    {
      'name': 'Riverside Restaurant',
      'location': 'Phnom Penh, Cambodia',
      'category': 'Fine Dining',
      'price': '\$10 - \$30',
      'rating': 4.7,
      'image': 'assets/images/resturant_1.jpg',
      'description':
      'Relax and enjoy a beautiful riverside dining experience.',
      'open': 'Open daily',
    },
    {
      'name': 'Garden Restaurant',
      'location': 'Siem Reap, Cambodia',
      'category': 'Khmer Food',
      'price': '\$5 - \$20',
      'rating': 4.6,
      'image': 'assets/images/resturant_2.jpg',
      'description':
      'A peaceful garden atmosphere with delicious local food.',
      'open': 'Open daily',
    },
    {
      'name': 'Luxury Dining Restaurant',
      'location': 'Phnom Penh, Cambodia',
      'category': 'Fine Dining',
      'price': '\$15 - \$40',
      'rating': 4.9,
      'image': 'assets/images/resturant_3.jpg',
      'description':
      'A comfortable dining place for family and friends.',
      'open': 'Open daily',
    },
    {
      'name': 'Local Food Restaurant',
      'location': 'Kampot, Cambodia',
      'category': 'Local Food',
      'price': '\$3 - \$12',
      'rating': 4.5,
      'image': 'assets/images/resturant_4.jpg',
      'description':
      'Discover local dishes and Cambodian hospitality.',
      'open': 'Open daily',
    },
  ];

  final List<String> _categories = [
    'All',
    'Khmer Food',
    'Fine Dining',
    'Local Food',
  ];

  List<Map<String, dynamic>> get _filteredRestaurants {
    final query = _searchController.text.trim().toLowerCase();

    return _restaurants.where((restaurant) {
      final name = restaurant['name'].toString().toLowerCase();
      final location = restaurant['location'].toString().toLowerCase();
      final category = restaurant['category'].toString();

      final matchesSearch =
          name.contains(query) || location.contains(query);

      final matchesCategory =
          _selectedCategory == 'All' || category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = _filteredRestaurants;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Restaurants',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF087F8C),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildCategoryFilters(),
            Expanded(
              child: restaurants.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  return _buildRestaurantCard(
                    restaurants[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search restaurants or locations...',
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF087F8C),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();
              setState(() {});
            },
            icon: const Icon(Icons.close),
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final selected = _selectedCategory == category;

          return ChoiceChip(
            label: Text(category),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _selectedCategory = category;
              });
            },
            selectedColor: const Color(0xFF087F8C),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(
              color: selected
                  ? const Color(0xFF087F8C)
                  : Colors.grey.shade300,
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: () => _showRestaurantDetails(restaurant),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  restaurant['image'] as String,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 190,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text('Restaurant image unavailable'),
                        ],
                      ),
                    );
                  },
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
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          (restaurant['rating'] as num).toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF087F8C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      restaurant['category'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant['name'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF202124),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        restaurant['price'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF087F8C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant['location'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    restaurant['description'] as String,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 17,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        restaurant['open'] as String,
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'View details',
                        style: TextStyle(
                          color: Color(0xFF087F8C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 13,
                        color: Color(0xFF087F8C),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 72,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No restaurants found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try another search or category.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedCategory = 'All';
                });
              },
              child: const Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRestaurantDetails(Map<String, dynamic> restaurant) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.8,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Image.asset(
                    restaurant['image'] as String,
                    width: double.infinity,
                    height: 230,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.restaurant,
                          size: 64,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant['name'] as String,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${(restaurant['rating'] as num).toStringAsFixed(1)} rating',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            restaurant['price'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF087F8C),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _detailRow(
                        Icons.location_on_outlined,
                        restaurant['location'] as String,
                      ),
                      const SizedBox(height: 10),
                      _detailRow(
                        Icons.restaurant_menu,
                        restaurant['category'] as String,
                      ),
                      const SizedBox(height: 10),
                      _detailRow(
                        Icons.access_time,
                        restaurant['open'] as String,
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'About this restaurant',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        restaurant['description'] as String,
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF087F8C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF087F8C),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
