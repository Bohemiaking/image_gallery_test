import 'package:pixabay_images_test/data/api/api_core.dart';
import 'package:dio/dio.dart';
import 'package:pixabay_images_test/data/models/image_model.dart';
import 'package:pixabay_images_test/utils/constants/app_strings.dart';
import 'package:pixabay_images_test/utils/constants/app_uri.dart';

class PixabayApiService {
  final ApiService _apiService = ApiService();

  Future<ImagesModel> fetchImages(String query, int page) async {
    String encodedQuery = Uri.encodeComponent(query); // encoding query as per docs
    try {
      final response = await _apiService.dio.get(
        AppUri.pixabayBaseUri,
        queryParameters: {
          'key': AppStrings.pixaBayApiKey,
          'q': encodedQuery,
          'page': page,
          'per_page': 40
        },
      );
      if (response.statusCode == 200) {
        return ImagesModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load images');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch images $e');
    }
  }
}
