// 2. Navigation State
class NavigationState {
  final int currentIndex;

  NavigationState({required this.currentIndex});

  NavigationState copyWith({int? currentIndex}) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}