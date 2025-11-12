import SwiftUI
import Combine

struct TicTacToeGame: View {
    @StateObject private var gameState = GameState()
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Title with enhanced styling
                VStack(spacing: 8) {
                    Text("Rock Game")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("First to 3 in a row wins!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Score Display with enhanced cards
                HStack(spacing: 15) {
                    PlayerScoreCard(
                        playerName: "Player 1",
                        rockImage: "rock1",
                        score: gameState.player1Score,
                        isActive: gameState.currentPlayer == .player1,
                        accentColor: .blue
                    )
                    
                    PlayerScoreCard(
                        playerName: "Player 2",
                        rockImage: "rock2",
                        score: gameState.player2Score,
                        isActive: gameState.currentPlayer == .player2,
                        accentColor: .purple
                    )
                }
                .padding(.horizontal)
                
                // Current Turn Indicator with animation
                if gameState.winner == nil {
                    HStack(spacing: 12) {
                        Image(gameState.currentPlayer == .player1 ? "rock1" : "rock2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .shadow(color: gameState.currentPlayer == .player1 ? .blue.opacity(0.5) : .purple.opacity(0.5), radius: 8)
                        
                        Text("\(gameState.currentPlayer == .player1 ? "Player 1" : "Player 2")'s Turn")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(gameState.currentPlayer == .player1 ? Color.blue.opacity(0.15) : Color.purple.opacity(0.15))
                    )
                    .overlay(
                        Capsule()
                            .stroke(gameState.currentPlayer == .player1 ? Color.blue : Color.purple, lineWidth: 2)
                    )
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: gameState.currentPlayer)
                }
                
                Spacer(minLength: 0)
                
                // Game Board with enhanced styling
                VStack(spacing: 10) {
                    ForEach(0..<3) { row in
                        HStack(spacing: 10) {
                            ForEach(0..<3) { column in
                                CellView(
                                    player: gameState.board[row][column],
                                    isWinningCell: gameState.isWinningCell(row: row, column: column),
                                    action: {
                                        gameState.makeMove(row: row, column: column)
                                    }
                                )
                            }
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.7))
                        .shadow(color: .black.opacity(0.1), radius: 15, y: 5)
                )
                .padding(.horizontal)
                
                Spacer(minLength: 0)
                
                // Reset Button with enhanced styling
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        gameState.resetAll()
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset All")
                            .fontWeight(.medium)
                    }
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.red.opacity(0.1))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.red.opacity(0.5), lineWidth: 1)
                    )
                }
                .padding(.bottom, 20)
            }
            
            // Game Over Popup Overlay
            if let winner = gameState.winner {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // Dismiss on tap outside
                    }
                
                VStack(spacing: 20) {
                    if winner == .tie {
                        VStack(spacing: 12) {
                            Image(systemName: "equal.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.orange)
                            
                            Text("It's a Tie!")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.orange)
                        }
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.yellow)
                                .shadow(color: .yellow.opacity(0.5), radius: 10)
                            
                            HStack(spacing: 12) {
                                Image(winner == .player1 ? "rock1" : "rock2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                
                                Text("\(winner == .player1 ? "Player 1" : "Player 2") Wins!")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.green, .blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            }
                        }
                    }
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            gameState.resetGame()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Play Again")
                                .fontWeight(.semibold)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .blue.opacity(0.4), radius: 10, y: 5)
                    }
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.3), radius: 30, y: 15)
                )
                .padding(.horizontal, 40)
                .transition(.scale(scale: 0.8).combined(with: .opacity))
            }
        }
    }
}

// Enhanced Player Score Card
struct PlayerScoreCard: View {
    let playerName: String
    let rockImage: String
    let score: Int
    let isActive: Bool
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(rockImage)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .shadow(color: isActive ? accentColor.opacity(0.5) : .clear, radius: 8)
                .scaleEffect(isActive ? 1.1 : 1.0)
            
            Text(playerName)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isActive ? accentColor : .secondary)
            
            VStack(spacing: 2) {
                Text("Score")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text("\(score)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(accentColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: isActive ? accentColor.opacity(0.3) : .black.opacity(0.1), radius: isActive ? 12 : 8, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isActive ? accentColor : Color.clear, lineWidth: 2)
        )
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isActive)
    }
}

struct CellView: View {
    let player: Player?
    let isWinningCell: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                action()
            }
        }) {
            ZStack {
                cellBackground
                
                if let player = player {
                    rockImage(for: player)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: player)
        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isWinningCell)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if player == nil {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
    
    // MARK: - Subviews
    
    private var cellBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(backgroundColor)
            .frame(width: 90, height: 90)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(strokeColor, lineWidth: strokeWidth)
            )
            .shadow(color: shadowColor, radius: shadowRadius, y: 2)
            .scaleEffect(isPressed ? 0.95 : 1.0)
    }
    
    private func rockImage(for player: Player) -> some View {
        Image(player == .player1 ? "rock1" : "rock2")
            .resizable()
            .scaledToFit()
            .frame(width: 65, height: 65)
            .shadow(
                color: player == .player1 ? .blue.opacity(0.3) : .purple.opacity(0.3),
                radius: 5
            )
            .scaleEffect(isWinningCell ? 1.1 : 1.0)
            .rotationEffect(.degrees(isWinningCell ? 360 : 0))
            .transition(.scale.combined(with: .opacity))
    }
    
    // MARK: - Computed Properties
    
    private var backgroundColor: Color {
        if player == nil {
            return Color.white.opacity(0.5)
        } else if player == .player1 {
            return Color.blue.opacity(0.1)
        } else {
            return Color.purple.opacity(0.1)
        }
    }
    
    private var strokeColor: Color {
        if isWinningCell {
            return Color.green
        } else if player == nil {
            return Color.gray.opacity(0.3)
        } else if player == .player1 {
            return Color.blue.opacity(0.4)
        } else {
            return Color.purple.opacity(0.4)
        }
    }
    
    private var strokeWidth: CGFloat {
        isWinningCell ? 4 : 2
    }
    
    private var shadowColor: Color {
        isWinningCell ? .green.opacity(0.5) : .black.opacity(0.05)
    }
    
    private var shadowRadius: CGFloat {
        isWinningCell ? 10 : 5
    }
}

enum Player {
    case player1
    case player2
    case tie
}

@MainActor
class GameState: ObservableObject {
    @Published var board: [[Player?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    @Published var currentPlayer: Player = .player1
    @Published var winner: Player?
    @Published var player1Score: Int = 0
    @Published var player2Score: Int = 0
    @Published var winningCells: Set<String> = []  // Store winning cell positions as "row,col"
    
    func makeMove(row: Int, column: Int) {
        // Don't allow moves if game is over or cell is occupied
        guard winner == nil, board[row][column] == nil else { return }
        
        // Place the piece
        board[row][column] = currentPlayer
        
        // Check for winner
        if let gameWinner = checkWinner() {
            winner = gameWinner
            if gameWinner == .player1 {
                player1Score += 1
            } else if gameWinner == .player2 {
                player2Score += 1
            }
        } else {
            // Switch players
            currentPlayer = currentPlayer == .player1 ? .player2 : .player1
        }
    }
    
    func checkWinner() -> Player? {
        // Check rows
        for row in 0..<3 {
            if let player = board[row][0],
               board[row][1] == player,
               board[row][2] == player {
                winningCells = ["\(row),0", "\(row),1", "\(row),2"]
                return player
            }
        }
        
        // Check columns
        for col in 0..<3 {
            if let player = board[0][col],
               board[1][col] == player,
               board[2][col] == player {
                winningCells = ["0,\(col)", "1,\(col)", "2,\(col)"]
                return player
            }
        }
        
        // Check diagonals
        if let player = board[0][0],
           board[1][1] == player,
           board[2][2] == player {
            winningCells = ["0,0", "1,1", "2,2"]
            return player
        }
        
        if let player = board[0][2],
           board[1][1] == player,
           board[2][0] == player {
            winningCells = ["0,2", "1,1", "2,0"]
            return player
        }
        
        // Check for tie (board is full)
        let isFull = board.allSatisfy { row in
            row.allSatisfy { $0 != nil }
        }
        
        return isFull ? .tie : nil
    }
    
    func isWinningCell(row: Int, column: Int) -> Bool {
        return winningCells.contains("\(row),\(column)")
    }
    
    func resetGame() {
        board = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        currentPlayer = .player1
        winner = nil
        winningCells = []
    }
    
    func resetAll() {
        resetGame()
        player1Score = 0
        player2Score = 0
    }
}

#Preview {
    TicTacToeGame()
}
