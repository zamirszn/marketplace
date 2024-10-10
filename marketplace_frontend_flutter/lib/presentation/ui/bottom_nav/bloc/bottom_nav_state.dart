part of 'bottom_nav_bloc.dart';

@immutable
sealed class BottomNavState {
  final int selectedIndex;

  const BottomNavState(this.selectedIndex);
}

final class BottomNavInitial extends BottomNavState {
  const BottomNavInitial() : super(0);
}

final class BottomNavChangedState extends BottomNavState {
  const BottomNavChangedState(super.newIndex);
}
