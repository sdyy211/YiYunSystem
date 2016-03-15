//
//  baoXiaoTableView.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class baoXiaoTableView: UIView,UITableViewDelegate,UITableViewDataSource,segmentProtocol,HttpProtocol{

    var tv = UITableView()
    var itemArry = NSMutableArray()
    var flageArry = NSMutableArray()
    var dataArry = NSArray()
    
    var styleIdDic = NSDictionary()
    var styleId = ""
    var request = HttpRequest()
    var segmentV = segmentView()
    var url = "/mobile/mobile/JReimbureseList"
    var detileURL = "/mobile/mobile/JReimburseseDetail"
    
    var loadFlag = ""
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    func initView()
    {
        segmentV = segmentView()
        segmentV.segmentArray = ["通讯费","差旅费","市内交通费","通用","培训费","会议费"]
        segmentV.delegate = self
        segmentV.frame = CGRectMake(0,0,CGRectGetWidth(self.frame),40)
        self.addSubview(segmentV)
        
        tv.frame = CGRectMake(0,CGRectGetHeight(segmentV.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
        tv.delegate = self
        tv.dataSource = self
        self.addSubview(tv)
        
        loadData()
    }
    func loadData()
    {
        loadFlag = "0"
        loadingAnimationMethod.sharedInstance.startAnimation()
        request.delegate = self
        let parmer = "zt=2"
        let str = GetService + url
        request.Post(str, str: parmer)
    }
    func loadData2()
    {
        loadFlag = "1"
        loadingAnimationMethod.sharedInstance.startAnimation()
        request.delegate = self
        let parmer = "bxaid=\(styleId)&zt=2"
        let str = GetService + detileURL
        request.Post(str, str: parmer)
    }
    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        if(loadFlag == "0")
        {
            let segmentTitle = segmentV.segmentArray.objectAtIndex(0) as! String
            dataArry = result.objectForKey("dt") as! NSArray
            panduan(segmentTitle)
            
            styleIdDic = result.objectForKey("values") as! NSDictionary
            styleId = styleIdDic.objectForKey(segmentTitle) as! String
            loadData2()
        }else if(loadFlag == "1"){
            print(result)
            let dic =  result.objectForKey("values") as! NSDictionary
            let str = dic.objectForKey("sbudate") as! String
        
            var jsonStr = str.stringByReplacingOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
            jsonStr = jsonStr.stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            jsonStr = jsonStr.stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            print(jsonStr)
            let Arry2 = jsonStr.componentsSeparatedByString(",")
            print(Arry2)
//            let data:NSData = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)!
//            
//            let jsondic:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
//            
//            let dicXXX2:NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as! NSArray
            
//            print(dic22)
        }
    }
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    //MARK:segment 点击改变的函数u
    func getSegmentDidchange(index: String) {
         styleId = styleIdDic.objectForKey(index) as! String
         panduan(index)
         loadData2()
    }
    // MARK: 处理数据，把数据分开
    func panduan(index:String)
    {
        itemArry.removeAllObjects()
        flageArry.removeAllObjects()
        for(var i = 0;i < dataArry.count;++i)
        {
            let dic = dataArry.objectAtIndex(i)
            let indexstr = dic.objectForKey("BX_ABName") as! String
            if(indexstr == index)
            {
                itemArry.addObject(dic)
                flageArry.addObject("0")
            }
        }
        print(itemArry)
        tv.reloadData()
    }


    //MARK:UItableviewdelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "baoXiaoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let cell:baoXiaoTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! baoXiaoTableViewCell
        let dic = itemArry.objectAtIndex(indexPath.row)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.cusView.layer.cornerRadius = 5
        cell.name?.text =  dic.objectForKey("BX_UName") as? String
        cell.style.text =  dic.objectForKey("BX_ABName") as? String
        cell.time.text =   dic.objectForKey("BX_AddTime") as? String
        cell.feiYong.text = (dic.objectForKey("BX_Total") as? String)! + "元"
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
