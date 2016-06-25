//
//  ViewController.swift
//  TipCalculator
//
//  Created by Dinh Quang Hieu on 6/24/16.
//  Copyright © 2016 Dinh Quang Hieu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var userDefault:NSUserDefaults!
    var defaultTipPercentage:Int! = 20
    var minTipPercentage:Int! = 10
    var maxTipPercentage:Int! = 30
    var tipPercentageTapStart:Int!
    var billAmount:Double! = 0
    var tip:Double! = 0
    var totalAmount:Double! = 0
    var formatter:NSNumberFormatter!
    var reverseSwipe:Bool! = false
    var peoplePicker:UIPickerView!
    var txtTotalAmountPerPeople:UITextField!
    var timeIntervalToReload:NSTimeInterval! = 60*10 // 10 mins
    
    var peoplePickerData:[String]!
    
    @IBOutlet weak var txtBill: UITextField!
    @IBOutlet weak var lblTipPercentage: UILabel!
    @IBOutlet weak var lblTip: UILabel!
    @IBOutlet weak var lblTotalAmount: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        userDefault = NSUserDefaults()
        // Do any additional setup after loading the view, typically from a nib.
        runAnimation()
        onCreate()
    }
    
    func runAnimation() {
        self.view.alpha = 0
        UIView.animateWithDuration(0.4, animations: {
            self.view.alpha = 1
        })
    }
    
    func onCreate() {
        initFormatter()
        if (isFirstRun()) {
            setupFirstRun()
        } else {
            // Load last bill amount if less than 10 mins
            if canReloadData() {
                reloadData()
            }
        }
        loadData()
        initPeoplePickerData()
    }
    
    func reloadData() {
        billAmount = userDefault.objectForKey("billAmount") as! Double
        txtBill.text = String(Int(billAmount))
        calculateBill()
        displayResult()
    }
    
    func canReloadData()->Bool {
        let lastRunDate = userDefault.objectForKey("lastRunDate") as! NSDate
        //print("Last Rune Date")
        //print(lastRunDate)
        //print(NSDate())
        //print((0 - lastRunDate.timeIntervalSinceNow))
        if (0 - lastRunDate.timeIntervalSinceNow) < timeIntervalToReload {
            //print("Reload")
            return true
        }
        return false
    }
    
    func initPeoplePickerData() {
        peoplePickerData = []
        let maxPerson:Int = 99
        for index in 1...maxPerson {
            peoplePickerData.append(String(index))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()
        lblTipPercentage.text = String(defaultTipPercentage) + "%"
        onBillChanged(self)
    }
    
    func initFormatter() {
        formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        
        let bill = formatter.stringFromNumber(0)
        let index = bill?.startIndex.advancedBy(0)
        txtBill.placeholder = String(bill![index!])
        lblTip.text = formatter.stringFromNumber(0)
        lblTotalAmount.text = formatter.stringFromNumber(0)
    }
    
    func setupFirstRun() {
        saveData()
        userDefault.setValue(true, forKey: "firstRun")
        userDefault.synchronize()
    }
    
    func isFirstRun()->Bool {
        if userDefault.objectForKey("firstRun") != nil {
            return false
        }
        return true;
    }
    
    func saveData() {
        userDefault.setValue(defaultTipPercentage, forKey: "defaultTipPercentage")
        userDefault.setValue(minTipPercentage, forKey: "minTipPercentage")
        userDefault.setValue(maxTipPercentage, forKey: "maxTipPercentage")
        userDefault.setValue(reverseSwipe, forKey: "reverseSwipe")
        userDefault.setValue(NSDate(), forKey: "lastRunDate")
        userDefault.setValue(billAmount, forKey: "billAmount")
        
        userDefault.synchronize()
        //print("save data")
    }
    
    func loadData() {
        defaultTipPercentage = userDefault.objectForKey("defaultTipPercentage") as! Int
        minTipPercentage = userDefault.objectForKey("minTipPercentage") as! Int
        maxTipPercentage = userDefault.objectForKey("maxTipPercentage") as! Int
        reverseSwipe = userDefault.objectForKey("reverseSwipe") as! Bool
        //print("load data")
    }

    @IBAction func onBillChanged(sender: AnyObject) {
        if (txtBill.text == "") {
            lblTip.text = formatter.stringFromNumber(0)
            lblTotalAmount.text = formatter.stringFromNumber(0)
            return
        }
        calculateBill()
        displayResult()
    }
    
    func calculateBill() {
        billAmount = Double(txtBill.text!)!
        tip = billAmount * Double(defaultTipPercentage) / 100
        totalAmount = billAmount + tip
    }
    
    func displayResult() {
        lblTip.text = formatter.stringFromNumber(tip)
        lblTotalAmount.text = formatter.stringFromNumber(totalAmount)
    }
    
    
    @IBAction func onPanGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if (recognizer.state == .Began) {
            tipPercentageTapStart = defaultTipPercentage
        }
        else if (recognizer.state == .Changed) {
            let reverse = reverseSwipe == true ? -1 : 1
            defaultTipPercentage = Int(CGFloat(tipPercentageTapStart) + CGFloat(reverse) * translation.x / 20)
            if (defaultTipPercentage < minTipPercentage) {
                defaultTipPercentage = minTipPercentage
            }
            else if (defaultTipPercentage > maxTipPercentage) {
                defaultTipPercentage = maxTipPercentage
            }
            lblTipPercentage.text = String(defaultTipPercentage) + "%"
            onBillChanged(self)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        txtBill.becomeFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        saveData()
    }
    
    
    @IBAction func onChangeNumOfPeople(sender: UITapGestureRecognizer) {
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "\n\n\n\n\n", preferredStyle: .Alert)
        
        //Create and an option action
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
            //Do some other stuff
        }
        actionSheetController.addAction(okAction)
        
        // Create and add a text total amount
        txtTotalAmountPerPeople = UITextField(frame: CGRect(x: 20, y: 30, width: 160, height: 100))
        txtTotalAmountPerPeople.enabled = false
        txtTotalAmountPerPeople.borderStyle = .None
        txtTotalAmountPerPeople.font = UIFont(name: "Avenir Next Ultra Light", size: 60)
        txtTotalAmountPerPeople.adjustsFontSizeToFitWidth = true
        txtTotalAmountPerPeople.text = self.lblTotalAmount.text! + " /"
        actionSheetController.view.addSubview(txtTotalAmountPerPeople)
        
        // Create and add a picker view
        peoplePicker = UIPickerView(frame: CGRect(x: 175, y: 55, width: 50, height: 50))
        peoplePicker.dataSource = self
        peoplePicker.delegate = self
        actionSheetController.view.addSubview(peoplePicker)
        
        // Create and add a image view
        let imageView = UIImageView(frame: CGRect(x: 220, y: 65, width: 30, height: 30))
        imageView.image = UIImage(named: "person.png")
        actionSheetController.view.addSubview(imageView)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return peoplePickerData.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int) -> String! {
        return peoplePickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = peoplePickerData[row]
        pickerLabel.font = UIFont(name: "Avenir Next Ultra Light", size: 30)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let numberOfPeople = row + 1
        let totalAmountPerPeople = totalAmount / Double(numberOfPeople)
        txtTotalAmountPerPeople.text = formatter.stringFromNumber(NSNumber(double: totalAmountPerPeople))! + " /"
    }
}

