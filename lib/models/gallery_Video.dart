class GalleryVideo {
  final String description;
  final String videoUrl;

  GalleryVideo({
    this.description = '',
    this.videoUrl ='',
    
  });

  GalleryVideo.fromMap(Map snapshot)
      :
        description = snapshot['description'] ?? '',
        videoUrl = snapshot['videoUrl'];

}
