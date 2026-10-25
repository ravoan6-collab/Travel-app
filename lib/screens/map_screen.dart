
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'destination_detail_screen.dart';

class MapScreen extends StatefulWidget {
  final Map<String, dynamic>? initialDestination;

  const MapScreen({
    super.key,
    this.initialDestination,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  final MapController _mapController = MapController();
  final TextEditingController _searchController =
  TextEditingController();

  late List<Map<String, dynamic>> _places;

  int _selectedPlace = 0;
  String _searchQuery = '';
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();

    _places = [
      {
        'name': 'Angkor Wat',
        'city': 'Siem Reap, Cambodia',
        'category': 'Temple',
        'description':
        'Explore Cambodia’s famous Angkor Wat temple complex.',
        'image': 'assets/images/angkor_wat.jpg',
        'latitude': 13.4125,
        'longitude': 103.8670,
        'icon': Icons.temple_buddhist,
      },
      {
        'name': 'Royal Palace',
        'city': 'Phnom Penh, Cambodia',
        'category': 'Culture',
        'description':
        'Visit the Royal Palace and admire Khmer architecture.',
        'image': 'assets/images/royal.jpg',
        'latitude': 11.5564,
        'longitude': 104.9282,
        'icon': Icons.account_balance,
      },
      {
        'name': 'Koh Rong',
        'city': 'Sihanoukville, Cambodia',
        'category': 'Beach',
        'description':
        'Enjoy beautiful beaches and island scenery.',
        'image': 'assets/images/koh rong.jpg',
        'latitude': 10.7083,
        'longitude': 103.2317,
        'icon': Icons.beach_access,
      },
      {
        'name': 'Bokor National Park',
        'city': 'Kampot, Cambodia',
        'category': 'Nature',
        'description':
        'Explore mountain scenery around Bokor National Park.',
        'image': 'assets/images/bokor.jpg',
        'latitude': 10.6250,
        'longitude': 104.0280,
        'icon': Icons.park,
      },
      {
        'name': 'Sample City Hotel',
        'city': 'Phnom Penh, Cambodia',
        'category': 'Hotel',
        'description':
        'Sample hotel location for demonstrating the map.',
        'image': 'assets/images/hotel.jpg',
        'latitude': 11.5620,
        'longitude': 104.9160,
        'icon': Icons.hotel,
      },
      {
        'name': 'Sample Riverside Restaurant',
        'city': 'Phnom Penh, Cambodia',
        'category': 'Restaurant',
        'description':
        'Sample restaurant location for demonstrating the map.',
        'image': 'assets/images/budget.jpg',
        'latitude': 11.5680,
        'longitude': 104.9310,
        'icon': Icons.restaurant,
      },
      {
        'name': 'Kirirom National Park',
        'city': 'Kampong Speu, Cambodia',
        'category': 'Nature',
        'description':
        'Discover pine forest and peaceful mountain scenery.',
        'image': 'assets/images/kirirum.jpg',
        'latitude': 11.3150,
        'longitude': 104.0600,
        'icon': Icons.forest,
      },
      {
        'name': 'Battambang City',
        'city': 'Battambang, Cambodia',
        'category': 'City',
        'description':
        'Explore Battambang and its surrounding attractions.',
        'image': 'assets/images/angkor_wat.jpg',
        'latitude': 13.0957,
        'longitude': 103.2022,
        'icon': Icons.location_city,
      },
      {
        'name': 'Mondulkiri',
        'city': 'Sen Monorom, Cambodia',
        'category': 'Nature',
        'description':
        'Discover the highlands and natural scenery of Mondulkiri.',
        'image': 'assets/images/resort.jpg',
        'latitude': 12.4558,
        'longitude': 107.1881,
        'icon': Icons.forest,
      },
    ];

    final destination = widget.initialDestination;

    if (destination != null) {
      final destinationName =
      destination['name']?.toString().toLowerCase();

      final index = _places.indexWhere(
            (place) =>
        place['name'].toString().toLowerCase() ==
            destinationName,
      );

      if (index != -1) {
        _selectedPlace = index;
      } else {
        final latitude = destination['latitude'];
        final longitude = destination['longitude'];

        if (latitude is num && longitude is num) {
          _places.insert(0, {
            'name': destination['name'] ?? 'Selected Destination',
            'city': destination['city'] ??
                destination['location'] ??
                'Cambodia',
            'category': destination['category'] ?? 'Place',
            'description': destination['description'] ??
                'Explore this destination in Cambodia.',
            'image': destination['image'] ??
                'assets/images/angkor_wat.jpg',
            'latitude': latitude.toDouble(),
            'longitude': longitude.toDouble(),
            'icon': _categoryIcon(
              destination['category']?.toString() ?? 'Place',
            ),
          });

          _selectedPlace = 0;
        }
      }
    }
  }

  List<Map<String, dynamic>> get _filteredPlaces {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return _places;
    }

    return _places.where((place) {
      return place['name'].toString().toLowerCase().contains(query) ||
          place['city'].toString().toLowerCase().contains(query) ||
          place['category'].toString().toLowerCase().contains(query);
    }).toList();
  }

  Color _markerColor(Map<String, dynamic> place) {
    switch (place['category'] as String) {
      case 'Hotel':
        return Colors.orange;
      case 'Restaurant':
        return Colors.deepOrange;
      case 'Beach':
        return Colors.blue;
      case 'Temple':
        return Colors.purple;
      case 'Culture':
        return Colors.teal;
      case 'Nature':
        return Colors.green;
      case 'City':
        return Colors.indigo;
      default:
        return const Color(0xFF087F8C);
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Temple':
        return Icons.temple_buddhist;
      case 'Beach':
        return Icons.beach_access;
      case 'Hotel':
        return Icons.hotel;
      case 'Restaurant':
        return Icons.restaurant;
      case 'Nature':
        return Icons.forest;
      case 'Culture':
        return Icons.account_balance;
      case 'City':
        return Icons.location_city;
      default:
        return Icons.place;
    }
  }

  LatLng _placePosition(Map<String, dynamic> place) {
    return LatLng(
      (place['latitude'] as num).toDouble(),
      (place['longitude'] as num).toDouble(),
    );
  }

  void _moveToPlace(Map<String, dynamic> place) {
    final index = _places.indexOf(place);

    if (index == -1) return;

    setState(() {
      _selectedPlace = index;
      _searchQuery = '';
      _searchController.clear();
    });

    if (_mapReady) {
      _mapController.move(_placePosition(place), 14);
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_isLoadingLocation) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showMessage('Please enable location services.');
        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showMessage('Location permission was denied.');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showMessage(
          'Please allow location access in your device settings.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      if (!mounted) return;

      setState(() {
        _currentPosition = position;
      });

      if (_mapReady) {
        _mapController.move(
          LatLng(position.latitude, position.longitude),
          15,
        );
      }

      _showMessage('Your current location was found.');
    } catch (_) {
      _showMessage(
        'Could not get your location. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showPlacesList() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(sheetContext).size.height * 0.65,
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Choose a destination',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ..._filteredPlaces.map((place) {
                  final color = _markerColor(place);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withValues(alpha: 0.12),
                      child: Icon(
                        place['icon'] as IconData,
                        color: color,
                      ),
                    ),
                    title: Text(place['name'] as String),
                    subtitle: Text(
                      '${place['category']} • ${place['city']}',
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _moveToPlace(place);
                    },
                  );
                }),
                if (_filteredPlaces.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No destinations found.'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openDestinationDetails(Map<String, dynamic> place) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => DestinationDetailScreen(
          destination: place,
        ),
      ),
    );
  }

  void _showPlaceDetails(Map<String, dynamic> place) {
    final color = _markerColor(place);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor:
                      color.withValues(alpha: 0.12),
                      child: Icon(
                        place['icon'] as IconData,
                        color: color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        place['name'] as String,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  value: place['city'] as String,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.category_outlined,
                  title: 'Category',
                  value: place['category'] as String,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.map_outlined,
                  title: 'Coordinates',
                  value:
                  '${place['latitude']}, ${place['longitude']}',
                ),
                const SizedBox(height: 16),
                Text(
                  place['description'] as String,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _moveToPlace(place);
                    },
                    icon: const Icon(Icons.my_location),
                    label: const Text('Show on Map'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = _places[_selectedPlace];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Explore Map',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF15343B),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Choose destination',
            onPressed: _showPlacesList,
            icon: const Icon(Icons.list_alt),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search hotels, restaurants, places...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.close),
                )
                    : IconButton(
                  onPressed: _showPlacesList,
                  icon: const Icon(Icons.tune),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _placePosition(
                      _places[_selectedPlace],
                    ),
                    initialZoom:
                    widget.initialDestination != null ? 14 : 6.5,
                    onMapReady: () {
                      _mapReady = true;

                      if (widget.initialDestination != null) {
                        _mapController.move(
                          _placePosition(_places[_selectedPlace]),
                          14,
                        );
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.ai_travel',
                    ),
                    MarkerLayer(
                      markers: [
                        ...List.generate(_places.length, (index) {
                          final place = _places[index];
                          final isSelected = index == _selectedPlace;
                          final markerColor = _markerColor(place);

                          return Marker(
                            point: _placePosition(place),
                            width: 64,
                            height: 72,
                            child: GestureDetector(
                              onTap: () => _showPlaceDetails(place),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(9),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF087F8C)
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.white
                                            : markerColor,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.2),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      place['icon'] as IconData,
                                      color: isSelected
                                          ? Colors.white
                                          : markerColor,
                                      size: 22,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: isSelected
                                        ? const Color(0xFF087F8C)
                                        : markerColor,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        if (_currentPosition != null)
                          Marker(
                            point: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            width: 56,
                            height: 56,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.blue,
                                size: 32,
                              ),
                            ),
                          ),
                      ],
                    ),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: FloatingActionButton.small(
                    heroTag: 'map_zoom_in',
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF087F8C),
                    onPressed: () {
                      if (!_mapReady) return;

                      _mapController.move(
                        _mapController.camera.center,
                        _mapController.camera.zoom + 1,
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 60,
                  child: FloatingActionButton.small(
                    heroTag: 'map_zoom_out',
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF087F8C),
                    onPressed: () {
                      if (!_mapReady) return;

                      _mapController.move(
                        _mapController.camera.center,
                        _mapController.camera.zoom - 1,
                      );
                    },
                    child: const Icon(Icons.remove),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 108,
                  child: FloatingActionButton.small(
                    heroTag: 'map_my_location',
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF087F8C),
                    onPressed: _isLoadingLocation
                        ? null
                        : _getCurrentLocation,
                    child: _isLoadingLocation
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore Destinations',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
                        _LegendItem(
                          color: Colors.orange,
                          label: 'Hotel',
                        ),
                        _LegendItem(
                          color: Colors.deepOrange,
                          label: 'Restaurant',
                        ),
                        _LegendItem(
                          color: Colors.purple,
                          label: 'Temple',
                        ),
                        _LegendItem(
                          color: Colors.blue,
                          label: 'Beach',
                        ),
                        _LegendItem(
                          color: Colors.green,
                          label: 'Nature',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final places = _filteredPlaces;

                        if (places.isEmpty) {
                          return const Center(
                            child: Text('No destinations found.'),
                          );
                        }

                        return ListView.separated(
                          itemCount: places.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(height: 6),
                          itemBuilder: (context, index) {
                            final place = places[index];
                            final isSelected =
                                _places.indexOf(place) == _selectedPlace;
                            final color = _markerColor(place);

                            return ListTile(
                              contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              tileColor: isSelected
                                  ? const Color(0xFFD8EFF0)
                                  : const Color(0xFFF5F7FA),
                              leading: CircleAvatar(
                                backgroundColor:
                                color.withValues(alpha: 0.12),
                                child: Icon(
                                  place['icon'] as IconData,
                                  color: color,
                                ),
                              ),
                              title: Text(
                                place['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${place['category']} • ${place['city']}',
                              ),
                              trailing:
                              const Icon(Icons.chevron_right),
                              onTap: () => _moveToPlace(place),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Icon(
                selected['icon'] as IconData,
                color: _markerColor(selected),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selected['name'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      selected['category'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => _openDestinationDetails(selected),
                icon: const Icon(Icons.info_outline),
                label: const Text('Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF087F8C),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 95,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
