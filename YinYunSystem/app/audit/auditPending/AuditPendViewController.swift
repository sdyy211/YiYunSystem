//
//  AuditViewController.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/16.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class AuditPendViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,HttpProtocol,AuditDetileProtocol{

    @IBOutlet weak var cusheaderView: UIView!
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var cusFooterView: UIView!
    
    var postFlag = "0"
    var url = "/KaoQinCheck/JDaiShenList"
    var deleteURL = "/KaoQinCheck/JShenHe"
    var itemsWith = 80
    var myscrollView : UIScrollView?
    var request = HttpRequest()
    var itemArry = NSMutableArray()
    var dataArry = NSMutableArray()
    var flageArry = NSMutableArray()
    var segmentArray = NSArray()
    var segmented = UISegmentedControl()
    var rightBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request.delegate = self
        self.title = "审核管理"
//        itemsWith = Int(CGRectGetWidth(UIScreen.mainScreen().bounds))/4
        addLeftItem()
        addRightItem()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        initView()
        loadData()
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
    func addRightItem()
    {
        rightBtn = UIButton(frame: CGRectMake(0, 0,60, 30))
        rightBtn.setTitle("批量", forState: UIControlState.Normal)
        rightBtn.titleLabel?.font = UIFont.systemFontOfSize(17.0)
        rightBtn.titleLabel?.textAlignment = NSTextAlignment.Right
        rightBtn.addTarget(self, action: Selector("rightItemAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn.tag = 1
        let item2=UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = item2
    }

  
    // MARK: 请求数据的方法
    func loadData()
    {
        postFlag = "0"
        let bodyStr = NSString(format:"page=1&rows=100000&lx=0&Name=")
        let str = "\(((UIApplication.sharedApplication().delegate) as! AppDelegate).getService())\(url)"
        request.delegate = self
        request.Post(str, str: bodyStr as String)

    }
    // MARK: 批量删除 和 批量退回请求的接口
    func loadBatch(type:String,kqid:String)
    {
        let bodyStr = NSString(format:"type=\(type)&kqid=\(kqid)")
        let str = "\(((UIApplication.sharedApplication().delegate) as! AppDelegate).getService())\(deleteURL)"
        request.delegate = self
        request.Post(str, str: bodyStr as String)
    }
    // MARK: 接收请求后台的数据
    func didResponse(result: NSDictionary) {

        if(postFlag == "0")
        {
            dataArry.removeAllObjects()
            itemArry.removeAllObjects()
            let ary = result.objectForKey("rows") as! NSArray
            dataArry.setArray(ary as [AnyObject])
            
            panduan(segmentArray.objectAtIndex(segmented.selectedSegmentIndex) as! String)
        }else if(postFlag == "1")
        {
            let num = result.objectForKey("flag") as! NSNumber
            let flag =  "\(num)"
            rightBtn.tag == 1
            rightBtn.setTitle("批量", forState: UIControlState.Normal)
            if(flag == "0")
            {
                alter("提示", message: "操作失败！")
            }else{
                alter("提示", message: "操作成功！")
            }
            loadData()
        }
        tv.reloadData()
    }
    // MARK: 弹出窗口
    func alter(title:String,message:String)
    {
        let alertView =  UIAlertController.init(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertView.addAction(alertViewCancelAction)
        self.presentViewController(alertView, animated:true , completion: nil)
    }

    // MARK: 处理数据，把数据分开
    func panduan(index:String)
    {
        itemArry.removeAllObjects()
        flageArry.removeAllObjects()
        for(var i = 0;i < dataArry.count;++i)
        {
            let dic = dataArry.objectAtIndex(i)
            let indexstr = dic.objectForKey("KQ_Type") as! String
            if(indexstr == index)
            {
                itemArry.addObject(dic)
                flageArry.addObject("0")
            }
        }
        tv.reloadData()
    }
    func initView()
    {
        tv.delegate = self
        tv.dataSource = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        segmentArray = ["公出","调休","加班","请假","补录考勤"]
        segmented = UISegmentedControl(items: segmentArray as [AnyObject])
        let with = itemsWith*segmentArray.count
  
        segmented.frame = CGRectMake(0,0,CGFloat(with), 40)
        segmented.selectedSegmentIndex=0
        segmented.setBackgroundImage(UIImage(named:"inchoose"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        segmented.addTarget(self, action:"segmentDidchange:",forControlEvents: UIControlEvents.ValueChanged)
        
        myscrollView = UIScrollView()
        myscrollView!.frame = CGRectMake(0,0,CGRectGetWidth(self.view.frame),40)
        myscrollView!.contentSize = CGSize(width: CGFloat(with),height:0)
        
        myscrollView!.delegate = self
        myscrollView?.delegate = self;
        myscrollView?.directionalLockEnabled = true
        myscrollView!.alwaysBounceVertical = false
        myscrollView?.showsHorizontalScrollIndicator = false
        myscrollView!.backgroundColor = UIColor.whiteColor()
        myscrollView?.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        myscrollView!.addSubview(segmented)
        cusheaderView.addSubview(myscrollView!)
    }
    // MARK: rightItem 点击事件
    func rightItemAction(sender:UIButton)
    {
        if(itemArry.count > 0)
        {
            if(rightBtn.tag == 1)
            {
                rightBtn.tag = 2
                tv.frame = CGRectMake(CGRectGetMinX(tv.frame), CGRectGetMinY(tv.frame),CGRectGetWidth(tv.frame),CGRectGetHeight(tv.frame)-49)
                cusFooterView.hidden = false
                rightBtn.setTitle("取消", forState: UIControlState.Normal)
            }else if(rightBtn.tag == 2){
                rightBtn.tag = 1
                RemoveFlagArray()
                tv.frame = CGRectMake(CGRectGetMinX(tv.frame), CGRectGetMinY(tv.frame),CGRectGetWidth(tv.frame),CGRectGetHeight(tv.frame)+49)
                cusFooterView.hidden = true
                rightBtn.setTitle("批量", forState: UIControlState.Normal)
                
            }
            tv.reloadData()
        }
       
    }
    // MARK: 清空已选择标示的数组
    func RemoveFlagArray()
    {
        if(flageArry.count > 0)
        {
            for(var i = 0;i < flageArry.count;++i)
            {
                let str = flageArry.objectAtIndex(i) as! String
                if(str == "1")
                {
                    flageArry.replaceObjectAtIndex(i, withObject:"0")
                }
            }
        }
    }
    // MARK: 批量退回点击事件
    @IBAction func batchReturnAction(sender: AnyObject) {
        postFlag = "1"
        rightBtn.tag = 1
        rightBtn.setTitle("批量", forState: UIControlState.Normal)
        tv.frame = CGRectMake(CGRectGetMinX(tv.frame)+50, CGRectGetMinY(tv.frame),CGRectGetWidth(tv.frame),CGRectGetHeight(tv.frame)+49)
        tv.reloadData()
        cusFooterView.hidden = true
        let kqid =  getID()
        loadBatch("0",kqid: kqid)
        RemoveFlagArray()
    }
    // MARK: 批量通过点击事件
    @IBAction func batchDeleteAction(sender: AnyObject) {
        postFlag = "1"
        rightBtn.tag = 1
        rightBtn.setTitle("批量", forState: UIControlState.Normal)
        tv.frame = CGRectMake(CGRectGetMinX(tv.frame)+50, CGRectGetMinY(tv.frame),CGRectGetWidth(tv.frame),CGRectGetHeight(tv.frame)+49)
        tv.reloadData()
        cusFooterView.hidden = true
        let kqid =  getID()
        loadBatch("1",kqid: kqid)
        
        RemoveFlagArray()
    }
    // MARK: 获取要删除的id
    func getID()->String
    {
        var kqid = ""
        if(flageArry.count > 0)
        {
            for(var i = 0; i < flageArry.count; ++i)
            {
                let str = flageArry.objectAtIndex(i) as! String
                if(str == "1")
                {
                    let dic =  itemArry.objectAtIndex(i) as! NSDictionary
                    let id = dic.objectForKey("KQ_ID") as! String
                    kqid = kqid+"\(id),"
                }
            }
        }
        if(kqid != "")
        {
            kqid = (kqid as NSString).substringToIndex(kqid.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)-1)
        }
        return kqid
    }
    // MARK: segmentDidchange 点击事件
    func segmentDidchange(segmented:UISegmentedControl){
        if(cusFooterView.hidden == false)
        {
            cusFooterView.hidden = true
            rightBtn.setTitle("批量", forState: UIControlState.Normal)
            rightBtn.tag = 1	
        }
        
        var str = ""
        if(segmented.selectedSegmentIndex == 0)
        {
            str = segmentArray.objectAtIndex(segmented.selectedSegmentIndex) as! String
            panduan(str)
        }else if(segmented.selectedSegmentIndex == 1)
        {
            str = segmentArray.objectAtIndex(segmented.selectedSegmentIndex) as! String
            panduan(str)
        }else if(segmented.selectedSegmentIndex == 2)
        {
            str = segmentArray.objectAtIndex(segmented.selectedSegmentIndex) as! String
            panduan(str)
        }else if(segmented.selectedSegmentIndex == 3)
        {
            str = segmentArray.objectAtIndex(segmented.selectedSegmentIndex) as! String
            panduan(str)
        }else if(segmented.selectedSegmentIndex == 4)
        {
            str = segmentArray.objectAtIndex(segmented.selectedSegmentIndex) as! String
            panduan(str)
        }
        
        tv.reloadData()
    }
    //MARK: 在详情页面中，通过代理来实现数据的刷新
    func setLoadData() {
        loadData()
    }
    // MARK:scrollerDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    // MARK: tableViewDataSource  tableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  90
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        tableView.registerNib(UINib(nibName: "AuditTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let cell:AuditTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! AuditTableViewCell
       
        if(rightBtn.tag == 1)
        {
            cell.imageFlage.hidden = true
            cell.imageFlage.image = UIImage(named: "inchoose")
        }else if(rightBtn.tag == 2){
            cell.imageFlage.hidden = false
            if(flageArry.count > 0)
            {
                let flagStr =  flageArry.objectAtIndex(indexPath.row) as! String
                if(flagStr == "0")
                {
                    cell.imageFlage.image = UIImage(named: "inchoose")
                }else if(flagStr == "1")
                {
                    cell.imageFlage.image = UIImage(named: "choosed")
                }
            }
        }
        let dic = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
        cell.name.text = dic.objectForKey("U_Name") as? String
        cell.endTime.text = dic.objectForKey("KQ_EndTime") as? String
        cell.startTime.text = dic.objectForKey("KQ_AddTime") as? String
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let flagStr = flageArry.objectAtIndex(indexPath.row) as! String
        if(rightBtn.tag == 2)
        {
            if(flagStr == "0")
            {
                flageArry.replaceObjectAtIndex(indexPath.row, withObject:"1")
            }else if(flagStr == "1"){
                flageArry.replaceObjectAtIndex(indexPath.row, withObject:"0")
            }
            tableView.reloadData()
        }else if(rightBtn.tag == 1){
            
            let dic = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
            let detileView = AuditDetileView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
            detileView.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
            detileView.itemDic = dic
            detileView.viewController = self
            detileView.delegate = self
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
