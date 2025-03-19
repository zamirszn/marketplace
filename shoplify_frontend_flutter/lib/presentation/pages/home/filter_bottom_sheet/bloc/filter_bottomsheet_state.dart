// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filter_bottomsheet_bloc.dart';

enum SortProductBy {
  name,
  price,
  discount,
  flashsale,
}

class FilterBottomsheetState extends Equatable {
  final String? selectedCategory;
  final SortProductBy? sortProductBy;
  final RangeValues priceRange;
  final bool isFilterEnabled;

  const FilterBottomsheetState(
      {this.isFilterEnabled = false,
      this.selectedCategory,
      this.sortProductBy,
      this.priceRange = const RangeValues(0, 1)});

  @override
  List<Object?> get props => [selectedCategory, sortProductBy, priceRange];

  FilterBottomsheetState copyWith({
    String? selectedCategory,
    SortProductBy? sortProductBy,
    RangeValues? priceRange,
    bool? isFilterEnabled,
  }) {
    return FilterBottomsheetState(
      selectedCategory: selectedCategory,
      sortProductBy: sortProductBy,
      priceRange: priceRange ?? this.priceRange,
      isFilterEnabled: isFilterEnabled ?? this.isFilterEnabled,
    );
  }
}
