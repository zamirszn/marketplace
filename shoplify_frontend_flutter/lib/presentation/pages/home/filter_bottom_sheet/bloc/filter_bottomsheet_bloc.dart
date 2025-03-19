import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'filter_bottomsheet_event.dart';
part 'filter_bottomsheet_state.dart';

class FilterBottomsheetBloc
    extends Bloc<FilterBottomsheetEvent, FilterBottomsheetState> {
  FilterBottomsheetBloc() : super(const FilterBottomsheetState()) {
    on<FilterByCategoryEvent>(_onselectedCategory);
    on<SortProductByEvent>(_onSortProduct);
    on<ResetFilterEvent>(_onResetFilter);
    on<FilterPriceRangeEvent>(_onFilterPriceRange);
    on<ApplyFilterEvent>(_onApplyFilter);
  }

  void _onApplyFilter(
      ApplyFilterEvent event, Emitter<FilterBottomsheetState> emit) {}
  void _onFilterPriceRange(
      FilterPriceRangeEvent event, Emitter<FilterBottomsheetState> emit) {
    emit(state.copyWith(priceRange: event.priceRange, isFilterEnabled: true));
  }

  void _onselectedCategory(
      FilterByCategoryEvent event, Emitter<FilterBottomsheetState> emit) {
    emit(state.copyWith(
        selectedCategory: event.selectedCategory,
        sortProductBy: state.sortProductBy,
        isFilterEnabled: true));
  }

  void _onSortProduct(
      SortProductByEvent event, Emitter<FilterBottomsheetState> emit) {
    emit(state.copyWith(
        sortProductBy: event.sortBy,
        selectedCategory: state.selectedCategory,
        isFilterEnabled: true));
  }

  void _onResetFilter(
      ResetFilterEvent event, Emitter<FilterBottomsheetState> emit) {
    emit(state.copyWith(
        selectedCategory: null,
        sortProductBy: null,
        isFilterEnabled: false,
        priceRange: const RangeValues(0, 1)));
  }
}
