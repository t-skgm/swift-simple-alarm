//
//  ViewController.swift
//  simple-alarm
//
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        timeLabel.font = initFont
        toggleBT.addTarget(self, action: #selector(self.handleToggleBT), for: .touchUpInside)
        resetBT.addTarget(self, action: #selector(self.handleResetBT), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var timer = Timer()
    var isStarted = false
    var count: Float = 0
    var pausedTime: Float = 0

    var bigFont = UIFont(name: "Zapfino", size: 120)
    var initFont = UIFont(name: "Arial", size: 80)
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var resetBT: UIButton!
    @IBOutlet weak var toggleBT: UIButton!

    @objc func handleToggleBT(sender: UIButton) {
        if isStarted {
            toggleBT.setTitle("RESTART", for: .normal)
            isStarted = false
            stopCountDown()
        } else {
            self.view.backgroundColor = .white
            toggleBT.setTitle("STOP", for: .normal)
            isStarted = true
            startCountDown()
        }
    }

    @objc func handleResetBT(_ sender: UIButton) {
        resetTimer()
    }

    func resetTimer() {
        self.view.backgroundColor = .white
        timeLabel.text = "00:00"
        toggleBT.setTitle("START", for: .normal)
        pausedTime = 0
        isStarted = false
        timer.invalidate()
        timer = Timer()
    }

    func startCountDown() {
        if pausedTime == 0 {
            count = Float(timePicker.countDownDuration)
        } else {
            count = pausedTime
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onUpdate), userInfo: nil,  repeats: true)
    }

    @objc func onUpdate() {
        count -= 1

        if count > 0 {
            if Int(floor(count)) % 30 == 0 {
                drawAho()
            } else {
                self.view.backgroundColor = .white
            }
            timeLabel.text = intervalToHHMMSS(seconds: Int(count))
        } else {
            resetTimer()
            self.view.backgroundColor = .red
            timeLabel.text = "End!"
        }
    }

    func drawAho() {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 1.0)
        UIImage(named: "aho")?.draw(in: CGRect(x: 8, y: 100, width: 360, height: 240))
        let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.view.backgroundColor = UIColor(patternImage: image)
    }

    func stopCountDown() {
        pausedTime = count
        timer.invalidate()
    }

    func intervalToHHMMSS(seconds: Int) -> (String){
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: TimeInterval(count))!
    }
}
