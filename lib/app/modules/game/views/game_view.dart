import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import '../controllers/game_controller.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView>
    with SingleTickerProviderStateMixin {
  final GameController controller = Get.find<GameController>();
  late ConfettiController _confettiController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double boardSize = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 45, 55, 72),
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F2937),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 57, 79, 110), // dark gray
              Color(0xFF2D3748), // grid similar color
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = MediaQuery.of(context).size.width;
              double screenHeight = MediaQuery.of(context).size.height;
              double boardSize = screenWidth < screenHeight
                  ? screenWidth * 0.9
                  : screenHeight * 0.7; // ✅ Adjusts for horizontal tablets

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Current Player Display
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => _playerBox('X')),
                          const SizedBox(width: 16),
                          const Text(
                            'VS',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Obx(() => _playerBox('O')),
                        ],
                      ),
                    ),

                    // Tic-Tac-Toe Board + Confetti
                    Center(
                      child: Stack(
                        alignment:
                            Alignment.center, // ✅ center confetti on grid
                        children: [
                          // Grid Container
                          Container(
                            width: boardSize,
                            height: boardSize,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D3748),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(4, 8),
                                ),
                              ],
                            ),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 9,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                              itemBuilder: (context, index) {
                                return Obx(() {
                                  final isWinningCell = controller
                                      .winningIndices
                                      .contains(index);
                                  final cellValue = controller.board[index];

                                  return AnimatedBuilder(
                                    animation: _glowController,
                                    builder: (context, child) {
                                      return GestureDetector(
                                        onTap: () => controller.makeMove(index),
                                        child: Container(
                                          margin: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF374151),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                              if (isWinningCell)
                                                BoxShadow(
                                                  color: Colors.greenAccent
                                                      .withOpacity(
                                                        0.5 +
                                                            0.5 *
                                                                _glowController
                                                                    .value,
                                                      ),
                                                  blurRadius: 16,
                                                  spreadRadius: 4,
                                                ),
                                            ],
                                          ),
                                          child: Center(
                                            child: _AnimatedCellSymbol(
                                              symbol: cellValue,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                });
                              },
                            ),
                          ),

                          // Confetti Widget
                          Obx(() {
                            if (controller.resultMessage.value.contains(
                              'wins',
                            )) {
                              _confettiController.play();
                            }
                            return ConfettiWidget(
                              confettiController: _confettiController,
                              blastDirectionality:
                                  BlastDirectionality.explosive,
                              shouldLoop: false,
                              maxBlastForce: 20,
                              minBlastForce: 5,
                              emissionFrequency: 0.05,
                              numberOfParticles: 30,
                              gravity: 0.2,
                            );
                          }),
                        ],
                      ),
                    ),

                    // Result Message below grid
                    Obx(() {
                      return Text(
                        controller.resultMessage.value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),

                    // Scores Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => _buildScoreCard(
                              'X',
                              controller.scoreX.value,
                              const Color(0xFF8B5CF6),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Obx(
                            () => _buildScoreCard(
                              'O',
                              controller.scoreO.value,
                              const Color(0xFFF43F5E),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                    // Action Buttons Row
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildActionButton(
                              'Undo',
                              controller.undoLastMove,
                              const Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 8),
                            _buildActionButton(
                              'Restart',
                              controller.restartBoard,
                              const Color(0xFF8B5CF6),
                            ),
                            const SizedBox(width: 8),
                            _buildActionButton(
                              'Reset Scores',
                              controller.resetGame,
                              const Color(0xFFF43F5E),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _playerBox(String player) {
    final bool isActive = controller.currentPlayer.value == player;

    return AnimatedScale(
      scale: isActive ? 1.3 : 1.0, // zoom effect
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Text(
        player,
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: isActive
              ? (player == 'X'
                    ? const Color(0xFF8B5CF6) // purple for X
                    : const Color(0xFFF43F5E)) // red for O
              : const Color(0xFF9CA3AF), // grey when inactive
        ),
      ),
    );
  }

  Widget _buildScoreCard(String player, int score, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Player $player',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        shadowColor: color.withOpacity(0.5),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Animated X or O Symbol
class _AnimatedCellSymbol extends StatefulWidget {
  final String symbol;
  const _AnimatedCellSymbol({super.key, required this.symbol});

  @override
  State<_AnimatedCellSymbol> createState() => _AnimatedCellSymbolState();
}

class _AnimatedCellSymbolState extends State<_AnimatedCellSymbol>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 250, // very slow
      ),
    );

    _scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _opacityAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    if (widget.symbol.isNotEmpty) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedCellSymbol oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.symbol != widget.symbol && widget.symbol.isNotEmpty) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.symbol.isEmpty) return const SizedBox.shrink();

    return FadeTransition(
      opacity: _opacityAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Text(
          widget.symbol,
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: widget.symbol == 'X'
                ? const Color(0xFF8B5CF6)
                : const Color(0xFFF43F5E),
          ),
        ),
      ),
    );
  }
}
