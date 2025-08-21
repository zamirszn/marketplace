import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/response_models.dart';
import 'package:shoplify/domain/usecases/auth_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<ResetProfileEvent>((event, emit) async {
      emit(const ProfileState());
    });

    on<UpdateNotificationEvent>((event, emit) async {
      emit(state.copyWith(
          updateNotificationStatus: UpdateNotificationStatus.loading));

      final Either response =
          await sl<UpdateProfileUseCase>().call(params: event.params);

      response.fold((error) {
        emit(state.copyWith(
            errorMessage: error,
            updateNotificationStatus: UpdateNotificationStatus.failure));
      }, (data) {
        final ProfileModel profileResponse = ProfileModel.fromMap(data);
        emit(state.copyWith(
          profile: profileResponse,
          updateNotificationStatus: UpdateNotificationStatus.success,
        ));
      });
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(state.copyWith(updateProfileStatus: UpdateProfileStatus.loading));

      final Either response =
          await sl<UpdateProfileUseCase>().call(params: event.params);

      response.fold((error) {
        emit(state.copyWith(
            errorMessage: error,
            updateProfileStatus: UpdateProfileStatus.failure));
      }, (data) {
        final ProfileModel profileResponse = ProfileModel.fromMap(data);
        emit(state.copyWith(
          profile: profileResponse,
          updateProfileStatus: UpdateProfileStatus.success,
        ));
      });
    });

    on<GetProfileEvent>((event, emit) async {
      emit(
        state.copyWith(profileStatus: ProfileStatus.loading),
      );

      Either response = await sl<GetProfileUseCase>().call();

      response.fold((error) {
        emit(
          state.copyWith(
              profileStatus: ProfileStatus.failure, errorMessage: error),
        );
      }, (data) {
        final ProfileModel profileResponse = ProfileModel.fromMap(data);
        emit(state.copyWith(
          profile: profileResponse,
          profileStatus: ProfileStatus.success,
        ));
      });
    });
  }
}
