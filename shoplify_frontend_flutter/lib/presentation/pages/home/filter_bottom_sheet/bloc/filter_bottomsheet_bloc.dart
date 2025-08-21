import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shoplify/core/constants/constant.dart';

part 'filter_bottomsheet_event.dart';
part 'filter_bottomsheet_state.dart';

class FilterBottomsheetBloc
    extends Bloc<FilterBottomsheetEvent, FilterBottomsheetState> {
  FilterBottomsheetBloc() : super(const FilterBottomsheetState()) {
    on<FilterByCategoryEvent>(_onselectedCategory);
    on<SortProductByEvent>(_onSortProduct);
    on<ResetFilterEvent>(_onResetFilter);
    on<FilterPriceRangeEvent>(_onFilterPriceRange);
  }

  

  void _onFilterPriceRange(
      FilterPriceRangeEvent event, Emitter<FilterBottomsheetState> emit) {

    emit(state.copyWith(priceRange: event.priceRange, isFilterEnabled: true));
  }


  void _onselectedCategory(
      FilterByCategoryEvent event, Emitter<FilterBottomsheetState> emit) {
    emit(state.copyWith(
        selectedCategoryId: event.selectedCategory,
        sortProductBy: state.sortProductBy,
        isFilterEnabled: true));
  }

  void _onSortProduct(
      SortProductByEvent event, Emitter<FilterBottomsheetState> emit) {
    emit(state.copyWith(
        sortProductBy: event.sortBy,
        selectedCategoryId: state.selectedCategoryId,
        isFilterEnabled: true));
  }

  void _onResetFilter(
      ResetFilterEvent event, Emitter<FilterBottomsheetState> emit) {
    emit(const FilterBottomsheetState());
  }
}
