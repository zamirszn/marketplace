// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final GetProfileResponseModel? profile;
  final ProfileStatus profileStatus;
  final String? successMessage;
  final String? errorMessage;

  const ProfileState({
    this.profile,
    this.profileStatus = ProfileStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        profile,
        profileStatus,
        successMessage,
        errorMessage,
      ];

  

  ProfileState copyWith({
    GetProfileResponseModel? profile,
    ProfileStatus? profileStatus,
    String? successMessage,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      profileStatus: profileStatus ?? this.profileStatus,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
