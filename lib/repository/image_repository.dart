import 'package:pixabay_images_test/data/api/pixabay_api_service.dart';
import 'package:pixabay_images_test/data/models/image_model.dart';

class ImageRepository {
  final PixabayApiService apiService;

  ImageRepository({required this.apiService});

  Future<ImagesModel> getImages(String query, int page) async {
    return apiService.fetchImages(query, page);
  }
}
