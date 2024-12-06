import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loading_user_display_event.dart';

part 'loading_user_display_state.dart';

class LoadingUserDisplayBloc extends Bloc<LoadUserDisplayEvent, LoadUserState> {
  LoadingUserDisplayBloc() : super(InitialState()) {
    on<LoadUserDisplayEvent>((mapEventToState));
  }

  void mapEventToState(
      LoadUserDisplayEvent event, Emitter<LoadUserState> emit) async {
    if (event is LoadingUserStartedEvent) {
      emit(LoadingUserState());
    } else if (event is UserNotFoundEvent) {
      emit(UserNotFoundState());
    } else if (event is LoadingProjectsEvent) {
      emit(LoadingProjectsState());
    } else if (event is LoadingCompleteEvent) {
      emit(LoadingCompleteState());
    } else if (event is ErrorLoadingUserEvent) {
      emit(ErrorLoadingUserState());
    } else {
      emit(InitialState());
    }
  }
}
