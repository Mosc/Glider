import 'package:glider/common/mixins/data_mixin.dart';

mixin PaginatedListMixin<T> on DataMixin<List<T>> {
  static const pageSize = 30;

  int get page;

  Iterable<T>? get loadedData => data?.take(page * pageSize);

  Iterable<T>? get currentPageData => loadedData?.skip((page - 1) * pageSize);
}
