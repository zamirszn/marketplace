part of 'countdown_bloc.dart';

abstract class CountdownState extends Equatable {
  final int secondsRemaining;

  const CountdownState({required this.secondsRemaining});

  @override
  List<Object?> get props => [secondsRemaining];
}

final class CountdownInitial extends CountdownState {
  const CountdownInitial({required super.secondsRemaining});
}

final class CountdownRunning extends CountdownState {
  const CountdownRunning({required super.secondsRemaining});
}

final class CountdownStopped extends CountdownState {
  const CountdownStopped({required super.secondsRemaining});
}

final class CountdownFinished extends CountdownState {
  CountdownFinished() : super(secondsRemaining: Constant.otpCountdown);
}
