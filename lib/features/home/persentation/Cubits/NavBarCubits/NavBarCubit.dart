import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Profile/data/Model/UserModel.dart';
import 'NavBarState.dart';

class NavBarCubit extends Cubit<NavBarState> {
  int _currentIndex = 0; // Keep track of the current navigation index
  UserModel? _currentUser; // Store the current user

  NavBarCubit() : super(NavBarInitial());

  int get currentIndex => _currentIndex;

  void moveChange(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;

      // Preserve the user state if already loaded
      if (_currentUser != null) {
        emit(UserLoaded(_currentUser!, _currentIndex));
      } else {
        emit(NavBarChanged(index));
      }
    }
  }

  Future<void> fetchCurrentUser() async {
    emit(UserLoading()); // Emit loading state
    try {
      // Get the current user's ID from FirebaseAuth
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        debugPrint('No user is logged in.');
        emit(UserFetchError('No user is logged in.'));
        return;
      }

      // Fetch the user's document from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        debugPrint('User document does not exist.');
        emit(UserFetchError('User document does not exist.'));
        return;
      }

      // Extract data and construct the UserModel
      Map<String, dynamic>? userData = userDoc.data();
      if (userData == null) {
        debugPrint('User document data is null.');
        emit(UserFetchError('User document data is null.'));
        return;
      }

      _currentUser = UserModel.fromFirestore(userData, userId);
      debugPrint('Current User Retrieved: ${_currentUser.toString()}');
      emit(UserLoaded(_currentUser!, _currentIndex)); // Emit loaded state with current index
    } catch (e, stackTrace) {
      debugPrint('Error fetching current user: $e');
      debugPrint('$stackTrace');
      emit(UserFetchError('Failed to fetch user: $e'));
    }
  }
}