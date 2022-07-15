import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/utils/pagination_mixin.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/inbox/inbox_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeStateProvider<int> inboxPaginationStateProvider =
    StateProvider.autoDispose<int>(
  (AutoDisposeStateProviderRef<int> ref) => PaginationMixin.initialPage,
);

class InboxPage extends HookConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FloatingAppBarScrollView(
        title: Text(AppLocalizations.of(context).inbox),
        body: const InboxBody(),
      ),
    );
  }
}
