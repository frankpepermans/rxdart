import 'package:test/test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  test('rx.Observable.every', () async {
    final dynamic actual =
        await new Observable<int>.just(1).firstWhere((int val) => val == 1);

    await expect(actual, 1);
  });
}
