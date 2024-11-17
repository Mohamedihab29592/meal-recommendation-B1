abstract class ImagesState {}

class ImagesInitial extends ImagesState {}

class IsLoadingState extends ImagesState {
  final String id;
  IsLoadingState(this.id); // Identify the ingredient being updated
}

class LoadedImageState extends ImagesState {
  final String id;
  final String imageUrl;
  LoadedImageState(this.id, this.imageUrl);
}

class FailureImageError extends ImagesState {
  final String id;
  final String message;
  FailureImageError(this.id, this.message);
}