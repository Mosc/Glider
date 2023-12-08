import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';

EventTransformer<Event> debounce<Event>(Duration duration) =>
    (events, mapper) => events.debounceTime(duration).switchMap(mapper);
