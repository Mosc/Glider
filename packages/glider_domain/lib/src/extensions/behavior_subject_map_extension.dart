import 'dart:async';

import 'package:glider_domain/src/extensions/behavior_subject_extension.dart';
import 'package:rxdart/subjects.dart';

extension BehaviorSubjectMapExtension<K, T> on Map<K, BehaviorSubject<T>> {
  BehaviorSubject<T> getOrAdd(K key, {Future<T> Function()? asyncSeed}) {
    if (!containsKey(key)) {
      this[key] = BehaviorSubject<T>();

      if (asyncSeed != null) {
        unawaited(this[key]!.addAsync(asyncValue: asyncSeed));
      }
    }

    return this[key]!;
  }
}
