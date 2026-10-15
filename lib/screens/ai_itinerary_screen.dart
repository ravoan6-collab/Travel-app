
import 'package:flutter/material.dart';

class AiItineraryScreen extends StatefulWidget {
  const AiItineraryScreen({super.key});

  @override
  State<AiItineraryScreen> createState() => _AiItineraryScreenState();
}

class _AiItineraryScreenState extends State<AiItineraryScreen> {
  final TextEditingController destinationController =
  TextEditingController();

  final TextEditingController interestsController =
  TextEditingController();

  int days = 3;
  String? generatedPlan;

  @override
  void dispose() {
    destinationController.dispose();
    interestsController.dispose();
    super.dispose();
  }

  void generatePlan() {
    final destination = destinationController.text.trim();
    final interests = interestsController.text.trim();

    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a destination first.'),
        ),
      );
      return;
    }

    setState(() {
      generatedPlan =
      'Your $days-day trip to $destination\n\n'
          'Day 1: Explore popular attractions in $destination.\n'
          'Day 2: Discover local food and cultural experiences.\n'
          '${days >= 3 ? 'Day 3: Visit nearby attractions and relax.\n' : ''}'
          '\nYour interests: ${interests.isEmpty ? 'General sightseeing' : interests}\n\n'
          'This is a sample itinerary. AI generation will be connected later.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Icon(
          Icons.auto_awesome,
          size: 48,
          color: Color(0xFF087F8C),
        ),
        const SizedBox(height: 12),
        const Text(
          'AI Trip Planner',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Create a travel plan based on your preferences.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: destinationController,
          decoration: const InputDecoration(
            labelText: 'Destination',
            hintText: 'e.g. Siem Reap',
            prefixIcon: Icon(Icons.location_on_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: interestsController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Your interests',
            hintText: 'e.g. Culture, food, nature',
            prefixIcon: Icon(Icons.favorite_outline),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Trip duration: $days day${days == 1 ? '' : 's'}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Slider(
          value: days.toDouble(),
          min: 1,
          max: 7,
          divisions: 6,
          label: '$days days',
          onChanged: (value) {
            setState(() {
              days = value.round();
              generatedPlan = null;
            });
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: FilledButton.icon(
            onPressed: generatePlan,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate my trip'),
          ),
        ),
        if (generatedPlan != null) ...[
          const SizedBox(height: 24),
          const Text(
            'Your itinerary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(generatedPlan!),
            ),
          ),
        ],
      ],
    );
  }
}
