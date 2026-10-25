import 'package:flutter/material.dart';
import 'map_screen.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String searchQuery = '';
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> places = [
    {
      'name': 'Angkor Wat',
      'location': 'Siem Reap, Cambodia',
      'category': 'Temple',
      'rating': 4.9,
      'price': 'Free / Ticket required',
      'image': 'assets/images/angkor_wat.jpg',
      'latitude': 13.4125,
      'longitude': 103.8670,
      'description':
          'Explore Cambodia’s famous ancient temple complex and enjoy its beautiful sunrise views.',
    },
    {
      'name': 'Koh Rong',
      'location': 'Sihanoukville, Cambodia',
      'category': 'Beach',
      'rating': 4.8,
      'price': 'Varies by activity',
      'image': 'assets/images/koh rong.jpg',
      'latitude': 10.7083,
      'longitude': 103.2317,
      'description':
          'Enjoy white sand beaches, clear water, island activities and beautiful sunsets.',
    },
    {
      'name': 'Sokha Phnom Penh Hotel',
      'location': 'Phnom Penh, Cambodia',
      'category': 'City',
      'rating': 4.6,
      'price': 'Hotel area',
      'image': 'assets/images/hotel.jpg',
      'latitude': 11.5620,
      'longitude': 104.9160,
      'description':
          'Discover the Phnom Penh riverside area and nearby city attractions.',
    },
    {
      'name': 'Island Resort',
      'location': 'Cambodia',
      'category': 'Resort',
      'rating': 4.7,
      'price': 'Varies by booking',
      'image': 'assets/images/resort.jpg',
      'latitude': 10.7083,
      'longitude': 103.2317,
      'description':
          'Relax in a resort setting and plan a peaceful Cambodian holiday.',
    },
    {
      'name': 'Budget Travel',
      'location': 'Cambodia',
      'category': 'Resort',
      'rating': 4.5,
      'price': 'Budget-friendly travel',
      'image': 'assets/images/budget.jpg',
      'latitude': 12.5657,
      'longitude': 104.9910,
      'description': 'Discover affordable travel options across Cambodia.',
    },
    {
      'name': 'Royal Palace',
      'location': 'Phnom Penh, Cambodia',
      'category': 'Temple',
      'rating': 4.8,
      'price': 'Ticket / entry rules may apply',
      'image': 'assets/images/royal.jpg',
      'latitude': 11.5564,
      'longitude': 104.9282,
      'description':
          'Visit Cambodia’s Royal Palace and admire traditional Khmer architecture.',
    },
    {
      'name': 'Bokor National Park',
      'location': 'Kampot, Cambodia',
      'category': 'Nature',
      'rating': 4.7,
      'price': 'Varies by activity',
      'image': 'assets/images/bokor.jpg',
      'latitude': 10.6250,
      'longitude': 104.0280,
      'description':
          'Explore mountain scenery and cool weather around the Bokor area.',
    },
    {
      'name': 'Bokor Scenic Area',
      'location': 'Kampot, Cambodia',
      'category': 'Nature',
      'rating': 4.6,
      'price': 'Varies by activity',
      'image': 'assets/images/bokor_1.jpg',
      'latitude': 10.6250,
      'longitude': 104.0280,
      'description': 'Enjoy scenic views and nature around Bokor Mountain.',
    },
    {
      'name': 'Kirirom National Park',
      'location': 'Kampong Speu, Cambodia',
      'category': 'Nature',
      'rating': 4.6,
      'price': 'Varies by activity',
      'image': 'assets/images/kirirum.jpg',
      'latitude': 11.3167,
      'longitude': 104.0667,
      'description':
          'Discover pine forest, walking areas and peaceful mountain scenery.',
    },
    {
      'name': 'Kirirom Forest',
      'location': 'Kampong Speu, Cambodia',
      'category': 'Nature',
      'rating': 4.5,
      'price': 'Varies by activity',
      'image': 'assets/images/kirirum_1.jpg',
      'latitude': 11.3167,
      'longitude': 104.0667,
      'description': 'A nature destination for a quiet outdoor escape.',
    },
    {
      'name': 'Cambodia Beach Resort',
      'location': 'Cambodia',
      'category': 'Resort',
      'rating': 4.6,
      'price': 'Varies by booking',
      'image': 'assets/images/resort_2.jpg',
      'latitude': 10.7083,
      'longitude': 103.2317,
      'description': 'Relax by the coast and enjoy a resort-style holiday.',
    },
  ];

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.explore},
    {'name': 'Temple', 'icon': Icons.temple_buddhist},
    {'name': 'Beach', 'icon': Icons.beach_access},
    {'name': 'City', 'icon': Icons.location_city},
    {'name': 'Resort', 'icon': Icons.pool},
    {'name': 'Nature', 'icon': Icons.forest},
  ];

  List<Map<String, dynamic>> get filteredPlaces {
    return places.where((place) {
      final name = place['name'].toString().toLowerCase();
      final location = place['location'].toString().toLowerCase();
      final query = searchQuery.toLowerCase().trim();

      final matchesSearch = name.contains(query) || location.contains(query);

      final matchesCategory =
          selectedCategory == 'All' || place['category'] == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openMap(Map<String, dynamic> place) {
    final destination = <String, dynamic>{
      'name': place['name'],
      'city': place['location'],
      'category': place['category'],
      'description': place['description'],
      'image': place['image'],
      'latitude': (place['latitude'] as num).toDouble(),
      'longitude': (place['longitude'] as num).toDouble(),
      'icon': _categoryIcon(place['category'] as String),
    };

    Navigator.pop(context);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MapScreen(initialDestination: destination),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Temple':
        return Icons.temple_buddhist;
      case 'Beach':
        return Icons.beach_access;
      case 'City':
        return Icons.location_city;
      case 'Resort':
        return Icons.pool;
      case 'Nature':
        return Icons.forest;
      default:
        return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const MapScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.map_outlined),
                        label: const Text('Explore Map'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Explore Places 🌏',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Discover amazing destinations in Cambodia.',
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search places or locations...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon:
                            searchQuery.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      searchQuery = '';
                                    });
                                  },
                                )
                                : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/angkor_wat.jpg',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 45,
                                ),
                              );
                            },
                          ),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.75),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 18,
                            right: 18,
                            bottom: 18,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Discover Cambodia',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Find your next unforgettable adventure.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 12),
                                FilledButton.icon(
                                  onPressed: () {
                                    _showPlaceDetails(places[0]);
                                  },
                                  icon: const Icon(Icons.explore),
                                  label: const Text('Explore Angkor Wat'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            categories.map((category) {
                              final name = category['name'] as String;
                              final selected = selectedCategory == name;

                              return Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: ChoiceChip(
                                  avatar: Icon(
                                    category['icon'] as IconData,
                                    size: 18,
                                    color:
                                        selected
                                            ? Colors.white
                                            : const Color(0xFF087F8C),
                                  ),
                                  label: Text(name),
                                  selected: selected,
                                  onSelected: (_) {
                                    setState(() {
                                      selectedCategory = name;
                                    });
                                  },
                                  selectedColor: const Color(0xFF087F8C),
                                  labelStyle: TextStyle(
                                    color:
                                        selected
                                            ? Colors.white
                                            : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Popular Destinations',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${filteredPlaces.length} places',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            if (filteredPlaces.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.travel_explore,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No destinations found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text('Try another search or category.'),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final place = filteredPlaces[index];
                    return _buildPlaceCard(place);
                  }, childCount: filteredPlaces.length),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => _showPlaceDetails(place),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  place['image'] as String,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 190,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, size: 45),
                    );
                  },
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${place['rating']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place['name'] as String,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Color(0xFF087F8C),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          place['location'] as String,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                      Text(
                        place['category'] as String,
                        style: const TextStyle(
                          color: Color(0xFF087F8C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      Expanded(child: Text(place['price'] as String)),
                      const Icon(Icons.arrow_forward_ios, size: 16),
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

  void _showPlaceDetails(Map<String, dynamic> place) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    place['image'] as String,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 220,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported, size: 40),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  place['name'] as String,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(place['location'] as String),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 5),
                    Text('${place['rating']} rating'),
                    const SizedBox(width: 16),
                    const Icon(Icons.category_outlined),
                    const SizedBox(width: 5),
                    Text(place['category'] as String),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  place['description'] as String,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 14),
                Text(
                  'Information: ${place['price']}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _openMap(place),
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('View on Map'),
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
