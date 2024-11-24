import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeState.dart';

import '../../../../core/utiles/app_colors.dart';
import '../../../gemini_integrate/data/Recipe.dart';
import '../Cubits/HomeCubit/HomeCubit.dart';
import '../Cubits/HomeCubit/HomeEvent.dart';

class FilterBottomSheet extends StatefulWidget {

  const FilterBottomSheet({super.key});

  @override
  FilterBottomSheetState createState() => FilterBottomSheetState();
}

class FilterBottomSheetState extends State<FilterBottomSheet> {

  @override
  void initState() {
   // context.read<HomeBloc>().add(FetchRecipesEvent());
    super.initState();
  }
  int _selectedMeal = -1;
  int _selectedTime = -1;

  double _ingredientsSliderValue = 5;
   RangeValues _caloriesRange =  const RangeValues(0, 1000);
   RangeValues _proteinRange =  const RangeValues(0, 100);
   RangeValues _carbsRange = const RangeValues(0, 200);
   RangeValues _fatRange = const RangeValues(0, 100);

  final List<String> _vitamins = [
    'Vitamin A',
    'Vitamin B1',
    'Vitamin B2',
    'Vitamin C',
    'Vitamin D',
    'Vitamin E',
    'Vitamin K'
  ];

  List<String> _selectedVitamins = [];
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc,HomeState>(
      listener: (context, state) {

      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Title and Reset Button
                _buildHeader(),

                // Meal Type Filter
                _buildSectionWithTitle(
                  title: "Meal Type",
                  child: _buildFilterChips(
                    options: ["Breakfast", "Lunch", "Dinner", "Drink", "Dessert", "Snacks","Appetizer"],
                    selectedIndex: _selectedMeal,
                    onSelected: (index) {
                      setState(() {
                        _selectedMeal = index;
                      });
                    },
                  ),
                ),

                // Cooking Time Filter
                _buildSectionWithTitle(
                  title: "Cooking Time",
                  child: _buildFilterChips(
                    options: ["5 min", "10 min", "15+ min"],
                    selectedIndex: _selectedTime,
                    onSelected: (index) {
                      setState(() {
                        _selectedTime = index;
                      });
                    },
                  ),
                ),

                // Difficulty Level Filter
                _buildNutritionRangeSection(
                  title: "Calories (kcal)",
                  rangeValues: _caloriesRange,
                  min: 0,
                  max: 1000,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _caloriesRange = values;
                    });
                  },
                ),
                _buildNutritionRangeSection(
                  title: "Protein (g)",
                  rangeValues: _proteinRange,
                  min: 0,
                  max: 100,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _proteinRange = values;
                    });
                  },
                ),

                _buildNutritionRangeSection(
                  title: "Carbs (g)",
                  rangeValues: _carbsRange,
                  min: 0,
                  max: 200,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _carbsRange = values;
                    });
                  },
                ),

                _buildNutritionRangeSection(
                  title: "Fat (g)",
                  rangeValues: _fatRange,
                  min: 0,
                  max: 100,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _fatRange = values;
                    });
                  },
                ),

                // Vitamins Multi-Select
                _buildSectionWithTitle(
                  title: "Vitamins",
                  child: _buildVitaminsMultiSelect(),
                ),

                // Apply Filters Button
                const SizedBox(height: 20),
                // Number of Ingredients Slider
                _buildSectionWithTitle(
                  title: "Number of Ingredients",
                  child: _buildIngredientsSlider(),
                ),

                // Apply Filters Button
                const SizedBox(height: 20),
                _buildApplyFiltersButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Filter Recipes",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: _resetFilters,
            child: const Text(
              "Reset",
              style: TextStyle(
                color:  AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWithTitle({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildFilterChips({
    required List<String> options,
    required int selectedIndex,
    required Function(int) onSelected,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(options.length, (index) {
        bool isSelected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
                  : [],
            ),
            child: Text(
              options[index],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildIngredientsSlider() {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor:  AppColors.primary,
        inactiveTrackColor: Colors.grey.shade300,
        thumbColor:  AppColors.primary,
        overlayColor:  AppColors.primary.withOpacity(0.2),
      ),
      child: Slider(
        value: _ingredientsSliderValue,
        min: 1,
        max: 20,
        divisions: 9,
        label: _ingredientsSliderValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            _ingredientsSliderValue = value;
          });
        },
      ),
    );
  }

  Widget _buildApplyFiltersButton() {
    return ElevatedButton(
      onPressed: _applyFilters,
      style: ElevatedButton.styleFrom(
        backgroundColor:  AppColors.primary,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: const Text(
        "Apply Filters",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
  Widget _buildNutritionRangeSection({
    required String title,
    required RangeValues rangeValues,
    required double min,
    required double max,
    required Function(RangeValues) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          RangeSlider(
            values: rangeValues,
            min: min,
            max: max,
            divisions: 20,
            labels: RangeLabels(
              rangeValues.start.round().toString(),
              rangeValues.end.round().toString(),
            ),
            onChanged: onChanged,
            activeColor: Colors.deepOrange,
            inactiveColor: Colors.grey.shade300,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${rangeValues.start.round()}', style: const TextStyle(color: Colors.grey)),
                Text('${rangeValues.end.round()}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitaminsMultiSelect() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _vitamins.map((vitamin) {
        bool isSelected = _selectedVitamins.contains(vitamin);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedVitamins.remove(vitamin);
              } else {
                _selectedVitamins.add(vitamin);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepOrange : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
                  : [],
            ),
            child: Text(
              vitamin,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _applyFilters() {
    // Map meal type index to actual meal type string
    String? mealType;
    if (_selectedMeal != -1) {
      const mealTypes = [
        "Breakfast", "Lunch", "Dinner", "Drink",
        "Dessert", "Snacks", "Appetizer"
      ];
      mealType = mealTypes[_selectedMeal];
    }

    // Use the new event-based approach
    context.read<HomeBloc>().add(
      FilterRecipesEvent(
        mealType: mealType,
        cookingTime: _selectedTime != -1 ? _selectedTime : null,
        caloriesRange: _caloriesRange,
        proteinRange: _proteinRange,
        carbsRange: _carbsRange,
        fatRange: _fatRange,
        selectedVitamins: _selectedVitamins.isNotEmpty ? _selectedVitamins : null,
        maxIngredients: _ingredientsSliderValue.round(),
      ),
    );

    Navigator.pop(context);
  }

  // Reset method also uses events
  void _resetFilters() {
    setState(() {
      // Reset local state
      _selectedMeal = -1;
      _selectedTime = -1;
      _caloriesRange = const RangeValues(0, 1000);
      _proteinRange = const RangeValues(0, 100);
      _carbsRange = const RangeValues(0, 200);
      _fatRange = const RangeValues(0, 200);
      _selectedVitamins = [];
      _ingredientsSliderValue = 5;
    });

    context.read<HomeBloc>().add(ResetFiltersEvent());
    Navigator.pop(context);
  }
}



