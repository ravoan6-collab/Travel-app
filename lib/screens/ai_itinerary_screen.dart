import 'package:flutter/material.dart';

class AIItineraryScreen extends StatefulWidget {
  const AIItineraryScreen({super.key});

  @override
  State<AIItineraryScreen> createState() => _AIItineraryScreenState();
}

class _AIItineraryScreenState extends State<AIItineraryScreen> {
  static const Color primaryColor = Color(0xFF087F8C);
  static const Color backgroundColor = Color(0xFFF5F8FA);

  String _destination = 'Siem Reap';
  int _tripDays = 3;
  int _budget = 150;
  int _selectedDay = 1;
  bool _generated = false;

  final List<String> _destinations = [
    'Siem Reap',
    'Phnom Penh',
    'Koh Rong',
    'Kampot',
    'Battambang',
    'Mondulkiri',
  ];

  final Map<String, List<Map<String, dynamic>>> _destinationPlaces = {
    'Siem Reap': [
      {
        'name': 'Angkor Wat',
        'period': 'Morning',
        'time': '7:00 AM',
        'description': 'Explore the famous Angkor Wat temple and its ancient Khmer architecture.',
        'cost': 15,
        'icon': Icons.account_balance,
      },
      {
        'name': 'Angkor Thom',
        'period': 'Morning',
        'time': '10:00 AM',
        'description': 'Discover the ancient city and the impressive Bayon temple.',
        'cost': 10,
        'icon': Icons.temple_buddhist,
      },
      {
        'name': 'Local Khmer Restaurant',
        'period': 'Afternoon',
        'time': '12:30 PM',
        'description': 'Enjoy traditional Cambodian food and local specialties.',
        'cost': 8,
        'icon': Icons.restaurant,
      },
      {
        'name': 'Ta Prohm Temple',
        'period': 'Afternoon',
        'time': '2:00 PM',
        'description': 'Explore the temple surrounded by enormous tree roots.',
        'cost': 10,
        'icon': Icons.forest,
      },
      {
        'name': 'Pub Street',
        'period': 'Evening',
        'time': '6:00 PM',
        'description': 'Walk around the lively night area and browse local shops.',
        'cost': 12,
        'icon': Icons.nightlife,
      },
      {
        'name': 'Angkor National Museum',
        'period': 'Morning',
        'time': '8:30 AM',
        'description': 'Learn about the history and art of the Khmer civilization.',
        'cost': 12,
        'icon': Icons.museum,
      },
      {
        'name': 'Cambodian Cultural Village Area',
        'period': 'Afternoon',
        'time': '1:30 PM',
        'description': 'Explore local culture and discover Cambodian traditions.',
        'cost': 8,
        'icon': Icons.theater_comedy,
      },
      {
        'name': 'Old Market',
        'period': 'Evening',
        'time': '5:30 PM',
        'description': 'Browse souvenirs, local products, and street food.',
        'cost': 5,
        'icon': Icons.storefront,
      },
      {
        'name': 'Banteay Srei',
        'period': 'Morning',
        'time': '8:00 AM',
        'description': 'Discover a temple known for its detailed pink sandstone carvings.',
        'cost': 15,
        'icon': Icons.account_balance,
      },
      {
        'name': 'Cambodian Cooking Experience',
        'period': 'Afternoon',
        'time': '1:00 PM',
        'description': 'Learn about Cambodian ingredients and traditional dishes.',
        'cost': 15,
        'icon': Icons.soup_kitchen,
      },
      {
        'name': 'Siem Reap Riverside',
        'period': 'Evening',
        'time': '5:30 PM',
        'description': 'Enjoy a relaxed walk along the river in the evening.',
        'cost': 0,
        'icon': Icons.waves,
      },
    ],
    'Phnom Penh': [
      {
        'name': 'Royal Palace',
        'period': 'Morning',
        'time': '8:00 AM',
        'description': 'Admire traditional Khmer architecture and palace grounds.',
        'cost': 10,
        'icon': Icons.account_balance,
      },
      {
        'name': 'National Museum',
        'period': 'Morning',
        'time': '10:30 AM',
        'description': 'Discover Cambodian history, sculpture, and cultural artifacts.',
        'cost': 10,
        'icon': Icons.museum,
      },
      {
        'name': 'Riverside Restaurant',
        'period': 'Afternoon',
        'time': '12:30 PM',
        'description': 'Enjoy lunch near the Tonle Sap and Mekong rivers.',
        'cost': 10,
        'icon': Icons.restaurant,
      },
      {
        'name': 'Central Market',
        'period': 'Afternoon',
        'time': '2:30 PM',
        'description': 'Browse local products, souvenirs, and Cambodian snacks.',
        'cost': 10,
        'icon': Icons.storefront,
      },
      {
        'name': 'Mekong Riverside',
        'period': 'Evening',
        'time': '5:30 PM',
        'description': 'Enjoy a relaxing walk along the riverside promenade.',
        'cost': 0,
        'icon': Icons.waves,
      },
      {
        'name': 'Wat Phnom',
        'period': 'Morning',
        'time': '8:00 AM',
        'description': 'Visit the historic hilltop pagoda in the capital.',
        'cost': 2,
        'icon': Icons.temple_buddhist,
      },
      {
        'name': 'Tuol Sleng Genocide Museum',
        'period': 'Morning',
        'time': '10:00 AM',
        'description': 'Learn about an important and difficult chapter of Cambodian history.',
        'cost': 5,
        'icon': Icons.museum,
      },
      {
        'name': 'BKK Local Food Area',
        'period': 'Afternoon',
        'time': '1:00 PM',
        'description': 'Discover local restaurants and Cambodian dishes.',
        'cost': 10,
        'icon': Icons.restaurant,
      },
      {
        'name': 'Independence Monument',
        'period': 'Evening',
        'time': '5:30 PM',
        'description': 'See an important city landmark and enjoy the surrounding area.',
        'cost': 0,
        'icon': Icons.account_balance,
      },
      {
        'name': 'Russian Market',
        'period': 'Morning',
        'time': '9:00 AM',
        'description': 'Explore a popular market with clothing, handicrafts, and food.',
        'cost': 5,
        'icon': Icons.shopping_bag,
      },
      {
        'name': 'Bassac Lane Area',
        'period': 'Evening',
        'time': '6:00 PM',
        'description': 'Explore the lively dining and entertainment area.',
        'cost': 10,
        'icon': Icons.nightlife,
      },
    ],
    'Koh Rong': [
      {
        'name': 'Long Set Beach',
        'period': 'Morning',
        'time': '8:00 AM',
        'description': 'Relax on the white sand and enjoy the tropical scenery.',
        'cost': 0,
        'icon': Icons.beach_access,
      },
      {
        'name': 'Island Snorkeling',
        'period': 'Morning',
        'time': '10:00 AM',
        'description': 'Explore marine life with a snorkeling activity.',
        'cost': 15,
        'icon': Icons.scuba_diving,
      },
      {
        'name': 'Beachside Lunch',
        'period': 'Afternoon',
        'time': '12:30 PM',
        'description': 'Try fresh seafood and local dishes beside the beach.',
        'cost': 12,
        'icon': Icons.restaurant,
      },
      {
        'name': 'Island Exploration',
        'period': 'Afternoon',
        'time': '3:00 PM',
        'description': 'Discover the island scenery and enjoy a peaceful beach walk.',
        'cost': 5,
        'icon': Icons.explore,
      },
      {
        'name': 'Beach Sunset',
        'period': 'Evening',
        'time': '5:30 PM',
        'description': 'Watch the sunset and enjoy the island atmosphere.',
        'cost': 0,
        'icon': Icons.wb_twilight,
      },
      {
        'name': 'Koh Touch Village',
        'period': 'Morning',
        'time': '8:30 AM',
        'description': 'Explore the island village and local shops.',
        'cost': 0,
        'icon': Icons.storefront,
      },
      {
        'name': 'Boat Trip',
        'period': 'Afternoon',
        'time': '1:00 PM',
        'description': 'Consider a local boat excursion if weather and operators permit.',
        'cost': 20,
        'icon': Icons.directions_boat,
      },
      {
        'name': 'Beachside Dinner',
        'period': 'Evening',
        'time': '6:00 PM',
        'description': 'Enjoy dinner and relax near the sea.',
        'cost': 12,
        'icon': Icons.restaurant,
      },
      {
        'name': 'Quiet Beach Walk',
        'period': 'Morning',
        'time': '8:00 AM',
        'description': 'Take a peaceful walk along the shoreline.',
        'cost': 0,
        'icon': Icons.directions_walk,
      },
      {
        'name': 'Island Cafe',
        'period': 'Afternoon',
        'time': '2:00 PM',
        'description': 'Take a break at a local cafe and enjoy the island scenery.',
        'cost': 8,
        'icon': Icons.local_cafe,
      },
      {
        'name': 'Stargazing by the Beach',
        'period': 'Evening',
        'time': '7:00 PM',
        'description': 'Enjoy the night sky when the weather is clear.',
        'cost': 0,
        'icon': Icons.nights_stay,
      },
    ],
    'Kampot': [
      {
        'name': 'Kampot Riverside',
        'period': 'Morning',
        'time': '8:00 AM',
        'description': 'Walk beside the river and enjoy the peaceful town.',
        'cost': 0,
        'icon': Icons.waves,
      },
      {
        'name': 'Kampot Pepper Farm',
        'period': 'Morning',
        'time': '10:00 AM',
        'description': 'Learn about Kampot pepper and local agriculture.',
        'cost': 5,
        'icon': Icons.eco,
      },
      {
        'name': 'Local Cambodian Lunch',
        'period': 'Afternoon',
        'time': '12:30 PM',
        'description': 'Taste Cambodian dishes at a local restaurant.',
        'cost': 8,
        'icon': Icons.restaurant,
      },
      {
        'name': 'Bokor Mountain',
        'period': 'Afternoon',
        'time': '2:30 PM',
        'description': 'Explore mountain scenery and enjoy the cooler atmosphere.',
        'cost': 10,
        'icon': Icons.terrain,
      },
      {
        'name': 'Sunset by the River',
        'period': 'Evening',
        'time': '5:30 PM',
        'description': 'Relax by the river and enjoy the evening view.',
        'cost': 0,
        'icon': Icons.wb_twilight,
      },
      {
        'name': 'Kampot Old Town',
        'period': 'Morning',
        'time': '9:00 AM',
        'description': 'Explore the town streets and historic architecture.',
        'cost': 0,
        'icon': Icons.location_city,
      },
      {
        'name': 'Countryside Cafe',
        'period': 'Afternoon',
        'time': '1:00 PM',
        'description': 'Relax with a drink and enjoy countryside scenery.',
        'cost': 5,
        'icon': Icons.local_cafe,
      },
      {
        'name': 'Local Night Market',
        'period': 'Evening',
        'time': '6:00 PM',
        'description': 'Browse local food stalls and evening shopping areas.',
        'cost': 8,
        'icon': Icons.storefront,
      },
      {
        'name': 'Secret Lake Area',
        'period': 'Morning',
        'time': '8:30 AM',
        'description': 'Enjoy the rural landscape and quiet surroundings.',
        'cost': 0,
        'icon': Icons.landscape,
      },
      {
        'name': 'Local Food Experience',
        'period': 'Afternoon',
        'time': '1:00 PM',
        'description': 'Discover regional food and Cambodian flavors.',
        'cost': 10,
        'icon': Icons.restaurant,
      },
      {
        'name': 'Riverside Evening Walk',
        'period': 'Evening',
        'time': '5:30 PM',
        'description': 'Enjoy a relaxed walk and the town atmosphere.',
        'cost': 0,
        'icon': Icons.directions_walk,
      },
    ],
    'Battambang': [
      {
        'name': 'Battambang City Center',
        'period': 'Morning',
        'time': '8:00 AM',
        'description': 'Explore the charming streets and historic buildings.',
        'cost': 0,
        'icon': Icons.location_city,
      },
      {
        'name': 'Bamboo Train',
        'period': 'Morning',
        'time': '10:00 AM',
        'description': 'Experience a unique ride through the countryside.',
        'cost': 10,
        'icon': Icons.train,
      },
      {
        'name': 'Local Food Market',
        'period': 'Afternoon',
        'time': '12:30 PM',
        'description': 'Try Cambodian dishes and discover local market life.',
        'cost': 7,
        'icon': Icons.restaurant,
      },
      {
        'name': 'Phnom Sampeau',
        'period': 'Afternoon',
        'time': '3:00 PM',
        'description': 'Explore the hill area and surrounding countryside.',
        'cost': 5,
        'icon': Icons.terrain,
      },
      {
        'name': 'Local Night Market',
        'period': 'Evening',
        'time': '6:00 PM',
        'description': 'Browse local snacks and souvenirs.',
        'cost': 8,
        'icon': Icons.storefront,
      },
      {
        'name': 'Battambang Museum',
        'period': 'Morning',
        'time': '9:00 AM',
        'description': 'Learn about local history and archaeological discoveries.',
        'cost': 5,
        'icon': Icons.museum,
      },
      {
        'name': 'Local Art Galleries',
        'period': 'Afternoon',
        'time': '1:30 PM',
        'description': 'Discover local art and creative spaces.',
        'cost': 5,
        'icon': Icons.palette,
      },
      {
        'name': 'Riverside Walk',
        'period': 'Evening',
        'time': '5:30 PM',
        'description': 'Relax beside the river and enjoy the evening atmosphere.',
        'cost': 0,
        'icon': Icons.waves,
      },
      {
        'name': 'Countryside Village',
        'period': 'Morning',
        'time': '8:30 AM',
        'description': 'Discover rural landscapes and traditional local life.',
        'cost': 5,
        'icon': Icons.landscape,
      },
      {
        'name': 'Khmer Cooking Experience',
        'period': 'Afternoon',
        'time': '1:00 PM',
        'description': 'Learn about Cambodian ingredients and traditional recipes.',
        'cost': 12,
        'icon': Icons.soup_kitchen,
      },
      {
        'name': 'Town Evening Walk',
        'period': 'Evening',
        'time': '6:00 PM',
        'description': 'Explore the town at a relaxed pace.',
        'cost': 0,
        'icon': Icons.directions_walk,
      },
    ],
    'Mondulkiri': [
      {
        'name': 'Sen Monorom Town',
        'period': 'Morning',
        'time': '8:00 AM',
        'description': 'Explore the peaceful town and enjoy the cool mountain air.',
        'cost': 0,
        'icon': Icons.location_city,
      },
      {
        'name': 'Bousra Waterfall',
        'period': 'Morning',
        'time': '10:00 AM',
        'description': 'Visit the waterfall surrounded by green forest.',
        'cost': 5,
        'icon': Icons.water,
      },
      {
        'name': 'Local Restaurant',
        'period': 'Afternoon',
        'time': '12:30 PM',
        'description': 'Enjoy a meal featuring local Cambodian ingredients.',
        'cost': 8,
        'icon': Icons.restaurant,
      },
      {
        'name': 'Countryside Viewpoint',
        'period': 'Afternoon',
        'time': '3:00 PM',
        'description': 'Enjoy scenic landscapes and take countryside photos.',
        'cost': 5,
        'icon': Icons.landscape,
      },
      {
        'name': 'Town Evening Walk',
        'period': 'Evening',
        'time': '5:30 PM',
        'description': 'Take a quiet walk and enjoy the cool evening weather.',
        'cost': 0,
        'icon': Icons.directions_walk,
      },
      {
        'name': 'Coffee Plantation',
        'period': 'Morning',
        'time': '9:00 AM',
        'description': 'Discover regional coffee and agricultural landscapes.',
        'cost': 5,
        'icon': Icons.local_cafe,
      },
      {
        'name': 'Forest Nature Walk',
        'period': 'Afternoon',
        'time': '1:30 PM',
        'description': 'Explore nature with a responsible local guide.',
        'cost': 10,
        'icon': Icons.forest,
      },
      {
        'name': 'Local Dinner',
        'period': 'Evening',
        'time': '6:00 PM',
        'description': 'Try local food and relax after a day of exploring.',
        'cost': 8,
        'icon': Icons.restaurant,
      },
      {
        'name': 'Mountain View',
        'period': 'Morning',
        'time': '8:00 AM',
        'description': 'Enjoy the fresh air and mountain scenery.',
        'cost': 0,
        'icon': Icons.terrain,
      },
      {
        'name': 'Local Community Visit',
        'period': 'Afternoon',
        'time': '1:00 PM',
        'description': 'Learn about local culture through a respectful community visit.',
        'cost': 10,
        'icon': Icons.people,
      },
      {
        'name': 'Sunset Viewpoint',
        'period': 'Evening',
        'time': '5:30 PM',
        'description': 'Enjoy the evening landscape when weather conditions allow.',
        'cost': 0,
        'icon': Icons.wb_twilight,
      },
    ],
  };

  List<Map<String, dynamic>> get _allPlaces =>
      _destinationPlaces[_destination] ?? [];

  List<Map<String, dynamic>> get _selectedDayPlaces {
    if (_allPlaces.isEmpty) return [];

    final start = ((_selectedDay - 1) * 3) % _allPlaces.length;

    return List.generate(3, (index) {
      return _allPlaces[(start + index) % _allPlaces.length];
    });
  }

  int get _dailyCost {
    return _selectedDayPlaces.fold<int>(
      0,
          (total, place) => total + (place['cost'] as int),
    );
  }

  int get _totalEstimatedCost => _dailyCost * _tripDays;

  void _generateItinerary() {
    setState(() {
      _generated = true;
      _selectedDay = 1;
    });
  }

  void _resetPlanner() {
    setState(() {
      _destination = 'Siem Reap';
      _tripDays = 3;
      _budget = 150;
      _selectedDay = 1;
      _generated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildHero()),
            SliverToBoxAdapter(child: _buildPlanner()),
            if (_generated) ...[
              SliverToBoxAdapter(child: _buildTripSummary()),
              SliverToBoxAdapter(child: _buildDayTabs()),
              SliverToBoxAdapter(child: _buildDayHeading()),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _buildActivityCard(
                      _selectedDayPlaces[index],
                      index,
                    ),
                  ),
                  childCount: _selectedDayPlaces.length,
                ),
              ),
              SliverToBoxAdapter(child: _buildBudgetCard()),
            ] else
              SliverToBoxAdapter(child: _buildEmptyState()),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 16, 18),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Travel Planner',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B35),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Plan your next adventure',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Reset planner',
            onPressed: _resetPlanner,
            icon: const Icon(Icons.refresh, color: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF087F8C), Color(0xFF13A6A0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              top: 0,
              child: Icon(
                Icons.travel_explore,
                size: 100,
                color: Colors.white.withValues(alpha: 0.14),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 15),
                      SizedBox(width: 6),
                      Text(
                        'SMART TRAVEL PLANNER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Your next adventure\nstarts here.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Choose your destination, set your budget,\nand plan each day of your trip.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.tune, color: primaryColor, size: 22),
                SizedBox(width: 9),
                Text(
                  'Plan your trip',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildLabel('DESTINATION'),
            const SizedBox(height: 9),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5ECEF)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _destination,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: primaryColor,
                  ),
                  items: _destinations.map((destination) {
                    return DropdownMenuItem<String>(
                      value: destination,
                      child: Text(
                        destination,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _destination = value;
                      _generated = false;
                      _selectedDay = 1;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('TRIP DURATION'),
            const SizedBox(height: 9),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5ECEF)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: primaryColor,
                        size: 21,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Length of trip',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$_tripDays ${_tripDays == 1 ? 'day' : 'days'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _tripDays.toDouble(),
                    min: 1,
                    max: 7,
                    divisions: 6,
                    activeColor: primaryColor,
                    inactiveColor: const Color(0xFFDDE9EB),
                    onChanged: (value) {
                      setState(() {
                        _tripDays = value.round();
                        _selectedDay = 1;
                        _generated = false;
                      });
                    },
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1 day',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                      Text(
                        '7 days',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('TOTAL BUDGET'),
            const SizedBox(height: 9),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [50, 100, 150, 300, 500].map((amount) {
                final selected = _budget == amount;

                return ChoiceChip(
                  label: Text('\$$amount'),
                  selected: selected,
                  showCheckmark: false,
                  selectedColor: primaryColor,
                  backgroundColor: backgroundColor,
                  side: BorderSide(
                    color: selected
                        ? primaryColor
                        : const Color(0xFFE5ECEF),
                  ),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF40535C),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  onSelected: (_) {
                    setState(() {
                      _budget = amount;
                      _generated = false;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              'Budget per day: \$${(_budget / _tripDays).toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 23),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _generateItinerary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Generate My Itinerary',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF53666F),
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildTripSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: const Color(0xFFE5ECEF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F4F1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _destination,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172B35),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_tripDays ${_tripDays == 1 ? 'day' : 'days'} • Sample itinerary',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  color: primaryColor,
                  size: 23,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryStat(
                    Icons.calendar_month,
                    '$_tripDays',
                    'Days',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryStat(
                    Icons.place_outlined,
                    '${_tripDays * 3}',
                    'Activities',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryStat(
                    Icons.wallet_outlined,
                    '\$$_budget',
                    'Budget',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryColor, size: 21),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your daily plan',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B35),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Tap a day to view its activities.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 43,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _tripDays,
              separatorBuilder: (context, index) =>
              const SizedBox(width: 9),
              itemBuilder: (context, index) {
                final day = index + 1;
                final selected = _selectedDay == day;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: selected ? primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? primaryColor
                            : const Color(0xFFE0E8EB),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Day $day',
                      style: TextStyle(
                        color: selected ? Colors.white : const Color(0xFF42555D),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeading() {
    final names = [
      'First day',
      'Second day',
      'Third day',
      'Fourth day',
      'Fifth day',
      'Sixth day',
      'Seventh day',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  names[_selectedDay - 1],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B35),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Day $_selectedDay • $_destination',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE2F4F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '\$$_dailyCost est.',
              style: const TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> place, int index) {
    final period = place['period'] as String;
    final cost = place['cost'] as int;
    final icon = place['icon'] as IconData;

    Color periodColor;
    IconData periodIcon;

    switch (period) {
      case 'Morning':
        periodColor = const Color(0xFFE99B36);
        periodIcon = Icons.wb_sunny_outlined;
        break;
      case 'Afternoon':
        periodColor = const Color(0xFF3984C6);
        periodIcon = Icons.wb_cloudy_outlined;
        break;
      default:
        periodColor = const Color(0xFF8862B4);
        periodIcon = Icons.nights_stay_outlined;
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7EEF0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: periodColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: periodColor, size: 23),
              ),
              const SizedBox(height: 7),
              Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(periodIcon, color: periodColor, size: 14),
                    const SizedBox(width: 5),
                    Text(
                      period,
                      style: TextStyle(
                        color: periodColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      place['time'] as String,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  place['name'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B35),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  place['description'] as String,
                  style: const TextStyle(
                    color: Color(0xFF65747B),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      size: 15,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      cost == 0 ? 'Free activity' : 'Est. \$$cost per person',
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildBudgetCard() {
    final remaining = _budget - _totalEstimatedCost;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: const Color(0xFFE7F5F2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFCDEAE3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: primaryColor,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Estimated activity budget',
                    style: TextStyle(
                      color: Color(0xFF174D4C),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _budgetRow('Total selected budget', '\$$_budget'),
            const SizedBox(height: 10),
            _budgetRow('Selected day activities', '\$$_dailyCost'),
            const SizedBox(height: 10),
            _budgetRow(
              'Estimated activities for $_tripDays days',
              '\$$_totalEstimatedCost',
            ),
            const Divider(height: 26, color: Color(0xFFB8DDD5)),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Budget remaining (estimate)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF174D4C),
                    ),
                  ),
                ),
                Text(
                  '\$${remaining < 0 ? 0 : remaining}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: remaining >= 0 ? primaryColor : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Demo estimates only. This planner does not fetch live prices or verify opening hours. Transport, accommodation, meals, entry tickets, and other expenses may cost extra. Confirm details before travelling.',
              style: TextStyle(
                color: Color(0xFF536D68),
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF536D68),
              fontSize: 12,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF174D4C),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 28, 25, 12),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F3F1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.map_outlined,
              color: primaryColor,
              size: 37,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Your adventure awaits!',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B35),
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Choose your destination, trip duration, and budget above. Then tap Generate My Itinerary to explore your day-by-day plan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}