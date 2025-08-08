import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/presentation/pages/favorite/bloc/favorite_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';
import 'package:shoplify/presentation/widgets/error_message_widget.dart';
import 'package:shoplify/presentation/widgets/favorite_product_widget.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';
import 'package:shoplify/presentation/widgets/product_carousel_skeleton_widget.dart';
import 'package:shoplify/presentation/widgets/product_widget_skeleton.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    context
        .read<FavoriteBloc>()
        .add(GetFavoriteProductEvent(params: FavoriteProductParamsModel()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        extendBodyBehindAppBar: false,
        extendBody: false,
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppStrings.favorite,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              context,
              font: FontConstants.ojuju,
              fontSize: AppSize.s20,
            ),
          ),
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<FavoriteBloc>().add(RefreshFavoriteProductEvent(
                  params: FavoriteProductParamsModel(
                      page: 1, ordering: FavoriteProductSort.intial),
                ));
          },
          child: deviceWidth(context) > 400
              // TODO: fix
              ? GridView.builder(
                  itemCount: 20,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      mainAxisExtent: 250,
                      crossAxisSpacing: AppSize.s10,
                      mainAxisSpacing: AppSize.s10),
                  itemBuilder: (context, index) {
                    return const ProductWidgetSkeleton();
                  },
                )
              : BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case FavoriteProductStatus.initial:
                        if (state.isFetching) {
                          return CarouselView.weighted(
                              scrollDirection: Axis.vertical,
                              consumeMaxWeight: true,
                              enableSplash: false,
                              flexWeights: const [4, 2, 1],
                              children: List.generate(
                                5,
                                (index) =>
                                    const ProductCarouselSkeletonWidget(),
                              ));
                        } else {
                          return const SizedBox();
                        }

                      case FavoriteProductStatus.failure:
                        return ErrorMessageWidget(
                          retry: () {
                            context
                                .read<FavoriteBloc>()
                                .add(RefreshFavoriteProductEvent(
                                  params: FavoriteProductParamsModel(
                                      page: 1,
                                      ordering: FavoriteProductSort.intial),
                                ));
                          },
                          message: state.errorMessage,
                        );

                      case FavoriteProductStatus.success:
                        if (state.favoriteProducts.isEmpty) {
                          return const Center(
                            child: EmptyWidget(
                              message: AppStrings.noFavoriteProduct,
                              icon: Icon(
                                Iconsax.save_add,
                                size: AppSize.s40,
                              ),
                            ),
                          );
                        }

                        return NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent - 50) {
                              // Load more items when the user reaches the end of the list
                              context.read<FavoriteBloc>().add(
                                    GetFavoriteProductEvent(
                                      params: FavoriteProductParamsModel(),
                                    ),
                                  );
                            }
                            return false;
                          },
                          child: CarouselView.weighted(
                            enableSplash: false,
                            scrollDirection: Axis.vertical,
                            consumeMaxWeight: true,
                            flexWeights: const [4, 2, 1],
                            children: [
                              // Map the existing favorite products to widgets
                              ...state.favoriteProducts.map((product) =>
                                  FavoriteProductWidget(product: product)),

                              // Add a loading widget if more items are being loaded
                              if (!state.hasReachedMax)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppPadding.p20),
                                  child: Center(
                                    child: Transform.scale(
                                      scale: .8,
                                      child: const LoadingWidget(),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                    }
                  },
                ),
        ));
  }
}
