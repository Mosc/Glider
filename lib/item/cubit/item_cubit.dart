import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/common/widgets/hacker_news_text.dart';
import 'package:glider/item/models/vote_type.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:share_plus/share_plus.dart';

part 'item_cubit_event.dart';
part 'item_state.dart';

class ItemCubit extends HydratedCubit<ItemState>
    with BlocPresentationMixin<ItemState, ItemCubitEvent> {
  ItemCubit(
    this._itemRepository,
    this._itemInteractionRepository,
    this._userInteractionRepository, {
    required int id,
  })  : itemId = id,
        _blockedSubscription = null,
        super(const ItemState()) {
    safeEmit(
      state.copyWith(status: () => Status.loading),
    );
    _itemSubscription = _itemRepository.getItemStream(itemId).listen(
      (item) async {
        if (item.username != state.data?.username ||
            _blockedSubscription == null) {
          unawaited(_blockedSubscription?.cancel());

          if (item.username case final username?) {
            _blockedSubscription =
                _userInteractionRepository.blockedStream.listen(
              (blocked) => safeEmit(
                state.copyWith(blocked: () => blocked.contains(username)),
              ),
            );
          }
        }

        safeEmit(
          state.copyWith(
            status: () => Status.success,
            data: () => item,
            parsedText: () => switch (item.text) {
              final String text => HackerNewsText.parse(text),
              _ => null,
            },
            exception: () => null,
          ),
        );
      },
      // ignore: avoid_types_on_closure_parameters
      onError: (Object exception) => safeEmit(
        state.copyWith(
          status: () => Status.failure,
          exception: () => exception,
        ),
      ),
    );
    _visitedSubscription = _itemInteractionRepository.visitedStream.listen(
      (visited) => safeEmit(
        state.copyWith(visited: () => visited.contains(itemId)),
      ),
    );
    _upvotedSubscription = _itemInteractionRepository.upvotedStream.listen(
      (upvoted) => safeEmit(
        state.copyWith(
          vote: () => upvoted.contains(itemId)
              ? VoteType.upvote
              : state.vote.upvoted
                  ? null
                  : state.vote,
        ),
      ),
    );
    _downvotedSubscription = _itemInteractionRepository.downvotedStream.listen(
      (downvoted) => safeEmit(
        state.copyWith(
          vote: () => downvoted.contains(itemId)
              ? VoteType.downvote
              : state.vote.downvoted
                  ? null
                  : state.vote,
        ),
      ),
    );
    _favoritedSubscription = _itemInteractionRepository.favoritedStream.listen(
      (favorited) => safeEmit(
        state.copyWith(favorited: () => favorited.contains(itemId)),
      ),
    );
    _flaggedSubscription = _itemInteractionRepository.flaggedStream.listen(
      (flagged) => safeEmit(
        state.copyWith(flagged: () => flagged.contains(itemId)),
      ),
    );
  }

  final ItemRepository _itemRepository;
  final ItemInteractionRepository _itemInteractionRepository;
  final UserInteractionRepository _userInteractionRepository;
  final int itemId;

  late final StreamSubscription<Item> _itemSubscription;
  late final StreamSubscription<List<int>> _visitedSubscription;
  late final StreamSubscription<List<int>> _upvotedSubscription;
  late final StreamSubscription<List<int>> _downvotedSubscription;
  late final StreamSubscription<List<int>> _favoritedSubscription;
  late final StreamSubscription<List<int>> _flaggedSubscription;
  StreamSubscription<List<String>>? _blockedSubscription;

  @override
  String get id => itemId.toString();

  Future<void> load() async {
    safeEmit(
      state.copyWith(status: () => Status.loading),
    );
    await _itemRepository.getItem(itemId);
  }

  Future<void> visit(bool visit) async {
    final visited = state.visited;
    safeEmit(
      state.copyWith(visited: () => visit),
    );
    final success =
        await _itemInteractionRepository.visit(itemId, visit: visit);

    if (!success) {
      safeEmit(
        state.copyWith(visited: () => visited),
      );
    }
  }

  Future<void> upvote(bool upvote) async {
    final vote = state.vote;
    safeEmit(
      state.copyWith(vote: () => VoteType.upvote),
    );
    final success =
        await _itemInteractionRepository.upvote(itemId, upvote: upvote);

    if (!success) {
      safeEmit(
        state.copyWith(vote: () => vote),
      );
      emitPresentation(const ItemActionFailedEvent());
    } else {
      await load();
    }
  }

  Future<void> downvote(bool downvote) async {
    final vote = state.vote;
    safeEmit(
      state.copyWith(vote: () => VoteType.downvote),
    );
    final success =
        await _itemInteractionRepository.downvote(itemId, downvote: downvote);

    if (!success) {
      safeEmit(
        state.copyWith(vote: () => vote),
      );
      emitPresentation(const ItemActionFailedEvent());
    } else {
      await load();
    }
  }

  Future<void> favorite(bool favorite) async {
    final favorited = state.favorited;
    safeEmit(
      state.copyWith(favorited: () => favorite),
    );
    final success =
        await _itemInteractionRepository.favorite(itemId, favorite: favorite);

    if (!success) {
      safeEmit(
        state.copyWith(favorited: () => favorited),
      );
      emitPresentation(const ItemActionFailedEvent());
    }
  }

  Future<void> flag(bool flag) async {
    final flagged = state.flagged;
    safeEmit(
      state.copyWith(flagged: () => flag),
    );
    final success = await _itemInteractionRepository.flag(itemId, flag: flag);

    if (!success) {
      safeEmit(
        state.copyWith(flagged: () => flagged),
      );
      emitPresentation(const ItemActionFailedEvent());
    } else {
      await load();
    }
  }

  Future<void> delete() async {
    final isDeleted = state.data?.isDeleted ?? false;
    safeEmit(
      state.copyWith(
        data: () => state.data?.copyWith(isDeleted: () => true),
      ),
    );
    final success = await _itemInteractionRepository.delete(itemId);

    if (!success) {
      safeEmit(
        state.copyWith(
          data: () => state.data?.copyWith(isDeleted: () => isDeleted),
        ),
      );
      emitPresentation(const ItemActionFailedEvent());
    } else {
      await load();
    }
  }

  Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> share(String text, {String? subject}) async {
    await Share.share(text, subject: subject);
  }

  @override
  ItemState? fromJson(Map<String, dynamic> json) => ItemState.fromMap(json);

  @override
  Map<String, dynamic>? toJson(ItemState state) =>
      state.status == Status.success ? state.toMap() : null;

  @override
  Future<void> close() async {
    await _itemSubscription.cancel();
    await _visitedSubscription.cancel();
    await _upvotedSubscription.cancel();
    await _downvotedSubscription.cancel();
    await _favoritedSubscription.cancel();
    await _flaggedSubscription.cancel();
    await _blockedSubscription?.cancel();
    return super.close();
  }
}
