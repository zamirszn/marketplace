import 'package:bloc/bloc.dart';
import 'package:marketplace/app/functions.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<UsernameChanged>(_onUsernameChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  void _onTogglePasswordVisibility(
      TogglePasswordVisibility event, Emitter<LoginState> emit) {
    final currentState = state;

    if (currentState is LoginFormUpdate) {
      emit(LoginFormUpdate(
        isUsernameValid: currentState.isUsernameValid,
        isPasswordValid: currentState.isPasswordValid,
        isPasswordVisible:
            !currentState.isPasswordVisible, // Toggle the visibility
      ));
    }
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    final currentState = state;

    if (currentState is LoginFormUpdate &&
        currentState.isUsernameValid &&
        currentState.isPasswordValid) {
      emit(LoginLoading());

      // Simulating a login process
      await Future.delayed(const Duration(seconds: 2));

      // In a real scenario, call an authentication API here
      const success = true; // Mocking a successful login response

      if (success == true) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure("Invalid username or password"));
      }
    }
  }

  void _onUsernameChanged(UsernameChanged event, Emitter<LoginState> emit) {
    final isUsernameValid = validateUsername(event.username);
    final currentState = state;

    if (currentState is LoginInitial || currentState is LoginFormUpdate) {
      emit(LoginFormUpdate(
        isUsernameValid: isUsernameValid,
        isPasswordValid: (currentState is LoginFormUpdate)
            ? currentState.isPasswordValid
            : true,
        isPasswordVisible: (currentState is LoginFormUpdate)
            ? currentState.isPasswordVisible
            : false,
      ));
    }
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final isPasswordValid = validatePassword(event.password);
    final currentState = state;

    if (currentState is LoginInitial || currentState is LoginFormUpdate) {
      emit(LoginFormUpdate(
        isUsernameValid: (currentState is LoginFormUpdate)
            ? currentState.isUsernameValid
            : true,
        isPasswordValid: isPasswordValid,
        isPasswordVisible: (currentState is LoginFormUpdate)
            ? currentState.isPasswordVisible
            : false,
      ));
    }
  }
}
