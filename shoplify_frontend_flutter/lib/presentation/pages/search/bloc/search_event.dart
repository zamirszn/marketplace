part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

final class UpdateSearchText extends SearchEvent {
  final String text;

  UpdateSearchText({required this.text});
}

final class SearchProductEvent extends SearchEvent {
  final SearchParamsModel searchParamsModel;
  final bool useFilterParams;

  SearchProductEvent(
      {required this.searchParamsModel, this.useFilterParams = false});
}

final class ResetSearchEvent extends SearchEvent {}


