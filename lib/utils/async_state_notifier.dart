import 'package:hooks_riverpod/hooks_riverpod.dart';

class AsyncStateNotifier<T> extends StateNotifier<AsyncValue<T>> {
  AsyncStateNotifier(this.getData) : super(AsyncValue<T>.loading()) {
    load();
  }

  final Future<T> Function() getData;

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
