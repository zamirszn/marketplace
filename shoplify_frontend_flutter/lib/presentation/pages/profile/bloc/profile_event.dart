part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class GetProfileEvent extends ProfileEvent{}
final class ResetProfileEvent extends ProfileEvent{}



