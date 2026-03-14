import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_assessment_app/core/extensions/size_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_fonts.dart';
import 'providers/shop_provider.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shopProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                Future.microtask(() {
                  ref
                      .read(shopProvider.notifier)
                      .updateScroll(notification.metrics.pixels);
                });
              }
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTabs(context, ref, state),
                  _buildFeaturedSection(ref, state),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "For You:",
                      style: TextStyle(
                        fontFamily: AppFonts.dmSans,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2B2B2C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final products = [
                          AppImages.sneakerWhite,
                          AppImages.teeBlack,
                          AppImages.jacket,
                          AppImages.sneakerWhite,
                        ];
                        final names = [
                          "Box Fit Minecraft Tee",
                          "A-H-D Oversized Tee",
                          "Urban Jacket",
                          "Nike Air Max",
                        ];
                        final heights = [220.0, 320.0, 320.0, 220.0];
                        final colors = [
                          const Color(0xFFF5F5F5),
                          const Color(0xFFFF9595),
                          const Color(0xFFF5F5F5),
                          const Color(0xFFF5F5F5),
                        ];
                        return _buildProductCard(
                          products[index],
                          names[index],
                          "R4 999.99",
                          heights[index],
                          colors[index],
                        );
                      },
                    ),
                  ),
                  _buildPremiumScrollSection(
                    ref,
                    state,
                  ),
                  SizedBox(height: 8.h,),
                  _buildPromotionSection(),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildGlassHeader(context, ref, state),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassHeader(BuildContext context, WidgetRef ref, ShopState state) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 65),
          _buildSearchBar(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  Widget _buildTabs(BuildContext context, WidgetRef ref, ShopState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  _buildTab("For You", state.activeTabIndex == 0,
                      () => ref.read(shopProvider.notifier).setTab(0)),
                  _buildTab("World", state.activeTabIndex == 1,
                      () => ref.read(shopProvider.notifier).setTab(1)),
                ],
              ),
              Positioned(
                top: 25.0,
                left: 0,
                right: 0,
                child: _buildBackgroundLine(),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: 25.0,
                left: state.activeTabIndex == 0 ? 0 : tabWidth,
                width: tabWidth,
                child: _buildActiveIndicator(),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _buildBackgroundLine() {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDEDED), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40EFEFEF),
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }
  Widget _buildActiveIndicator() {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF0079FF), width: 1),
      ),
    );
  }
  Widget _buildTab(String title, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.dmSans,
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Colors.black : const Color(0xFF3A3A3C),
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(23),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            SvgPicture.asset(AppImages.search,
                width: 18,
                colorFilter:
                    const ColorFilter.mode(Color(0xFFB0B0B0), BlendMode.srcIn)),
            const SizedBox(width: 10),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search your product...",
                  hintStyle: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 12,
                      color: Color(0xFF9C9898),
                      fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            SvgPicture.asset(AppImages.filterButton, width: 22),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
  Widget _buildFeaturedSection(WidgetRef ref, ShopState state) {
    return SizedBox(
      height: 420.h,
      child: PageView(
        onPageChanged: ref.read(shopProvider.notifier).setFeaturedIndex,
        children: [
          _buildFeaturedCard(
            "Emerging Designers",
            "Explore small businesses and discover unique, one-of-a-kind looks.",
            const Color(0xFFFF9595),
            AppImages.teeBlack,
            true,
          ),
          _buildTrendingBrandsContent(),
        ],
      ),
    );
  }
  Widget _buildFeaturedCard(
      String title, String desc, Color bgColor, String imageUrl, bool isFirst) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.3,
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Image(
                image: imageUrl.startsWith('http')
                    ? NetworkImage(imageUrl)
                    : AssetImage(imageUrl) as ImageProvider,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(title,
              style: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  color: Colors.black)),
          const SizedBox(height: 5),
          Text(
            desc,
            style: const TextStyle(
              fontFamily: AppFonts.dmSans,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3F3636),
            ),
          ),
          SizedBox(height: 20.h),
          buildShopNowButton("Shop Now", () {}),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerRight,
            child: buildDotIndicator(isFirst ? 0 : -1), // Only shows first dot if on first page
          ),
        ],
      ),
    );
  }
  Widget _buildTrendingBrandsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTrendingBrands(),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _buildGlobalScene()),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: buildDotIndicator(1),
            ),
          ],
        ),
      ],
    );
  }
  Widget buildShopNowButton(String btnText, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 164,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF001226),
              Color(0xFF303030),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF626262).withValues(alpha: 0.45),
              offset: const Offset(0, 8),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                btnText,
                style: const TextStyle(
                  fontFamily: AppFonts.poppins ,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildDotIndicator(int activeIndex) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final bool isActive = index == activeIndex;
        return Container(
          margin: const EdgeInsets.only(left: 4),
          width: isActive ? 14 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF0079FF) : const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(3),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF0079FF).withValues(alpha: 0.363),
                      offset: const Offset(0, 2),
                      blurRadius: 7,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
  Widget _buildTrendingBrands() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Trending Brands",
            style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.black),
          ),
          const SizedBox(height: 4),
          const Text(
            "Loved by the community, picked by us.",
            style: TextStyle(
                fontFamily: AppFonts.dmSans,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF707070),
                height: 1.2),
          ),
          const SizedBox(height: 15),
          _buildBrandItem(
              "Amanda's Boutique",
              "A modern designer with a youthful spirit.",
              AppImages.profile2),
          _buildBrandItem("Nike", "Just do it.",
              AppImages.profile1),
          _buildBrandItem("Yousaf", "Wear the mood, not the label.",
              AppImages.profile1),
        ],
      ),
    );
  }
  Widget _buildBrandItem(String title, String subtitle, String avatarUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 24, backgroundImage: AssetImage(avatarUrl)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: AppFonts.dmSans,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                if (subtitle.isNotEmpty)
                  Text(subtitle,
                      style: const TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.w300,
                          fontSize: 11,
                          color: Color(0xFF8F8F8F),
                          height: 1.2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Text("More",
              style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF007AFF))),
        ],
      ),
    );
  }
  Widget _buildCategoryTags(BuildContext context) {
    final tags = ["For You", "Men", "Women", "Jackets", "Hoodies"];

    return SizedBox(
      height: 55,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          bool isActive = index == 0;
          return _buildTabItem(tags[index], isActive);
        },
      ),
    );
  }
  Widget _buildTabItem(String label, bool isActive) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isActive ? null : const Color(0xFF2B2B2C).withValues(alpha: 0.1),
        gradient: isActive
            ? const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF5AB0FF), Color(0xFF0079FF)],
        )
            : null,
        boxShadow: isActive ? [
          BoxShadow(
            color: const Color(0xFF0079FF).withValues(alpha: 0.5),
            offset: const Offset(0, 5),
            blurRadius: 28,
            spreadRadius: 0,
          )
        ] : [],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          // Selected: White, Unselected: Dark Grey
          color: isActive ? Colors.white : const Color(0xFF2B2B2C),
        ),
      ),
    );
  }
  Widget _buildProductCard(
      String imagePath, String name, String price, double height, Color bgColor) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 88,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF111111).withValues(alpha: 0.1),
                    const Color(0xFF111111).withValues(alpha: 0.8),
                    const Color(0xFF111111),
                  ],
                ),
              ),
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 48),
              child: Row(
                children: [
                  Container(
                    width: 19,
                    height: 19.3,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(AppImages.profile1),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontFamily: AppFonts.dmSans,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    price,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: AppFonts.dmSans,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPromotionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _buildProductCard(AppImages.teeBack, "'No Breeze' Wind Br...", "R16 999.99", 180, const Color(0xFFF5F5F5)),
                const SizedBox(height: 15),
                _buildPromoCTA("Exclusively\non Swéy..."),
                const SizedBox(height: 15),
                _buildProductCard(AppImages.teeBlack, "'No Breeze' Wind Br...", "R16 999.99", 240, const Color(0xFFCCEDF3)),
                const SizedBox(height: 15),
                _buildPromoCTA("Grab the best!"),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              children: [
                _buildProductCard(AppImages.teePink, "'No Breeze' Wind Br...", "R16 999.99", 265, const Color(0xFFF5F5F5)),
                const SizedBox(height: 15),
                _buildProductCard(AppImages.teeBack, "'No Breeze' Wind Br...", "R16 999.99", 400, const Color(0xFFF5F5F5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPromoCTA(String text) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF007AFF),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.north_east, color: Colors.white, size: 28),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppFonts.inter,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPremiumScrollSection(WidgetRef ref, ShopState state) {
    return Column(
      children: [
        SizedBox(
          height: 380.h,
          child: PageView(
            onPageChanged: ref.read(shopProvider.notifier).setFeaturedIndex,
            children: [
              _buildPremiumScrollItem(
                AppImages.sneakerNike,
                state.featuredIndex == 0,
                0,
              ),
              _buildPremiumScrollItem(
                AppImages.sneakerBlack,
                state.featuredIndex == 1,
                1,
              ),
              _buildPremiumScrollItem(
                AppImages.sneakerWhite,
                state.featuredIndex == 2,
                2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(AppImages.profile1),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.featuredIndex == 0
                      ? "Nike - Off White Air Prestos [Virgil Abloah 2019]"
                      : state.featuredIndex == 1
                      ? "A-H-D Oversized Tee - Black Premium Edition"
                      : "Classic White Sneakers - Essential Collection",
                  style: const TextStyle(
                    fontFamily: AppFonts.dmSans,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC7C7C7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                state.featuredIndex == 0 ? "R4 999.99" : "R899.99",
                style: const TextStyle(
                  fontFamily: AppFonts.dmSans,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFC7C7C7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildPremiumScrollItem(String imageUrl, bool isActive, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              children: List.generate(3, (i) {
                final bool isDotActive = i == index;
                return Container(
                  margin: const EdgeInsets.only(left: 4),
                  width: isDotActive ? 14 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isDotActive ? const Color(0xFF0079FF) : Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: isDotActive ? [
                      BoxShadow(
                        color: const Color(0xFF0079FF).withValues(alpha: 0.363),
                        offset: const Offset(0, 2),
                        blurRadius: 7,
                      ),
                    ] : null,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildGlobalScene() {
    final List<String> flags = [
      'assets/images/sk.png',
      'assets/images/br.png',
      'assets/images/en.png',
      'assets/images/mg.png',
      'assets/images/us.png',
      'assets/images/sa.png',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            height: 38,
            child: Stack(
              children: List.generate(flags.length, (index) {
                return Positioned(
                  left: index * 18.0,
                  child: Container(
                    decoration: BoxDecoration(

                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(flags[index]),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Explore the Global Scene",
              style: TextStyle(
                fontFamily: AppFonts.inter,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0079FF),
                decoration: TextDecoration.underline,
                height: 1.0,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: Color(0xFF0079FF)),
        ],
      ),
    );
  }
}
