part of 'review_bloc.dart';

@immutable
sealed class ReviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ReviewInitial extends ReviewState {}

final class GetReviewLoadingState extends ReviewState {}

final class GetReviewFailureState extends ReviewState {
  final String message;

  GetReviewFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}

final class GetReviewSuccessState extends ReviewState {
  final List<ReviewModelEntity> reviews;

  GetReviewSuccessState({required this.reviews});
}
