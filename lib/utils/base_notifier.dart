import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseNotifier<T> extends StateNotifier<AsyncValue<T>> {
  BaseNotifier(this.read) : super(AsyncValue<T>.loading()) {
    load();
  }

  final Reader read;

  Future<T> getData();

  void setData(T data) => state = AsyncValue<T>.data(data);

  void setLoading() => state = AsyncValue<T>.loading();

  Future<T> load() async {
    return state.maybeWhen(
      data: (T data) => data,
      orElse: forceLoad,
    );
  }

  Future<T> forceLoad() async {
    final T data = await getData();
    setData(data);
    return data;
  }
}
