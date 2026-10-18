
import 'package:flutter/material.dart';

class AiItineraryScreen extends StatefulWidget {
  const AiItineraryScreen({super.key});

  @override
  State<AiItineraryScreen> createState() =>
      _AiItineraryScreenState();
}

class _AiItineraryScreenState
    extends State<AiItineraryScreen> {
  final TextEditingController _destinationController =
  TextEditingController(text: 'Siem Reap');

  final TextEditingController _budgetController =
  TextEditingController(text: '150');

  int _days = 3;

  final List<String> _interests = [
    'Temples',
    'Food',
    'Nature',
    'Beaches',
    'Culture',
    'Shopping',
  ];

  final Set<String> _selectedInterests = {
    'Temples',
    'Food',
  };

  bool _hasGenerated = false;

  @override
  void dispose() {
    _destinationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _generateItinerary() {
    final destination = _destinationController.text.trim();
    final budget = double.tryParse(_budgetController.text);

    if (destination.isEmpty) {
      _showMessage('Please enter a destination.');
      return;
    }

    if (budget == null || budget <= 0) {
      _showMessage('Please enter a valid budget.');
      return;
    }

    if (_selectedInterests.isEmpty) {
      _showMessage('Please select at least one interest.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _hasGenerated = true;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  List<Map<String, dynamic>> _getActivities() {
    final destination = _destinationController.text.trim();
    final interests = _selectedInterests.toList();

    final activities = <Map<String, dynamic>>[];

    if (interests.contains('Temples')) {
      activities.add({
        'time': '8:00 AM',
        'title': 'Visit a famous temple',
        'description':
        'Explore historic temples and enjoy the local scenery in $destination.',
        'icon': Icons.account_balance,
        'cost': 15.0,
      });
    }

    if (interests.contains('Nature')) {
      activities.add({
        'time': '10:30 AM',
        'title': 'Explore nature',
        'description':
        'Enjoy green landscapes and discover beautiful natural spots.',
        'icon': Icons.park,
        'cost': 10.0,
      });
    }

    if (interests.contains('Food')) {
      activities.add({
        'time': '12:30 PM',
        'title': 'Enjoy local food',
        'description':
        'Try local Cambodian dishes at a nearby restaurant.',
        'icon': Icons.restaurant,
        'cost': 8.0,
      });
    }

    if (interests.contains('Culture')) {
      activities.add({
        'time': '2:00 PM',
        'title': 'Discover local culture',
        'description':
        'Learn about local traditions, history, and daily life.',
        'icon': Icons.museum,
        'cost': 5.0,
      });
    }

    if (interests.contains('Beaches')) {
      activities.add({
        'time': '3:00 PM',
        'title': 'Relax by the beach',
        'description':
        'Discover a beach destination and enjoy the coastal views.',
        'icon': Icons.beach_access,
        'cost': 10.0,
      });
    }

    if (interests.contains('Shopping')) {
      activities.add({
        'time': '4:00 PM',
        'title': 'Visit a local market',
        'description':
        'Explore local markets and browse souvenirs and handmade items.',
        'icon': Icons.shopping_bag,
        'cost': 10.0,
      });
    }

    activities.add({
      'time': '6:00 PM',
      'title': 'Dinner and relaxation',
      'description':
      'Enjoy dinner and prepare for the next day of your trip.',
      'icon': Icons.dinner_dining,
      'cost': 12.0,
    });

    return activities;
  }

  @override
  Widget build(BuildContext context) {
    final budget =
        double.tryParse(_budgetController.text) ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'AI Travel Planner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF15343B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildInputForm(),
            const SizedBox(height: 24),
            _buildInterestSelector(),
            const SizedBox(height: 24),
            _buildGenerateButton(),
            if (_hasGenerated) ...[
              const SizedBox(height: 28),
              _buildItinerary(budget),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF006D77),
            Color(0xFF20A39E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 36,
          ),
          const SizedBox(height: 12),
          const Text(
            'Your next adventure starts here!',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Plan your trip by choosing your destination, '
                'budget, duration, and interests.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trip Details',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Destination',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _destinationController,
            decoration: InputDecoration(
              hintText: 'e.g. Phnom Penh',
              prefixIcon: const Icon(Icons.location_on_outlined),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Travel Budget (USD)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _budgetController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your budget',
              prefixIcon: const Icon(Icons.attach_money),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Trip Duration',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _dayButton(
                icon: Icons.remove,
                onTap: () {
                  if (_days > 1) {
                    setState(() => _days--);
                  }
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '$_days ${_days == 1 ? 'Day' : 'Days'}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _dayButton(
                icon: Icons.add,
                onTap: () {
                  if (_days < 14) {
                    setState(() => _days++);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dayButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFD8EFF0),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: const Color(0xFF006D77),
          ),
        ),
      ),
    );
  }

  Widget _buildInterestSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What do you enjoy?',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose your favorite travel activities.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _interests.map((interest) {
              final selected =
              _selectedInterests.contains(interest);

              return FilterChip(
                label: Text(interest),
                selected: selected,
                showCheckmark: true,
                selectedColor: const Color(0xFFCDEBED),
                checkmarkColor: const Color(0xFF006D77),
                onSelected: (value) {
                  setState(() {
                    if (value) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }

                    _hasGenerated = false;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: _generateItinerary,
        icon: const Icon(Icons.auto_awesome),
        label: const Text(
          'Generate Itinerary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006D77),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildItinerary(double budget) {
    final activities = _getActivities();
    final destination = _destinationController.text.trim();

    final estimatedTotal = activities.fold<double>(
      0,
          (total, activity) =>
      total + (activity['cost'] as double),
    ) * _days;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Travel Plan',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$destination • $_days ${_days == 1 ? 'day' : 'days'}',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFD8EFF0),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF006D77),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimated activity budget',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${estimatedTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                estimatedTotal <= budget
                    ? 'Within budget'
                    : 'Over budget',
                style: TextStyle(
                  color: estimatedTotal <= budget
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(_days, (index) {
          final day = index + 1;

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFF006D77),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$day',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Day $day in $destination',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...activities.map((activity) {
                  return _buildActivityCard(activity);
                }),
              ],
            ),
          );
        }),
        const Text(
          'Note: This is a sample itinerary. '
              'Activity costs are estimates, not live prices. '
              'The plan does not yet use AI or live map data.',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E9ED)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFD8EFF0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              activity['icon'] as IconData,
              color: const Color(0xFF006D77),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['time'] as String,
                  style: const TextStyle(
                    color: Color(0xFF00838A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  activity['description'] as String,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Estimated cost: \$${(activity['cost'] as double).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
