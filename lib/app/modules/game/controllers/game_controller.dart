// lib/app/modules/game/controllers/game_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GameController extends GetxController {
  final RxList<String> board = List.generate(9, (index) => '').obs; // 3x3 board
  final RxString currentPlayer = 'X'.obs; // Tracks whose turn
  final RxList<int> winningIndices = <int>[].obs; // Winning line highlight

  final RxInt scoreX = 0.obs;
  final RxInt scoreO = 0.obs;
  final RxBool isGameOver = false.obs;
  final RxString resultMessage = ''.obs;

  final _storage = GetStorage();

  final List<List<int>> winPatterns = const [
    [0, 1, 2], // rows
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6], // columns
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8], // diagonals
    [2, 4, 6],
  ];

  final List<int> _moveHistory = []; // To support undo

  @override
  void onInit() {
    super.onInit();
    // Load saved scores
    scoreX.value = _storage.read('scoreX') ?? 0;
    scoreO.value = _storage.read('scoreO') ?? 0;
  }

  /// Handles player move
  void makeMove(int index) {
    if (board[index] != '' || isGameOver.value) return;

    board[index] = currentPlayer.value;
    _moveHistory.add(index);

    // Check winner
    if (_checkWinner(currentPlayer.value)) {
      isGameOver.value = true;
      resultMessage.value = '${currentPlayer.value} wins!';
      if (currentPlayer.value == 'X') {
        scoreX.value++;
        _storage.write('scoreX', scoreX.value);
      } else {
        scoreO.value++;
        _storage.write('scoreO', scoreO.value);
      }
      return;
    }

    // Check draw
    if (!board.contains('')) {
      isGameOver.value = true;
      resultMessage.value = 'It\'s a draw!';
      return;
    }

    // Switch turn
    currentPlayer.value = currentPlayer.value == 'X' ? 'O' : 'X';
  }

  /// Restart only board (keeps scores)
  void restartBoard() {
    board.fillRange(0, 9, '');
    winningIndices.clear();
    isGameOver.value = false;
    resultMessage.value = '';
    currentPlayer.value = 'X';
    _moveHistory.clear();
  }

  /// Full reset (board + scores)
  void resetGame() {
    restartBoard();
    scoreX.value = 0;
    scoreO.value = 0;
    _storage.write('scoreX', 0);
    _storage.write('scoreO', 0);
  }

  /// Undo last move
  void undoLastMove() {
    if (_moveHistory.isEmpty || isGameOver.value) return;
    int lastIndex = _moveHistory.removeLast();
    board[lastIndex] = '';
    currentPlayer.value = currentPlayer.value == 'X' ? 'O' : 'X';
  }

  /// Check winner
  bool _checkWinner(String symbol) {
    for (var pattern in winPatterns) {
      if (board[pattern[0]] == symbol &&
          board[pattern[1]] == symbol &&
          board[pattern[2]] == symbol) {
        winningIndices.assignAll(pattern);
        return true;
      }
    }
    return false;
  }
}
