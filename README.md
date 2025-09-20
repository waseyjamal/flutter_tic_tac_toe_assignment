Tic-Tac-Toe Flutter App 🎮

A 2-player Tic-Tac-Toe game built with Flutter, playable on both Android and iOS devices. This app includes win/draw detection, animated highlights for winning cells, score tracking, and a restart/undo feature.

Demo Video

Note: For large videos, GitHub may not play it inline. See the video in your repository tic_tec_toe.mp4.

Features

Two-player game on the same device (X and O).

3×3 Grid UI for gameplay.

Current player display.

Win/draw detection.

Winning animation:

Glowing cells

Confetti celebration

Undo last move.

Restart board.

Reset player scores.

Responsive layout for phones and tablets.

Tech Stack

Flutter & Dart – App development

GetX – State management

Confetti Package – Winning animation


Getting Started

Clone the repository:

git clone https://github.com/waseyjamal/flutter_tic_tac_toe_assignment.git


Navigate to the project folder:

cd flutter_tic_tac_toe_assignment


Install dependencies:

flutter pub get


Run the app:

flutter run

How to Play

Players take turns placing X and O on the grid.

The current player is displayed at the top.

If a player wins, the winning cells glow and confetti appears.

Use Restart to reset the board, Reset Scores to clear scores, or Undo to undo the last move.

Challenges & Learnings

Managed reactive state with GetX for smooth updates.

Implemented animated winning highlights using AnimatedContainer + AnimationController.

Created undo, reset, and score-tracking logic.

Designed a responsive UI for different screen sizes.

Assignment Submission

GitHub Repository: Flutter Tic-Tac-Toe

Screenshot: tic_tec_toe.png

Gameplay Video: tic_tec_toe.mp4

Conclusion

This project showcases a complete Flutter app with interactive gameplay, animations, and responsive design, ready for both Android and iOS deployment.
