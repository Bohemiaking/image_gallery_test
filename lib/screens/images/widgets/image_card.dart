import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pixabay_images_test/data/models/image_model.dart';
import 'package:pixabay_images_test/screens/images/widgets/image_fullview.dart';
import 'package:pixabay_images_test/utils/helpers/navigate.dart';

class ImageCard extends StatelessWidget {
  final Images image;

  const ImageCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigation to full image screen with hero animation
        AppNavigation.push(context, ImageFullView(image: image));
      },
      child: Hero(
        tag: image.id,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    image.imageUrl,
                    fit: BoxFit.cover,
                    cacheHeight: 400,
                    cacheWidth: 400,
                  ),
                ),
              ),
              likesViews(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget likesViews(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Row(
            children: [
              const Icon(
                Icons.favorite,
                size: 15,
                color: Colors.red,
              ),
              Text(
                image.likes.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
          const Gap(10),
          Row(
            children: [
              const Icon(
                Icons.remove_red_eye_rounded,
                size: 15,
                color: Colors.blue,
              ),
              Text(
                image.views.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ],
      ),
    );
  }
}
