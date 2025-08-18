import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/data/models/review_model.dart';
import 'package:shoplify/presentation/pages/home/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/pages/review/bloc/review_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';
import 'package:shoplify/presentation/widgets/star_rating/interactive_star_rating_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({
    super.key,
  });

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
    final colorScheme = Theme.of(context).colorScheme;
    final reviewBloc = context.read<ProductDetailsBloc>();
    final String? productId = reviewBloc.state.selectedProduct?.id;
    final Product? product = reviewBloc.state.selectedProduct;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppStrings.addReview,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              context,
              font: FontConstants.ojuju,
              fontSize: AppSize.s24,
            ),
          ),
          forceMaterialTransparency: true,
          leading: const Padding(
            padding: EdgeInsets.all(AppPadding.p10),
            child: GoBackButton(),
          ),
        ),
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
                        imageUrl: product != null && product.images.isNotEmpty
                            ? product.images.first.image!
                            : "",
                        height: AppSize.s100,
                        width: AppSize.s100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SizedBox(
                          child: Container(
                            color: colorScheme.secondary,
                            height: AppSize.s100,
                            width: AppSize.s100,
                          ),
                        ),
                        errorWidget: (context, url, error) => Skeletonizer(
                            child: Container(
                          color: colorScheme.error,
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
                            product?.name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                getMediumStyle(context, fontSize: FontSize.s18),
                          ),
                          space(h: AppSize.s20),
                          Text(
                            product?.description ?? "",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style:
                                getLightStyle(context, fontSize: FontSize.s14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                space(h: AppSize.s20),
                const Divider(),
                space(h: AppSize.s10),
                Text(
                  AppStrings.leaveARating,
                  style: getMediumStyle(
                    context,
                    fontSize: FontSize.s16,
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
                const Divider(),
                space(h: AppSize.s40),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.yourReview,
                      style: getRegularStyle(
                        context,
                        fontSize: FontSize.s16,
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
                      context,
                      fontSize: FontSize.s16,
                    ),
                    decoration: InputDecoration(
                      hintText: AppStrings.leaveAYourReview,
                      counterStyle:
                          getMediumStyle(context, font: FontConstants.ojuju),
                      hintStyle: getLightStyle(
                        context,
                      ),
                    )),
                space(h: AppSize.s20),
                ColoredBox(
                  color: colorScheme.surface,
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
                          if (state.submitReviewStatus ==
                              SubmitReviewStatus.failure) {
                            if (state.errorMessage != null) {
                              showErrorMessage(context, state.errorMessage!);
                            }
                          } else if (state.submitReviewStatus ==
                              SubmitReviewStatus.success) {
                            showMessage(context, AppStrings.reviewSubmitted);
                            if (product?.id != null) {
                              // refresh review

                              // refresh product details
                              context.read<ProductDetailsBloc>().add(
                                  RefreshProductDetailsEvent(
                                      productId: product!.id!));

                              goPopRoute(context);
                            }
                          }
                        },
                        child: BlocBuilder<ReviewBloc, ReviewState>(
                          builder: (context, state) {
                            if (state.submitReviewStatus ==
                                SubmitReviewStatus.loading) {
                              return ElevatedButton(
                                onPressed: null,
                                child: Transform.scale(
                                    scale: .85, child: const LoadingWidget()),
                              );
                            }
                            return ElevatedButton(
                                onPressed: () {
                                  if (productId != null) {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      context
                                          .read<ReviewBloc>()
                                          .add(SubmitReviewEvent(
                                            params: SubmitReviewModel(
                                                productId: productId,
                                                rating: currentStarRating,
                                                review:
                                                    reviewTextController.text),
                                          ));
                                    }
                                  }
                                },
                                child: Text(
                                  AppStrings.submitReview,
                                  style: getRegularStyle(context,
                                      font: FontConstants.ojuju,
                                      fontSize: FontSize.s18),
                                ));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
