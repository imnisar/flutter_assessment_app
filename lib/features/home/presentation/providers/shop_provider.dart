import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopState {
  final int activeTabIndex; // 0 for "For You", 1 for "World"
  final int featuredIndex;
  final double scrollOffset;
  final double pullDownPercentage;

  const ShopState({
    this.activeTabIndex = 0,
    this.featuredIndex = 0,
    this.scrollOffset = 0,
    this.pullDownPercentage = 0,
  });

  ShopState copyWith({
    int? activeTabIndex,
    int? featuredIndex,
    double? scrollOffset,
    double? pullDownPercentage,
  }) {
    return ShopState(
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      featuredIndex: featuredIndex ?? this.featuredIndex,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      pullDownPercentage: pullDownPercentage ?? this.pullDownPercentage,
    );
  }
}

class ShopNotifier extends StateNotifier<ShopState> {
  ShopNotifier() : super(const ShopState());

  void setTab(int index) => state = state.copyWith(activeTabIndex: index);
  void setFeaturedIndex(int index) => state = state.copyWith(featuredIndex: index);
  void updateScroll(double offset) => state = state.copyWith(scrollOffset: offset);
  void setPullDown(double percentage) => state = state.copyWith(pullDownPercentage: percentage);
}

final shopProvider = StateNotifierProvider<ShopNotifier, ShopState>((ref) {
  return ShopNotifier();
});
