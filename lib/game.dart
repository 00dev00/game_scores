import 'dart:math';

const timestampsCount = 5;
const probabilityScoreChanged = 0.0001;
const probabilityHomeScore = 0.45;
const offsetMaxStep = 3;

class Score {
  final int home;
  final int away;

  const Score({
    required this.home,
    required this.away,
  });
}

class Stamp {
  final int offset;
  final Score score;

  const Stamp({
    required this.offset,
    required this.score,
  });
}

const Score emptyScore = Score(
  home: 0,
  away: 0,
);

const Stamp emptyScoreStamp = Stamp(
  offset: 0,
  score: emptyScore,
);

List<Stamp> generateGame() {
  final stamps =
      List<Stamp>.generate(timestampsCount, (score) => emptyScoreStamp);

  var currentStamp = stamps[0];

  for (var i = 0; i < timestampsCount; i++) {
    currentStamp = generateStamp(currentStamp);
    stamps[i] = currentStamp;
  }

  return stamps;
}

Stamp generateStamp(Stamp prev) {
  final scoreChanged = Random().nextDouble() > (1 - probabilityScoreChanged);
  final homeScoreChange =
      scoreChanged && Random().nextDouble() < probabilityHomeScore ? 1 : 0;

  final awayScoreChange = scoreChanged && !(homeScoreChange > 0) ? 1 : 0;
  final offsetChange = (Random().nextDouble() * offsetMaxStep).floor() + 1;

  return Stamp(
    offset: prev.offset + offsetChange,
    score: Score(
      home: prev.score.home + homeScoreChange,
      away: prev.score.away + awayScoreChange,
    ),
  );
}

// использую бинарный поиск, т.к. оффсеты в сгенерированном массиве
// упорядочены по возрастанию естественным образом
Score getScore(List<Stamp> gameStamps, int offset) {
  compare(Stamp stamp1, Stamp stamp2) => stamp1.offset.compareTo(stamp2.offset);

  var scoreToSearch = Stamp(offset: offset, score: emptyScore);
  int index = binarySearch<Stamp>(gameStamps, scoreToSearch, compare);

  // явного указания на то, как действовать
  // в случае отсутствия элемента в списке нет,
  // поэтому будем возвращать пустой Score,
  // что представляется наиболее разумным в данном случае
  return index == -1 ? emptyScore : gameStamps[index].score;
}

// возвращаем индекс, а не найденный объект на тот случай,
// если нам нужно будет знать положение элемента в массиве
int binarySearch<T>(List<T> items, T itemToFind, Function(T, T) compare) {
  int lowerBound = 0;
  int upperBound = items.length - 1;

  while (lowerBound <= upperBound) {
    int currIndex = lowerBound + ((upperBound - lowerBound) ~/ 2);
    T item = items[currIndex];
    int compResult = compare(item, itemToFind);

    if (compResult == 0) {
      return currIndex;
    } else if (compResult < 0) {
      lowerBound = currIndex + 1;
    } else {
      upperBound = currIndex - 1;
    }
  }

  return -1;
}
