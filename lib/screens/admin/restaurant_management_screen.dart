
import 'package:flutter/material.dart';

class RestaurantManagementScreen extends StatefulWidget {
  const RestaurantManagementScreen({super.key});

  @override
  State<RestaurantManagementScreen> createState() =>
      _RestaurantManagementScreenState();
}

class _RestaurantManagementScreenState
    extends State<RestaurantManagementScreen> {
  final TextEditingController searchController =
  TextEditingController();

  String selectedFilter = 'All';

  final List<Map<String, dynamic>> restaurants = [
    {
      'name': 'Khmer Kitchen Restaurant',
      'location': 'Siem Reap',
      'category': 'Khmer Food',
      'price': '\$5 - \$15',
      'rating': '4.8',
      'active': true,
    },
    {
      'name': 'Malis Restaurant',
      'location': 'Phnom Penh',
      'category': 'Fine Dining',
      'price': '\$15 - \$40',
      'rating': '4.9',
      'active': true,
    },
    {
      'name': 'Sister Srey Cafe',
      'location': 'Siem Reap',
      'category': 'Cafe',
      'price': '\$3 - \$10',
      'rating': '4.6',
      'active': true,
    },
    {
      'name': 'Ocean Restaurant',
      'location': 'Sihanoukville',
      'category': 'Seafood',
      'price': '\$8 - \$25',
      'rating': '4.5',
      'active': false,
    },
  ];

  List<Map<String, dynamic>> get filteredRestaurants {
    final searchText = searchController.text.toLowerCase();

    return restaurants.where((restaurant) {
      final matchesSearch =
          restaurant['name'].toString().toLowerCase().contains(searchText) ||
              restaurant['location'].toString().toLowerCase().contains(searchText);

      final matchesFilter =
          selectedFilter == 'All' ||
              (selectedFilter == 'Active' && restaurant['active'] == true) ||
              (selectedFilter == 'Inactive' && restaurant['active'] == false);

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
    final activeCount =
        restaurants.where((item) => item['active'] == true).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Restaurant Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF087F8C),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showRestaurantDialog(),
        backgroundColor: const Color(0xFF087F8C),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Restaurant'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(activeCount),
            const SizedBox(height: 20),

            const Text(
              'Restaurant List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildSearchBar(),
            const SizedBox(height: 12),

            _buildFilterButtons(),
            const SizedBox(height: 16),

            if (filteredRestaurants.isEmpty)
              _buildEmptyState()
            else
              ...filteredRestaurants.map(
                    (restaurant) => _buildRestaurantCard(restaurant),
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(int activeCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF087F8C),
            Color(0xFF13A6A6),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.restaurant,
            color: Colors.white,
            size: 35,
          ),
          const SizedBox(height: 12),
          const Text(
            'Total Restaurants',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${restaurants.length}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$activeCount Active Restaurants',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Search restaurant or location...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    final filters = ['All', 'Active', 'Inactive'];

    return Row(
      children: filters.map((filter) {
        final isSelected = selectedFilter == filter;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: SizedBox(
                width: double.infinity,
                child: Text(
                  filter,
                  textAlign: TextAlign.center,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  selectedFilter = filter;
                });
              },
              selectedColor: const Color(0xFF087F8C),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: Colors.white,
              showCheckmark: false,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    final bool isActive = restaurant['active'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.deepOrange,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      restaurant['location'],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    showRestaurantDialog(restaurant: restaurant);
                  } else if (value == 'delete') {
                    deleteRestaurant(restaurant);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Divider(height: 24),

          Row(
            children: [
              _infoItem(
                Icons.restaurant_menu,
                restaurant['category'],
              ),
              const Spacer(),
              _infoItem(
                Icons.star,
                restaurant['rating'],
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              _infoItem(
                Icons.attach_money,
                restaurant['price'],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Switch(
                    value: isActive,
                    activeColor: const Color(0xFF087F8C),
                    onChanged: (value) {
                      setState(() {
                        restaurant['active'] = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(
      IconData icon,
      String value, {
        Color color = Colors.grey,
      }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.restaurant_outlined,
            size: 55,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'No restaurants found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Try another search or filter.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ADD OR EDIT RESTAURANT
  void showRestaurantDialog({
    Map<String, dynamic>? restaurant,
  }) {
    final isEditing = restaurant != null;

    final nameController = TextEditingController(
      text: restaurant?['name'] ?? '',
    );
    final locationController = TextEditingController(
      text: restaurant?['location'] ?? '',
    );
    final priceController = TextEditingController(
      text: restaurant?['price'] ?? '',
    );
    final ratingController = TextEditingController(
      text: restaurant?['rating'] ?? '',
    );

    String category = restaurant?['category'] ?? 'Khmer Food';

    final categories = [
      'Khmer Food',
      'Fine Dining',
      'Cafe',
      'Seafood',
      'Fast Food',
      'International',
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                isEditing ? 'Edit Restaurant' : 'Add Restaurant',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Restaurant Name',
                        prefixIcon: Icon(Icons.restaurant),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                      items: categories.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            category = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price Range',
                        hintText: 'Example: \$5 - \$15',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: ratingController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Rating',
                        hintText: 'Example: 4.8',
                        prefixIcon: Icon(Icons.star),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF087F8C),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty ||
                        locationController.text.trim().isEmpty ||
                        priceController.text.trim().isEmpty ||
                        ratingController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields.'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      if (isEditing) {
                        restaurant['name'] = nameController.text.trim();
                        restaurant['location'] =
                            locationController.text.trim();
                        restaurant['category'] = category;
                        restaurant['price'] = priceController.text.trim();
                        restaurant['rating'] = ratingController.text.trim();
                      } else {
                        restaurants.add({
                          'name': nameController.text.trim(),
                          'location': locationController.text.trim(),
                          'category': category,
                          'price': priceController.text.trim(),
                          'rating': ratingController.text.trim(),
                          'active': true,
                        });
                      }
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing
                              ? 'Restaurant updated successfully.'
                              : 'Restaurant added successfully.',
                        ),
                      ),
                    );
                  },
                  child: Text(isEditing ? 'Update' : 'Add'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      nameController.dispose();
      locationController.dispose();
      priceController.dispose();
      ratingController.dispose();
    });
  }

  // DELETE RESTAURANT
  void deleteRestaurant(Map<String, dynamic> restaurant) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Restaurant?'),
          content: Text(
            'Are you sure you want to delete ${restaurant['name']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  restaurants.remove(restaurant);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Restaurant deleted successfully.'),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
