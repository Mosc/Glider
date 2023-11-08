import 'package:rxdart/subjects.dart';

extension BehaviorSubjectExtension<T> on BehaviorSubject<T> {
  Future<void> addAsync({required Future<T> Function() asyncValue}) async {
    try {
      final value = await asyncValue();
      add(value);
    } on Object catch (e, st) {
      addError(e, st);
    }
  }
}
