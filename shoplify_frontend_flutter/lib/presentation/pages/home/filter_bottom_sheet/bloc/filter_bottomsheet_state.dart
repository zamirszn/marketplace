// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filter_bottomsheet_bloc.dart';

enum SortProductBy {
  discount,
  flashsale,
}

class FilterBottomsheetState extends Equatable {
  final String? selectedCategoryId;
  final SortProductBy? sortProductBy;
  final RangeValues priceRange;
  final bool isFilterEnabled;

  const FilterBottomsheetState(
      {this.isFilterEnabled = false,
      this.selectedCategoryId,
      this.sortProductBy,
      this.priceRange = const RangeValues(0, 1)});

  @override
  List<Object?> get props => [selectedCategoryId, sortProductBy, priceRange];

  FilterBottomsheetState copyWith({
    String? selectedCategory,
    SortProductBy? sortProductBy,
    RangeValues? priceRange,
    bool? isFilterEnabled,
  }) {
    return FilterBottomsheetState(
      selectedCategoryId: selectedCategory,
      sortProductBy: sortProductBy,
      priceRange: priceRange ?? this.priceRange,
      isFilterEnabled: isFilterEnabled ?? this.isFilterEnabled,
    );
  }
}
