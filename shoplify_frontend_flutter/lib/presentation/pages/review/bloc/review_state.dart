part of 'review_bloc.dart';

enum ReviewStatus { initial, success, failure }

final class ReviewState extends Equatable {
  const ReviewState(
      {this.status = ReviewStatus.initial,
      this.reviews = const <Review>[],
      this.hasReachedMax = false,
      this.isFetching = false,
      this.page = 1,
      this.errorMessage,
      // this.sortBy,
      this.selectedOption});

  final ReviewStatus status;
  final List<Review> reviews;
  final bool hasReachedMax;
  final String? errorMessage;
  final bool isFetching;
  final int page;
  final String? selectedOption;

  ReviewState copyWith({
    ReviewStatus? status,
    List<Review>? reviews,
    bool? hasReachedMax,
    String? errorMessage,
    bool? isFetching,
    int? page,
    String? selectedOption,
    // String? sortBy,
  }) {
    return ReviewState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetching: isFetching ?? this.isFetching,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
      // sortBy: sortBy ?? this.sortBy,
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }

  @override
  List<Object?> get props => [
        status,
        reviews,
        hasReachedMax,
        isFetching,
        page,
        // sortBy,
        selectedOption
      ];
}

final class SubmitReviewLoadingState extends ReviewState {}

final class SubmitReviewFailureState extends ReviewState {
  final String message;

  const SubmitReviewFailureState({required this.message});
}

final class SubmitReviewSuccessState extends ReviewState {}
