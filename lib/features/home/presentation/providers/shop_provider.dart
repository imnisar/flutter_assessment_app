import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopState {
  final int activeTabIndex;
  final int featuredIndex;
  final double scrollOffset;
  final double pullDownPercentage;
  final bool isTagsVisible;
  final bool isSearchActive;

  const ShopState({
    this.activeTabIndex = 0,
    this.featuredIndex = 0,
    this.scrollOffset = 0,
    this.pullDownPercentage = 0.0,
    this.isTagsVisible = false,
    this.isSearchActive = false,
  });

  ShopState copyWith({
    int? activeTabIndex,
    int? featuredIndex,
    double? scrollOffset,
    double? pullDownPercentage,
    bool? isTagsVisible,
    bool? isSearchActive,
  }) {
    return ShopState(
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      featuredIndex: featuredIndex ?? this.featuredIndex,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      pullDownPercentage: pullDownPercentage ?? this.pullDownPercentage,
      isTagsVisible: isTagsVisible ?? this.isTagsVisible,
      isSearchActive: isSearchActive ?? this.isSearchActive,
    );
  }
}

class ShopNotifier extends StateNotifier<ShopState> {
  ShopNotifier() : super(const ShopState());

  void setTab(int index) => state = state.copyWith(activeTabIndex: index);
  void setFeaturedIndex(int index) =>
      state = state.copyWith(featuredIndex: index);

  void updateScroll(double offset) {
    state = state.copyWith(scrollOffset: offset);
    if (offset < 0) {
      final absOffset = offset.abs();
      final percentage = (absOffset / 60).clamp(0.0, 1.0);
      state = state.copyWith(pullDownPercentage: percentage);
      if (absOffset > 40 && !state.isTagsVisible) {
        state = state.copyWith(isTagsVisible: true);
      }
    } else {
      state = state.copyWith(pullDownPercentage: 0.0);
      if (offset > 120 && state.isTagsVisible) {
        state = state.copyWith(isTagsVisible: false);
      }
    }
  }

  void setPullDown(double percentage) =>
      state = state.copyWith(pullDownPercentage: percentage);

  void setSearchActive(bool active) =>
      state = state.copyWith(isSearchActive: active);
}

final shopProvider = StateNotifierProvider<ShopNotifier, ShopState>((ref) {
  return ShopNotifier();
});
