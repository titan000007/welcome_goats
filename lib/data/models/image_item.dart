class ImageItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final String uploadDate;
  final String uploaderName;
  final String location;
  bool isFavorite;
  int downloadsCount;
  int likesCount;
  final String? userId;

  ImageItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.uploadDate,
    required this.uploaderName,
    required this.location,
    this.isFavorite = false,
    this.downloadsCount = 0,
    this.likesCount = 0,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'uploadDate': uploadDate,
      'uploaderName': uploaderName,
      'location': location,
      'isFavorite': isFavorite,
      'downloadsCount': downloadsCount,
      'likesCount': likesCount,
      'userId': userId,
    };
  }

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      uploadDate: json['uploadDate'] as String,
      uploaderName: json['uploaderName'] as String,
      location: json['location'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      downloadsCount: json['downloadsCount'] as int? ?? 0,
      likesCount: json['likesCount'] as int? ?? 0,
      userId: json['userId'] as String?,
    );
  }
}
