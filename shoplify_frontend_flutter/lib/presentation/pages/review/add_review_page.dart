import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/review_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/review/bloc/review_bloc.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';
import 'package:shoplify/presentation/widgets/star_rating/interactive_star_rating_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({super.key, required this.product});
  final ProductModelEntity product;

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final reviewTextController = TextEditingController();

  @override
  void dispose() {
    reviewTextController.dispose();
    super.dispose();
  }

  num? currentStarRating;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewBloc(),
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(AppPadding.p10),
              child: GoBackButton(
                backgroundColor: ColorManager.lightGrey,
              ),
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
                          imageUrl: widget.product.images.isNotEmpty
                              ? widget.product.images.first.image!
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
                              widget.product.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getMediumStyle(),
                            ),
                            space(h: AppSize.s20),
                            Text(
                              widget.product.description ?? "",
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
                    color: ColorManager.lightGrey,
                  ),
                  space(h: AppSize.s10),
                  Text(
                    AppStrings.leaveARating,
                    style: getLightStyle(
                      fontSize: FontSize.s14,
                    ),
                  ),
                  space(h: AppSize.s20),
                  Transform.scale(
                      scale: 2,
                      child: InteractiveStarRatingWidget(
                        onRatingChanged: (value) {
                          currentStarRating = value;
                        },
                      )),
                  space(h: AppSize.s20),
                  Divider(
                    color: ColorManager.lightGrey,
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
                  TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppStrings.enterReview;
                        }
                        return null;
                      },
                      controller: reviewTextController,
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
                  space(h: AppSize.s80),
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
                child: BlocListener<ReviewBloc, ReviewState>(
                  listener: (context, state) {
                    if (state is SubmitReviewFailureState) {
                      showErrorMessage(context, state.message);
                    } else if (state is SubmitReviewSuccessState) {
                      showMessage(context, AppStrings.reviewSubmitted);
                    }
                  },
                  child: BlocBuilder<ReviewBloc, ReviewState>(
                    builder: (context, state) {
                      if (state is SubmitReviewLoadingState) {
                        return ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSize.s20)),
                            shadowColor: Colors.transparent,
                            foregroundColor: ColorManager.black,
                            backgroundColor: ColorManager.grey,
                          ),
                          child: Transform.scale(
                              scale: .85, child: const LoadingWidget()),
                        );
                      }
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSize.s20)),
                            shadowColor: Colors.transparent,
                            foregroundColor: ColorManager.black,
                            backgroundColor: ColorManager.grey,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ReviewBloc>().add(SubmitReviewEvent(
                                    params: SubmitReviewModel(
                                        productId: widget.product.id!,
                                        rating: currentStarRating,
                                        review: reviewTextController.text),
                                  ));
                            }
                          },
                          child: Text(
                            AppStrings.submitReview,
                            style: getRegularStyle(
                                font: FontConstants.ojuju,
                                fontSize: FontSize.s18),
                          ));
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
