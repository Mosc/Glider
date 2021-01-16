import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:glider/models/search_range.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/utils/app_bar_util.dart';
import 'package:glider/widgets/items/stories_search_body.dart';
import 'package:hooks_riverpod/all.dart';

final AutoDisposeStateProvider<String> storySearchQueryStateProvider =
    StateProvider.autoDispose<String>((ProviderReference ref) => '');

final AutoDisposeStateProvider<SearchRange> storySearchRangeStateProvider =
    StateProvider.autoDispose<SearchRange>(
        (ProviderReference ref) => SearchRange.pastMonth);

final AutoDisposeStateProvider<StoryType> storySearchTypeStateProvider =
    StateProvider.autoDispose<StoryType>(
        (ProviderReference ref) => StoryType.bestStories);

class StoriesSearchPage extends HookWidget {
  const StoriesSearchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> speedDialVisibleState = useState(true);
    final ScrollController scrollController = useScrollController();
    useEffect(
      () {
        void onScrollForwardListener() => speedDialVisibleState.value =
            scrollController.position.userScrollDirection ==
                ScrollDirection.forward;
        scrollController.addListener(onScrollForwardListener);
        return () => scrollController.removeListener(onScrollForwardListener);
      },
      <Object>[scrollController],
    );

    final TextEditingController queryController = useTextEditingController();
    final StateController<String> storySearchQueryStateController =
        useProvider(storySearchQueryStateProvider);
    final StateController<SearchRange> storySearchRangeStateController =
        useProvider(storySearchRangeStateProvider);
    final StateController<StoryType> searchStoryTypeStateController =
        useProvider(storySearchTypeStateProvider);

    final ThemeData theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        appBarTheme: theme.appBarTheme.copyWith(
          color: theme.colorScheme.brightness == Brightness.dark
              ? null
              : theme.scaffoldBackgroundColor,
          iconTheme: theme.iconTheme,
        ),
        inputDecorationTheme:
            theme.inputDecorationTheme.copyWith(border: InputBorder.none),
      ),
      child: Scaffold(
        body: NestedScrollView(
          controller: scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (_, bool innerBoxIsScrolled) => <Widget>[
            SliverAppBar(
              leading: AppBarUtil.buildFluentIconsLeading(context),
              title: TextField(
                controller: queryController,
                decoration: const InputDecoration(hintText: 'Search...'),
                textInputAction: TextInputAction.search,
                autofocus: true,
                onChanged: (String value) =>
                    storySearchQueryStateController.state = value,
              ),
              actions: <Widget>[
                if (storySearchQueryStateController.state.isNotEmpty)
                  IconButton(
                    icon: const Icon(FluentIcons.dismiss_24_filled),
                    tooltip:
                        MaterialLocalizations.of(context).closeButtonTooltip,
                    onPressed: () {
                      queryController.clear();
                      storySearchQueryStateController.state = '';
                    },
                  )
              ],
              bottom: _buildBottom(context, storySearchRangeStateController),
              forceElevated: innerBoxIsScrolled,
              floating: true,
            ),
          ],
          body: const StoriesSearchBody(),
        ),
        floatingActionButton: Hero(
          tag: 'fab',
          child: SpeedDial(
            children: <SpeedDialChild>[
              for (StoryType storyType in StoryType.values
                  .where((StoryType storyType) => storyType.searchable))
                SpeedDialChild(
                  label: storyType.title,
                  child: Icon(storyType.icon),
                  onTap: () => searchStoryTypeStateController.state = storyType,
                ),
            ],
            visible: speedDialVisibleState.value,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            animationSpeed: 100,
            child: Icon(searchStoryTypeStateController.state.icon),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildBottom(BuildContext context,
      StateController<SearchRange> storySearchRangeStateController) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: <Widget>[
                for (SearchRange searchRange in SearchRange.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(searchRange.title),
                      selected:
                          storySearchRangeStateController.state == searchRange,
                      onSelected: (bool selected) =>
                          storySearchRangeStateController.state =
                              selected ? searchRange : null,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
