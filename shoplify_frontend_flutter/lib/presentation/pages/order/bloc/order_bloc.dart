import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/models/response_models.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderState()) {
    on<SetMyOrderFilter>((event, emit) {
      emit(state.copyWith(
          isFetching: false,
          hasReachedMax: false,
          page: 1,
          myOrderStatus: MyOrderStatus.initial,
          myOrderData: [],
          selectedMyOrderFilter: event.myOrderFilter));
    });

    on<GetMyOrder>((event, emit) async {
      if (state.isFetching || state.hasReachedMax) {
        return;
      }
      emit(state.copyWith(
        isFetching: true,
      ));

      final Either response =
          await sl<GetMyOrderUseCase>().call(params: event.params);

      response.fold(
        (error) {
          emit(state.copyWith(
              isFetching: false,
              hasReachedMax: false,
              errorMessage: error,
              myOrderStatus: MyOrderStatus.failure));
        },
        (data) {
          final MyOrderResponseModel reponse =
              MyOrderResponseModel.fromMap(data);
          final String? nextPage = reponse.next;
          final List<MyOrderData>? fetchedMyOrderData = reponse.results;

          if (fetchedMyOrderData != null && fetchedMyOrderData.isEmpty) {
            emit(state.copyWith(
              myOrderStatus: MyOrderStatus.success,
              hasReachedMax: true,
              isFetching: false,
            ));
            return;
          }

          emit(state.copyWith(
            myOrderStatus: MyOrderStatus.success,

            myOrderData: [...state.myOrderData, ...fetchedMyOrderData ?? []],
            page: state.page + 1, // Increment page here
            hasReachedMax: nextPage != null ? false : true,
            isFetching: false, // Stop fetching
          ));
          return;
        },
      );
    });
  }
}
