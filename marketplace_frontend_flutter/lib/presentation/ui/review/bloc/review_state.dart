part of 'review_bloc.dart';

enum ReviewStatus { initial, success, failure }

final class ReviewState extends Equatable {
  const ReviewState(
      {this.status = ReviewStatus.initial,
      this.reviews = const <ReviewModelEntity>[],
      this.hasReachedMax = false,
      this.isFetching = false,
      this.page = 1,
      this.errorMessage,
      // this.sortBy,
      this.selectedOption});

  final ReviewStatus status;
  final List<ReviewModelEntity> reviews;
  final bool hasReachedMax;
  final String? errorMessage;
  final bool isFetching;
  final int page;
  final String? selectedOption;

  // final String? sortBy;

  ReviewState copyWith({
    ReviewStatus? status,
    List<ReviewModelEntity>? reviews,
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
