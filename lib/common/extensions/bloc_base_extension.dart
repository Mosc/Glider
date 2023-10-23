import 'package:bloc/bloc.dart';

extension BlocBaseExtension<T> on BlocBase<T> {
  void safeEmit(T state) {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    if (!isClosed) emit(state);
  }
}
