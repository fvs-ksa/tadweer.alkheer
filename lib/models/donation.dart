import './place_location.dart';

class Donation {
  final String id;
  final String userId;
  String name = "no_name";
  final String description;
  final String category;
  //final String pickupAddress;
  final String imageUrl;
  final String videoUrl;
  final int quantity;
  final DateTime date;
  final DateTime pickupDateTime;
  final String status;
  final PlaceLocation location;

  Donation({
    this.id,
    this.userId,
    this.name = 'Unknown',
    this.description,
    this.category,
    //this.pickupAddress,
    this.imageUrl,
    this.videoUrl,
    this.quantity,
    this.date,
    this.pickupDateTime,
    this.status,
    this.location,
  });

  Donation.fromMap(Map snapshot, String id)
      : id = id ?? '',
        userId = snapshot['userId'] ?? '',
        name = snapshot['name'] ?? '',
        description = snapshot['description'] ?? '',
        category = snapshot['category'] ?? '',
        imageUrl = snapshot['imageUrl'] ?? '',
        videoUrl = snapshot['videoUrl'] ?? '',
        quantity = snapshot['quantity'] ?? 1,
        date = DateTime.parse(snapshot['date']) ?? DateTime.now(),
        pickupDateTime =
             DateTime.now(),
        location = PlaceLocation(
              latitude: snapshot['latitude'],
              longitude: snapshot['longitude'],
              address: snapshot['pickupAddress'],
            ) ??
            '',
        status = snapshot['status'] ?? '';

  toJson() {
    return {
      "userId": userId,
      "name": name,
      "description": description,
      "category": category,
      "latitude": location.latitude,
      "longitude": location.longitude,
      "pickupAddress": location.address,
      "imageUrl": imageUrl,
      "videoUrl": videoUrl,
      "quantity": quantity,
      "date": date.toString(),
      "pickupDateTime": pickupDateTime.toString(),
      "status": status,
    };
  }
}
