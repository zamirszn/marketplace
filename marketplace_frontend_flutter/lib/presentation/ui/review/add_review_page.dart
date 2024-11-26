import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/domain/entities/product_entity.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/widgets/back_button.dart';
import 'package:marketplace/presentation/widgets/star_rating_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddReviewPage extends StatelessWidget {
  const AddReviewPage({super.key, required this.product});
  final ProductModelEntity product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(AppPadding.p10),
          child: GoBackButton(),
        ),
        title: Text(
          AppStrings.addReview,
          style: getRegularStyle(
              font: FontConstants.ojuju, fontSize: FontSize.s20),
        ),
      ),
      backgroundColor: ColorManager.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
          child: Column(
            children: [
              space(h: AppSize.s20),
              Row(
                children: [
                  RoundCorner(
                    child: CachedNetworkImage(
                      imageUrl: product.images.isNotEmpty
                          ? product.images.first.image!
                          : "",
                      height: AppSize.s100,
                      width: AppSize.s100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => SizedBox(
                        child: Container(
                          color: ColorManager.white,
                          height: AppSize.s100,
                          width: AppSize.s100,
                        ),
                      ),
                      errorWidget: (context, url, error) => Skeletonizer(
                          child: Container(
                        color: ColorManager.white,
                        height: AppSize.s100,
                        width: AppSize.s100,
                      )),
                    ),
                  ),
                  space(w: AppSize.s20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getMediumStyle(),
                        ),
                        space(h: AppSize.s20),
                        Text(
                          product.description ?? "",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: getLightStyle(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              space(h: AppSize.s20),
              Divider(
                color: ColorManager.primary,
              ),
              space(h: AppSize.s10),
              Text(
                AppStrings.leaveARating,
                style: getLightStyle(
                  fontSize: FontSize.s14,
                ),
              ),
              space(h: AppSize.s20),
              Transform.scale(scale: 2, child: StarRating(rating: 3.5)),
              space(h: AppSize.s20),
              Divider(
                color: ColorManager.primary,
              ),
              space(h: AppSize.s40),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppStrings.yourReview,
                    style: getRegularStyle(
                      fontSize: FontSize.s14,
                    ),
                  )),
              space(h: AppSize.s20),
              TextField(
                  maxLength: 300,
                  maxLines: 6,
                  minLines: 2,
                  style: getRegularStyle(
                    fontSize: FontSize.s12,
                  ),
                  decoration: InputDecoration(
                    hintText: AppStrings.leaveAYourReview,
                    counterStyle: getMediumStyle(font: FontConstants.ojuju),
                    hintStyle: getLightStyle(),
                  )),
              space(h: AppSize.s40),
            ],
          ),
        ),
      ),
      bottomSheet: ColoredBox(
        color: ColorManager.white,
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: AppPadding.p10,
              left: AppPadding.p10,
              right: AppPadding.p10),
          child: SizedBox(
            height: AppSize.s50,
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.s20)),
                  shadowColor: Colors.transparent,
                  foregroundColor: ColorManager.black,
                  backgroundColor: ColorManager.primaryDark,
                ),
                onPressed: () {},
                child: Text(
                  AppStrings.submitReview,
                  style: getRegularStyle(
                      font: FontConstants.ojuju, fontSize: FontSize.s18),
                )),
          ),
        ),
      ),
    );
  }
}
