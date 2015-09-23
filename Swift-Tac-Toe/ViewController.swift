//
//  ViewController.swift
//  Swift-Tac-Toe
//
//  Created by Senghuot Lim on 9/12/15.
//  Copyright (c) 2015 Home Brew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var TicTacImg1: UIImageView!
    @IBOutlet weak var TicTacImg2: UIImageView!
    @IBOutlet weak var TicTacImg3: UIImageView!
    @IBOutlet weak var TicTacImg4: UIImageView!
    @IBOutlet weak var TicTacImg5: UIImageView!
    @IBOutlet weak var TicTacImg6: UIImageView!
    @IBOutlet weak var TicTacImg7: UIImageView!
    @IBOutlet weak var TicTacImg8: UIImageView!
    @IBOutlet weak var TicTacImg9: UIImageView!
    
    @IBOutlet weak var TicTacBtn1: UIButton!
    @IBOutlet weak var TicTacBtn2: UIButton!
    @IBOutlet weak var TicTacBtn3: UIButton!
    @IBOutlet weak var TicTacBtn4: UIButton!
    @IBOutlet weak var TicTacBtn5: UIButton!
    @IBOutlet weak var TicTacBtn6: UIButton!
    @IBOutlet weak var TicTacBtn7: UIButton!
    @IBOutlet weak var TicTacBtn8: UIButton!
    @IBOutlet weak var TicTacBtn9: UIButton!

    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var msgLabel: UILabel!

    
    var plays = Dictionary<Int, Int>()
    var aiDeciding = false
    var done = false
    var playerXTurn = true
    var numPlayer = 2
    
    @IBAction func btnClick(sender: UIButton) {
        if (plays[sender.tag] == nil && !aiDeciding && !done) {
            let player = playerXTurn ? 1 : 0
            // switch turn
            if (numPlayer == 2) {
                playerXTurn = !playerXTurn
                setImageSpot(sender.tag, player: player)
                checkForWin()
            } else {
                setImageSpot(sender.tag, player: player)
                checkForWin()
                if (!done) {
                    aiTurn(plays)
                    checkForWin()
                }
            }
        }
    }
    
    @IBAction func reset(sender: UIButton) {
        done = false
        resetBtn.hidden = true
        msgLabel.hidden = true
        plays = [:]
        TicTacImg1.image = nil
        TicTacImg2.image = nil
        TicTacImg3.image = nil
        TicTacImg4.image = nil
        TicTacImg5.image = nil
        TicTacImg6.image = nil
        TicTacImg7.image = nil
        TicTacImg8.image = nil
        TicTacImg9.image = nil
        msgLabel.hidden = true
        resetBtn.hidden = true
    }
    
    // to actually pick the best spot by calling minimax and returnin (score and spot)
    private func aiTurn(plays: Dictionary<Int, Int>) {
        let result = minimax(plays, playerXTurn: false)
        setImageSpot(result.spot, player: 0)
    }
    
    // pick the least damage spot or pick the best score possible
    private func minimax(plays: Dictionary<Int, Int>, playerXTurn: Bool) -> (score: Int, spot: Int) {
        var availableSpots = [Int]()
        for (var i = 1; i <= 9; i++) {
            if (plays[i] == nil) {
                availableSpots.append(i)
            }
        }
        
        // this is our base case where we have reach our leaf
        if (availableSpots.count == 0) {
            print("here");
            return (heuristic(plays), -1);
        }
        
        // now loop over all the available spots
        var bestScore = 0
        var bestSpot = -1
        for availableSpot in availableSpots {
            var tmpPlays = plays;
            if (playerXTurn) {
                tmpPlays[availableSpot] = 1;
                let tmp = minimax(tmpPlays, playerXTurn: !playerXTurn)
                if (tmp.score < bestScore) {
                    bestScore = tmp.score
                    bestSpot = tmp.spot
                }
            } else {
                tmpPlays[availableSpot] = 0;
                let tmp = minimax(tmpPlays, playerXTurn: !playerXTurn)
                if (tmp.score > bestScore) {
                    bestScore = tmp.score
                    bestSpot = tmp.spot
                }
            }

        }
        
        return (bestScore, bestSpot)
    }
    
    private func heuristic(plays: Dictionary<Int, Int>) -> Int {
        var score = 0;
        // across
        score += compareLine(plays[1], y: plays[2], z: plays[3])
        score += compareLine(plays[4], y: plays[5], z: plays[6])
        score += compareLine(plays[7], y: plays[8], z: plays[9])

        // verticle
        score += compareLine(plays[1], y: plays[4], z: plays[7])
        score += compareLine(plays[2], y: plays[5], z: plays[8])
        score += compareLine(plays[3], y: plays[6], z: plays[9])
        
        // diagonal
        score += compareLine(plays[1], y: plays[5], z: plays[9])
        score += compareLine(plays[3], y: plays[5], z: plays[7])

        return score
    }
    
    private func compareLine(x: Int?, y: Int?, z:Int?) -> Int{
        // x, y, and z are not nil and are the same
        if (x != nil && y != nil && z != nil) {
            if (x == y && y == z && z == 0) {
                return 100
            } else if (x == y && y == z && z == 1) {
                return -100
            }
        // two adjacent cells with an empty
        } else if ((x != nil && y != nil && z == nil) ||
                    (x == nil && y != nil && z != nil)) {
            if (x == y || y == z && y == 0) {
                return 10
            } else if (x == y || y == z && y == 1) {
                return -10
            }
        } else if ((x == 0 && y == nil && z == nil) ||
            (x == nil && y == 0 && z == nil) ||
            (x == nil && y == nil && z == 0)) {
                return 1
        } else if ((x == 1 && y == nil && z == nil) ||
            (x == nil && y == 1 && z == nil) ||
            (x == nil && y == nil && z == 1)) {
            return -1;
        }
        return 0;
    }
    
    private func setImageSpot(spot: Int, player: Int) {
        let playerSpot = (player == 1) ? "x" : "o"
        plays[spot] = player
        switch spot{
        case 1:
            TicTacImg1.image = UIImage(named: playerSpot)
        case 2:
            TicTacImg2.image = UIImage(named: playerSpot)
        case 3:
            TicTacImg3.image = UIImage(named: playerSpot)
        case 4:
            TicTacImg4.image = UIImage(named: playerSpot)
        case 5:
            TicTacImg5.image = UIImage(named: playerSpot)
        case 6:
            TicTacImg6.image = UIImage(named: playerSpot)
        case 7:
            TicTacImg7.image = UIImage(named: playerSpot)
        case 8:
            TicTacImg8.image = UIImage(named: playerSpot)
        case 9:
            TicTacImg9.image = UIImage(named: playerSpot)
        default:
            TicTacImg9.image = UIImage(named: playerSpot)
        }
    }

    private func checkForWin() {
        var players = Dictionary<Int, String>()
        players[1] = "X"
        players[0] = "O"
        var res = false
        for (player, name) in players {
            // check horizontal win
            for (var i = 1; i <= 9; i += 3) {
                res = (plays[i] == player && plays[i + 1] == player && plays[i + 2] == player) ? true : res
            }
        
            // check vertical win
            for (var i = 1; i <= 3; i++) {
                res = (plays[i] == player && plays[i + 3] == player && plays[i + 6] == player) ? true : res
            }
            
            // check diagonal win
            res = (plays[1] == player && plays[5] == player && plays[9] == player) ? true : res
            res = (plays[3] == player && plays[5] == player && plays[7] == player) ? true : res
            
            if res {
                msgLabel.hidden = false
                msgLabel.text = "Looks like " + name + " won."
                resetBtn.hidden = false
                done = true
                return
            }
        }
        
        var tie = true
        for (var i = 1; i <= 9; i++) {
            tie = tie && (plays[i] != nil)
        }
        if tie {
            msgLabel.hidden = false
            msgLabel.text = "Looks like a tie game."
            resetBtn.hidden = false
            done = true
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}