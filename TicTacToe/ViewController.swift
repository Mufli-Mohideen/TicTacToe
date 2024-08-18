import UIKit
import AVFoundation

class ViewController: UIViewController {
    enum Turn {
        case Nought
        case Cross
    }
    
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    var firstTurn = Turn.Cross
    var currentTurn = Turn.Cross
    
    var NOUGHT = "O"
    var CROSS = "X"
    var board = [UIButton]()
    
    var noughtsScore = 0
    var crossesScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.0078, green: 0.0, blue: 0.2078, alpha: 1.0)
        styleButtons()
        styleTurnLabel()
        initBoard()
        addMadeWithLoveLabel()
    }

    func initBoard() {
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    
    func styleButtons() {
        let buttons = [a1, a2, a3, b1, b2, b3, c1, c2, c3]
        for button in buttons {
            button?.layer.cornerRadius = 10
            button?.layer.shadowColor = UIColor.black.cgColor
            button?.layer.shadowOffset = CGSize(width: 0, height: 2)
            button?.layer.shadowOpacity = 0.3
            button?.layer.shadowRadius = 4
            button?.backgroundColor = UIColor.white
        }
    }
    
    func styleTurnLabel() {

        turnLabel.layer.cornerRadius = 10
        turnLabel.layer.masksToBounds = true
        turnLabel.backgroundColor = UIColor(red: 0.0078, green: 0.0, blue: 0.2078, alpha: 1.0)
        turnLabel.textColor = UIColor.white
        turnLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        turnLabel.layer.shadowColor = UIColor.black.cgColor
        turnLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        turnLabel.layer.shadowOpacity = 0.5
        turnLabel.layer.shadowRadius = 4
        turnLabel.layer.borderWidth = 2
        turnLabel.layer.borderColor = UIColor.black.cgColor
    }

    func updateButtonAppearance(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        button.setTitleColor(UIColor.black, for: .normal)
    }
    
    func animateButtonPress(button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = CGAffineTransform.identity
            }
        }
    }
    
    func playSound(for symbol: String) {
        guard let url = Bundle.main.url(forResource: symbol, withExtension: "mp3") else { return }
        var player: AVAudioPlayer?
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing sound.")
        }
    }
    
    @IBAction func boardTapAction(_ sender: UIButton) {
        addToBoard(sender)
        
        if checkForVictory(CROSS) {
            crossesScore += 1
            resultAlert(title: "Crosses Win!")
        }
        
        if checkForVictory(NOUGHT) {
            noughtsScore += 1
            resultAlert(title: "Noughts Win!")
        }
        
        if fullBoard() {
            resultAlert(title: "Draw")
        }
    }
    
    func checkForVictory(_ s: String) -> Bool {
        if thisSymbol(a1, s) && thisSymbol(a2, s) && thisSymbol(a3, s) {
            return true
        }
        if thisSymbol(b1, s) && thisSymbol(b2, s) && thisSymbol(b3, s) {
            return true
        }
        if thisSymbol(c1, s) && thisSymbol(c2, s) && thisSymbol(c3, s) {
            return true
        }
        
        if thisSymbol(a1, s) && thisSymbol(b1, s) && thisSymbol(c1, s) {
            return true
        }
        if thisSymbol(a2, s) && thisSymbol(b2, s) && thisSymbol(c2, s) {
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b3, s) && thisSymbol(c3, s) {
            return true
        }
        
        if thisSymbol(a1, s) && thisSymbol(b2, s) && thisSymbol(c3, s) {
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b2, s) && thisSymbol(c1, s) {
            return true
        }
        
        return false
    }
    
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool {
        return button.title(for: .normal) == symbol
    }
    
    func resultAlert(title: String) {
        let message = "\nNoughts \(noughtsScore)\n\nCrosses \(crossesScore)"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(ac, animated: true)
    }
    
    func resetBoard() {
        for button in board {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if firstTurn == Turn.Nought {
            firstTurn = Turn.Cross
            turnLabel.text = CROSS
        } else if firstTurn == Turn.Cross {
            firstTurn = Turn.Nought
            turnLabel.text = NOUGHT
        }
        currentTurn = firstTurn
    }
    
    func fullBoard() -> Bool {
        for button in board {
            if button.title(for: .normal) == nil {
                return false
            }
        }
        return true
    }
    
    func addToBoard(_ sender: UIButton) {
        if(sender.title(for: .normal) == nil) {
            let symbol = currentTurn == Turn.Nought ? NOUGHT : CROSS
            updateButtonAppearance(button: sender, title: symbol)
            playSound(for: symbol)
            animateButtonPress(button: sender)
            currentTurn = currentTurn == Turn.Nought ? Turn.Cross : Turn.Nought
            turnLabel.text = currentTurn == Turn.Nought ? NOUGHT : CROSS
            sender.isEnabled = false
        }
    }
    
    func addMadeWithLoveLabel() {
        let madeWithLoveLabel = UILabel()
        madeWithLoveLabel.text = "Made with 🤍 by Mufli"
        madeWithLoveLabel.textColor = UIColor.white
        madeWithLoveLabel.font = UIFont(name: "AvenirNext-medium", size: 20)
        madeWithLoveLabel.shadowColor = UIColor.black
        madeWithLoveLabel.layer.shadowOffset = CGSize(width: 2, height: 2) 
        madeWithLoveLabel.layer.shadowOpacity = 0.5
        madeWithLoveLabel.layer.shadowRadius = 4
        madeWithLoveLabel.textAlignment = .center
        
        madeWithLoveLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(madeWithLoveLabel)
        
        NSLayoutConstraint.activate([
            madeWithLoveLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            madeWithLoveLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
