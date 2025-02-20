import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/favorite_product_params_model.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/favorite/bloc/favorite_bloc.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';
import 'package:shoplify/presentation/widgets/error_message_widget.dart';
import 'package:shoplify/presentation/widgets/favorite_product_skeleton_widget.dart';
import 'package:shoplify/presentation/widgets/favorite_product_widget.dart';
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
    return Scaffold(
      extendBodyBehindAppBar: false,
      extendBody: false,
      bottomNavigationBar: const SizedBox(
        height: kBottomNavigationBarHeight + 10,
      ),
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.favorite,
          overflow: TextOverflow.ellipsis,
          style: getSemiBoldStyle(
            font: FontConstants.ojuju,
            fontSize: AppSize.s24,
          ),
        ),
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.keyboard_arrow_down_outlined),
          ),
          space(
            w: AppSize.s10,
          )
        ],
      ),
      body: Builder(builder: (context) {
        // TODO: remove comment , builder is placed to get the current context
        //dont remove or bloc throws error saying it cant
        //find the ancestor provider context for some weird reasons
        return RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            context.read<FavoriteBloc>().add(RefreshFavoriteProductEvent(
                  params: FavoriteProductParamsModel(
                      page: 1, ordering: FavoriteProductSort.intial),
                ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p10,
            ),
            child: deviceWidth(context) > 400
                // TODO:
                ? GridView.builder(
                    itemCount: 20,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
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
                          return CarouselView.weighted(
                              scrollDirection: Axis.vertical,
                              consumeMaxWeight: true,
                              enableSplash: false,
                              flexWeights: const [4, 2, 1],
                              children: List.generate(
                                5,
                                (index) =>
                                    const FavoriteProductSkeletonWidget(),
                              ));

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
                                // load more
                                context.read<FavoriteBloc>().add(
                                    GetFavoriteProductEvent(
                                        params: FavoriteProductParamsModel()));
                              }
                              return false;
                            },
                            child: CarouselView.weighted(
                                enableSplash: false,
                                onTap: (value) {
                                  print("tap");
                                },
                                // onTap: (value) => goPush(context, Routes.productDetailsPage,
                                //         extra: {
                                //           'product': product,
                                //           'heroTag': '${product.id}_popular'
                                //         }),
                                scrollDirection: Axis.vertical,
                                consumeMaxWeight: true,
                                flexWeights: const [4, 2, 1],
                                children: state.favoriteProducts
                                    .map((product) =>
                                        FavoriteProductWidget(product: product))
                                    .toList()),
                          );
                      }
                    },
                  ),
          ),
        );
      }),
    );
  }
}
