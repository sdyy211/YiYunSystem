//
//  yiShenViewController.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/10.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class yiShenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,selectProtocol,HttpProtocol{


    @IBOutlet weak var tabbarView: UIView!
    
    @IBOutlet weak var selectStypeBtn: UIButton!
    
    
    var color = UIColor(colorLiteralRed: 238.0/255.0, green: 247.0/255.0, blue: 244.0/255.0, alpha: 1)
    var request = HttpRequest()
    var tv = UITableView()
    var itemArry = NSArray()
    var selectView = selectStyleView()
    var styleStr = "全部"
    var kaoQinURL = "/KaoQinCheck/JDaiShenList"
    var yongZhangURL = "/mobile/mobile/JGetCachetCheckList"
    var detileView = yongZhangDetileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        request.delegate = self
        self.navigationController?.navigationBar.hidden = true
        tv.frame = CGRectMake(0, CGRectGetMaxY(tabbarView.frame), CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-CGRectGetMaxY(tabbarView.frame))
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = color
        self.view.addSubview(tv)

    }
    @IBAction func selectStypeAction(sender: AnyObject) {
        //点击全部按钮显示所有类型的列表
        selectView.removeFromSuperview()
        selectView = selectStyleView()
        selectView.frame = CGRectMake(CGRectGetMinX(selectStypeBtn.frame),CGRectGetMinY(tabbarView.frame)+CGRectGetMaxY(selectStypeBtn.frame),CGRectGetWidth(selectStypeBtn.frame),5*40)
        selectView.delegate  = self
        selectView.itemArry = ["考勤","用章","报销","全部"]
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(selectView)
        window?.makeKeyAndVisible()
    }
    
    @IBAction func backbtn(sender: AnyObject) {
        selectView.removeFromSuperview()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    
    //MARK:获取选择的待审的类型
    func getSelectStyle(style: String) {
        selectStypeBtn.setTitle(style, forState: UIControlState.Normal)
        styleStr = style
        if(style == "全部")
        {
          
        }else if(style == "考勤"){
            kaoQinLoadData()
        }else if(style == "用章"){
            yongZhangLoadData()
            
        }else if(style == "报销"){
        
        }
    }
    func kaoQinLoadData()
    {
        loadingAnimationMethod.sharedInstance.startAnimation()
        itemArry = []
        let bodyStr = NSString(format:"page=1&rows=100000&lx=1&Name=")
        let str = "\(((UIApplication.sharedApplication().delegate) as! AppDelegate).getService())\(kaoQinURL)"
        request.delegate = self
        request.Post(str, str: bodyStr as String)
    }
    func yongZhangLoadData()
    {
        loadingAnimationMethod.sharedInstance.startAnimation()
        request.delegate = self
        let param = ["zt":"-1"]
        request.Get(GetService + yongZhangURL, parameters: param)
    }
    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        itemArry = []
        if(styleStr == "全部")
        {
            
        }else if(styleStr == "考勤"){
            itemArry = (result.objectForKey("rows") as? NSMutableArray)!
            tv.reloadData()

        }else if(styleStr == "用章"){
            itemArry = (result.objectForKey("dt") as? NSArray)!
            tv.reloadData()
        }else if(styleStr == "报销"){
            
        }
        
      
    }


    //MARK: UItableviewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(styleStr == "考勤")
        {
            return 90
        }else if(styleStr == "用章"){
            return 113
        }else {
            return 50
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(styleStr == "考勤")
        {
            tableView.registerNib(UINib(nibName: "auditHasbeenViewCell", bundle: nil), forCellReuseIdentifier: "cell")
            let cell:auditHasbeenViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! auditHasbeenViewCell
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            cell.contentView.backgroundColor = color
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
            cell.cellBackView.layer.borderWidth = 1
            cell.cellBackView.layer.borderColor = UIColor.grayColor().CGColor
            cell.cellBackView.layer.cornerRadius  = 10
            
            
            let dic = itemArry.objectAtIndex(indexPath.row) as? NSDictionary
            cell.name.text = dic!.objectForKey("U_Name") as? String
            cell.startTime.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
            cell.endTime.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
            
            
            cell.startTime.text = dic!.objectForKey("KQ_StartTime") as? String
            cell.endTime.text = dic!.objectForKey("KQ_EndTime") as? String
            cell.state.text = dic!.objectForKey("KQ_State") as? String
            return cell

        }else if(styleStr == "用章"){
            tableView.registerNib(UINib(nibName: "yongZhangPendingCell", bundle: nil), forCellReuseIdentifier: "cell2")
            
            let cell:yongZhangPendingCell = tableView.dequeueReusableCellWithIdentifier("cell2") as! yongZhangPendingCell
            cell.contentView.backgroundColor = color
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
            cell.cellbackView.layer.borderWidth = 1
            cell.cellbackView.layer.borderColor = UIColor.grayColor().CGColor
            cell.cellbackView.layer.cornerRadius  = 10
            
            let dic =  itemArry.objectAtIndex(indexPath.row) as! NSDictionary
            cell.name.text = dic.objectForKey("BD_UName") as? String
            cell.department.text = dic.objectForKey("BD_BuMen") as? String
            cell.type.text = dic.objectForKey("BD_LeiXing") as? String
            cell.time.text = dic.objectForKey("BD_Time") as? String
//            cell.state.text = dic.objectForKey("FCK_State") as? String
            return cell
        }else{
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(styleStr == "考勤")
        {
            let dic = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
            let detileView = AuditHasbeenView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
            detileView.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
            detileView.itemDic = dic
            detileView.viewController = self
            
            let window:UIWindow = UIApplication.sharedApplication().keyWindow!
            window.addSubview(detileView)
        }else if(styleStr == "用章"){
            let dic = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
            detileView = yongZhangDetileView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
            detileView.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
            detileView.dataDic = dic
            detileView.nameKey = "BD_UName"
            detileView.departmentKey = "BD_BuMen"
            detileView.viewController = self
            detileView.titleArry = ["用印分类","用印时间","用印事由","备注","留存材料","用印次数","当前状态"]
            detileView.keyArry = ["BD_LeiXing","BD_Time","BD_Reason","BD_BeiZhu","BD_CaiLiao","BD_CiShu","BD_State"]
            detileView.state = "1"
            let window:UIWindow = UIApplication.sharedApplication().keyWindow!
            window.addSubview(detileView)
        }
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
