import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/app/modules/game/controllers/game_controller.dart';

class CellWidget extends StatelessWidget {
  final int index;
  const CellWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();

    // Obx rebuilds only when board or winningIndices change
    return Obx(() {
      final cellValue = controller.board[index]; // '' / 'X' / 'O'
      final isWinner = controller.winningIndices.contains(index);
      final theme = Theme.of(context);

      // Small color mapping for X/O
      final textColor = cellValue == 'X'
          ? Colors.blue.shade700
          : Colors.red.shade700;

      return GestureDetector(
        onTap: () =>
            controller.makeMove(index), // delegate action to controller
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isWinner
                ? Colors.yellow.withOpacity(0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Center(
            // Combine small placement animation + scale for winning cells
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 1.0,
                end: cellValue.isEmpty ? 1.0 : (isWinner ? 1.18 : 1.06),
              ),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Text(
                cellValue,
                style: TextStyle(
                  fontSize:
                      MediaQuery.of(context).size.width *
                      0.095, // responsive font
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
