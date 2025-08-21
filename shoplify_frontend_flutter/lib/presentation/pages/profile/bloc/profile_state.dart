// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure }
enum UpdateProfileStatus { initial, loading, success, failure }
enum UpdateNotificationStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileModel? profile;
  final ProfileStatus profileStatus;
  final UpdateProfileStatus updateProfileStatus;
  final UpdateNotificationStatus updateNotificationStatus;
  final String? successMessage;
  final String? errorMessage;

  const ProfileState({
    this.profile,
    this.profileStatus = ProfileStatus.initial,
    this.successMessage,
    this.errorMessage,
    this.updateProfileStatus = UpdateProfileStatus.initial,
    this.updateNotificationStatus = UpdateNotificationStatus.initial
  });

  @override
  List<Object?> get props => [
        profile,
        profileStatus,
        successMessage,
        errorMessage,
        updateProfileStatus,
        updateNotificationStatus,
      ];

  ProfileState copyWith({
    ProfileModel? profile,
    ProfileStatus? profileStatus,
    String? successMessage,
    String? errorMessage,
    UpdateProfileStatus? updateProfileStatus,
    UpdateNotificationStatus? updateNotificationStatus
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      profileStatus: profileStatus ?? this.profileStatus,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      updateProfileStatus: updateProfileStatus ?? this.updateProfileStatus,
      updateNotificationStatus: updateNotificationStatus ?? this.updateNotificationStatus,
    );
  }
}
