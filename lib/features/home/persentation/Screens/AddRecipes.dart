import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/utiles/app_colors.dart';
import '../../../../core/utiles/assets.dart';
import '../../data/RepoImpl/HomeRepoImpl.dart';
import '../Cubits/AddRecipesCubit/ImageCubit.dart';
import '../Cubits/AddRecipesCubit/ImageState.dart';
import '../Widgets/CustomeContainerWithTextField.dart';
import '../Widgets/CustomeMultiLineTextField.dart';

class AddRecipes extends StatelessWidget {
  AddRecipes({super.key});
  final TextEditingController typeMeal = TextEditingController();
  final TextEditingController mealName = TextEditingController();
  final TextEditingController numberOfIngrediantes = TextEditingController();
  final TextEditingController time = TextEditingController();
  final TextEditingController summary = TextEditingController();
  final TextEditingController protein = TextEditingController();
  final TextEditingController carb = TextEditingController();
  final TextEditingController fat = TextEditingController();
  final TextEditingController kcal = TextEditingController();
  final TextEditingController vitamenes = TextEditingController();
  final TextEditingController firstingrediant = TextEditingController();
  final TextEditingController secoundingrediant = TextEditingController();
  final TextEditingController thirdingrediant = TextEditingController();
  final TextEditingController fourthingrediant = TextEditingController();
  final TextEditingController piecesone = TextEditingController();
  final TextEditingController piecestwo = TextEditingController();
  final TextEditingController piecesthree = TextEditingController();
  final TextEditingController piecesfour = TextEditingController();
  final TextEditingController firstStep = TextEditingController();
  final TextEditingController secoundStep = TextEditingController();

  bool loading = false;
  final HomeRepoImpl homerepoimpl = HomeRepoImpl();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          decoration: const BoxDecoration(
            color: Colors.black38,
            image: DecorationImage(
              image: AssetImage("${Assets.authLayoutFoodImage}"),
              fit: BoxFit.fill,
            ),
          ),
          child: ListView(
            children: [
              //appbar
              CustomeAppbar(leftImage: Assets.icBack,rightImage: Assets.gemini,ontapleft: (){Navigator.of(context).pop();},ontapright: (){},),
            const SizedBox(height: 35,),
              //upload image
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
                        ? const AssetImage("${Assets.icSearch}")
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
                      : const CircularProgressIndicator();
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
                validator: (value) {},
                hintText: 'Type Of Meal',
                inputType: TextInputType.text,
                controller: typeMeal,

              ),
              SizedBox(height: 15),
              CustomTextField(validator: (value) {},
                hintText: 'Meal Name',
                inputType: TextInputType.text,
                controller: mealName,
              ),
              SizedBox(height: 15),
              CustomTextField(validator: (value){},
                hintText: 'Number of Ingredients',
                inputType: TextInputType.text,
                controller: numberOfIngrediantes,
              ),
              SizedBox(height: 15),
              CustomTextField(validator: (value) {},
                hintText: 'Time',
                inputType: TextInputType.text,
                controller: time,
              ),
              SizedBox(height: 15),
              //summary
              Customemultilinetextfield(controller: summary,hintText: "Summary",),
             SizedBox(height: 15,),

              //nutrations
              Text("Nutrations",style: TextStyle(color:AppColors.black,fontSize: 20,fontWeight: FontWeight.bold),),SizedBox(height: 10,),
             Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 Customecontainerwithtextfield(hinttext: "Protein",controller: protein,),
                 Customecontainerwithtextfield(hinttext: "carb",controller: carb,),
                 Customecontainerwithtextfield(hinttext: "Fat",controller: fat,),
          ],),SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 Customecontainerwithtextfield(controller: kcal,hinttext: "Kcal",),
                 Customecontainerwithtextfield(hinttext:"vitamenes" ,controller: vitamenes,),
             ],),

              //ingrediants
              SizedBox(height: 20,),
              Text("Ingrediants",style: TextStyle(color:AppColors.black,fontSize: 20,fontWeight: FontWeight.bold),),SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Customecontainerwithtextfield(hinttext: "1th Ingrediante",controller: firstingrediant,),
                Customecontainerwithtextfield(hinttext: "pieces",controller: piecesone,),
              ],),SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Customecontainerwithtextfield(hinttext: "2th Ingrediante",controller: secoundingrediant,),
                Customecontainerwithtextfield(hinttext: "pieces",controller: piecestwo,),
              ],),SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Customecontainerwithtextfield(hinttext: "3th Ingrediante",controller: thirdingrediant,),
                Customecontainerwithtextfield(hinttext: "pieces",controller: piecesthree,),
              ],),SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Customecontainerwithtextfield(hinttext: "4th Ingrediante",controller: fourthingrediant,),
                Customecontainerwithtextfield(hinttext: "pieces",controller: piecesfour,),
              ],),SizedBox(height: 20,),

              //direction
              Customemultilinetextfield(hintText: "Step 1",controller:firstStep ,),SizedBox(height: 10,),
              Customemultilinetextfield(hintText: "Step 2",controller:secoundStep ,),SizedBox(height: 30,),

              // Button
              ElevatedButton(
                onPressed: () {
                  homerepoimpl.sendData(
                    image: BlocProvider.of<ImageCubit>(context).im.toString(),
                    typeofmeal: typeMeal.text.trim(),
                    mealName: mealName.text.trim(),
                    ingrediantes: numberOfIngrediantes.text.trim(),
                    time: time.text.trim(),
                    summary: summary.text.trim(),
                    protein: protein.text.trim(),
                    carb: carb.text.trim(),
                    fat: fat.text.trim(),
                    kcal: kcal.text.trim(),
                    vitamins: vitamenes.text.trim(),
                    firstIngrediants: firstingrediant.text.trim(),
                    secoundIngrediants: secoundingrediant.text.trim(),
                    thirdIngrediants: thirdingrediant.text.trim(),
                    fourthIngrediants: fourthingrediant.text.trim(),
                    piecesone: piecesone.text.trim(),
                    piecestwo: piecestwo.text.trim(),
                    piecesthree: piecesthree.text.trim(),
                    piecesfour: piecesfour.text.trim(),
                    firstStep: firstStep.text.trim(),
                    secoundtStep: secoundStep.text.trim(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.all(screenSize.width < 600 ? 15 : 18),
                ),
                child: Text(
                  "Add Ingredients",
                  style: TextStyle(color: Colors.white, fontSize: screenSize.width < 600 ? 15 : 20),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
