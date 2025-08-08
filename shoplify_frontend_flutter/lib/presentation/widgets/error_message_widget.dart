import 'package:flutter/material.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/retry_button.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    super.key,
    this.message,
    required this.retry,
  });

  final String? message;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p40),
      child: Center(
        child: SizedBox(
          height: AppSize.s250,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
              child: RetryButton(message: message, retry: () => retry()),
            ),
          ),
        ),
      ),
    );
  }
}
