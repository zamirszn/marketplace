import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/presentation/pages/home/filter_bottom_sheet/bloc/filter_bottomsheet_bloc.dart';
import 'package:shoplify/presentation/pages/home/filter_bottom_sheet/filter_bottom_sheet.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';

class FilterProductsButton extends StatelessWidget {
  const FilterProductsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<FilterBottomsheetBloc, FilterBottomsheetState>(
      builder: (context, state) {
        return Badge(
          smallSize: AppSize.s12,
          alignment: const AlignmentDirectional(1, -1.3),
          backgroundColor: colorScheme.tertiary,
          isLabelVisible: state.isFilterEnabled,
          child: const RoundFilterProductsButton(),
        );
      },
    );
  }
}

class RoundFilterProductsButton extends StatelessWidget {
  const RoundFilterProductsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RoundCorner(
      child: IconButton(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            showModalBottomSheet(
              showDragHandle: true,
              enableDrag: true,
              isScrollControlled: true,
              context: context,
              builder: (context) => const FilterBottomSheet(),
            );
          },
          icon: const Icon(Iconsax.setting_4)),
    );
  }
}
