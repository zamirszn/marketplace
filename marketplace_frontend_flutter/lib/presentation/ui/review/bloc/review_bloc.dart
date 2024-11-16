import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/models/review_model.dart';
import 'package:marketplace/data/models/review_param_model.dart';
import 'package:marketplace/domain/entities/review_entity.dart';
import 'package:marketplace/domain/usecases/products_usecase.dart';
import 'package:marketplace/presentation/service_locator.dart';
import 'package:meta/meta.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(ReviewInitial()) {
    on<GetProductReviewEvent>(_getProductReview);
  }

  _getProductReview(
      GetProductReviewEvent event, Emitter<ReviewState> emit) async {
    emit(GetReviewLoadingState());
    Either response = await sl<GetReviewsUseCase>().call(params: event.params);
    response.fold((error) {
      emit(GetReviewFailureState(message: error));
    }, (data) {
      List<ReviewModelEntity> reviews = List.from(data["results"])
          .map((e) => ReviewModel.fromMap(e).toEntity())
          .toList();
      emit(GetReviewSuccessState(reviews: reviews));
    });
  }
}
