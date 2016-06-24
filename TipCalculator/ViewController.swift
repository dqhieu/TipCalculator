//
//  ViewController.swift
//  TipCalculator
//
//  Created by Dinh Quang Hieu on 6/24/16.
//  Copyright © 2016 Dinh Quang Hieu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userDefault:NSUserDefaults!
    var defaultTipPercentage:Int! = 20
    var minTipPercentage:Int! = 10
    var maxTipPercentage:Int! = 30
    var tipPercentageTapStart:Int!
    var billAmount:Double! = 0
    var tip:Double!
    var totalAmount:Double!
    var formatter:NSNumberFormatter!
    var reverseSwipe:Bool! = false
    
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
        if (isFirstRun()) {
            setupFirstRun()
        }
        loadData()
        
        initFormatter()
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
        //userDefault.setValue(billAmount, forKey: "billAmount")
        userDefault.setValue(reverseSwipe, forKey: "reverseSwipe")
        print("save data")
    }
    
    func loadData() {
        defaultTipPercentage = userDefault.objectForKey("defaultTipPercentage") as! Int
        minTipPercentage = userDefault.objectForKey("minTipPercentage") as! Int
        maxTipPercentage = userDefault.objectForKey("maxTipPercentage") as! Int
        //billAmount = userDefault.objectForKey("billAmount") as! Double
        reverseSwipe = userDefault.objectForKey("reverseSwipe") as! Bool
        print("load data")
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
}

