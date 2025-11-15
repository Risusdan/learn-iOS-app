# Rock Game - Tic-Tac-Toe

A modern, visually appealing Tic-Tac-Toe game built with SwiftUI, featuring custom rock images for game pieces and smooth animations.

## Tech Stack

### Core Technologies
- **SwiftUI** - Declarative UI framework for building the interface
- **Combine** - Reactive programming framework for state management
- **Swift** - Programming language (iOS 13.0+)

### Architecture & Patterns
- **MVVM (Model-View-ViewModel)** - Clean separation of concerns
  - `TicTacToeGame` (View) - Main game interface
  - `GameState` (ViewModel) - Game logic and state management
  - `Player` (Model) - Player enumeration

### Key SwiftUI Features

#### State Management
- `@StateObject` - Managing the game state lifecycle
- `@Published` - Publishing changes to the UI
- `ObservableObject` - Making GameState observable

#### Animations & Effects
- **Spring Animations** - Natural, physics-based motion
  - Response: 0.3-0.5s
  - Damping: 0.6-0.7
- **Transitions** - Scale and opacity effects for game over overlay
- **Namespace** - For matched geometry effects
- **Shadow Effects** - Dynamic shadows based on game state

#### UI Components
- **LinearGradient** - Background and text gradients
- **Custom Components**:
  - `PlayerScoreCard` - Displays player info and score
  - `CellView` - Interactive game board cells
- **Layout**:
  - VStack/HStack - Vertical and horizontal stacks
  - ZStack - Layering for overlays
  - Spacer - Flexible spacing

#### Gestures & Interactions
- **DragGesture** - Press state detection
- **simultaneousGesture** - Combining gesture recognizers
- **ButtonStyle** - Custom button interactions

## Features

### Game Mechanics
- Classic 3x3 Tic-Tac-Toe gameplay
- Two-player turn-based system
- Win detection (rows, columns, diagonals)
- Tie game detection
- Score tracking across multiple rounds

### Visual Design
- **Color Scheme**:
  - Player 1: Blue accent
  - Player 2: Purple accent
  - Winning cells: Green highlight
- **Modern UI**:
  - Rounded corners and soft shadows
  - Glass-morphism effect on game board
  - Gradient backgrounds
  - Active player indicators

### Animations
- **Turn Transitions** - Smooth player switching
- **Piece Placement** - Scale and fade-in effects
- **Win Celebration** - Rotating and scaling winning pieces
- **Button Press** - Scale feedback
- **Game Over Popup** - Scale and fade overlay

## File Structure

```
hw1/
├── hw1.xcodeproj/          # Xcode project file
└── hw1/
    ├── AppDelegate.swift       # App lifecycle management
    ├── SceneDelegate.swift     # Scene lifecycle management
    ├── ViewController.swift    # Initial view controller
    ├── TicTacToeGame.swift    # Main game implementation
    └── Assets.xcassets/
        ├── rock1.imageset/     # Player 1 rock image
        └── rock2.imageset/     # Player 2 rock image
```

## Implementation Details

### GameState Class
```swift
@MainActor
class GameState: ObservableObject {
    @Published var board: [[Player?]]           // 3x3 game board
    @Published var currentPlayer: Player        // Current turn
    @Published var winner: Player?              // Game outcome
    @Published var player1Score: Int           // Running score
    @Published var player2Score: Int           // Running score
    @Published var winningCells: Set<String>   // Highlighted cells
}
```

### Key Methods
- `makeMove(row:column:)` - Handles player moves
- `checkWinner()` - Evaluates win conditions
- `isWinningCell(row:column:)` - Checks if cell is part of winning line
- `resetGame()` - Resets board for new round
- `resetAll()` - Resets board and scores

## Learning Outcomes

This project demonstrates proficiency in:
- SwiftUI view composition and layout
- State management with Combine
- Animation and transitions
- Custom reusable components
- Game logic implementation
- Asset management in Xcode
- Responsive UI design
- iOS app architecture patterns

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## How to Run

1. Open `hw1.xcodeproj` in Xcode
2. Select a simulator or device
3. Press ⌘R to build and run

## Future Enhancements

- [ ] AI opponent (single-player mode)
- [ ] Game history tracking
- [ ] Custom themes and color schemes
- [ ] Sound effects
- [ ] Haptic feedback
- [ ] Accessibility improvements (VoiceOver support)
- [ ] iPad layout optimization
