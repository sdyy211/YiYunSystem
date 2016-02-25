//
//  workPlatformVController.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/21.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class workPlatformVController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,HttpProtocol{
    var itemArry  =  NSMutableArray()
    var imageArry  = NSMutableArray()
    var itemWith:CGFloat = 0
    var itemHeight:CGFloat = 0
    var cv : UICollectionView?

    var url = "/Mobile/Mobile/right"
    var request = HttpRequest()
    override func viewDidLoad() {
        super.viewDidLoad()

        itemArry  = ["会议管理","考勤管理","固定资产"]
        imageArry  =  ["p1","p2","p3"]
        itemWith = (CGRectGetWidth(UIScreen.mainScreen().bounds)-10-15)/4
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(itemWith,itemWith)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10)//设置边距
        layout.minimumLineSpacing = 5.0;//每个相邻layout的上下
        layout.minimumInteritemSpacing = 5.0;//每个相邻layout的左右
        
        cv = UICollectionView(frame: CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds)),collectionViewLayout:layout)
        cv?.registerClass(checkMeetingRoomCollectionCell.self, forCellWithReuseIdentifier:"cell")
        cv?.delegate = self
        cv?.dataSource = self
        cv?.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(cv!)
        request.delegate = self
        loadData()
    }
    func loadData()
    {
        loadingAnimationMethod.sharedInstance.startAnimation()
        let par = ["":""]
        let str = "\(((UIApplication.sharedApplication().delegate) as! AppDelegate).getService())\(url)"
        request.Get(str, parameters: par)
    }
    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        let ary =  result.objectForKey("dt") as? NSArray
        //考勤审批列表 报销审批列表
        for(var i = 0;i < ary?.count ;i++)
        {
            let dic =  ary?.objectAtIndex(i) as! NSDictionary
            let name = dic.objectForKey("Menu_Name") as? String
            if(name == "考勤审批列表" ||  name == "报销审批列表")
            {
                itemArry  = ["会议管理","考勤管理","固定资产","办理事项"]
                imageArry  = ["p1","p2","p3","p4"]
            }
        }
        cv?.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    //MARK: 实现UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArry.count;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        collectionView.registerNib(UINib(nibName:"workCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        let cell:workCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! workCollectionCell
    
        cell.title.text = itemArry[indexPath.row] as? String
        cell.image.image = UIImage(named: imageArry[indexPath.row] as! String)
    
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
            return UIEdgeInsetsMake(20,0,5, 0)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //某个Cell被选择的事件处理
        jumpPage(indexPath.row)
    }
    func jumpPage(index: Int)
    {
        if(index == 0)
        {
            //跳转会议
            self.performSegueWithIdentifier("HYSSegue", sender: self)
        }else if(index == 1)
        {
            //跳转考勤
            self.performSegueWithIdentifier("KQSegue", sender: self)
        }else if(index == 2)
        {
            //跳转固定
            let vc:fixedAssetsViewController = fixedAssetsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(index == 3)
        {
            //跳转审核
            self.performSegueWithIdentifier("pushAudit", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToWorkPlace(segue: UIStoryboardSegue) {
        
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
