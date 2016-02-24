//
//  KQNewBLTableViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQNewBLTableViewController: UITableViewController, HttpProtocol, UITextFieldDelegate {
    
    
    @IBOutlet weak var timeBT: UIButton!
    @IBOutlet weak var reasonTF: UITextField!
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        
        if timeBT.titleLabel?.text != "考勤时间" && reasonTF.text != "" {
            
            let time = timeBT.titleLabel!.text!
            let reason = reasonTF.text!
            
            let bodStr = "pstarttime=\(time)&reason=\(reason)&starttime=\(time)"
            do {
                try self.httpRequest.Post2(GetService + "/KaoQinMask/JAddBuLu", str: bodStr)
            } catch {
                
            }
        } else {
            let alert = UIAlertController(title: "警告", message: "有选项未填写！", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        

    }
    
    @IBAction func timeChoose(sender: AnyObject) {
        self.performSegueWithIdentifier("TimeSegue", sender: self)
    }
    
    var httpRequest: HttpRequest!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpRequest = HttpRequest()
        httpRequest.delegate = self
        reasonTF.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        reasonTF.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToNewBL(segue: UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? KQNewBLTimeViewController {
            if let time = vc.chooseDate {
                timeBT.setTitle(time, forState: .Normal)
            }
        }
    }
    
    // MARK:TextField代理
    // 点击return会隐藏键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        reasonTF.resignFirstResponder()

        
        
        return true
    }
    
    //点击空白处会隐藏键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        reasonTF.resignFirstResponder()

    }
    
    func didResponse(result: NSDictionary) {
//        print(result)
        let json = JSON(result)
        
        if let flag = json["flag"].int {
            if flag == 1 {
                self.performSegueWithIdentifier("UnwindToBL", sender: self)
            } else {
                let alert = UIAlertController(title: "警告", message: json["msg"].string, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "警告", message: "网络错误", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }


    // MARK: - Table view data source
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
