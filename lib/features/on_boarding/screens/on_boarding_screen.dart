import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/utiles/Assets.dart';
import '../../../core/utiles/app_colors.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  //classes objects
  AppColors appcolor=AppColors();
  Assets assets=Assets();
  //list of images
  List images=[Assets.firstOnbordingLogo,Assets.secoundtOnbordingLogo,Assets.thirdOnbordingLogo,Assets.secoundtOnbordingLogo];
  //Global variables
  int _currentpage=0;
  PageController _pageController=PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //first component in stack (text , circle,points)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //circle
                Container(
                  margin: EdgeInsets.only(bottom: 60),
                  height: 320,
                  decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: Colors.black,width: 1),),
                ),

              //text
              Text("like in a Restaurant but at home",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),SizedBox(height: 25,),
              Center(child: Text(",consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea qui officia deserunt mollit anim id est laborum.",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w200),textAlign:TextAlign.center,)),

                //texts & points
                SizedBox(height: 70,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //skip
                    TextButton(onPressed: (){}, child: Text("Skip",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15,color: AppColors.primary),),),

                    //points
                    Row(children: [
                      ...List.generate(4, (index) => AnimatedContainer(
                        margin: EdgeInsets.only(right: 10),
                        width: 25,
                        height: 10,
                        duration: Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                            color: _currentpage==index?AppColors.primary:Colors.black12,
                            shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(4)),
                      ),)
                    ],),

                    //next text
                   _currentpage!=3?TextButton(onPressed: (){
                      _pageController.nextPage(duration: Duration(milliseconds: 800), curve: Curves.decelerate);
                    }, child:Text("Next",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15,color: AppColors.primary),),):
                   TextButton(onPressed: (){}, child:Text("Login",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15,color: AppColors.primary),),),

                  ],
                )
              ],),),

          //circle container (secound component)
          Container(
            height: 420,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(350),bottomRight: Radius.circular(350),)
            ),),

          //third component (logo & image & pageview)
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              children: [
              //logo
              Center(child: Image(image:AssetImage("${Assets.icSplash}"),height:100,)),
                // pageview
                Container(
                  margin: EdgeInsets.only(top: 80),
                  height: 280,
                  width: 280,
                  child: PageView.builder(
                    padEnds: true,
                    onPageChanged: (value) {
                      setState(() {
                        _currentpage=value!;
                      });
                    },
                    controller: _pageController,
                    itemCount: images.length,
                      itemBuilder: (context, index) => CircleAvatar(backgroundImage: AssetImage("${images[index]}"),),
                  ),),
            ],),
          )],
      ),
    );
  }
}
