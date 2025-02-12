import 'package:flutter/material.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSize.s10),
      child: ColoredBox(
        color: ColorManager.primary,
        child: SizedBox(
          height: deviceHeight(context) / 3,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RetryButton(message: message, retry: () => retry()),
            ),
          ),
        ),
      ),
    );
  }
}
