import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shoplify/data/models/review_model.dart';
import 'package:shoplify/data/models/review_param_model.dart';
import 'package:shoplify/domain/entities/review_entity.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';
import 'package:meta/meta.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(const ReviewState()) {
    on<GetProductReviewEvent>(_getProductReview);
    on<RefreshProductReviewEvent>(_refreshProductReview);
    on<ReviewSelectSortEvent>(_onSelectSortOption);
    on<ShowLoadingReviewEvent>(_onShowReviewsLoading);
    on<SubmitReviewEvent>(_onSubmitReview);
  }

  void _onSubmitReview(
      SubmitReviewEvent event, Emitter<ReviewState> emit) async {
    emit(SubmitReviewLoadingState());

    final Either response =
        await sl<SubmitReviewUsecase>().call(params: event.params);

    response.fold((error) {
      emit(SubmitReviewFailureState(message: error.toString()));
    }, (data) {
      emit(SubmitReviewSuccessState());
    });
  }

  void _onSelectSortOption(
      ReviewSelectSortEvent event, Emitter<ReviewState> emit) {
    emit(state.copyWith(selectedOption: event.selectedOption, page: 1));
  }

  // dont call this , except you understand when and how its used
  // this is used to force the loading screen to show when a user
  // click on the sort bottomsheet
  void _onShowReviewsLoading(
      ShowLoadingReviewEvent event, Emitter<ReviewState> emit) {
    emit(state.copyWith(
        hasReachedMax: false, isFetching: false, status: ReviewStatus.initial));
  }

  Future<void> _refreshProductReview(
      RefreshProductReviewEvent event, Emitter<ReviewState> emit) async {
    if (state.isFetching) {
      return;
    }
    emit(state.copyWith(
      selectedOption: "Oldest",
      isFetching: true,
      errorMessage: null,
      page: 1,
      reviews: [],
      hasReachedMax: false,
      status: ReviewStatus.initial,
    )); // Start fetching

    final Either response =
        await sl<GetReviewsUseCase>().call(params: event.params);

    response.fold(
      (error) {
        // Handle failure, no page increment
        emit(state.copyWith(
            errorMessage: error.toString(),
            isFetching: false,
            hasReachedMax: false,
            status: ReviewStatus.failure

            // Stop fetching
            ));
      },
      (data) {
        // if the page index doesnt exist
        final List<ReviewModelEntity> fetchedReviews =
            List.from(data["results"])
                .map((e) => ReviewModel.fromMap(e).toEntity())
                .toList();

        // If no reviews are fetched, stop pagination
        if (fetchedReviews.isEmpty) {
          emit(state.copyWith(
            status: ReviewStatus.success,
            hasReachedMax: true,
            isFetching: false,
          ));
          return;
        }

        emit(state.copyWith(
          status: ReviewStatus.success,
          reviews: fetchedReviews,
          page: state.page,
          hasReachedMax: false,
          isFetching: false,
        ));
      },
    );
  }

  Future<void> _getProductReview(
      GetProductReviewEvent event, Emitter<ReviewState> emit) async {
    if (state.isFetching || state.hasReachedMax) {
      return;
    }

    try {
      emit(state.copyWith(
        isFetching: true,
      ));
      ReviewParamModel? requestParams;
      if (state.selectedOption != null) {
        requestParams = ReviewParamModel(
          productId: event.params.productId,
          rating: event.params.rating,

          ordering: event.params.ordering,
          page: event.params.page ??
              state.page, // Use the current page from the state
        );
      } else {
        requestParams = ReviewParamModel(
          productId: event.params.productId,
          page: state.page, // Use the current page from the state
        );
      }
      final Either response =
          await sl<GetReviewsUseCase>().call(params: requestParams);

      response.fold(
        (error) {
          // Handle failure, no page increment
          emit(state.copyWith(
              errorMessage: error.toString(),
              isFetching: false,
              hasReachedMax: false,
              status: ReviewStatus.failure
              // Stop fetching
              ));
        },
        (data) {
          // if the page index doesnt exist

          final String? nextPage = data["next"];

          final List<ReviewModelEntity> fetchedReviews =
              List.from(data["results"])
                  .map((e) => ReviewModel.fromMap(e).toEntity())
                  .toList();

          if (state.selectedOption != null) {
            // for sorted list
            emit(state.copyWith(
              selectedOption: state.selectedOption,
              status: ReviewStatus.success,
              reviews: fetchedReviews,
              page: state.page + 1, // Increment page here
              hasReachedMax: nextPage != null ? false : true,

              isFetching: false,
            ));

            return;
          }

          // If no reviews are fetched, stop pagination
          if (fetchedReviews.isEmpty) {
            emit(state.copyWith(
              status: ReviewStatus.success,
              hasReachedMax: true,
              isFetching: false,
            ));
            return;
          }

          // Increment page only if data is fetched
          emit(state.copyWith(
            status: ReviewStatus.success,
            reviews: [...state.reviews, ...fetchedReviews],
            page: state.page + 1, // Increment page here
            hasReachedMax: nextPage != null ? false : true,
            isFetching: false, // Stop fetching
          ));
          return;
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: ReviewStatus.failure,
        errorMessage: e.toString(),
        isFetching: false, // Stop fetching
      ));
    }
  }
}
