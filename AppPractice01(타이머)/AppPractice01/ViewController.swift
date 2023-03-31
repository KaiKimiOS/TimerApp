//
//  ViewController.swift
//  AppPractice01
//
//  Created by kaikim on 2023/03/08.
//

import UIKit
import AVFoundation //사운드 출력을 위한 import

class ViewController: UIViewController {
    
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var startButton: UIButton!
    
    var timer = Timer()// 타이머를 위한 변수,클래스 인스턴스는 힙에 저장
    var number = 30 // 기본값 30초
    let systemSoundID: SystemSoundID = 1016 // 사운드 소리 입력
    
    
    override func viewDidLoad() { //UIViewcontroller의 재정의
        super.viewDidLoad()
        
        configureUI() // 초기화를 위한 configure()
    }
    
    func configureUI() {
        mainLabel.text = "슬라이더를 선택해주세요"
        //슬라이더 가운데 설정
        slider.setValue(0.5, animated: true)// 초기화시 슬라이더 중앙으로
        startButton.setTitle("Start", for: .normal)
        startButton.setTitle("Paused", for: .selected)
        slider.thumbTintColor = UIColor.white
        mainLabel.textColor = UIColor.black
        startButton.isSelected = false // isSelected == true 이면 눌러진거여서 Pause가 출력
        timer.invalidate()
        number = 30
        
    }
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        //슬라이더의 밸류값을 가지고 메인레이블이ㅡ 텍스트 셋팅
        let seconds =  Int(sender.value * 60)
        //슬라이더의 밸류가 0 에서 1 까지여서 거기서 * 60 해줌
        mainLabel.text =  " \(seconds) 초"
        number = seconds
    }
    //    func flashLabel() {
    //
    //        let changeColor = CATransition()
    //        changeColor.duration = 1
    //        changeColor.type = .reveal
    //        changeColor.repeatCount = Float(number)
    //        CATransaction.begin()
    //        CATransaction.setCompletionBlock {
    //            self.mainLabel.layer.add(changeColor, forKey: nil)
    //            self.mainLabel
    //                .textColor = .red
    //        }
    //
    //        self.mainLabel.textColor = .red
    //        CATransaction.commit()
    //    }
    func timerFunction() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 , repeats: true) {
            
            //block에 대한 클로저임
            [self] _ in
            if number > 0  {
                number -= 1
                
                slider.value = Float(number) / Float(60)
                //슬라이더 줄여주는 역할
                
                mainLabel.text = "\(number)초"
                //메인 텍스트에 초가 줄어드는거 보여주는 역할
                mainLabel.textColor = UIColor.black
                
                
                if number <= 5 {
                    mainLabel.textColor = UIColor.red
                    //                flashLabel()
                    mainLabel.blink()
                    
                    
                }
                
            }
            else {
                
                number = 0
                configureUI()
                
                
                //오디오 코드 중요
                AudioServicesPlaySystemSound(systemSoundID)
                
            }
            
        }
        
    }
    @IBAction func startButtonTapped(_ sender: UIButton) {
        print(sender.isSelected) //기본값이 False
        //버튼을 누르면 True
        sender.isSelected = !sender.isSelected
        print(sender.isSelected)
        guard sender.isSelected else {
            timer.invalidate() //타이머를 멈추는 방법
            return
        }
        
        //1초씩 지나갈때마다 무언가를 실행
        slider.thumbTintColor = UIColor.red
        
        //타이머 코드 중요
        
        timerFunction()
        //sender의 기본값은 False 인데, Strat 버튼을 누르면
        // sender는 true가 되면서 thumcolor 레드로 바꾸고
        // timerFunction()을 작동한다
        //다시 한번 누르면 sender가 false가 되고
        // guard 문으로 인해서 time.invalidate()를 실행하며 멈추면서 pause를 하게 된다.
        
    }
    
    
    
    
    
    
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        //초기화 셋팅
        configureUI()
        
//        number = 30 //다시 리셋해줘야함
//        timer.invalidate()
        
        
    }
    
    
    
    
}

extension UILabel {
    func blink() {
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.6, //Time duration you want,
                       delay: 0.0,
            options: [.curveEaseInOut, .autoreverse],
                       animations: { [weak self] in self?.alpha = 1.0 },
            completion: { [weak self] _ in self?.alpha = 1.0 })
    }
}
