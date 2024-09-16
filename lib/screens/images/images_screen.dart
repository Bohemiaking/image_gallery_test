import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixabay_images_test/controllers/image_controller.dart';
import 'package:pixabay_images_test/screens/images/widgets/image_card.dart';
import 'package:pixabay_images_test/screens/images/widgets/image_shimmer.dart';
import 'package:pixabay_images_test/screens/square_test/square_test_screen.dart';
import 'package:pixabay_images_test/utils/helpers/debouncer.dart';
import 'package:pixabay_images_test/utils/helpers/navigate.dart';
import 'package:pixabay_images_test/utils/helpers/scroll_listner.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  ImageController imageController = Get.find();
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  // debouncer timer is 500 milliseconds
  final Debouncer _debouncer = Debouncer(milliseconds: 700);

  // default page is 1
  int currentPage = 1;

  // if current loaded images count is not equal to total available images in api and currently api is not loading any data
  // then it means its safe to load next page data (shouldLoadMore=true)
  bool get shouldLoadMore =>
      (imageController.images.length != imageController.totalItems.value) &&
      imageController.isLoading.isFalse &&
      imageController.isLoadingMore.isFalse;

  // if current loaded images count is equal to total available images in api then isAllImagesLoaded will be true
  bool get isAllImagesLoaded =>
      (imageController.images.length == imageController.totalItems.value);

  @override
  void initState() {
    // reinitiating controllers
    scrollController = ScrollController();
    textEditingController = TextEditingController();

    // default page is 1
    currentPage = 1;

    // Schedule the fetchImages() method to be called after the widget's initial build.
    // This ensures that the images are fetched once the widget has been rendered,
    // avoiding potential issues with state being accessed before the widget is fully built.
    WidgetsBinding.instance.addPostFrameCallback((t) {
      imageController.fetchImages();
    });

    // setupScrollListener is for paggination
    setupScrollListener(
      scrollController: scrollController,
      onAtBottom: () {
        // hit ehen reached at bottom
        // if shouldLoadMore is true then it is safe to load next page data
        if (shouldLoadMore) {
          // incrementing current page by +1
          currentPage += 1;
          imageController.fetchImages(page: currentPage);
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    // disposing controllers
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;
    // Define the desired item width
    double itemWidth = 150.0;
    // Calculate the number of columns
    int crossAxisCount = (screenWidth / itemWidth).floor();
    double aspectRatio = 0.9;

    return Scaffold(
        appBar: AppBar(
          title: CupertinoSearchTextField(
            controller: textEditingController,
            decoration: BoxDecoration(color: Colors.grey.shade50),
            onChanged: (value) {
              // using debouncer to search images with query
              _debouncer.run(() {
                // reseting page to 1
                currentPage = 1;
                imageController.fetchImages(page: 1, query: value);
              });
            },
          ),
          actions: [
            TextButton(
                onPressed: () {
                  AppNavigation.push(context, const SquareAnimation());
                },
                child: Text(
                  'Squares',
                  style: TextStyle(color: Colors.grey.shade100),
                ))
          ],
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            // swipe down to refresh
            currentPage = 1;
            await imageController.fetchImages(
                page: currentPage, query: textEditingController.text);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            controller: scrollController,
            child: Column(
              children: [
                Obx(() => GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount, // Number of columns
                        childAspectRatio: aspectRatio, // Makes the items square
                        crossAxisSpacing: 10, // Spacing between columns
                        mainAxisSpacing: 10, // Spacing between rows
                      ),
                      children: [
                        // if data is loading then showing images shimmer, a loading effect
                        if (imageController.isLoading.isTrue) ...[
                          for (int i = 0; i < 6; i++) const ImageShimmer()
                        ]
                        // if there is no data then showing a empty place holder text
                        else if (imageController.images.isEmpty) ...[
                          const Text(
                            'No images were found!',
                            textAlign: TextAlign.center,
                          )
                        ]
                        // if there are images in response then show imagecard with images
                        else ...[
                          for (var data in imageController.images)
                            ImageCard(image: data)
                        ]
                      ],
                    )),
                Obx(() =>
                    // if isAllImagesLoaded=false then show loading indicator at bottom
                    Visibility(
                      visible: !isAllImagesLoaded,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
