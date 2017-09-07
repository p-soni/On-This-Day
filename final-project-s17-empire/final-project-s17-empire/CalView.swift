//
//  CalendarView.swift
//  final-project-s17-empire
//
//  Created by Charu Mishra on 4/16/17.
//  Copyright © 2017 Charu Mishra. All rights reserved.
//

import JTAppleCalendar
import CoreData

class CalView: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    
    @IBOutlet var monthLabel: UILabel!
    weak var calendarView: JTAppleCalendarView!
    static var labelDate: Date!
    static var mydate: Date!
    @IBOutlet var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myButton.isEnabled = false
        calendarView = JTAppleCalendarView()
        calendarView.frame = CGRect(x: 16, y: 54, width: 300, height: 300)
        calendarView.backgroundColor = UIColor.white
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        //calendarView.registerCellViewXib(file: "CellView")
        calendarView.register(UINib.init(nibName: "CellView", bundle: Bundle.main), forCellWithReuseIdentifier: "cal_cell")
        self.view.addSubview(calendarView)
        
    }
  
    @IBAction func saveMonth(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoDay", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2017 01 01")! // You can use date generated from a formatter
        let endDate = Date()                                // You can also use dates created from thisfunction
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleCell, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CellView
        myCustomCell.dayLabel.text = cellState.text
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.dayLabel.textColor = UIColor.black
        } else {
            myCustomCell.dayLabel.textColor = UIColor.gray
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell, cellState: CellState) -> Bool {
        return true
    }
    
    /// Asks the delegate if de-selecting the
    /// - returns: A Bool value indicating if the operation can be done.
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell, cellState: CellState) -> Bool {
        return true
    }
    
    /// Tells the delegate that a date-cell with a specified date was selected
    /// - Parameters:
    ///     - calendar: The JTAppleCalendar view giving this information.
    ///     - date: The date attached to the date-cell.
    ///     - cell: The date-cell view. This can be customized at this point.
    ///             This may be nil if the selected cell is off the screen
    ///     - cellState: The month the date-cell belongs to.
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        // ****** DO WHAT YOU WANT WHEN USER CLICKS A CELL ***********
        print(date)
        CalView.mydate = date
        myButton.isEnabled = true
        CalView.labelDate = date
        
        cell?.contentView.layer.backgroundColor = UIColor.cyan.withAlphaComponent(0.5).cgColor
   
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        let predicate = NSPredicate(format: "date == %@", date as CVarArg)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do{
            let count = try managedContext.count(for: request)
            if(count == 0){
                // no matching object. create new entity for this selected date. 
                let entity = NSEntityDescription.entity(forEntityName: "Day", in: managedContext)!
                let newDay = NSManagedObject(entity: entity, insertInto: managedContext)
                newDay.setValue(CalView.labelDate, forKey: "date")
                print(newDay.value(forKey: "date")!)
                
            }
            else{
                // at least one matching object exists
                print("exists already")
                
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    
    }

    
    

    /// Tells the delegate that a date-cell
    /// with a specified date was de-selected
    /// - Parameters:
    ///     - calendar: The JTAppleCalendar view giving this information.
    ///     - date: The date attached to the date-cell.
    ///     - cell: The date-cell view. This can be customized at this point.
    ///             This may be nil if the selected cell is off the screen
    ///     - cellState: The month the date-cell belongs to.
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        cell?.contentView.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    /// Tells the delegate that the JTAppleCalendar view
    /// scrolled to a segment beginning and ending with a particular date
    /// - Parameters:
    ///     - calendar: The JTAppleCalendar view giving this information.
    ///     - startDate: The date at the start of the segment.
    ///     - endDate: The date at the end of the segment.
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let full = visibleDates.monthDates[0].date
        let stringdate = dateFormatter.string(from: full)
        let month = stringdate.components(separatedBy: " ").first
        monthLabel.text = month
    }
    
    /// Tells the delegate that the JTAppleCalendar is about to display
    /// a date-cell. This is the point of customization for your date cells
    /// - Parameters:
    ///     - calendar: The JTAppleCalendar view giving this information.
    ///     - date: The date attached to the cell.
    ///     - cellState: The month the date-cell belongs to.
    ///     - indexPath: use this value when dequeing cells
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let myCustomCell = calendarView.dequeueReusableJTAppleCell(withReuseIdentifier: "cal_cell", for: indexPath) as! CellView
        
        let calendar = NSCalendar.current
        let day = calendar.component(.day, from: date)
        myCustomCell.dayLabel.text = "\(day)"
        
        
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.dayLabel.textColor = UIColor.black
        } else {
            myCustomCell.dayLabel.textColor = UIColor.gray
        }
        
        return myCustomCell
    }
    

    
    /// Informs the delegate that the user just lifted their finger from swiping the calendar
    func scrollDidEndDecelerating(for calendar: JTAppleCalendarView) {
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return nil
    }
    func sizeOfDecorationView(indexPath: IndexPath) -> CGRect {
        return CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    }

}

