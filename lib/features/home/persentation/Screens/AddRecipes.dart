import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/components/dynamic_notification_widget.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/AddRecipesCubit/add_ingredient_cubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/AddRecipesCubit/add_ingredient_state.dart';
import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/components/custom_drop_down_Button.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/services/di.dart';
import '../../../../core/utiles/app_colors.dart';
import '../../../../core/utiles/assets.dart';
import '../../../gemini_integrate/data/Recipe.dart';
import '../../domain/HomeRepo/HomeRepo.dart';
import '../Widgets/CustomeContainerWithTextField.dart';
import '../Widgets/CustomeMultiLineTextField.dart';

class AddRecipes extends StatefulWidget {
  const AddRecipes({super.key});

  @override
  AddRecipesState createState() => AddRecipesState();
}

class AddRecipesState extends State<AddRecipes> {
  // Use late initialization for controllers
  late TextEditingController typeMeal;
  late TextEditingController mealName;
  late TextEditingController numberOfIngredients;
  late TextEditingController time;
  late TextEditingController summary;
  late TextEditingController protein;
  late TextEditingController carb;
  late TextEditingController fat;
  late TextEditingController kcal;
  late TextEditingController vitamenes;
  late TextEditingController firstingrediant;
  late TextEditingController secoundingrediant;
  late TextEditingController thirdingrediant;
  late TextEditingController fourthingrediant;
  late TextEditingController piecesone;
  late TextEditingController piecestwo;
  late TextEditingController piecesthree;
  late TextEditingController piecesfour;
  late TextEditingController firstStep;
  late TextEditingController secoundStep;

  late List<IngredientUI> ingredients;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    // Initialize all controllers
    typeMeal = TextEditingController();
    mealName = TextEditingController();
    numberOfIngredients = TextEditingController();
    time = TextEditingController();
    summary = TextEditingController();
    protein = TextEditingController();
    carb = TextEditingController();
    fat = TextEditingController();
    kcal = TextEditingController();
    vitamenes = TextEditingController();
    firstingrediant = TextEditingController();
    secoundingrediant = TextEditingController();
    thirdingrediant = TextEditingController();
    fourthingrediant = TextEditingController();
    piecesone = TextEditingController();
    piecestwo = TextEditingController();
    piecesthree = TextEditingController();
    piecesfour = TextEditingController();
    firstStep = TextEditingController();
    secoundStep = TextEditingController();

    // Initialize ingredients
    ingredients = List.generate(
      4,
      (index) => IngredientUI(id: 'ingredient_$index'),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    typeMeal.dispose();
    mealName.dispose();
    numberOfIngredients.dispose();
    time.dispose();
    summary.dispose();
    protein.dispose();
    carb.dispose();
    fat.dispose();
    kcal.dispose();
    vitamenes.dispose();
    firstingrediant.dispose();
    secoundingrediant.dispose();
    thirdingrediant.dispose();
    fourthingrediant.dispose();
    piecesone.dispose();
    piecestwo.dispose();
    piecesthree.dispose();
    piecesfour.dispose();
    firstStep.dispose();
    secoundStep.dispose();

    // Dispose ingredient controllers
    for (var ingredient in ingredients) {
      ingredient.nameController.dispose();
      ingredient.quantityController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              color: Colors.black38,
              image: DecorationImage(
                image: AssetImage(Assets.authLayoutFoodImage),
                fit: BoxFit.fill,
              ),
            ),
            child: ListView(
              children: [
                // AppBar
                CustomAppbar(
                  leftImage: Assets.icBack,
                  ontapleft: () => Navigator.of(context).pop(),
                  ontapright: () =>
                      Navigator.of(context).pushNamed(AppRoutes.geminiRecipe),
                ),
                const SizedBox(height: 35),

                // Upload Meal Image
                BlocConsumer<AddIngredientCubit, AddIngredientState>(
                  listener: (context, state) {
                    if (state is IsLoadingImageState) {
                      loading = true;
                    } else if (state is LoadedImageState) {
                      loading = false;
                    } else if (state is FailureImageError) {
                      loading = false;
                      DynamicNotificationWidget.showNotification(
                        context: context,
                        title: 'Oh Hey!!',
                        message: state.message,
                        color: Colors.green,
                        // You can use this color if needed
                        contentType: ContentType.failure,
                        inMaterialBanner: false,
                      );
                    }
                  },
                  builder: (context, state) {
                    return loading
                        ? const Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: screenSize.width < 600 ? 62 : 50,
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<AddIngredientCubit>(context)
                                    .pickMainImage();
                              },
                              child: ClipOval(
                                child: BlocProvider.of<AddIngredientCubit>(
                                                context)
                                            .mainImageUrl ==
                                        null
                                    ? Image.asset(
                                        Assets.icSplash,
                                        fit: BoxFit.cover,
                                        width:
                                            screenSize.width < 600 ? 124 : 100,
                                        height:
                                            screenSize.width < 600 ? 124 : 100,
                                      )
                                    : Image.network(
                                        BlocProvider.of<AddIngredientCubit>(
                                                context)
                                            .mainImageUrl!,
                                        fit: BoxFit.cover,
                                        width:
                                            screenSize.width < 600 ? 124 : 100,
                                        height:
                                            screenSize.width < 600 ? 124 : 100,
                                      ),
                              ),
                            ),
                          );
                  },
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Add Meal Image",
                    style: TextStyle(
                      fontSize: screenSize.width < 600 ? 14 : 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomDropdownField(
                  hintText: 'Type Of Meal',
                  prefixIcon: Assets.icSplash,
                  controller: typeMeal,
                  items: const ['Breakfast', 'Lunch', 'Dinner', 'Snack', 'Appetizers'],
                  onChanged: (value) {
                    // Handle change if needed
                  },
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  hintText: 'Meal Name',
                  inputType: TextInputType.text,
                  controller: mealName,
                  prefixIcon: Assets.icSplash,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  hintText: 'Number of Ingredients',
                  inputType: TextInputType.text,
                  controller: numberOfIngredients,
                  prefixIcon: Assets.icSplash,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  hintText: 'Time',
                  inputType: TextInputType.text,
                  controller: time,
                  prefixIcon: Assets.icSplash,
                ),
                const SizedBox(height: 15),
                CustomMultilineTextfield(
                  controller: summary,
                  hintText: "Summary",
                ),
                const SizedBox(height: 15),

                // Nutrition
                const Text(
                  "Nutrition",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomContainerWithTextfield(
                          hintText: "Protein", controller: protein),
                      CustomContainerWithTextfield(
                          hintText: "Carb", controller: carb),
                      CustomContainerWithTextfield(
                          hintText: "Fat", controller: fat),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomContainerWithTextfield(
                        controller: kcal, hintText: "Kcal"),
                    CustomContainerWithTextfield(
                        hintText: "Vitamins", controller: vitamenes),
                  ],
                ),

                // Ingredients
                const SizedBox(height: 20),
                const Text(
                  "Ingredients",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...ingredients.map(
                  (ingredient) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BlocConsumer<AddIngredientCubit, AddIngredientState>(
                          listener: (context, state) {
                            if (state is IsLoadingImageState &&
                                state.id == ingredient.id) {
                              ingredient.loading = true;
                            } else if (state is LoadedImageState &&
                                state.id == ingredient.id) {
                              ingredient.loading = false;
                              ingredient.imageUrl = state.imageUrl;
                            }
                          },
                          builder: (context, state) {
                            return ingredient.loading
                                ? const CircularProgressIndicator()
                                : CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: screenSize.width < 600 ? 40 : 50,
                                    child: InkWell(
                                      onTap: () {
                                        context
                                            .read<AddIngredientCubit>()
                                            .pickImage(ingredient.id);
                                      },
                                      child: ClipOval(
                                        child: ingredient.imageUrl == null
                                            ? Image.asset(
                                                Assets.icSplash,
                                                fit: BoxFit.cover,
                                                width: screenSize.width < 600
                                                    ? 80
                                                    : 100,
                                                height: screenSize.width < 600
                                                    ? 80
                                                    : 100,
                                              )
                                            : Image.network(
                                                ingredient.imageUrl!,
                                                fit: BoxFit.cover,
                                                width: screenSize.width < 600
                                                    ? 80
                                                    : 100,
                                                height: screenSize.width < 600
                                                    ? 80
                                                    : 100,
                                              ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                        CustomContainerWithTextfield(
                          hintText: "Ingredient",
                          controller: ingredient.nameController,
                        ),
                        CustomContainerWithTextfield(
                          hintText: "Pieces",
                          controller: ingredient.quantityController,
                        ),
                      ],
                    ),
                  ),
                ),

                // Directions
                const SizedBox(height: 20),
                CustomMultilineTextfield(
                    hintText: "Step 1", controller: firstStep),
                const SizedBox(height: 10),
                CustomMultilineTextfield(
                    hintText: "Step 2", controller: secoundStep),
                const SizedBox(height: 30),

                // Button
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      final recipe = Recipe(
                        name: mealName.text.trim(),
                        summary: summary.text.trim(),
                        typeOfMeal: typeMeal.text.trim(),
                        time: time.text.trim(),
                        imageUrl: BlocProvider.of<AddIngredientCubit>(context)
                            .mainImageUrl
                            .toString(),
                        ingredients: [
                          Ingredient(
                            name: firstingrediant.text.trim(),
                            quantity: piecesone.text.trim(),
                            unit: '', // Provide unit if applicable
                            imageUrl:
                                BlocProvider.of<AddIngredientCubit>(context)
                                        .imageUrls["ingredient_0"] ??
                                    "", // Provide image URL if applicable
                          ),
                          Ingredient(
                            name: secoundingrediant.text.trim(),
                            quantity: piecestwo.text.trim(),
                            unit: '',
                            imageUrl:
                                BlocProvider.of<AddIngredientCubit>(context)
                                        .imageUrls["ingredient_1"] ??
                                    "",
                          ),
                          Ingredient(
                            name: thirdingrediant.text.trim(),
                            quantity: piecesthree.text.trim(),
                            unit: '',
                            imageUrl:
                                BlocProvider.of<AddIngredientCubit>(context)
                                        .imageUrls["ingredient_2"] ??
                                    "",
                          ),
                          Ingredient(
                            name: fourthingrediant.text.trim(),
                            quantity: piecesfour.text.trim(),
                            unit: '',
                            imageUrl:
                                BlocProvider.of<AddIngredientCubit>(context)
                                        .imageUrls["ingredient_3"] ??
                                    "",
                          ),
                        ],
                        nutrition: Nutrition(
                          calories: int.tryParse(kcal.text.trim()) ?? 0,
                          protein: double.tryParse(protein.text.trim()) ?? 0.0,
                          carbs: double.tryParse(carb.text.trim()) ?? 0.0,
                          fat: double.tryParse(fat.text.trim()) ?? 0.0,
                          vitamins: vitamenes.text.trim().split(','),
                        ),
                        directions: Directions(
                          firstStep: firstStep.text.trim(),
                          secondStep: secoundStep.text.trim(),
                          additionalSteps: [], // Add additional steps if any
                        ),
                      );

                      getIt<HomeRepo>().addIngredients(recipe).then((value) {
                        context.pushReplacementNamed(AppRoutes.navBar);
                      }).catchError((error) {
                        DynamicNotificationWidget.showNotification(
                          context: context,
                          title: 'Oh Hey!!',
                          message: 'Failed to send data: $error',
                          color: Colors.green,
                          // You can use this color if needed
                          contentType: ContentType.failure,
                          inMaterialBanner: true,
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.all(screenSize.width < 600 ? 15 : 18),
                    ),
                    child: Text(
                      "Add Ingredients",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenSize.width < 600 ? 15 : 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class IngredientUI {
  final TextEditingController nameController;
  final TextEditingController quantityController;
  String? imageUrl;
  final String id;
  bool loading;

  IngredientUI({required this.id})
      : nameController = TextEditingController(),
        quantityController = TextEditingController(),
        loading = false;
}
