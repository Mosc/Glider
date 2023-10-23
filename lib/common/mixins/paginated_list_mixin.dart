import 'package:glider/common/mixins/data_mixin.dart';

const _pageSize = 30;

mixin PaginatedListMixin<T> on DataMixin<List<T>> {
  int get page;

  Iterable<T>? get loadedData => data?.take(page * _pageSize);

  Iterable<T>? get currentPageData => loadedData?.skip((page - 1) * _pageSize);
}
