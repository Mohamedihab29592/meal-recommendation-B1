import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/utiles/app_colors.dart';
import '../../../../core/utiles/assets.dart';
import '../../data/RepoImpl/HomeRepoImpl.dart';
import '../Cubits/AddRecipesCubit/ImageCubit.dart';
import '../Cubits/AddRecipesCubit/ImageState.dart';

class AddRecipes extends StatelessWidget {
  AddRecipes({super.key});
  final TextEditingController typeMeal = TextEditingController();
  final TextEditingController mealName = TextEditingController();
  final TextEditingController numberOfIngrediantes = TextEditingController();
  final TextEditingController time = TextEditingController();

  bool loading = false;
  final HomeRepoImpl homerepoimpl = HomeRepoImpl();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 80, left: 10, right: 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("${Assets.authLayoutFoodImage}"),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: [
            BlocConsumer<ImageCubit, ImagesState>(
              listener: (context, state) {
                if (state is IsLoading) {
                  loading = true;
                } else if (state is VisibleImage) {
                  loading = false;
                }
              },
              builder: (context, state) {
                return loading == false
                    ? CircleAvatar(
                  backgroundImage: BlocProvider.of<ImageCubit>(context).urlimage == null
                      ? AssetImage("${Assets.icSearch}")
                      : NetworkImage("${BlocProvider.of<ImageCubit>(context).urlimage}"),
                  backgroundColor: Colors.black,
                  radius: screenSize.width < 600 ? 40 : 50,
                  child: IconButton(
                    onPressed: () {
                      BlocProvider.of<ImageCubit>(context).gettimage();
                    },
                    icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                  ),
                )
                    : CircularProgressIndicator();
              },
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Add Meal Image",
                style: TextStyle(
                  fontSize: screenSize.width < 600 ? 12 : 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Details of meals
            SizedBox(height: 60),
            CustomTextField(
              hintText: 'Type Of Meal',
              prefixIcon: Icons.playlist_add_check_circle,
              inputType: TextInputType.text,
              controller: typeMeal,
            ),
            SizedBox(height: 15),
            CustomTextField(
              hintText: 'Meal Name',
              prefixIcon: Icons.fastfood,
              inputType: TextInputType.text,
              controller: mealName,
            ),
            SizedBox(height: 15),
            CustomTextField(
              hintText: 'Number of Ingredients',
              prefixIcon: Icons.design_services_rounded,
              inputType: TextInputType.text,
              controller: numberOfIngrediantes,
            ),
            SizedBox(height: 15),
            CustomTextField(
              hintText: 'Time',
              prefixIcon: Icons.timer,
              inputType: TextInputType.text,
              controller: time,
            ),
            SizedBox(height: 30),

            // Button
            ElevatedButton(
              onPressed: () {
                homerepoimpl.sendData(
                  typeMeal.text.trim(),
                  mealName.text.trim(),
                  numberOfIngrediantes.text.trim(),
                  time.text.trim(),
                  BlocProvider.of<ImageCubit>(context).urlimage.toString(),
                );
              },
              child: Text(
                "Add Ingredients",
                style: TextStyle(color: Colors.white, fontSize: screenSize.width < 600 ? 12 : 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.all(screenSize.width < 600 ? 10 : 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
