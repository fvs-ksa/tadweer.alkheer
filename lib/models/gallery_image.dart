class GalleryImage {
  final String description;
  final String imageUrl;

  GalleryImage({
    this.description = '',
    this.imageUrl ='',
    
  });

  GalleryImage.fromMap(Map snapshot)
      :
        description = snapshot['description'] ?? '',
        imageUrl = snapshot['imageUrl'];

}
