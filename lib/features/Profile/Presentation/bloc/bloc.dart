import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/profile/Presentation/bloc/state.dart';
import '../../domain/usecase/editUser.dart';
import '../../domain/usecase/getUser.dart';
import 'event.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileUseCase getUserProfile;
  final UpdateUserProfileUseCase updateUserProfile;

  UserProfileBloc({required this.getUserProfile, required this.updateUserProfile}) : super(UserProfileInitial());

  Stream<UserProfileState> mapEventToState(UserProfileEvent event) async* {
    if (event is LoadUserProfile) {
      yield UserProfileLoading();
      try {
        final user = await getUserProfile(event.userId);
        yield UserProfileLoaded(user);
      } catch (e) {
        yield UserProfileError(e.toString());
      }
    } else if (event is UpdateUserProfile) {
      yield UserProfileUpdating();
      try {
        await updateUserProfile(event.updatedUser);
        yield UserProfileUpdated();
      } catch (e) {
        yield UserProfileError(e.toString());
      }
    }
  }
}
