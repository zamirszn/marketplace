part of 'new_product_bloc.dart';

@immutable
sealed class NewProductEvent {}

class GetNewProductsEvent extends NewProductEvent {}

