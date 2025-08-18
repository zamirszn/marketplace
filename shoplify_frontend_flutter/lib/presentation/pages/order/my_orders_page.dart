import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/models/response_models.dart';
import 'package:shoplify/presentation/pages/order/bloc/order_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';
import 'package:shoplify/presentation/widgets/error_message_widget.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';
import 'package:shoplify/presentation/widgets/refresh_widget.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  void initState() {
    getMyOrder();
    super.initState();
  }

  void getMyOrder() {
    final orderBloc = context.read<OrderBloc>();
    if (orderBloc.state.selectedMyOrderFilter?.name != null) {
      orderBloc.add(GetMyOrder(
          params: GetMyOrderParams(
              orderStatus: orderBloc.state.selectedMyOrderFilter!.name,
              page: 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: false,
      extendBody: false,
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(AppPadding.p10),
          child: GoBackButton(),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            return Text(
              switch (state.selectedMyOrderFilter) {
                MyOrderFilter.ORDER_CANCELLED => AppStrings.cancelled,
                MyOrderFilter.ORDER_DELIVERED => AppStrings.delivered,
                MyOrderFilter.PAYMENT_STATUS_COMPLETE => AppStrings.processing,
                MyOrderFilter.PAYMENT_STATUS_FAILED => AppStrings.paymentFailed,
                MyOrderFilter.PAYMENT_STATUS_PENDING =>
                  AppStrings.pendingPayment,
                null => "",
              },
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                context,
                font: FontConstants.ojuju,
                fontSize: AppSize.s24,
              ),
            );
          },
        ),
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
      ),
      body: RefreshWidget(
          onRefresh: () {
            getMyOrder();
          },
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              switch (state.myOrderStatus) {
                case MyOrderStatus.initial:
                  return const Center(
                    child: LoadingWidget(),
                  );
          
                case MyOrderStatus.failure:
                  return ErrorMessageWidget(
                    retry: () {
                      getMyOrder();
                    },
                    message: state.errorMessage,
                  );
          
                case MyOrderStatus.success:
                  if (state.myOrderData.isEmpty) {
                    return const Center(
                      child: EmptyWidget(
                        message: AppStrings.noOrders,
                        icon: Icon(
                          Iconsax.shop,
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
                        final orderBloc = context.read<OrderBloc>();
                        if (orderBloc.state.selectedMyOrderFilter?.name !=
                            null) {
                          orderBloc.add(GetMyOrder(
                              params: GetMyOrderParams(
                                  orderStatus: orderBloc
                                      .state.selectedMyOrderFilter!.name,
                                  page: orderBloc.state.page)));
                        }
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
                        ...state.myOrderData
                            .map((MyOrderData order) => const Placeholder()),
          
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
          )),
    );
  }
}
