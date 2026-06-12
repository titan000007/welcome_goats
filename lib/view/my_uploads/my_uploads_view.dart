import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../utils/colors.dart';
import '../../controllers/gallery_controller.dart';
import '../../data/models/image_item.dart';
import '../../routes/app_pages.dart';
import '../home/widgets/home_card_widget.dart';

class MyUploadsView extends StatefulWidget {
  const MyUploadsView({super.key});

  @override
  State<MyUploadsView> createState() => _MyUploadsViewState();
}

class _MyUploadsViewState extends State<MyUploadsView> {
  final GalleryController controller = Get.find<GalleryController>();
  late ScrollController _scrollController;

  final List<ImageItem> staticItems = [
    ImageItem(
      id: 'static_1',
      title: 'Alpine Ibex',
      description:
          'A majestic Alpine Ibex standing on a rocky ridge at sunset.',
      category: 'Animals',
      imageUrl:
          'https://images.unsplash.com/photo-1534067783941-51c9c23ecefd?q=80&w=600&auto=format&fit=crop',
      uploadDate: '2024-03-20',
      uploaderName: 'Amelia Rose',
      location: 'Swiss Alps, Switzerland',
      userId: 'user_default',
      isFavorite: true,
    ),
    ImageItem(
      id: 'static_2',
      title: 'Golden Eagle',
      description:
          'Powerful golden eagle soaring through the highland valleys.',
      category: 'Birds',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTA7lkDUlyv84i5iTcIS3WFis_krGnVf8jfLQ&s',
      uploadDate: '2024-03-18',
      uploaderName: 'Amelia Rose',
      location: 'Scottish Highlands',
      userId: 'user_default',
    ),
    ImageItem(
      id: 'static_3',
      title: 'Mist Forest',
      description: 'Deep morning mist rolling through a dense pine forest.',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?q=80&w=600&auto=format&fit=crop',
      uploadDate: '2024-03-15',
      uploaderName: 'Amelia Rose',
      location: 'Black Forest, Germany',
      userId: 'user_default',
    ),
    ImageItem(
      id: 'static_4',
      title: 'Arctic Fox',
      description: 'Arctic fox in the snow.',
      category: 'Animals',
      imageUrl:
          'https://images.unsplash.com/photo-1516467508483-a7212febe31a?q=80&w=600&auto=format&fit=crop',
      uploadDate: '2024-03-10',
      uploaderName: 'Amelia Rose',
      location: 'Iceland',
      userId: 'user_default',
    ),
    ImageItem(
      id: 'static_5',
      title: 'Red Deer',
      description: 'Red deer in the woods.',
      category: 'Animals',
      imageUrl:
          'https://images.unsplash.com/photo-1543946207-39bd91e70ca7?q=80&w=600&auto=format&fit=crop',
      uploadDate: '2024-03-05',
      uploaderName: 'Amelia Rose',
      location: 'Richmond Park, UK',
      userId: 'user_default',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'MY COLLECTIONS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
        body: Obx(() {
          final userItems = [
            ...staticItems,
            ...controller.images.where((img) => img.userId == 'user_default'),
          ];

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              _buildArcSlider(userItems),
            ],
          );
        }));
  }

  Widget _buildArcSlider(List<ImageItem> items) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = 200.0;
    double spacing = 20.0;
    double horizontalPadding = (screenWidth - cardWidth) / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.accent, size: 16),
              SizedBox(width: 8),
              Text(
                'HIGHLIGHTED CAPTURES',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final img = items[index];
              double itemPosition = index * (cardWidth + spacing);
              double scrollOffset =
                  _scrollController.hasClients ? _scrollController.offset : 0.0;
              double relativePosition = itemPosition - scrollOffset;
              double normalizedDist = relativePosition / (screenWidth / 2);
              double yOffset = math.pow(normalizedDist, 2) * 50.0;
              double rotation = normalizedDist * 0.20;
              double scale = 1.0 - (math.pow(normalizedDist, 2) * 0.1);

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(0.2, yOffset)
                  ..scale(scale)
                  ..rotateZ(rotation),
                alignment: Alignment.center,
                child: Container(
                  width: cardWidth,
                  margin: EdgeInsets.only(right: spacing, bottom: 8),
                  child: HomeCardWidget(
                    image: img.imageUrl,
                    title: img.title,
                    cardText: img.category,
                    isSelected: img.isFavorite,
                    location: img.location,
                    onTap: () => Get.toNamed(AppRoutes.details, arguments: img),
                    onFavoriteTap: () => controller.toggleFavorite(img.id),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
