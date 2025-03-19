import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavInitial()) {
    on<BottomNavChangedEvent>(_onBottomNavChangeEvent);
  }

  void _onBottomNavChangeEvent(
    BottomNavChangedEvent event,
    Emitter<BottomNavState> emit,
  ) {
    emit(BottomNavChangedState(event.index));
  }
}
