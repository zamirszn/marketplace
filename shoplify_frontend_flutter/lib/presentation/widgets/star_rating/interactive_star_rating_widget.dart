import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/star_rating/bloc/star_rating_bloc.dart';

class InteractiveStarRatingWidget extends StatelessWidget {
  final ValueChanged<double> onRatingChanged;

  const InteractiveStarRatingWidget({
    super.key,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StarRatingBloc(),
      child: BlocBuilder<StarRatingBloc, StarRatingState>(
        builder: (context, state) {
          List<Widget> stars = [];
          for (int i = 0; i < 5; i++) {
            // Determine if the star is filled
            final isFullStar = i + 1 <= state.rating;

            stars.add(
              GestureDetector(
                onTap: () {
                  double newRating = i + 1.0;
                  context
                      .read<StarRatingBloc>()
                      .add(RatingChangedEvent(newRating));

                  onRatingChanged(newRating);
                },
                onHorizontalDragUpdate: (details) {
                  // Handle sliding to adjust rating
                  RenderBox box = context.findRenderObject() as RenderBox;
                  final localPosition =
                      box.globalToLocal(details.globalPosition);
                  final starWidth = box.size.width / 5;
                  final newRating = (localPosition.dx / starWidth).clamp(0, 5);

                  // Emit the rating change
                  context.read<StarRatingBloc>().add(RatingChangedEvent(
                      double.parse(newRating.toStringAsFixed(1))));
                },
                child: SizedBox(
                  height: AppPadding.p40,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isFullStar ? 1.0 : 3, vertical: 10),
                    child: Icon(
                      isFullStar ? Iconsax.star1 : Iconsax.star,
                      size: isFullStar
                          ? 20
                          : 16, // Bigger size for selected stars
                      color: isFullStar
                          ? ColorManager.darkBlue
                          : ColorManager.black.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: stars,
          );
        },
      ),
    );
  }
}
