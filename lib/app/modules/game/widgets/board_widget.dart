import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/app/modules/game/controllers/game_controller.dart';
import 'cell_widget.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();

    // LayoutBuilder to compute a square board based on available space
    return LayoutBuilder(
      builder: (context, constraints) {
        // prefer width but clamp for very tall screens
        final boardSize = (constraints.maxWidth * 0.92).clamp(
          220.0,
          constraints.maxHeight * 0.78,
        );
        final cellSize = boardSize / 3;

        return Container(
          width: boardSize,
          height: boardSize,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() {
            // Using GridView.builder ensures efficient cell building
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: cellSize,
                  height: cellSize,
                  child: CellWidget(index: index),
                );
              },
            );
          }),
        );
      },
    );
  }
}
