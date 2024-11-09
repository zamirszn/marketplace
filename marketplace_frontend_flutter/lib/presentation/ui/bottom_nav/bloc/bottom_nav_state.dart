part of 'bottom_nav_bloc.dart';



@immutable
sealed class BottomNavState extends Equatable {
  final int selectedIndex;

  const BottomNavState(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}

final class BottomNavInitial extends BottomNavState {
  const BottomNavInitial() : super(0);
}

final class BottomNavChangedState extends BottomNavState {
  const BottomNavChangedState(super.selectedIndex);
}
