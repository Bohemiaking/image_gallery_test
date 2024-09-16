import 'package:flutter/material.dart';
import 'package:pixabay_images_test/data/models/image_model.dart';

class ImageFullView extends StatelessWidget {
  final Images image;
  const ImageFullView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black87),
      backgroundColor: Colors.black87,
      body: Hero(
        tag: image.id,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.network(
            image.imageUrl,
            cacheHeight: 400,
            cacheWidth: 400,
          ),
        ),
      ),
    );
  }
}
