part of 'filter_bottomsheet_bloc.dart';

@immutable
sealed class FilterBottomsheetEvent {}

final class FilterByCategoryEvent extends FilterBottomsheetEvent {
  final String selectedCategory;

  FilterByCategoryEvent({required this.selectedCategory});
}

final class SortProductByEvent extends FilterBottomsheetEvent {
  final SortProductBy sortBy;

  SortProductByEvent({required this.sortBy});
}

final class FilterPriceRangeEvent extends FilterBottomsheetEvent {
  final RangeValues priceRange;

  FilterPriceRangeEvent({required this.priceRange});
}

final class ResetFilterEvent extends FilterBottomsheetEvent {}
final class ApplyFilterEvent extends FilterBottomsheetEvent {}
