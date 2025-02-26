part of 'countdown_bloc.dart';

@immutable
sealed class CountdownEvent {}

final class CountdownStartEvent extends CountdownEvent {}

final class CountdownStopEvent extends CountdownEvent {}

final class CountdownTickEvent extends CountdownEvent {
  final int secondsRemaining;

  CountdownTickEvent({required this.secondsRemaining});
}

final class CountdownFinishedEvent extends CountdownEvent {
  
}
