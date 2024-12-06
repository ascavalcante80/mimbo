import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'page_controller_state.dart';

class PageControllerCubit extends Cubit<PageControllerState> {
  PageControllerCubit() : super(PageControllerState(currentPageIndex: 0));

  void updateCurrentPageIndex(int index) =>
      emit(PageControllerState(currentPageIndex: index));
}
