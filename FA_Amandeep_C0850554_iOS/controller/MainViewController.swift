import UIKit
class MainViewController: UIViewController, TicTacToeDelegate {
    @IBOutlet private weak var FooterText: UILabel!
    @IBOutlet var allButtons: [GameButton]!
    
    @IBOutlet var CrossScore: UILabel!
    @IBOutlet var ZeroScore: UILabel!
    private var game: TicTacToe!
    private var selectedButton: GameButton!
    private var isEnd: Bool = false
    private var CrossWinns: Int = 0
    private var ZeroWinns: Int = 0
    private var MainPlayer: String {
        return "\(game.player.name) turn"
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = TicTacToe()
        game.delegate = self
        setUpViews()
        GesturesFunction()
        Reset()
    }
    
    func Reset() {
        CrossWinns = LocalStorage.value(defaultValue: 0, forKey: LocalStorage.X_SCORE)
        ZeroWinns = LocalStorage.value(defaultValue: 0, forKey: LocalStorage.O_SCORE)
        printScore()
    }
    
    
    func GesturesFunction() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swiped(gesture: UISwipeGestureRecognizer) {
        let swipeGesture = gesture as UISwipeGestureRecognizer
        switch swipeGesture.direction
        {
        case UISwipeGestureRecognizer.Direction.up, UISwipeGestureRecognizer.Direction.down:
            game.reset()
            setUpViews()
        default:
            break
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEvent.EventSubtype.motionShake {
            if(!isEnd) {
                undo()
            }
        }
    }

    func undo() {
        if(selectedButton != nil) {
            game.undoMove(didChoose: (selectedButton.row, selectedButton.column))
            selectedButton.isEnabled = true
            selectedButton.setTitle("", for: .normal)
            selectedButton = nil
        }
    }

    
    @IBAction func pressGameButton(sender button: GameButton) {
        selectedButton = button
        button.isEnabled = false
        button.setTitle(game.player.rawValue, for: .normal)
        button.setTitleColor(game.player.color, for: .disabled)
        game.player(didChoose: (button.row, button.column))
    }

    
    private func setUpViews() {
        isEnd = false
        allButtons.forEach{
            $0.isEnabled = true
            $0.setTitleColor(.black, for: .disabled)
            $0.setTitle("", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 90)
        }
        FooterText.text = MainPlayer
    }

    
    func continues(with nextPlayer: TicTacToe.Player) {
        FooterText.text = MainPlayer
        saveState()
    }
    
    func saveState() {
        LocalStorage.value(value: CrossWinns, forKey: LocalStorage.X_SCORE)
        LocalStorage.value(value: ZeroWinns, forKey: LocalStorage.O_SCORE)
        var board = ""
        for players in game.board {
            for player in players {
                if(player == .X) {
                    board = board + "X"
                } else if (player == .O) {
                    board = board + "O"
                } else {
                    board = board + " "
                }
            }
        }
        LocalStorage.value(value: board, forKey: LocalStorage.GAME)
    }

    func over(winner: TicTacToe.Player?) {
        isEnd = true
        allButtons.forEach { $0.isEnabled = false }
        if let winner = winner {
            FooterText.text = "\(winner.name.capitalized) WIN!"
            if(game.isXTurn()) {
                CrossWinns += 1
            } else {
                ZeroWinns += 1
            }
            printScore()
        } else {
            FooterText.text = "GAME DRAW!"
            
            
        }
        saveState()
    }
    
    func printScore() {
        CrossScore.text = "\(CrossWinns)"
        ZeroScore.text = "\(ZeroWinns)"
    }
}
