import 'package:flutter_bloc/flutter_bloc.dart';

import 'NavBarState.dart';

class NavBarCubit extends Cubit<NavBarState> {
  int _currentIndex = 0;

  NavBarCubit() : super(NavBarInitial());

  int get currentIndex => _currentIndex;

  void moveChange(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;
      emit(NavBarChanged(index));
    }
  }
}

