import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/review_param_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/domain/entities/review_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/review/bloc/review_bloc.dart';
import 'package:shoplify/presentation/widgets/back_button.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';
import 'package:shoplify/presentation/widgets/error_message_widget.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/presentation/widgets/retry_button.dart';
import 'package:shoplify/presentation/widgets/star_rating/star_rating_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key, required this.product});
  final ProductModelEntity product;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ReviewBloc>().add(GetProductReviewEvent(
            params: ReviewParamModel(productId: widget.product.id!),
          ));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> sortOptions = [
      'Newest',
      'Oldest',
      "5 stars",
      "4 stars",
      "3 stars",
      "2 stars",
      "1 stars",
    ];
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: const Padding(
            padding: EdgeInsets.all(AppPadding.p10),
            child: GoBackButton(),
          ),
          title: Text(
            AppStrings.reviews,
            style: getRegularStyle(
                font: FontConstants.ojuju, fontSize: FontSize.s20),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ReviewBloc>().add(RefreshProductReviewEvent(
                  params:
                      ReviewParamModel(productId: widget.product.id!, page: 1),
                ));
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              sliverSpace(h: AppSize.s10),
              // review summary
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p12, vertical: AppPadding.p10),
                sliver: SliverToBoxAdapter(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.s20),
                      child: ColoredBox(
                          color: ColorManager.lemon,
                          child: BlocBuilder<ReviewBloc, ReviewState>(
                            builder: (context, state) {
                              switch (state.status) {
                                case ReviewStatus.success:
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: AppPadding.p10,
                                        horizontal: AppPadding.p10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: AppPadding.p5,
                                                  left: AppPadding.p5),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  AppStrings.reviews,
                                                  style: getMediumStyle(
                                                      fontSize: FontSize.s14),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  widget.product.averageRating
                                                          ?.toString() ??
                                                      "0",
                                                  style: getRegularStyle(
                                                      fontSize: FontSize.s30,
                                                      font:
                                                          FontConstants.ojuju),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 4),
                                                  child: Text(
                                                    "/5",
                                                    style: getRegularStyle(
                                                        fontSize: FontSize.s16,
                                                        font: FontConstants
                                                            .ojuju),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            space(h: AppSize.s4),
                                            Text(
                                              "${AppStrings.basedOn} ${widget.product.reviewsLength} ${AppStrings.reviews}",
                                              style: getLightStyle(
                                                  fontSize: FontSize.s12,
                                                  color: ColorManager.darkBlue,
                                                  font: FontConstants.poppins),
                                            ),
                                            space(h: AppSize.s12),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: AppPadding.p10),
                                              child: Transform.scale(
                                                scale: 1.4,
                                                child: StarRatingWidget(
                                                  rating: widget.product
                                                          .averageRating ??
                                                      0,
                                                ),
                                              ),
                                            ),
                                            space(h: AppSize.s10),
                                          ],
                                        ),
                                        const Column(
                                          children: [
                                            // ratingbar
                                            RatingBar(
                                              ratingText: 5,
                                            ),
                                            RatingBar(
                                              ratingText: 4,
                                            ),
                                            RatingBar(
                                              ratingText: 3,
                                            ),
                                            RatingBar(
                                              ratingText: 2,
                                            ),
                                            RatingBar(
                                              ratingText: 1,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );

                                default:
                                  return const SizedBox();
                              }
                            },
                          ))),
                ),
              ),

              // add a review
              SliverToBoxAdapter(
                child: SizedBox(
                  child: BlocBuilder<ReviewBloc, ReviewState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case ReviewStatus.success:
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.p10,
                                vertical: AppSize.s6),
                            child: InkWell(
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  goPush(context, Routes.addReviewPage,
                                      extra: widget.product);
                                },
                                child: const AddReviewWidget()),
                          );
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
              sliverSpace(h: AppSize.s10),
              // review sort
              SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.p5,
                    horizontal: AppPadding.p12,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: BlocBuilder<ReviewBloc, ReviewState>(
                      builder: (context, state) {
                        switch (state.status) {
                          case ReviewStatus.success:
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.reviews,
                                  style: getMediumStyle(fontSize: FontSize.s14),
                                ),
                                const Expanded(child: SizedBox()),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  onTap: () {
                                    showBottomSheet(
                                        context: context,
                                        // isDismissible: true,
                                        showDragHandle: true,
                                        enableDrag: true,

                                        // isScrollControlled: true,

                                        builder: (context) =>
                                            ReviewSortBottomSheet(
                                                sortOptions: sortOptions,
                                                product: widget.product));
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.sort_rounded,
                                        size: AppSize.s18,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppPadding.p10,
                                            vertical: AppPadding.p5),
                                        child: Text(
                                          state.selectedOption ?? "Oldest",
                                          style: getLightStyle(
                                              fontSize: FontSize.s14),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: AppSize.s20,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );

                          default:
                            return const SizedBox();
                        }
                      },
                    ),
                  )),
              // review list
              SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      width: deviceWidth(context),
                      margin:
                          const EdgeInsets.symmetric(horizontal: AppMargin.m12),
                      decoration: BoxDecoration(
                        color: ColorManager.lemon,
                        borderRadius: BorderRadius.circular(AppSize.s20),
                      ),
                      child: BlocBuilder<ReviewBloc, ReviewState>(
                        builder: (context, state) {
                          switch (state.status) {
                            case ReviewStatus.initial:
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                scrollDirection: Axis.vertical,
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return const ReviewWidgetSkeleton();
                                },
                              );

                            case ReviewStatus.failure:
                              return ErrorMessageWidget(
                                message: state.errorMessage,
                                retry: () {
                                  context
                                      .read<ReviewBloc>()
                                      .add(RefreshProductReviewEvent(
                                        params: ReviewParamModel(
                                          productId: widget.product.id!,
                                          page: 1,
                                        ),
                                      ));
                                },
                              );

                            case ReviewStatus.success:
                              if (state.reviews.isEmpty) {
                                return SizedBox(
                                    height: deviceHeight(context) / 4,
                                    child: const Center(
                                        child: EmptyWidget(
                                      message: AppStrings.noReviews,
                                      icon: Icon(
                                        Iconsax.star,
                                      ),
                                    )));
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                scrollDirection: Axis.vertical,
                                itemCount: state.hasReachedMax
                                    ? state.reviews.length
                                    : state.reviews.length + 1,
                                itemBuilder: (context, index) {
                                  if (index >= state.reviews.length) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: AppPadding.p20),
                                      child: Center(
                                        child: Transform.scale(
                                            scale: .7,
                                            child: const LoadingWidget()),
                                      ),
                                    );
                                  } else {
                                    ReviewModelEntity productReview =
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
                                                      productReview.owner
                                                              ?.fullName ??
                                                          "",
                                                      style: getMediumStyle(
                                                          fontSize:
                                                              FontSize.s14),
                                                    ),
                                                    Text(
                                                      productReview.review ??
                                                          "",
                                                      style: getRegularStyle(),
                                                    ),
                                                    space(h: AppSize.s8),
                                                    Text(
                                                      "Posted ${formatDateDDMMMYYY(
                                                        productReview
                                                                .dateCreated ??
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
                                                    productReview.rating
                                                            ?.toString() ??
                                                        "0",
                                                    style: getRegularStyle(
                                                        fontSize: FontSize.s20,
                                                        font: FontConstants
                                                            .ojuju),
                                                  ),
                                                  space(h: AppSize.s10),
                                                  StarRatingWidget(
                                                    rating:
                                                        productReview.rating ??
                                                            0,
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
                                              color: ColorManager.darkBlue,
                                              thickness: AppSize.s1,
                                            ),
                                          )
                                        else
                                          space(h: AppSize.s10)
                                      ],
                                    );
                                  }
                                },
                              );
                          }
                        },
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}

class ReviewSortBottomSheet extends StatelessWidget {
  const ReviewSortBottomSheet({
    super.key,
    required this.sortOptions,
    required this.product,
  });

  final List<String> sortOptions;
  final ProductModelEntity product;

  @override
  Widget build(BuildContext context) {
    final reviewBloc = context.read<ReviewBloc>();
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const GoBackButton(
                    padding: EdgeInsets.all(AppPadding.p8),
                  ),
                  Center(
                    child: Text('Sort',
                        textAlign: TextAlign.center,
                        style: getMediumStyle(
                            font: FontConstants.ojuju, fontSize: FontSize.s20)),
                  ),
                  space(w: AppSize.s36)
                ],
              ),
              space(h: AppSize.s20),
              ...sortOptions.map((option) => RadioListTile<String>(
                    contentPadding: const EdgeInsets.only(left: AppPadding.p2),
                    activeColor: ColorManager.darkBlue,
                    title: Text(
                      option,
                      style: getRegularStyle(fontSize: FontSize.s14),
                    ),
                    value: option,
                    selected: option == reviewBloc.state.selectedOption,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.s10)),
                    groupValue: reviewBloc.state.selectedOption,
                    onChanged: (value) {
                      if (value != null) {
                        reviewBloc.add(ReviewSelectSortEvent(
                          selectedOption: value,
                        ));
                      }
                    },
                  )),
              space(h: AppSize.s40),
              SizedBox(
                height: AppSize.s50,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s20)),
                      shadowColor: Colors.transparent,
                      foregroundColor: ColorManager.black,
                      backgroundColor: ColorManager.darkBlue,
                    ),
                    onPressed: () {
                      reviewBloc.add(ShowLoadingReviewEvent());

                      final rating = sortReviewsByStar(state.selectedOption);
                      final ordering = sortReviewByDate(state.selectedOption);

                      ReviewParamModel params = ReviewParamModel(
                          rating: rating,
                          page: 1,
                          ordering: ordering,
                          productId: product.id!);

                      reviewBloc.add(GetProductReviewEvent(params: params));
                      goPopRoute(context);
                    },
                    child: Text(
                      AppStrings.done,
                      style: getRegularStyle(
                          font: FontConstants.ojuju, fontSize: FontSize.s18),
                    )),
              ),
              space(h: AppSize.s10),
            ],
          ),
        );
      },
    );
  }
}

class RatingBar extends StatelessWidget {
  const RatingBar({
    super.key,
    required this.ratingText,
  });
  final int ratingText;

  @override
  Widget build(BuildContext context) {
    final reviewBloc = context.read<ReviewBloc>();

    final percentage =
        calculateRatingPercentage(reviewBloc.state.reviews, ratingText);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 45,
          child: Text(
            "$ratingText star",
            textAlign: TextAlign.end,
            style: getLightStyle(fontSize: FontSize.s14),
          ),
        ),
        space(w: AppSize.s8),
        Stack(
          children: [
            // bottom
            Container(
              decoration: BoxDecoration(
                color: ColorManager.darkBlue,
                borderRadius: BorderRadius.circular(AppSize.s10),
              ),
              height: AppSize.s8,
              width: deviceWidth(context) * .2,
            ),
            // top
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s10),
                color: ColorManager.darkBlue,
              ),
              height: AppSize.s8,
              width: deviceWidth(context) * .2 * percentage / 100,
            ),
          ],
        )
      ],
    );
  }
}

class AddReviewWidget extends StatelessWidget {
  const AddReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSize.s10),
      child: ColoredBox(
        color: ColorManager.lemon,
        child: const Column(
          children: [
            ListTile(
              minTileHeight: AppSize.s70,
              leading: Icon(Iconsax.message_edit),
              title: Text("Add review"),
              trailing: Icon(Iconsax.arrow_right),
            ),
          ],
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
                  const Skeletonizer(child: StarRatingWidget(rating: 0)),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          child: Divider(
            color: ColorManager.darkBlue,
            thickness: AppSize.s1,
          ),
        )
      ],
    );
  }
}
