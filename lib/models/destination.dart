
class Destination {
  final int id;
  final String name;
  final String country;
  final String description;
  final double latitude;
  final double longitude;
  final String? imageUrl;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? 'Unknown Destination',
      country: json['country']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      latitude: double.tryParse('${json['latitude']}') ?? 0,
      longitude: double.tryParse('${json['longitude']}') ?? 0,
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
    };
  }
}
