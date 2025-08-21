part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class GetProfileEvent extends ProfileEvent {}

final class ResetProfileEvent extends ProfileEvent {}

final class UpdateProfileEvent extends ProfileEvent {
  final ProfileModel params;

  UpdateProfileEvent({required this.params});
}
final class UpdateNotificationEvent extends ProfileEvent {
  final ProfileModel params;

  UpdateNotificationEvent({required this.params});
}
