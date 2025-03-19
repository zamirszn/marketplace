import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/pages/auth/account_verification/bloc/account_verification_bloc.dart';
import 'package:shoplify/presentation/widgets/count_down_widget/bloc/countdown_bloc.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class CountdownWidget extends StatelessWidget {
  const CountdownWidget({super.key, required this.callback});
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    final countdownBloc = BlocProvider.of<CountdownBloc>(context);
    countdownBloc.setCallBack(() => callback());
    return BlocBuilder<CountdownBloc, CountdownState>(
      builder: (context, state) {
        return Text("${state.secondsRemaining} ${AppStrings.seconds}",
            style: getSemiBoldStyle(
                fontSize: FontSize.s14, color: ColorManager.black));
      },
    );
  }
}
