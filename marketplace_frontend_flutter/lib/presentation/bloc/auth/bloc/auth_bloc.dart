import 'package:bloc/bloc.dart';
import 'package:marketplace/domain/usecases/signup_usecase.dart';
import 'package:marketplace/presentation/service_locator.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStartedEvent>(_onAppStartEvent);
  }

  void _onAppStartEvent(AppStartedEvent event, Emitter<AuthState> emit) async {
    var isUserLoggedIn = await sl<IsLoggedInUseCase>().call();
    if (isUserLoggedIn) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }
}
