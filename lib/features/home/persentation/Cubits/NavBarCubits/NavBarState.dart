// State classes
abstract class NavBarState {}

class NavBarInitial extends NavBarState {}

class NavBarChanged extends NavBarState {
  final int index;
  NavBarChanged(this.index);
}