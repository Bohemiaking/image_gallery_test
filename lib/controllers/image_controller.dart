import 'package:get/get.dart';
import 'package:pixabay_images_test/data/models/image_model.dart';
import 'package:pixabay_images_test/repository/image_repository.dart';

class ImageController extends GetxController {
  final ImageRepository repository;

  ImageController({required this.repository});

  RxList<Images> images = <Images>[].obs; // here the images will be store
  RxBool isLoading = true.obs; // to check if loading images
  RxBool isLoadingMore =
      false.obs; // to check if loading more images according to paggination
  RxInt totalItems = 0.obs; // total available images/item in api response

  Future<void> fetchImages({String query = '', int page = 1}) async {
    if (page == 1) {
      // if page is 1 that is default page, then set values accordingly
      isLoading.value = true;
      images.clear();
      totalItems.value = 0;
    } else {
      // if page is NOT 1, then set values accordingly
      isLoadingMore.value = true;
    }
    try {
      final data = await repository.getImages(query, page);
      images.addAll(data.images);
      totalItems.value = data.totalHits ?? 0;
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
}
