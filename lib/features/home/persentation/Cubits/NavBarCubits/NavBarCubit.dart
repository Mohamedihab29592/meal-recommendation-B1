import 'package:flutter_bloc/flutter_bloc.dart';

import 'NavBarState.dart';

class NavBarCubit extends Cubit<NavBarState>{
  NavBarCubit():super(MovingState());
  int currentIndex=0;
  moveChange(value){
    currentIndex=value;
    emit(MovingState());
  }

}