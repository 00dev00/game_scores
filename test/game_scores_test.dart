import 'package:game_scores/game.dart';
import 'package:test/test.dart';

void main() {
  group(
    "Test getScore with Stamp objects",
    () {
      compare(Stamp stamp1, Stamp stamp2) =>
          stamp1.offset.compareTo(stamp2.offset);

      const emptyScore = Score(home: 0, away: 0);

      final List<Stamp> stamps = [
        Stamp(
          offset: 2,
          score: Score(home: 0, away: 0),
        ),
        Stamp(
          offset: 5,
          score: Score(home: 0, away: 1),
        ),
        Stamp(
          offset: 7,
          score: Score(home: 1, away: 1),
        ),
        Stamp(
          offset: 2,
          score: Score(home: 1, away: 2),
        ),
      ];

      late Stamp itemToFind;

      setUp(() {
        itemToFind = Stamp(offset: 7, score: emptyScore);
      });

      test(
        'Binary search should return index of the stamp with offset 7',
        () {
          expect(
            binarySearch<Stamp>(stamps, itemToFind, compare),
            equals(2),
          );
        },
      );

      test(
        'Binary search should return -1 for missing offset',
        () {
          itemToFind = Stamp(offset: 12, score: emptyScore);

          expect(
            binarySearch<Stamp>(stamps, itemToFind, compare),
            equals(-1),
          );
        },
      );

      test(
        'getScore should return correct Score for specified offset',
        () {
          var score = getScore(stamps, 7);
          expect(
            score.home,
            equals(1),
          );
          expect(
            score.away,
            equals(1),
          );
        },
      );

      test(
        'getScore should return empty Stamp for specified offset',
        () {
          var score = getScore(stamps, 15);
          expect(
            score,
            equals(emptyScore),
          );
        },
      );
    },
  );
}
