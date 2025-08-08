import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/params_models.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<OrderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

