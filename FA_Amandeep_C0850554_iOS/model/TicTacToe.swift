import UIKit

protocol TicTacToeDelegate {
    func continues(with secondPlayer: TicTacToe.Player)
    func over(winner: TicTacToe.Player?)
}

class TicTacToe {

    typealias Coordinate = (row: Int, column: Int)

    enum Player: String {
        case X
        case O

        var color: UIColor {
            switch self {
            case .X: return .red
            case .O: return .green
            }
        }

        var name: String {
            return "Player \(self.rawValue)"
        }
    }

    var board: [[Player?]] = [[nil, nil, nil],
                                  [nil, nil, nil],
                                  [nil, nil, nil]]
    var player: Player = .X
    var numberOfMoves = 0
    var delegate: TicTacToeDelegate?

    func reset() {
        board = [[nil, nil, nil],
                     [nil, nil, nil],
                     [nil, nil, nil]]
        player = .X
        numberOfMoves = 0
    }

    private func getSecondPlayer() -> Player {
        switch player {
        case .X: return .O
        case .O: return .X
        }
    }
    
    public func getPlayer(player: Character) -> Player {
        switch player {
        case "O": return .O
        case "X": return .X
        default:
            return .X
        }
    }

    func player(didChoose coordinate: Coordinate) {
        guard board[coordinate.row][coordinate.column] == nil else { return }

        numberOfMoves += 1

        board[coordinate.row][coordinate.column] = player

        if checkForWin() {
            delegate?.over(winner: player)
        } else if numberOfMoves == 9 {
            delegate?.over(winner: nil)
        } else {
            let secondPlayer = getSecondPlayer()
            player = secondPlayer
            delegate?.continues(with: secondPlayer)
        }
    }
    
    func undoMove(didChoose coordinate: Coordinate) {
        numberOfMoves -= 1
        board[coordinate.row][coordinate.column] = nil
        let secondPlayer = getSecondPlayer()
        player = secondPlayer
        delegate?.continues(with: secondPlayer)
    }

    private func checkForWin() -> Bool {
        guard numberOfMoves > 4 else { return false }

        // check for forward diagonal
        if board[0][0] == player,
           board[1][1] == player,
           board[2][2] == player {
            return true
        }

        // check for backward diagonal
        if board[0][2] == player,
           board[1][1] == player,
           board[2][0] == player {
            return true
        }

        for i in 0...2 {
            // check for horizontal
            if board[i][0] == player,
               board[i][1] == player,
               board[i][2] == player {
                return true
            }

            // check for vertical
            if board[0][i] == player,
               board[1][i] == player,
               board[2][i] == player {
                return true
            }
        }

        return false
    }
    
    func isXTurn() -> Bool {
        if(player == .X) {
            return true
        }
        return false
    }
}


