
//import './place_location.dart';

class Task {
  final String id;
  final String driverId;
  final String donationId;
  // final DateTime pickupDateTime;
  final String status;
  // final PlaceLocation location;
  

  Task({
    this.id,
    this.driverId,
    this.donationId,
    // this.pickupDateTime,
    this.status,
    // this.location,
    
  });

  Task.fromMap(Map snapshot, String id)
      : id = id ?? '',
        driverId = snapshot['driverId'] ?? '',
        donationId = snapshot['donationId'] ?? '',
        // pickupDateTime = DateTime.parse(snapshot['pickupDateTime']) ?? DateTime.now(),
        // location = PlaceLocation(
        //       latitude: snapshot['latitude'],
        //       longitude: snapshot['longitude'],
        //       address: snapshot['pickupAddress'],
        //     ) ??
        //     '',
        status = snapshot['status'] ?? '';

  toJson() {
    return {
      "driverId": driverId,
      "donationId":donationId,
      // "latitude": location.latitude,
      // "longitude": location.longitude,
      // "pickupAddress": location.address,
      // "pickupDateTime": pickupDateTime.toString(),
      "status":status,
    };
  }
}
