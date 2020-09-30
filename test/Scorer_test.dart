import 'package:flutter_test/flutter_test.dart';
import 'package:boggle/Game/Scorer.dart';

void main() {
  test('Duplicates should be removed', () {
    Map<String, Set> wordLists = {
      'player1' : {'cat', 'dog', 'bird'},
      'player2' : {'cat', 'rat', 'bird'}
    };
    Scorer scorer = Scorer(wordLists);
    scorer.generateScores();
    expect(scorer.getWords('player1'), {'dog'});
    expect(scorer.getWords('player2'), {'rat'});
  });
  test('Point value test',() {
    Map<String, Set> wordList = {
      'player0' : {'', 'bog'},
      'player1' : {'dog', 'a'},
      'player2' : {'ab', 'dog'},
      'player3' : {'abc', 'bog'},
      'player4' : {'abcd', 'log'},
      'player5' : {'abcde', 'log'},
      'player6' : {'dog', 'frog', 'abcdef'},
      'player7' : {'dog', 'abcdefg', 'frog', 'bog'},
      'player8' : {'abcdefgh', 'log', 'bog', 'dog'},
      'player9' : {'abcdefghi', 'dog'}
    };
    List scores = [0, 0, 0, 1, 1, 2, 3, 5, 11, 18];
    Scorer scorer = Scorer(wordList);
    scorer.generateScores();
    for (int i=0; i<scores.length; i++) {
      expect(scorer.getScore('player$i') == scores[i], true);
    }
  });
}