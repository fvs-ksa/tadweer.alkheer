
class User {
  final String id;
  final String name;
  final String imageUrl;
  final String videoUrl;
  final DateTime joinDate;
  final int itemsDonated;
  final String phoneNumber;
  String type;
  final int completedTasks;
  

  User({
    this.id = '',
    this.name = '',
    this.imageUrl = '',
    this.videoUrl = '',
    this.joinDate ,
    this.itemsDonated,
    this.phoneNumber = '',
    this.type = '',
    this.completedTasks,
  });

  User.fromMap(Map snapshot, String id)
      : id = id,
        name = snapshot['name'] ?? '',
        imageUrl = snapshot['imageUrl'] ?? '',
        videoUrl = snapshot['videoUrl'] ?? '',
        joinDate = DateTime.parse(snapshot['joinDate']) ?? DateTime.now(),
        itemsDonated = snapshot['itemsDonated'] ?? 0,
        completedTasks = snapshot['completedTasks'] ?? 0,
        phoneNumber =  snapshot['phoneNumber'] ?? "",
        type =  snapshot['type'] ?? "";
        

  toJson() {
    return {
      "name" : name,
      "imageUrl": imageUrl,
      "videoUrl": videoUrl,
      "joinDate": joinDate.toString(),
      "itemsDonated": itemsDonated,
      "phoneNumber" : phoneNumber,
      "completedTasks": completedTasks,
      "type":type,
    };
  }
}
