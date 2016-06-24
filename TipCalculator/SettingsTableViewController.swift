//
//  SettingsTableViewController.swift
//  TipCalculator
//
//  Created by Dinh Quang Hieu on 6/24/16.
//  Copyright © 2016 Dinh Quang Hieu. All rights reserved.
//


import UIKit

class SettingsTableViewController: UITableViewController {
    
    var userDefault:NSUserDefaults!
    var defaultTipPercentage:Int!
    var minTipPercentage:Int!
    var maxTipPercentage:Int!
    
    @IBOutlet weak var txtDefault: UITextField!
    @IBOutlet weak var txtMin: UITextField!
    @IBOutlet weak var txtMax: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefault = NSUserDefaults()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        onCreate()
    }
    
    func onCreate() {
        loadData()
    }
    
    func loadData() {
        defaultTipPercentage = userDefault.objectForKey("defaultTipPercentage") as! Int
        minTipPercentage = userDefault.objectForKey("minTipPercentage") as! Int
        maxTipPercentage = userDefault.objectForKey("maxTipPercentage") as! Int
        txtDefault.text = String(defaultTipPercentage)
        txtMin.text = String(minTipPercentage)
        txtMax.text = String(maxTipPercentage)
    }
    
    func saveData() {
        userDefault.setValue(defaultTipPercentage, forKey: "defaultTipPercentage")
        userDefault.setValue(minTipPercentage, forKey: "minTipPercentage")
        userDefault.setValue(maxTipPercentage, forKey: "maxTipPercentage")
        userDefault.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tip percentage"
    }
    
    override func viewWillDisappear(animated: Bool) {
        onEditingDidEnd(self)
        saveData()
    }
    
    
    @IBAction func onEditingDidEnd(sender: AnyObject) {
        defaultTipPercentage = Int(txtDefault.text!)
        minTipPercentage = Int(txtMin.text!)
        maxTipPercentage = Int(txtMax.text!)
        
        if (defaultTipPercentage < minTipPercentage) {
            defaultTipPercentage = minTipPercentage
        }
        if (defaultTipPercentage > maxTipPercentage) {
            defaultTipPercentage = maxTipPercentage
        }
        if (minTipPercentage < 0) {
            minTipPercentage = 0
        }
        if (minTipPercentage > maxTipPercentage) {
            minTipPercentage = maxTipPercentage
        }
        if (maxTipPercentage > 100) {
            maxTipPercentage = 100
        }
        if (maxTipPercentage < minTipPercentage) {
            maxTipPercentage = minTipPercentage
        }
        txtDefault.text = String(defaultTipPercentage)
        txtMin.text = String(minTipPercentage)
        txtMax.text = String(maxTipPercentage)
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}