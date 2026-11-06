
import 'package:flutter/material.dart';

class HotelManagementScreen extends StatefulWidget {
  const HotelManagementScreen({super.key});

  @override
  State<HotelManagementScreen> createState() =>
      _HotelManagementScreenState();
}

class _HotelManagementScreenState extends State<HotelManagementScreen> {
  static const Color primaryColor = Color(0xFF087F8C);

  final TextEditingController searchController = TextEditingController();

  String selectedFilter = 'All';

  final List<Map<String, dynamic>> hotels = [
    {
      'name': 'Angkor Paradise Hotel',
      'location': 'Siem Reap',
      'price': 85.0,
      'rating': 4.8,
      'active': true,
      'image': 'assets/images/hotel.jpg',
    },
    {
      'name': 'Phnom Penh Palace Hotel',
      'location': 'Phnom Penh',
      'price': 120.0,
      'rating': 4.7,
      'active': true,
      'image': 'assets/images/resort.jpg',
    },
    {
      'name': 'Koh Rong Beach Resort',
      'location': 'Koh Rong',
      'price': 95.0,
      'rating': 4.5,
      'active': false,
      'image': 'assets/images/koh rong.jpg',
    },
    {
      'name': 'Bokor Mountain Resort',
      'location': 'Kampot',
      'price': 75.0,
      'rating': 4.6,
      'active': true,
      'image': 'assets/images/budget.jpg',
    },
  ];

  List<Map<String, dynamic>> get filteredHotels {
    final query = searchController.text.toLowerCase();

    return hotels.where((hotel) {
      final matchesSearch =
          hotel['name'].toString().toLowerCase().contains(query) ||
              hotel['location'].toString().toLowerCase().contains(query);

      final matchesFilter =
          selectedFilter == 'All' ||
              (selectedFilter == 'Active' && hotel['active'] == true) ||
              (selectedFilter == 'Inactive' && hotel['active'] == false);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  int get activeCount =>
      hotels.where((hotel) => hotel['active'] == true).length;

  int get inactiveCount =>
      hotels.where((hotel) => hotel['active'] == false).length;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showHotelDialog({int? editIndex}) {
    final isEditing = editIndex != null;

    final hotel = isEditing ? hotels[editIndex] : null;

    final nameController = TextEditingController(
      text: hotel?['name'] ?? '',
    );

    final locationController = TextEditingController(
      text: hotel?['location'] ?? '',
    );

    final priceController = TextEditingController(
      text: hotel == null ? '' : hotel['price'].toString(),
    );

    final ratingController = TextEditingController(
      text: hotel == null ? '4.5' : hotel['rating'].toString(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Hotel' : 'Add New Hotel'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Hotel Name',
                    prefixIcon: Icon(Icons.hotel),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Price per Night (\$)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: ratingController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Rating (0 - 5)',
                    prefixIcon: Icon(Icons.star_outline),
                    border: OutlineInputBorder(),
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
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final name = nameController.text.trim();
                final location = locationController.text.trim();
                final price = double.tryParse(priceController.text);
                final rating = double.tryParse(ratingController.text);

                if (name.isEmpty ||
                    location.isEmpty ||
                    price == null ||
                    rating == null ||
                    price <= 0 ||
                    rating < 0 ||
                    rating > 5) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter valid hotel details and rating from 0 to 5.',
                      ),
                    ),
                  );
                  return;
                }

                setState(() {
                  if (isEditing) {
                    hotels[editIndex] = {
                      ...hotels[editIndex],
                      'name': name,
                      'location': location,
                      'price': price,
                      'rating': rating,
                    };
                  } else {
                    hotels.insert(0, {
                      'name': name,
                      'location': location,
                      'price': price,
                      'rating': rating,
                      'active': true,
                      'image': 'assets/images/hotel.jpg',
                    });
                  }
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing
                          ? 'Hotel updated successfully!'
                          : 'Hotel added successfully!',
                    ),
                  ),
                );
              },
              child: Text(isEditing ? 'Save Changes' : 'Add Hotel'),
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
      locationController.dispose();
      priceController.dispose();
      ratingController.dispose();
    });
  }

  void toggleHotelStatus(int index) {
    setState(() {
      hotels[index]['active'] = !hotels[index]['active'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          hotels[index]['active']
              ? 'Hotel activated successfully.'
              : 'Hotel deactivated successfully.',
        ),
      ),
    );
  }

  void deleteHotel(int index) {
    final hotelName = hotels[index]['name'];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Hotel?'),
          content: Text(
            'Are you sure you want to delete $hotelName?',
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
                  hotels.removeAt(index);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hotel deleted successfully.'),
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

  @override
  Widget build(BuildContext context) {
    final visibleHotels = filteredHotels;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Hotel Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showHotelDialog(),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_business),
        label: const Text('Add Hotel'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Hotels',
                  hotels.length.toString(),
                  Icons.hotel_outlined,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryCard(
                  'Active',
                  activeCount.toString(),
                  Icons.check_circle_outline,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryCard(
                  'Inactive',
                  inactiveCount.toString(),
                  Icons.block_outlined,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          const Text(
            'All Hotels',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search hotel or location...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                onPressed: () {
                  searchController.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close),
              )
                  : null,
            ),
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            children: ['All', 'Active', 'Inactive'].map((filter) {
              return ChoiceChip(
                label: Text(filter),
                selected: selectedFilter == filter,
                selectedColor: primaryColor.withValues(alpha: 0.15),
                onSelected: (_) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          if (visibleHotels.isEmpty)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.hotel_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No hotels found',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Try another search or filter.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          else
            ...visibleHotels.map((hotel) {
              final originalIndex = hotels.indexOf(hotel);

              return _buildHotelCard(hotel, originalIndex);
            }),

          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(
      Map<String, dynamic> hotel,
      int index,
      ) {
    final isActive = hotel['active'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                hotel['image'],
                height: 145,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 145,
                    width: double.infinity,
                    color: const Color(0xFFE0F2F1),
                    child: const Icon(
                      Icons.hotel,
                      size: 55,
                      color: primaryColor,
                    ),
                  );
                },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Inactive',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hotel['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          showHotelDialog(editIndex: index);
                        } else if (value == 'status') {
                          toggleHotelStatus(index);
                        } else if (value == 'delete') {
                          deleteHotel(index);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit Hotel'),
                        ),
                        PopupMenuItem(
                          value: 'status',
                          child: Text(
                            isActive ? 'Deactivate' : 'Activate',
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Hotel'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                      size: 17,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hotel['location'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 17,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hotel['rating'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '\$${hotel['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      ' / night',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => showHotelDialog(editIndex: index),
                      icon: const Icon(Icons.edit_outlined, size: 17),
                      label: const Text('Edit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
