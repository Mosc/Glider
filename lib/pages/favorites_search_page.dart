import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/search_order.dart';
import 'package:glider/utils/color_extension.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/favorites/favorites_search_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeStateProvider<String> favoriteSearchQueryStateProvider =
    StateProvider.autoDispose<String>(
  (AutoDisposeStateProviderRef<String> ref) => '',
);

final AutoDisposeStateProvider<SearchOrder> favoriteSearchOrderStateProvider =
    StateProvider.autoDispose<SearchOrder>(
  (AutoDisposeStateProviderRef<SearchOrder> ref) => SearchOrder.byRelevance,
);

class FavoritesSearchPage extends HookConsumerWidget {
  const FavoritesSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.colorScheme.brightness.isDark;

    final ScrollController scrollController = useScrollController();

    final TextEditingController queryController = useTextEditingController();
    final StateController<String> favoriteSearchQueryStateController =
        ref.watch(favoriteSearchQueryStateProvider.state);
    final StateController<SearchOrder> favoriteSearchOrderStateController =
        ref.watch(favoriteSearchOrderStateProvider.state);

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
      child: Scaffold(
        body: FloatingAppBarScrollView(
          controller: scrollController,
          title: TextField(
            controller: queryController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).searchHint,
            ),
            textInputAction: TextInputAction.search,
            autofocus: true,
            onChanged: (String value) =>
                favoriteSearchQueryStateController.update((_) => value),
          ),
          actions: <Widget>[
            if (favoriteSearchQueryStateController.state.isNotEmpty)
              IconButton(
                icon: const Icon(FluentIcons.dismiss_24_regular),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () {
                  queryController.clear();
                  favoriteSearchQueryStateController.update((_) => '');
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
                  favoriteSearchOrderStateController.update((_) => searchOrder),
              tooltip: AppLocalizations.of(context).sort,
              icon: const Icon(FluentIcons.arrow_sort_down_lines_16_regular),
            ),
          ],
          body: const FavoritesSearchBody(),
        ),
      ),
    );
  }
}
