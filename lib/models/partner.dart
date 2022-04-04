
class Partner {
  final String image;
  final String description;

  Partner({
    this.image,
    this.description,
  });

  Partner.fromMap(Map snapshot)
      :
        image = snapshot['image'] ?? '',
        description = snapshot['description'] ?? '';


  toJson() {
    return {
      "image": image,
      "description": description
    };
  }

}
