class ImagesModel {
  final int? total;
  final int? totalHits;
  final List<Images> images;

  ImagesModel({
    this.total,
    this.totalHits,
    required this.images,
  });

  factory ImagesModel.fromJson(Map<String, dynamic> json) => ImagesModel(
        total: json["total"],
        totalHits: json["totalHits"],
        images: json["hits"] == null
            ? []
            : List<Images>.from(json["hits"]!.map((x) => Images.fromJson(x))),
      );
}

class Images {
  final int id;
  final String imageUrl;
  final int likes;
  final int views;

  Images(
      {required this.id,
      required this.imageUrl,
      required this.likes,
      required this.views});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      id: json['id'],
      imageUrl: json['webformatURL'],
      likes: json['likes'],
      views: json['views'],
    );
  }
}
