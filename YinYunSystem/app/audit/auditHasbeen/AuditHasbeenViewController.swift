//
//  AuditHasbeenViewController.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class AuditHasbeenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpProtocol{

    @IBOutlet weak var tv: UITableView!
    
    var url = "/KaoQinCheck/JDaiShenList"
    var itemArry = NSMutableArray()
    var request = HttpRequest()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tv.delegate = self
        tv.dataSource = self
        request.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        addLeftItem()
        loadData()
    }
    func loadData()
    {
        let bodyStr = NSString(format:"page=1&rows=100000&lx=1&Name=")
        let str = "\(((UIApplication.sharedApplication().delegate) as! AppDelegate).getService())\(url)"
        request.delegate = self
        request.Post(str, str: bodyStr as String)
    }
    func addLeftItem()
    {
        let btn1 = UIButton(frame: CGRectMake(0, 0,12, 20))
        btn1.setBackgroundImage(UIImage(named: "7"), forState: UIControlState.Normal)
        btn1.addTarget(self, action: Selector("letfItemAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.leftBarButtonItem = item2
    }
    func letfItemAction(send:UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    func didResponse(result: NSDictionary) {
        itemArry = (result.objectForKey("rows") as? NSMutableArray)!
        tv.reloadData()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "auditHasbeenViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let cell:auditHasbeenViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! auditHasbeenViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
        
        let dic = itemArry.objectAtIndex(indexPath.row) as? NSDictionary
        cell.name.text = dic!.objectForKey("U_Name") as? String
        cell.startTime.text = dic!.objectForKey("KQ_StartTime") as? String
        cell.endTime.text = dic!.objectForKey("KQ_EndTime") as? String
//        cell.auditName.text = dic!.objectForKey("CK_UName") as? String
        cell.state.text = dic!.objectForKey("KQ_State") as? String
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dic = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
        let detileView = AuditHasbeenView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
        detileView.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
        detileView.itemDic = dic
        detileView.viewController = self

        let window:UIWindow = UIApplication.sharedApplication().keyWindow!
        window.addSubview(detileView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
