class Game {
  List<String> board; // Stores board state: ["", "X", "O", ...]
  String currentPlayer; // Whose turn: "X" or "O"
  String? winner; // "X", "O" or null for ongoing
  bool isDraw;

  Game({
    required this.board,
    required this.currentPlayer,
    this.winner,
    this.isDraw = false,
  });

  factory Game.initial() {
    return Game(
      board: List.filled(9, ""), // Empty 3x3 board
      currentPlayer: "X", // X always starts
    );
  }
}
