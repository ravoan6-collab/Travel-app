
class Hotel {
  final int id;
  final String name;
  final String location;
  final double price;
  final double rating;
  final String? imageUrl;

  const Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    this.imageUrl,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? 'Unknown Hotel',
      location: json['location']?.toString() ?? '',
      price: double.tryParse('${json['price']}') ?? 0,
      rating: double.tryParse('${json['rating']}') ?? 0,
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'price': price,
      'rating': rating,
      'image_url': imageUrl,
    };
  }
}
