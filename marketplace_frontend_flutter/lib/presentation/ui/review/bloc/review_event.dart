part of 'review_bloc.dart';

@immutable
sealed class ReviewEvent {}

class GetProductReviewEvent extends ReviewEvent {
  final ReviewParamModel params;

  GetProductReviewEvent({required this.params});
}
