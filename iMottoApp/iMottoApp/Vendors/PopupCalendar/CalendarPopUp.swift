//
//  CalendarPopUp.swift
//  CalendarPopUp
//
//  Created by Atakishiyev Orazdurdy on 11/16/16.
//  Copyright © 2016 Veriloft. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol CalendarPopUpDelegate: class {
    func dateChaged(_ date: Date)
    func calendarDismissed()
}

class CalendarPopUp: UIView {
    
    @IBOutlet weak var calendarHeaderLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    //@IBOutlet weak var dateLabel: UILabel!
    
    weak var calendarDelegate: CalendarPopUpDelegate?
    
    var endDate: Date = Date()
    var startDate: Date = Date.fromString(CALENDAR_START)!
    
    var testCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
    var selectedDate: Date! = Date() {
        didSet {
            setDate()
        }
    }
    var selected:Date = Date() {
        didSet {
            calendarView.scrollToDate(selected)
            calendarView.selectDates([selected])
        }
    }
    
    @IBAction func closePopupButtonPressed(_ sender: AnyObject) {
        if let superView = self.superview as? PopupContainer {
            (superView ).close()
            calendarDelegate?.calendarDismissed()
        }
    }
    @IBAction func popupOkPressed(_ sender: AnyObject) {
        let day = selectedDate.toLocaleDate()
        calendarDelegate?.dateChaged(day)
        
        if let superView = self.superview as? PopupContainer {
            (superView ).close()
            calendarDelegate?.calendarDismissed()
        }
    }
    
    override func awakeFromNib() {
        //Calendar
        // You can also use dates created from this function
//        endDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 20, toDate: startDate, options: NSCalendarOptions.MatchFirst)
        
        setCalendar()
        setDate()
        
        let month = testCalendar.dateComponents([.month], from: startDate).month!
        let year = testCalendar.component(.year, from: startDate)
        calendarHeaderLabel.text = "\(year)年\(month)月"
    }
    
    
    
    func setCalendar() {
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CellView")
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        calendarView.reloadData()
    }
    
//    func setupViewsOfCalendar(_ startDate:Date, endDate:Date){
//        
//        if let month = (testCalendar as NSCalendar?)?.component(.month, from: startDate),
//            let year = (testCalendar as NSCalendar?)?.component(.year, from: startDate){
//        
//            calendarHeaderLabel.text = "\(year)年\(month)月"
//        }
//    }
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first else {
            return
        }
        let month = testCalendar.dateComponents([.month], from: startDate).month!
        let year = testCalendar.component(.year, from: startDate)
        calendarHeaderLabel.text = "\(year)年\(month)月"
    }
    
 
    func setDate() {
        //dateLabel.text = "\(selectedDate.toLocaleDate().toDayString())"
    }
}

// MARK : JTAppleCalendarDelegate
extension CalendarPopUp: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: testCalendar, // This parameter will be removed in version 6.0.1
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        (cell as? CellView)?.handleCellSelection(cellState, date: date, selectedDate: selectedDate, endDate: endDate)

    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        selectedDate = date
        (cell as? CellView)?.cellSelectionChanged(cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        (cell as? CellView)?.cellSelectionChanged(cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willResetCell cell: JTAppleDayCellView) {
        (cell as? CellView)?.selectedView.isHidden = true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
}
