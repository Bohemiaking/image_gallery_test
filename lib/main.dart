import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pixabay_images_test/controllers/image_controller.dart';
import 'package:pixabay_images_test/data/api/pixabay_api_service.dart';
import 'package:pixabay_images_test/repository/image_repository.dart';
import 'package:pixabay_images_test/screens/images/images_screen.dart';
import 'package:pixabay_images_test/utils/constants/app_strings.dart';
import 'package:pixabay_images_test/utils/themes/main_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppMainTheme.themeData, // theme of application
      home: const ImagesScreen(), // initial screen
      initialBinding: AppBindings(), // initial app bindings
    );
  }
}

//InitialBindings is a way to define and provide dependencies (such as controllers or services) that are required when your application starts
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ImageController(
        repository: ImageRepository(apiService: PixabayApiService())));
  }
}
