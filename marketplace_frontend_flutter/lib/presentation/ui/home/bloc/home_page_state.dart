part of 'home_page_bloc.dart';

@immutable
sealed class HomePageState {}

final class HomePageInitial extends HomePageState {}

final class HomePageCategoryLoading extends HomePageState {}

final class HomePageCategoryFailure extends HomePageState {}

final class HomePageCategorySuccess extends HomePageState {
  final List<String> categories;

  HomePageCategorySuccess({required this.categories});
}

final class HomePageCategoryUpdate extends HomePageState {
  final String selectedCategory;

  HomePageCategoryUpdate({required this.selectedCategory});
}
