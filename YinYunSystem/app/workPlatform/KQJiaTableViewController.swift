//
//  KQJiaTableViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQJiaTableViewController: UITableViewController, HttpProtocol, UITextFieldDelegate {
    
    

    @IBOutlet weak var flowData: UIButton!
    //开始时间和结束时间
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var reasonText: UITextField!
    
    @IBOutlet weak var otherText: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    //流程选择
    @IBAction func flowButton(sender: UIButton) {
        if flowArray.count > 0 {
            
            let alert = UIAlertController(title: "请选择流程", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            for i in 1...flowArray.count {
                let action = UIAlertAction(title: flowArray[i - 1].name + flowArray[i - 1].nodes, style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                    self.flowData.setTitle(self.flowArray[i - 1].name + self.flowArray[i - 1].nodes, forState: UIControlState.Normal)
                    self.liuChengId = self.flowArray[i - 1].id
                })
                alert.addAction(action)
            }
            let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.flowData.setTitle("暂无流程", forState: .Normal)
        }
        
        
    }
    //类型选择
    @IBAction func typeAction(sender: UIButton) {
        
        let alert = UIAlertController(title: "请选择类型", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        for i in 1...types.count {
            let action = UIAlertAction(title: types[i - 1], style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                self.typeButton.setTitle(self.types[i - 1], forState: UIControlState.Normal)
            })
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //时间选择
    @IBAction func beginTime(sender: UIButton) {
        self.performSegueWithIdentifier("TimeSegue", sender: self)
    }
    @IBAction func endTime(sender: UIButton) {
        self.performSegueWithIdentifier("TimeSegue", sender: self)
    }
    //保存事件
    @IBAction func saveAction(sender: UIBarButtonItem) {
        reasonText.resignFirstResponder()
        otherText.resignFirstResponder()
        if reasonText.text == "" {
            let alert = UIAlertController(title: "警告", message: "事由不能为空！", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (alertActon) -> Void in
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            let beigin = beginButton.titleLabel!.text!
            let end = endButton.titleLabel!.text!
            var type = typeButton.titleLabel!.text!
            let other = otherText.text!
            if type == "项目" {
                type = ""
            }
            //        print(liuChengId)
            let bodStr = "F_ID=\(liuChengId)&endtime=\(end)&info=\(other)&leixing=qj&pendtime=\(end)&pstarttime=\(beigin)&qjtype=\(type)&reason=\(reasonText.text!)&starttime=\(beigin)"
            if request1 == false {
                request1 = true
                self.httpRequest.Post2(GetService + "/KaoQinMask/JSendShenHe", str: bodStr)
                
            }
        }
        
        
        

        
        
    }
    
    var types = ["事假","病假","婚假","产假","陪产假","丧假","年假","其他"]
    var httpRequest: HttpRequest!
    var flowArray = Array<FlowData>()
    var liuChengId = ""
    
    var request1 = false


    

    override func viewDidLoad() {
        super.viewDidLoad()
        reasonText.delegate = self
        otherText.delegate = self
        

        
        httpRequest = HttpRequest()
        httpRequest.delegate = self
        //流程请求
        httpRequest.Get(GetService + "/Mobile/Mobile/JMGetLiuCheng", parameters: [:])
        //假期剩余时间请求
        let datefor = NSDateFormatter()
        datefor.dateFormat = "yyyy-MM-dd"
        let date = datefor.stringFromDate(NSDate())
//        print(date)
        
        let parameters = ["date": date, "lx":"qj"]
        httpRequest.Get(GetService + "/Mobile/Mobile/JMGetKQInfo", parameters: parameters)
        
//        flowData.setTitle(flowArray[0].name + flowArray[0].nodes, forState: UIControlState.Normal)
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        reasonText.resignFirstResponder()
        otherText.resignFirstResponder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
    
    
 
    
    func didResponse(result: NSDictionary) {
        //流程获取
        if let data = result["rows"] {
            let json = JSON(data)

            for val in json {
                let flowdata = FlowData()
                flowdata.id = val.1["F_ID"].string!
                flowdata.name = val.1["F_Name"].string!
                flowdata.nodes = val.1["Nodes"].string!
                flowArray.append(flowdata)
            }

        }
        
        //保存提示
        if request1 == true {
            request1 = false
            let json = JSON(result)
  
            if let flag = json["flag"].int {
                if flag == 0 {
                    let alert = UIAlertController(title: "警告", message: json["msg"].string, preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else if flag == 1 {

                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        //年假天数信息
        if let data = result["values"] {
        
            let json = JSON(data)
            guard json["nianjiatianshu"].string != nil else {
                return
            }

            let tianshu = json["nianjiatianshu"].string!
            let shengyu = json["nianjiashengyu"].string!
            let daishen = json["daishennianjiatianshu"].string!
            let shiyong = json["yishennianjiatianshu"].string!
            self.messageLabel.text = "该年共有\(tianshu)天年假，已使用\(shiyong)天年假，\n待审\(daishen)天年假，剩余\(shengyu)天年假。"
                
            
        }
        
        
        
    }
    
    
    @IBAction func unwindAskForJia(segue: UIStoryboardSegue) {
        
    }
    @IBAction func unwindAskForJiaDone(segue: UIStoryboardSegue) {
        
    }
    
    // MARK:TextField代理
    // 点击return会隐藏键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        reasonText.resignFirstResponder()
        otherText.resignFirstResponder()
        
        return true
    }
    
    //点击空白处会隐藏键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        reasonText.resignFirstResponder()
        otherText.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TimeSegue" {
            if beginButton.titleLabel?.text != "开始试时间" {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let vc = segue.destinationViewController as? KQJiaTimeViewController {
                    
                    vc.begin = dateFormatter.dateFromString(beginButton.titleLabel!.text!)
                    vc.end = dateFormatter.dateFromString(endButton.titleLabel!.text!)
                }
                
            }
        }
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
