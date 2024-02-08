import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/models/item_value.dart';
import 'package:glider/wallabag/cubit/wallabag_cubit.dart';

part 'wallabag_add_state.dart';

class WallabagAddCubit extends Cubit<WallabagAddState> {
  WallabagAddCubit(
    this._wallabagCubit,
    this._itemCubit, {
    required this.tags,
    required this.useHNTitle,
  }) : super(WallabagAddState());

  final WallabagCubit _wallabagCubit;
  final ItemCubit _itemCubit;
  final String? tags;
  final bool useHNTitle;

  Future<void> load() async {
    final item = _itemCubit.state.data!;

    safeEmit(WallabagAddState(status: Status.loading));

    final service = (_wallabagCubit.state.status == Status.success &&
            _wallabagCubit.state.data != null)
        ? _wallabagCubit.state.data
        : await _wallabagCubit.validate();

    if (service != null) {
      try {
        final processedHttpCode = await service.entryAdd(
          articleUrl: item.url!,
          commaSeparatedTags: tags,
          originUrl: Uri.parse(ItemValue.itemLink.value(_itemCubit)!),
          title: useHNTitle ? ItemValue.title.value(_itemCubit) : null,
        );
        safeEmit(
          state.copyWith(
            data: () => processedHttpCode,
            status: () => Status.success,
          ),
        );
      } on Object catch (exception) {
        safeEmit(
          state.copyWith(
            status: () => Status.failure,
            exception: () => exception,
          ),
        );
      }
    } else {
      safeEmit(
        state.copyWith(
          status: () => Status.failure,
          exception: () => _wallabagCubit.state.exception,
        ),
      );
    }
  }
}
