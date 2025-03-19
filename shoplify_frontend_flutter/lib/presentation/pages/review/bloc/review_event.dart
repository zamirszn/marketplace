// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'review_bloc.dart';

@immutable
sealed class ReviewEvent {}

class GetProductReviewEvent extends ReviewEvent {
  final ReviewParamModel params;

  GetProductReviewEvent({required this.params});
}

class RefreshProductReviewEvent extends ReviewEvent {
  final ReviewParamModel params;

  RefreshProductReviewEvent({required this.params});
}

class ReviewSelectSortEvent extends ReviewEvent {
  final String? selectedOption;

  ReviewSelectSortEvent({required this.selectedOption});
}

class ShowLoadingReviewEvent extends ReviewEvent {}

class SubmitReviewEvent extends ReviewEvent {
  final SubmitReviewModel params;
  SubmitReviewEvent({
    required this.params,
  });
}
