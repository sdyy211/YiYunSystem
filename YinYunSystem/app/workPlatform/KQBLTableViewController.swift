//
//  KQBLTableViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/16.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQBLTableViewController: UITableViewController, HttpProtocol {
    
    
    @IBOutlet var spinner: UIActivityIndicatorView!

    var httpRequest: HttpRequest!
    var bLArray: Array<KQBL>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.color = UIColor.blueColor()
        spinner.startAnimating()
        
        bLArray = Array<KQBL>()
        
        httpRequest = HttpRequest()
        httpRequest.delegate = self
        
        
        let bodyStr = "page=1&rows=1000"
        httpRequest.Post2(GetService + "/KaoQinMask/JBuLuList", str: bodyStr)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return bLArray.count
    }
    
    func didResponse(result: NSDictionary) {
//        print(result)
        bLArray.removeAll()
        
        if let data = result["rows"] {
            let json = JSON(data)
            
            for val in json {
                var bL = KQBL()
                bL.startTime = val.1["KQ_StartTime"].string!
                
                bL.content = val.1["KQ_Content"].string!
                bL.state = val.1["KQ_State"].string!
                bLArray.append(bL)
            }
            spinner.stopAnimating()
            self.tableView.reloadData()
            
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KQBLCell", forIndexPath: indexPath) as! KQBLTableViewCell
        cell.startTimeLabel.text = bLArray[indexPath.row].startTime
//        cell.startTimeLabel.textColor = UIColor.blueColor()
        cell.stateLabel.text = bLArray[indexPath.row].state
//        cell.startTimeLabel.textColor = UIColor.grayColor()
        cell.reasonLabel.text = bLArray[indexPath.row].content
//        cell.startTimeLabel.textColor = UIColor.grayColor()

        // Configure the cell...

        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }

    @IBAction func unwindToBL(segue: UIStoryboardSegue) {
        if let _ = segue.sourceViewController as? KQNewBLTableViewController {
            let bodyStr = "page=1&rows=1000"
            httpRequest.Post2(GetService + "/KaoQinMask/JBuLuList", str: bodyStr)
        }
    }

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
