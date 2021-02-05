import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  const StoriesSearchPage({Key key, this.enableSearch = true})
      : super(key: key);

  final bool enableSearch;

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

    final AnimationController animationController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );
    final double bottomHeightFactor = useAnimation(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    useMemoized(animationController.forward);

    final ThemeData theme = Theme.of(context);
    final bool dark = theme.colorScheme.brightness == Brightness.dark;

    return Theme(
      data: theme.copyWith(
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: dark ? null : theme.scaffoldBackgroundColor,
          iconTheme: theme.iconTheme,
          titleTextStyle: theme.textTheme.headline6,
          systemOverlayStyle:
              dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
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
              title: enableSearch
                  ? TextField(
                      controller: queryController,
                      decoration: const InputDecoration(hintText: 'Search...'),
                      textInputAction: TextInputAction.search,
                      autofocus: true,
                      onChanged: (String value) =>
                          storySearchQueryStateController.state = value,
                    )
                  : const Text('Catch up'),
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
              bottom: _buildBottom(
                context,
                storySearchRangeStateController,
                heightFactor: bottomHeightFactor,
              ),
              forceElevated: innerBoxIsScrolled,
              floating: true,
              backwardsCompatibility: false,
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
            useRotationAnimation: false,
            icon: searchStoryTypeStateController.state.icon,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            animationSpeed: 100,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildBottom(BuildContext context,
      StateController<SearchRange> storySearchRangeStateController,
      {double heightFactor}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight * heightFactor),
      child: ClipRect(
        child: Align(
          heightFactor: heightFactor,
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: <Widget>[
                  for (SearchRange searchRange in SearchRange.values)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildChip(
                        searchRange,
                        storySearchRangeStateController,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(SearchRange searchRange,
      StateController<SearchRange> storySearchRangeStateController) {
    return ChoiceChip(
      label: Text(searchRange.title),
      selected: storySearchRangeStateController.state == searchRange,
      onSelected: (bool selected) =>
          storySearchRangeStateController.state = selected ? searchRange : null,
    );
  }
}
