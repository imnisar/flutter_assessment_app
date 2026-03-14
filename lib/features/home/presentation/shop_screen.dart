import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_fonts.dart';
import 'providers/shop_provider.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    ref.read(shopProvider.notifier).updateScroll(_scrollController.offset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                if (notification.metrics.pixels < 0) {
                  double overscroll = -notification.metrics.pixels;
                  double percentage = (overscroll / 100).clamp(0, 1);
                  ref.read(shopProvider.notifier).setPullDown(percentage);
                } else if (state.pullDownPercentage > 0) {
                  ref.read(shopProvider.notifier).setPullDown(0);
                }
              }
              return false;
            },
            child: ListView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: EdgeInsets.only(top: 170 + (state.pullDownPercentage * 60)),
              children: [
                _buildFeaturedSection(state),
                const SizedBox(height: 30),
                _buildForYouHeader(),
                _buildProductGrid(),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            top: 125,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: state.pullDownPercentage,
              child: Transform.translate(
                offset: Offset(0, (state.pullDownPercentage - 1) * 30),
                child: _buildCategoryTags(),
              ),
            ),
          ),
          _buildGlassHeader(state),
        ],
      ),
    );
  }

  Widget _buildGlassHeader(ShopState state) {
    double opacity = (state.scrollOffset / 150).clamp(0, 0.98);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15 * opacity, sigmaY: 15 * opacity),
        child: Container(
          color: Colors.white.withValues(alpha: opacity > 0.5 ? opacity : 0),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTabs(state),
              const SizedBox(height: 15),
              _buildSearchBar(opacity),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(ShopState state) {
    return Row(
      children: [
        _buildTab("For You", state.activeTabIndex == 0, () => ref.read(shopProvider.notifier).setTab(0)),
        _buildTab("World", state.activeTabIndex == 1, () => ref.read(shopProvider.notifier).setTab(1)),
      ],
    );
  }

  Widget _buildTab(String title, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Colors.black : const Color(0xFFC7C7C7),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2,
              width: isActive ? 120 : 0,
              color: const Color(0xFF007AFF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(double headerOpacity) {
    final double textScale = MediaQuery.textScalerOf(context).scale(1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: BoxConstraints(minHeight: 46 * textScale),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: headerOpacity > 0.8 ? Colors.white.withValues(alpha: 0.8) : const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(23),
          border: headerOpacity > 0.8 ? Border.all(color: Colors.black.withValues(alpha: 0.05)) : null,
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            SvgPicture.asset(AppImages.search, width: 18, colorFilter: const ColorFilter.mode(Color(0xFFB0B0B0), BlendMode.srcIn)),
            const SizedBox(width: 10),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search your product...",
                  hintStyle: TextStyle(fontFamily: AppFonts.poppins, fontSize: 13, color: Color(0xFFB0B0B0)),
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

  Widget _buildCategoryTags() {
    final tags = ["For You", "Men", "Women", "Jackets", "Hoodies"];
    final double textScale = MediaQuery.textScalerOf(context).scale(1.0);
    return SizedBox(
      height: 36 * textScale,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          bool isActive = index == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF007AFF) : const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              tags[index],
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF707070),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection(ShopState state) {
    final double textScale = MediaQuery.textScalerOf(context).scale(1.0);
    return SizedBox(
      height: 480 * textScale,
      child: PageView(
        onPageChanged: ref.read(shopProvider.notifier).setFeaturedIndex,
        children: [
          _buildFeaturedCard(
            "Emerging Designers",
            "Explore small businesses and discover unique, one-of-a-kind looks.",
            "Shop Now",
            const Color(0xFFFFA09B),
            "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=1000&auto=format&fit=crop",
          ),
          _buildTrendingBrands(),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(String title, String desc, String btnText, Color bgColor, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(35),
                image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 15),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: AppFonts.poppins, fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFFC7C7C7)),
              children: [
                const TextSpan(text: "Emerging "),
                TextSpan(text: "Designers", style: TextStyle(color: Colors.black.withValues(alpha: 0.8))),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            desc,
            style: const TextStyle(fontFamily: AppFonts.poppins, fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF707070), height: 1.4),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF031420),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(btnText, style: const TextStyle(fontFamily: AppFonts.poppins, fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(width: 15),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
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
            style: TextStyle(fontFamily: AppFonts.poppins, fontSize: 32, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          const SizedBox(height: 5),
          const Text(
            "Loved by the community, picked by us — these brands are changing the game from the ground up.",
            style: TextStyle(fontFamily: AppFonts.poppins, fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF707070), height: 1.4),
          ),
          const SizedBox(height: 25),
          _buildBrandItem("Amanda's Boutique", "A modern designer with a youthful spirit, dedicated to hand-making every piece with care.", "https://randomuser.me/api/portraits/women/44.jpg"),
          _buildBrandItem("Nike", "Just Do It", "https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg"),
          _buildBrandItem("LOST COINS", "", "https://randomuser.me/api/portraits/men/32.jpg"),
        ],
      ),
    );
  }

  Widget _buildBrandItem(String title, String subtitle, String avatarUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 32, backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: AppFonts.poppins, fontSize: 15, fontWeight: FontWeight.w700)),
                if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(fontFamily: AppFonts.poppins, fontSize: 12, color: Color(0xFFC7C7C7), height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Text("More", style: TextStyle(fontFamily: AppFonts.poppins, fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF007AFF))),
        ],
      ),
    );
  }

  Widget _buildForYouHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text("For You:", style: TextStyle(fontFamily: AppFonts.poppins, fontSize: 17, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildProductGrid() {
    final products = [
      AppImages.sneakerWhite,
      AppImages.teeBlack,
      AppImages.jacket,
      AppImages.sneakerNike,
      AppImages.teePink,
      AppImages.teeBack,
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        itemCount: products.length + 2,
        itemBuilder: (context, index) {
          if (index == 4) return _buildPromoCard("Exclusively\non Swéy...", const Color(0xFF007AFF));
          if (index == 7) return _buildPromoCard("Grab the\nbest!", const Color(0xFF007AFF));
          
          int productIndex = index;
          if (index > 4) productIndex--;
          if (index > 7) productIndex--;
          
          if (productIndex >= products.length) return const SizedBox();

          return _buildProductCard(
            products[productIndex],
            (productIndex % 3 == 0) ? "Box Fit Minecraft Tee" : "A-H-D Oversized Tee",
            "R${(4000 + (index * 123)).toStringAsFixed(2)}",
            (productIndex % 3 == 0) ? 240 : 180,
          );
        },
      ),
    );
  }

  Widget _buildPromoCard(String text, Color color) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.north_east, color: Colors.white, size: 28),
          const Spacer(),
          Text(text, style: const TextStyle(fontFamily: AppFonts.poppins, fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildProductCard(String imagePath, String name, String price, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  color: Colors.black.withValues(alpha: 0.4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        price,
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
