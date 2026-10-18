
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  final MapController _mapController = MapController();

  int _selectedPlace = 0;

  final List<Map<String, dynamic>> _places = [
    {
      'name': 'Angkor Wat',
      'city': 'Siem Reap, Cambodia',
      'category': 'Temple',
      'latitude': 13.4125,
      'longitude': 103.8670,
      'icon': Icons.account_balance,
    },
    {
      'name': 'Royal Palace',
      'city': 'Phnom Penh, Cambodia',
      'category': 'Culture',
      'latitude': 11.5564,
      'longitude': 104.9282,
      'icon': Icons.castle,
    },
    {
      'name': 'Koh Rong',
      'city': 'Sihanoukville, Cambodia',
      'category': 'Beach',
      'latitude': 10.7083,
      'longitude': 103.2317,
      'icon': Icons.beach_access,
    },
    {
      'name': 'Bokor National Park',
      'city': 'Kampot, Cambodia',
      'category': 'Nature',
      'latitude': 10.6250,
      'longitude': 104.0280,
      'icon': Icons.park,
    },
  ];

  // Get the user's current GPS location.
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showLocationMessage(
          'Please enable location services.',
        );
        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showLocationMessage(
          'Location permission was denied.',
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationMessage(
          'Please allow location access in settings.',
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

      _mapController.move(
        LatLng(
          position.latitude,
          position.longitude,
        ),
        15,
      );

      _showLocationMessage('Your location was found!');
    } catch (e) {
      _showLocationMessage(
        'Could not get location. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _showLocationMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _selectPlace(int index) {
    final place = _places[index];

    setState(() {
      _selectedPlace = index;
    });

    _mapController.move(
      LatLng(
        place['latitude'] as double,
        place['longitude'] as double,
      ),
      14,
    );
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Explore places in Cambodia',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.tune),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: _showPlacesList,
            ),
          ),

          Expanded(
            flex: 5,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: const MapOptions(
                    initialCenter: LatLng(12.5657, 104.9910),
                    initialZoom: 6.5,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.ai_travel',
                    ),

                    // STEP 5: Tourist markers + current location.
                    MarkerLayer(
                      markers: [
                        ...List.generate(
                          _places.length,
                              (index) {
                            final place = _places[index];
                            final isSelected =
                                index == _selectedPlace;

                            return Marker(
                              point: LatLng(
                                place['latitude'] as double,
                                place['longitude'] as double,
                              ),
                              width: 56,
                              height: 64,
                              child: GestureDetector(
                                onTap: () => _selectPlace(index),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(9),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF006D77)
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.2),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        place['icon'] as IconData,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF006D77),
                                        size: 22,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: isSelected
                                          ? const Color(0xFF006D77)
                                          : Colors.white,
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // STEP 5: Current location marker.
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
                                color: Colors.blue.withValues(
                                  alpha: 0.15,
                                ),
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
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),

                // Existing Zoom In button.
                Positioned(
                  right: 12,
                  top: 12,
                  child: FloatingActionButton.small(
                    heroTag: 'zoom_in',
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF006D77),
                    onPressed: () {
                      _mapController.move(
                        _mapController.camera.center,
                        _mapController.camera.zoom + 1,
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                ),

                // Existing Zoom Out button.
                Positioned(
                  right: 12,
                  top: 60,
                  child: FloatingActionButton.small(
                    heroTag: 'zoom_out',
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF006D77),
                    onPressed: () {
                      _mapController.move(
                        _mapController.camera.center,
                        _mapController.camera.zoom - 1,
                      );
                    },
                    child: const Icon(Icons.remove),
                  ),
                ),

                // STEP 6: My Location button.
                Positioned(
                  right: 12,
                  top: 108,
                  child: FloatingActionButton.small(
                    heroTag: 'my_location',
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF006D77),
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
                    'Popular Destinations',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _places.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final place = _places[index];
                        final isSelected =
                            index == _selectedPlace;

                        return ListTile(
                          contentPadding:
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: isSelected
                              ? const Color(0xFFD8EFF0)
                              : const Color(0xFFF5F7FA),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              place['icon'] as IconData,
                              color: const Color(0xFF006D77),
                            ),
                          ),
                          title: Text(
                            place['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            place['city'] as String,
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                          ),
                          onTap: () => _selectPlace(index),
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
              const Icon(
                Icons.place,
                color: Color(0xFF006D77),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selected['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  _showPlaceDetails(selected);
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlacesList() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
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
              ...List.generate(_places.length, (index) {
                return ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Color(0xFF006D77),
                  ),
                  title: Text(
                    _places[index]['name'] as String,
                  ),
                  subtitle: Text(
                    _places[index]['city'] as String,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _selectPlace(index);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showPlaceDetails(Map<String, dynamic> place) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                place['name'] as String,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(place['city'] as String),
              const SizedBox(height: 12),
              Chip(
                label: Text(place['category'] as String),
              ),
              const SizedBox(height: 12),
              const Text(
                'This destination is sample data. '
                    'Check local information before travelling.',
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
