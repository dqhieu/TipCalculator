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
    
    @IBOutlet weak var txtBill: UITextField!
    @IBOutlet weak var lblTipPercentage: UILabel!
    @IBOutlet weak var lblTip: UILabel!
    @IBOutlet weak var lblTotalAmount: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        userDefault = NSUserDefaults()
        // Do any additional setup after loading the view, typically from a nib.
        onCreate()
    }
    
    func onCreate() {
        if (isFirstRun()) {
            setupFirstRun()
        }
        loadData()
        
        initFormatter()
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
        userDefault.setValue(billAmount, forKey: "billAmount")
        print("save data")
    }
    
    func loadData() {
        defaultTipPercentage = userDefault.objectForKey("defaultTipPercentage") as! Int
        minTipPercentage = userDefault.objectForKey("minTipPercentage") as! Int
        maxTipPercentage = userDefault.objectForKey("maxTipPercentage") as! Int
        billAmount = userDefault.objectForKey("billAmount") as! Double
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        txtBill.becomeFirstResponder()
    }
}

