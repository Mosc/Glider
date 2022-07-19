import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/search_order.dart';
import 'package:glider/utils/color_extension.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/common/scroll_to_top_scaffold.dart';
import 'package:glider/widgets/items/item_search_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeStateProvider<String> itemSearchQueryStateProvider =
    StateProvider.autoDispose<String>(
  (AutoDisposeStateProviderRef<String> ref) => '',
);

final AutoDisposeStateProvider<SearchOrder> itemSearchOrderStateProvider =
    StateProvider.autoDispose<SearchOrder>(
  (AutoDisposeStateProviderRef<SearchOrder> ref) => SearchOrder.byRelevance,
);

class ItemSearchPage extends HookConsumerWidget {
  const ItemSearchPage({super.key, required this.storyId});

  final int storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.colorScheme.brightness.isDark;

    final TextEditingController queryController = useTextEditingController();
    final StateController<String> itemSearchQueryStateController =
        ref.watch(itemSearchQueryStateProvider.state);
    final StateController<SearchOrder> itemStoryTypeStateController =
        ref.watch(itemSearchOrderStateProvider.state);

    return Theme(
      data: theme.copyWith(
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: isDark ? null : theme.scaffoldBackgroundColor,
          iconTheme: theme.iconTheme,
          titleTextStyle: theme.textTheme.titleLarge,
          systemOverlayStyle: isDark
              ? null
              : SystemUiOverlayStyle(
                  statusBarColor: theme.scaffoldBackgroundColor,
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.dark,
                ),
        ),
        inputDecorationTheme:
            theme.inputDecorationTheme.copyWith(border: InputBorder.none),
      ),
      child: ScrollToTopScaffold(
        body: FloatingAppBarScrollView(
          title: TextField(
            controller: queryController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).searchHint,
            ),
            textInputAction: TextInputAction.search,
            autofocus: true,
            onChanged: (String value) =>
                itemSearchQueryStateController.update((_) => value),
          ),
          actions: <Widget>[
            if (itemSearchQueryStateController.state.isNotEmpty)
              IconButton(
                icon: const Icon(FluentIcons.dismiss_24_regular),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () {
                  queryController.clear();
                  itemSearchQueryStateController.update((_) => '');
                },
              ),
            PopupMenuButton<SearchOrder>(
              itemBuilder: (_) => <PopupMenuEntry<SearchOrder>>[
                for (SearchOrder searchOrder in SearchOrder.values)
                  PopupMenuItem<SearchOrder>(
                    value: searchOrder,
                    child: Text(searchOrder.title(context)),
                  ),
              ],
              onSelected: (SearchOrder searchOrder) =>
                  itemStoryTypeStateController.update((_) => searchOrder),
              tooltip: AppLocalizations.of(context).sort,
              icon: const Icon(FluentIcons.arrow_sort_down_lines_16_regular),
            ),
          ],
          body: ItemSearchBody(storyId: storyId),
        ),
      ),
    );
  }
}
