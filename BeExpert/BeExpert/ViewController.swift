//
//  ViewController.swift
//  BeExpert
//
//  Created by 서유준 on 2023/02/18.
//

import UIKit
import FSCalendar

enum ButtonTag: Int {
        case start = 10
        case finish = 20
        case cancel = 30
    }


class ViewController: UIViewController {
    // Data
    var timeTableViewData = [String]()
    
    var date_totaltimeDic = [String: Int]()
    
    // TableView
    @IBOutlet weak var timeTableView: UITableView!
    
    // Calendar
    @IBOutlet weak var calendar: FSCalendar!
    
    // UI
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // Timer
    var mainTimer:Timer?
    var timeCount = 0
    var totalTimeCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView
        timeTableView.delegate = self
        timeTableView.dataSource = self

        // Calendar
        calendar.delegate = self
        calendar.dataSource = self
        setCalendarUI()
        
        // Timer
        setButton(button: startButton, tag: .start)
        setButton(button: finishButton, tag: .finish)
        setButton(button: cancelButton, tag: .cancel)
        finishButton.isEnabled = false
        cancelButton.isEnabled = false
    }
    
    @objc func buttonAction(_ button:UIButton) {

        if let select = ButtonTag(rawValue: button.tag) {

                    switch select {

                    case .start: startAction()

                    case .finish: finishAction()

                    case .cancel : cancelAction()

                    }
                } else {
                    print("존재하지않는 태그를 가진 버튼의 입력이 들어왔습니다.")
                }
    }
   
    func setButton(button:UIButton, tag:ButtonTag){

            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)

            button.tag = tag.rawValue

        }
    
    func startAction() {
            print("start")
            startButton.isEnabled = false
            finishButton.isEnabled = true
            cancelButton.isEnabled = true
        
        mainTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in

                    self.timeCount += 1

                    DispatchQueue.main.async {

                        let timeString = self.makeTimeLabel(count: self.timeCount)

                        self.timeLabel.text = timeString
                    }

                })
        }
        
        func finishAction() {
            print("finish")
            mainTimer?.invalidate()
            mainTimer = nil
            
            let timeString = self.makeTimeLabel(count: self.timeCount)
            self.timeTableViewData.append("\(timeString)")
            let indexPath = IndexPath(row: self.timeTableViewData.count - 1, section: 0)
            self.timeTableView.insertRows(at: [indexPath], with: .automatic)
            self.timeTableView.scrollToRow(at: indexPath, at: .none, animated: true)
            
            // totalTimeLabel UI 업데이트
            totalTimeCount += timeCount
            totalTimeLabel.text = self.makeTimeLabel(count: self.totalTimeCount)
            
            // 총 시간이 늘어남에 따라 날짜의 배경색 업데이트
            date_totaltimeDic["2023-03-01"] = totalTimeCount
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd" // 날짜 형식을 지정합니다.
//
//            // 업데이트할 날짜를 지정합니다.
//            let updateDate = formatter.date(from: "2023-03-18")!
                    
            // FSCalendar 객체의 reloadDates 메서드를 호출하여 날짜의 배경색을 업데이트합니다.
            calendar.reloadData()
            
            
            
            // timeCount, timeLabel 초기화
            timeCount = 0
            timeLabel.text = "0:   0:   0"
            
            
            
            startButton.isEnabled = true
            finishButton.isEnabled = false
            cancelButton.isEnabled = false
        }
        
        func cancelAction() {
            print("cancel")
            mainTimer?.invalidate()
            mainTimer = nil
            timeCount = 0
            timeLabel.text = "0:   0:   0"
            
//            오늘 공부한 시간 모두 리셋하고 싶을시 사용
//            self.timeTableviewData.removeAll()
//            self.timeTableView.reloadData()
            
            startButton.isEnabled = true
            finishButton.isEnabled = false
            cancelButton.isEnabled = false
        }
    
        func makeTimeLabel(count:Int) -> String {
            //return - (TimeLabel, decimalLabel)
            let sec = count % 60
            let min = count / 60
            let hour = count / 3600
            
            return "\(hour):   \(min):   \(sec)"
        }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableViewCell.cell_id, for: indexPath) as! TimeTableViewCell
                let item = self.timeTableViewData[indexPath.row]
                cell.timeLabel.text = item
                cell.currentTimeLabel.text = currentTime()
                return cell
    }
    
    // TableView Cell의 높이 고정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func currentTime() -> String {
        let formatter_time = DateFormatter()
        formatter_time.dateFormat = "HH:mm"
        let current_time_string = formatter_time.string(from: Date())
        return current_time_string
    }
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func setCalendarUI() {
            // calendar locale > 한국으로 설정
            self.calendar.locale = Locale(identifier: "ko_KR")
            
            // 상단 요일을 한글로 변경
            // 요일의 순서를 바꿀 경우에만 사용하자
            // self.calendar.locale = Locale(identifier: "ko_KR")로 한국어를 설정해주었다.
            
//            self.calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
//            self.calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
//            self.calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
//            self.calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
//            self.calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
//            self.calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
//            self.calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
            
//            // 월~일 글자 폰트 및 사이즈 지정
//            self.calendar.appearance.weekdayFont = UIFont.SpoqaHanSans(type: .Regular, size: 14)
//            // 숫자들 글자 폰트 및 사이즈 지정
//            self.calendar.appearance.titleFont = UIFont.SpoqaHanSans(type: .Regular, size: 16)
            
            // 캘린더 스크롤 가능하게 지정
            self.calendar.scrollEnabled = true
            // 캘린더 스크롤 방향 지정
            self.calendar.scrollDirection = .horizontal
            
            // Header dateFormat, 년도, 월 폰트(사이즈)와 색, 가운데 정렬
            self.calendar.appearance.headerDateFormat = "YYYY년 MM월"
//            self.calendar.appearance.headerTitleFont = UIFont.SpoqaHanSans(type: .Bold, size: 20)
            self.calendar.appearance.headerTitleColor = UIColor(named: "FFFFFF")?.withAlphaComponent(0.9)
            self.calendar.appearance.headerTitleAlignment = .center
        
            // 헤더의 폰트 정렬 설정
            // .center & .left & .justified & .natural & .right
            // self.calendar.appearance.headerTitleAlignment = .left
            
            // 요일 글자 색
            self.calendar.appearance.weekdayTextColor = UIColor(named: "F5F5F5")?.withAlphaComponent(0.2)
            
            // 캘린더 높이 지정
//            self.calendar.headerHeight = 68
            // 캘린더의 cornerRadius 지정
            self.calendar.layer.cornerRadius = 10
            
            // 선택된 날짜의 모서리 설정 ( 0으로 하면 사각형으로 표시 )
            // 값이 1이면 원
            // 값이 0이면 정사각형
            // 값이 0~1 이면 둥근 정사각형 조절 가능
            self.calendar.appearance.borderRadius = 0.5
        
            // 양옆 년도, 월 지우기
            self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
            // 달에 유효하지 않은 날짜의 색 지정
//            self.calendar.appearance.titlePlaceholderColor = UIColor.white.withAlphaComponent(0.2)
            // 평일 날짜 색
//            self.calendar.appearance.titleDefaultColor = UIColor.white.withAlphaComponent(0.5)
            // 달에 유효하지않은 날짜 지우기
            self.calendar.placeholderType = .none
            
            // 캘린더 숫자와 subtitle간의 간격 조정
            self.calendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
            
            
//            self.calendar.select(selectedDate)
        }

    // 특정 날짜의 이벤트 색상을 변경
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let green_1_Color = UIColor(named: "Green_1")
        let green_2_Color = UIColor(named: "Green_2")
        let green_3_Color = UIColor(named: "Green_3")
        let green_4_Color = UIColor(named: "Green_4")
        let green_5_Color = UIColor(named: "Green_5")

        if dateFormatter.string(from: date) == "2023-03-10" {
            return green_1_Color
        } else if dateFormatter.string(from: date) == "2023-03-11" {
            return green_2_Color
        } else if dateFormatter.string(from: date) == "2023-03-12" {
            return green_3_Color
        } else if dateFormatter.string(from: date) == "2023-03-13" {
            return green_4_Color
        } else if dateFormatter.string(from: date) == "2023-03-14" {
            return green_5_Color
        }
        
        for (key, value) in date_totaltimeDic {
            if dateFormatter.string(from: date) == key {
                if value < 10 {
                    return green_1_Color
                } else if value > 10 && value < 20 {
                    return green_3_Color
                } else if value > 20 {
                    return green_5_Color
                }
            }
        }
        
        print("호출됨")
        return nil
    }

// Chat GPT에서 추천해준 메서드는 FSCalendar 프로토콜의 메서드에 속하지 않아 호출되지 않았었다.
//
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//
//        let redColor = UIColor.red
//        let blueColor = UIColor.blue
//
//        if dateFormatter.string(from: date) == "2023-03-17" {
//            return [redColor]
//        } else if dateFormatter.string(from: date) == "2023-03-21" {
//            return [blueColor]
//        }
//        print("호출됨")
//        return nil
//    }
}
