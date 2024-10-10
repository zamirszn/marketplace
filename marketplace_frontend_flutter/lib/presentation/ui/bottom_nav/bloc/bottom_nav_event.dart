part of 'bottom_nav_bloc.dart';

@immutable
sealed class BottomNavEvent {}

final class BottomNavChangedEvent extends BottomNavEvent {
  final int index;

  BottomNavChangedEvent({required this.index});
}
