import SwiftUI
import Combine

struct TicTacToeGame: View {
    @StateObject private var gameState = GameState()
    
    var body: some View {
        VStack(spacing: 30) {
            // Title
            Text("Tic-Tac-Toe")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Score Display
            HStack(spacing: 40) {
                VStack {
                    Image("rock1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text("Player 1")
                        .font(.headline)
                    Text("Score: \(gameState.player1Score)")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .opacity(gameState.currentPlayer == .player1 ? 1.0 : 0.5)
                
                VStack {
                    Image("rock2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text("Player 2")
                        .font(.headline)
                    Text("Score: \(gameState.player2Score)")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .opacity(gameState.currentPlayer == .player2 ? 1.0 : 0.5)
            }
            .padding()
            
            // Current Turn Indicator
            HStack {
                Text("Current Turn:")
                    .font(.title3)
                Image(gameState.currentPlayer == .player1 ? "rock1" : "rock2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text(gameState.currentPlayer == .player1 ? "Player 1" : "Player 2")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            
            // Game Board
            VStack(spacing: 10) {
                ForEach(0..<3) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<3) { column in
                            CellView(
                                player: gameState.board[row][column],
                                action: {
                                    gameState.makeMove(row: row, column: column)
                                }
                            )
                        }
                    }
                }
            }
            .padding()
            
            // Game Status
            if let winner = gameState.winner {
                VStack(spacing: 10) {
                    if winner == .tie {
                        Text("It's a Tie!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    } else {
                        HStack {
                            Image(winner == .player1 ? "rock1" : "rock2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            Text("\(winner == .player1 ? "Player 1" : "Player 2") Wins!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                    }
                    
                    Button("Play Again") {
                        gameState.resetGame()
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            
            // Reset Button
            Button("Reset Game & Scores") {
                gameState.resetAll()
            }
            .font(.subheadline)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.red.opacity(0.2))
            .foregroundColor(.red)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
    }
}

struct CellView: View {
    let player: Player?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    )
                
                if let player = player {
                    Image(player == .player1 ? "rock1" : "rock2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: player)
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
                return player
            }
        }
        
        // Check columns
        for col in 0..<3 {
            if let player = board[0][col],
               board[1][col] == player,
               board[2][col] == player {
                return player
            }
        }
        
        // Check diagonals
        if let player = board[0][0],
           board[1][1] == player,
           board[2][2] == player {
            return player
        }
        
        if let player = board[0][2],
           board[1][1] == player,
           board[2][0] == player {
            return player
        }
        
        // Check for tie (board is full)
        let isFull = board.allSatisfy { row in
            row.allSatisfy { $0 != nil }
        }
        
        return isFull ? .tie : nil
    }
    
    func resetGame() {
        board = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        currentPlayer = .player1
        winner = nil
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
