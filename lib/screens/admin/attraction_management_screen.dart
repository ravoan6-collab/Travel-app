
import 'package:flutter/material.dart';

class AttractionManagementScreen extends StatefulWidget {
  const AttractionManagementScreen({super.key});

  @override
  State<AttractionManagementScreen> createState() =>
      _AttractionManagementScreenState();
}

class _AttractionManagementScreenState
    extends State<AttractionManagementScreen> {
  static const Color primaryColor = Color(0xFF087F8C);

  final TextEditingController searchController = TextEditingController();

  String selectedFilter = 'All';

  final List<Map<String, dynamic>> attractions = [
    {
      'name': 'Angkor Wat',
      'location': 'Siem Reap',
      'category': 'Temple',
      'description': 'Famous historical temple in Cambodia.',
      'price': 37.0,
      'active': true,
      'icon': Icons.temple_buddhist,
    },
    {
      'name': 'Royal Palace',
      'location': 'Phnom Penh',
      'category': 'Culture',
      'description': 'Historic royal residence and landmark.',
      'price': 10.0,
      'active': true,
      'icon': Icons.account_balance,
    },
    {
      'name': 'Koh Rong',
      'location': 'Sihanoukville',
      'category': 'Beach',
      'description': 'Beautiful island with clear water and beaches.',
      'price': 5.0,
      'active': true,
      'icon': Icons.beach_access,
    },
    {
      'name': 'Bokor National Park',
      'location': 'Kampot',
      'category': 'Nature',
      'description': 'Mountain landscapes and natural attractions.',
      'price': 0.0,
      'active': false,
      'icon': Icons.landscape,
    },
  ];

  List<Map<String, dynamic>> get filteredAttractions {
    final query = searchController.text.toLowerCase();

    return attractions.where((attraction) {
      final matchesSearch =
          attraction['name'].toString().toLowerCase().contains(query) ||
              attraction['location'].toString().toLowerCase().contains(query);

      final matchesFilter =
          selectedFilter == 'All' ||
              (selectedFilter == 'Active' && attraction['active'] == true) ||
              (selectedFilter == 'Inactive' &&
                  attraction['active'] == false);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  int get activeCount =>
      attractions.where((item) => item['active'] == true).length;

  int get inactiveCount =>
      attractions.where((item) => item['active'] == false).length;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showAttractionDialog({int? editIndex}) {
    final isEditing = editIndex != null;
    final attraction = isEditing ? attractions[editIndex] : null;

    final nameController = TextEditingController(
      text: attraction?['name'] ?? '',
    );
    final locationController = TextEditingController(
      text: attraction?['location'] ?? '',
    );
    final descriptionController = TextEditingController(
      text: attraction?['description'] ?? '',
    );
    final priceController = TextEditingController(
      text: attraction == null ? '' : attraction['price'].toString(),
    );

    String selectedCategory = attraction?['category'] ?? 'Temple';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                isEditing ? 'Edit Attraction' : 'Add Attraction',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Attraction Name',
                        prefixIcon: Icon(Icons.place_outlined),
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
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Temple',
                          child: Text('Temple'),
                        ),
                        DropdownMenuItem(
                          value: 'Culture',
                          child: Text('Culture'),
                        ),
                        DropdownMenuItem(
                          value: 'Beach',
                          child: Text('Beach'),
                        ),
                        DropdownMenuItem(
                          value: 'Nature',
                          child: Text('Nature'),
                        ),
                        DropdownMenuItem(
                          value: 'Adventure',
                          child: Text('Adventure'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
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
                        labelText: 'Entrance Fee (\$)',
                        prefixIcon: Icon(Icons.attach_money),
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
                    final description =
                    descriptionController.text.trim();
                    final price = double.tryParse(priceController.text);

                    if (name.isEmpty ||
                        location.isEmpty ||
                        description.isEmpty ||
                        price == null ||
                        price < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter valid attraction details.',
                          ),
                        ),
                      );
                      return;
                    }

                    final newAttraction = <String, dynamic>{
                      'name': name,
                      'location': location,
                      'category': selectedCategory,
                      'description': description,
                      'price': price,
                      'active': attraction?['active'] ?? true,
                      'icon': _categoryIcon(selectedCategory),
                    };

                    setState(() {
                      if (isEditing) {
                        attractions[editIndex] = newAttraction;
                      } else {
                        attractions.insert(0, newAttraction);
                      }
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing
                              ? 'Attraction updated successfully!'
                              : 'Attraction added successfully!',
                        ),
                      ),
                    );
                  },
                  child: Text(isEditing ? 'Save Changes' : 'Add'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      nameController.dispose();
      locationController.dispose();
      descriptionController.dispose();
      priceController.dispose();
    });
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Temple':
        return Icons.temple_buddhist;
      case 'Culture':
        return Icons.account_balance;
      case 'Beach':
        return Icons.beach_access;
      case 'Nature':
        return Icons.landscape;
      case 'Adventure':
        return Icons.hiking;
      default:
        return Icons.place;
    }
  }

  void toggleStatus(int index) {
    setState(() {
      attractions[index]['active'] = !attractions[index]['active'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          attractions[index]['active']
              ? 'Attraction activated.'
              : 'Attraction deactivated.',
        ),
      ),
    );
  }

  void deleteAttraction(int index) {
    final name = attractions[index]['name'];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Attraction?'),
          content: Text('Are you sure you want to delete $name?'),
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
                  attractions.removeAt(index);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Attraction deleted successfully.'),
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
    final visibleAttractions = filteredAttractions;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Attraction Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAttractionDialog(),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Add Attraction'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total',
                  attractions.length.toString(),
                  Icons.place_outlined,
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
            'All Attractions',
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
              hintText: 'Search attraction or location...',
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
          if (visibleAttractions.isEmpty)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.location_off_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No attractions found',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          else
            ...visibleAttractions.map((attraction) {
              final index = attractions.indexOf(attraction);
              return _buildAttractionCard(attraction, index);
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

  Widget _buildAttractionCard(
      Map<String, dynamic> attraction,
      int index,
      ) {
    final isActive = attraction['active'] == true;
    final icon = attraction['icon'] as IconData;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attraction['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  attraction['location'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${attraction['category']} • \$${attraction['price'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: isActive ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 11,
                        color: isActive ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                showAttractionDialog(editIndex: index);
              } else if (value == 'status') {
                toggleStatus(index);
              } else if (value == 'delete') {
                deleteAttraction(index);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit Attraction'),
              ),
              PopupMenuItem(
                value: 'status',
                child: Text(isActive ? 'Deactivate' : 'Activate'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Attraction'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
