class Category {
  final String id;
  final String name;
  final String arabicName;
  final String imageUrl;

  Category({
    this.id = '',
    this.name = '',
    this.arabicName = '',
    this.imageUrl ='',
    
  });

  Category.fromMap(Map snapshot, String id)
      : id = id,
        name = snapshot['name'] ?? '',
        arabicName = snapshot['arabicName'] ?? '',
        imageUrl = snapshot['imageUrl'];


  toJson() {
    return {
      "name": name,
      "arabicName": arabicName,
      "imageUrl": imageUrl,
    };
  }
}
