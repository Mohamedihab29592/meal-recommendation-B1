import '../../../../Profile/data/Model/UserModel.dart';

abstract class NavBarState {}

class NavBarInitial extends NavBarState {}

class NavBarChanged extends NavBarState {
  final int index;
  NavBarChanged(this.index);
}

class UserLoading extends NavBarState {}

class UserLoaded extends NavBarState {
  final UserModel user;
  final int currentIndex; // Include current index for consistency
  UserLoaded(this.user, this.currentIndex);
}

class UserFetchError extends NavBarState {
  final String errorMessage;
  UserFetchError(this.errorMessage);
}