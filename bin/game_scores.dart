import 'dart:math';

import 'package:game_scores/game.dart';

void main() {
  final game = generateGame();

  final randOffset = Random().nextInt(game[game.length - 1].offset);
  Score score = getScore(game, randOffset);

  if (score == emptyScore) {
    print("Score wasn't found");
  } else {
    print("Home - away ${score.home}:${score.home}\nOffset: $randOffset");
  }
}
