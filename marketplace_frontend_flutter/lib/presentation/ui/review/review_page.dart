import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/data/models/review_param_model.dart';
import 'package:marketplace/domain/entities/product_entity.dart';
import 'package:marketplace/domain/entities/review_entity.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/ui/review/bloc/review_bloc.dart';
import 'package:marketplace/presentation/widgets/back_button.dart';
import 'package:marketplace/presentation/widgets/retry_button.dart';
import 'package:marketplace/presentation/widgets/star_rating_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key, required this.product});
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
            "Reviews",
            style: getRegularStyle(
                font: FontConstants.ojuju, fontSize: FontSize.s20),
          ),
        ),
        body: BlocProvider<ReviewBloc>(
          create: (context) => ReviewBloc()
            ..add(GetProductReviewEvent(
              params: ReviewParamModel(productId: product.id!),
            )),
          child: Builder(builder: (context) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ReviewBloc>()
                  ..add(GetProductReviewEvent(
                    params: ReviewParamModel(productId: product.id!),
                  ));
              },
              child: CustomScrollView(
                slivers: [
                  sliverSpace(h: AppSize.s10),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p12, vertical: AppPadding.p10),
                    sliver: SliverToBoxAdapter(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSize.s20),
                          child: ColoredBox(
                              color: ColorManager.primary,
                              child: BlocBuilder<ReviewBloc, ReviewState>(
                                builder: (context, state) {
                                  if (state is GetReviewSuccessState) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: AppPadding.p10,
                                          horizontal: AppPadding.p10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: AppPadding.p5,
                                                left: AppPadding.p5),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${AppStrings.reviews} (${state.reviews.length})",
                                                style: getMediumStyle(
                                                    fontSize: FontSize.s14),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            product.averageRating?.toString() ??
                                                "0",
                                            style: getRegularStyle(
                                                fontSize: FontSize.s20,
                                                font: FontConstants.ojuju),
                                          ),
                                          space(h: AppSize.s3),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Transform.scale(
                                                scale: 1.4,
                                                child: StarRating(
                                                  rating:
                                                      product.averageRating ??
                                                          0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          space(h: AppSize.s10),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ))),
                    ),
                  ),
                  sliverSpace(h: AppSize.s2),
                  SliverPadding(
                      padding: EdgeInsets.symmetric(vertical: AppPadding.p10),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          width: deviceWidth(context),
                          margin:
                              EdgeInsets.symmetric(horizontal: AppMargin.m12),
                          decoration: BoxDecoration(
                            color: ColorManager.primary,
                            borderRadius: BorderRadius.circular(AppSize.s20),
                          ),
                          child: BlocBuilder<ReviewBloc, ReviewState>(
                            builder: (context, state) {
                              if (state is GetReviewLoadingState) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.all(0),
                                  scrollDirection: Axis.vertical,
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return ReviewWidgetSkeleton();
                                  },
                                );
                              } else if (state is GetReviewFailureState) {
                                return ReviewErrorWidget(
                                  productId: product.id!,
                                  message: state.message,
                                );
                              } else if (state is GetReviewSuccessState) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.all(0),
                                  scrollDirection: Axis.vertical,
                                  itemCount: state.reviews.length,
                                  itemBuilder: (context, index) {
                                    ReviewModelEntity review =
                                        state.reviews[index];

                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: AppPadding.p16,
                                                    top: AppPadding.p18,
                                                    bottom: AppPadding.p10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      review.owner?.fullName ??
                                                          "",
                                                      style: getMediumStyle(
                                                          fontSize:
                                                              FontSize.s14),
                                                    ),
                                                    Text(
                                                      review.description ?? "",
                                                      style: getRegularStyle(),
                                                    ),
                                                    space(h: AppSize.s8),
                                                    Text(
                                                      "Posted ${formatDateDDMMMYYY(
                                                        review.dateCreated ??
                                                            DateTime.now(),
                                                      )}",
                                                      style: getLightStyle(
                                                          fontSize:
                                                              FontSize.s10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: AppPadding.p10,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    review.rating?.toString() ??
                                                        "0",
                                                    style: getRegularStyle(
                                                        fontSize: FontSize.s20,
                                                        font: FontConstants
                                                            .ojuju),
                                                  ),
                                                  space(h: AppSize.s10),
                                                  StarRating(
                                                    rating: review.rating ?? 0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (index + 1 != state.reviews.length)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: AppPadding.p20),
                                            child: Divider(
                                              color: ColorManager.primaryLight,
                                              thickness: AppSize.s1,
                                            ),
                                          )
                                        else
                                          space(h: AppSize.s10)
                                      ],
                                    );
                                  },
                                );
                              } else {
                                return ReviewErrorWidget(
                                  productId: product.id!,
                                  message: null,
                                );
                              }
                            },
                          ),
                        ),
                      ))
                ],
              ),
            );
          }),
        ));
  }
}

class ReviewErrorWidget extends StatelessWidget {
  const ReviewErrorWidget({
    super.key,
    required this.productId,
    this.message,
  });

  final String productId;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceHeight(context) / 3,
      child: Center(
        child: RetryButton(
          message: message,
          retry: () {
            context.read<ReviewBloc>()
              ..add(GetProductReviewEvent(
                params: ReviewParamModel(productId: productId),
              ));
          },
        ),
      ),
    );
  }
}

class ReviewWidgetSkeleton extends StatelessWidget {
  const ReviewWidgetSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p16,
                    top: AppPadding.p18,
                    bottom: AppPadding.p10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeletonizer(
                      child: Text(
                        "**********",
                        style: getMediumStyle(fontSize: FontSize.s14),
                      ),
                    ),
                    Skeletonizer(
                      child: Text(
                        "*************************",
                        style: getRegularStyle(),
                      ),
                    ),
                    Skeletonizer(
                      child: Text(
                        "********************",
                        style: getRegularStyle(),
                      ),
                    ),
                    space(h: AppSize.s8),
                    Skeletonizer(
                      child: Text(
                        "*********************",
                        style: getLightStyle(fontSize: FontSize.s10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.p10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Skeletonizer(
                    child: Text(
                      "**",
                      style: getRegularStyle(
                          fontSize: FontSize.s20, font: FontConstants.ojuju),
                    ),
                  ),
                  space(h: AppSize.s10),
                  Skeletonizer(child: StarRating(rating: 0)),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          child: Divider(
            color: ColorManager.primaryLight,
            thickness: AppSize.s1,
          ),
        )
      ],
    );
  }
}
