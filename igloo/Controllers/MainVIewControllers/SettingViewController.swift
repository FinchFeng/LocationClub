//
//  SettingViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/21.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    //MARK:IBOutlet
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.navigationItem.titleView = nil
        self.tabBarController!.navigationItem.title = "设置"
        self.tabBarController!.navigationItem.leftBarButtonItem = nil
        self.tabBarController!.navigationItem.rightBarButtonItem = nil
    }
    
    func getDatasForMarsView(landingBlock:@escaping ([(id:String,rank2:LocationInfoRank2,rank3:LocationInfoRank3)])->Void) {
        //递归获取这些数据
        func getData(resultArray:[(id:String,rank2:LocationInfoRank2,rank3:LocationInfoRank3)],inputArray:[String]){
            if let firstData = inputArray.first{
                //更新输入数据
                var newInputArray = inputArray
                newInputArray.remove(at: 0)
                //获取rank2data 和 rank3
                var newResultArray = resultArray
                Network.getLocationInfo(locationID: firstData, rank: 2) { (data) in
                    let rank2Data = data as! LocationInfoRank2
                    Network.getLocationInfo(locationID: firstData, rank: 3, landingAction: { (data) in
                        let rank3Data = data as! LocationInfoRank3
                        //更新新的LocationData
                        newResultArray.append((id:firstData , rank2: rank2Data, rank3: rank3Data))
                        getData(resultArray: newResultArray, inputArray: newInputArray)
                    })
                }
            }else{
                print("执行landingAction")
                //执行landingAction
                landingBlock(resultArray)
                return
            }
        }
        print("LoginModel.owenLikedLocationIDArray")
        print(LoginModel.owenLikedLocationIDArray)
        getData(resultArray: [], inputArray: LoginModel.owenLikedLocationIDArray)
    }
    
    //MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingItemCell")!
        switch indexPath.row {
        case 0:
            cell.textLabel?.textColor = #colorLiteral(red: 0.02745098039, green: 0.462745098, blue: 0.4705882353, alpha: 1)
            //设置获取了多少赞
//            let totalLikeAmount =
            cell.textLabel?.text = "我收到的赞 " + String(LoginModel.totalLikeAmout)
        case 1:
            cell.textLabel?.text = "我赞过的地点"
        case 2:
            cell.textLabel?.text = "退出登陆"
        case 3:
            cell.textLabel?.text = "联系我们"
        default: return cell
        }
        return cell
    }
    
    
    var alert:UIAlertController?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            getDatasForMarsView { (dataArray) in
                //获取数据并且传递给下一个展现ViewController
                print(dataArray)
                self.performSegue(withIdentifier: "segueToLikedLocation", sender: nil)
            }
        case 2:
            let alertController = UIAlertController(title: "您要退出登陆吗？", message: nil, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "退出", style: UIAlertAction.Style.default, handler: { (_) in
                //选择了退出登陆
                LoginModel.login = false
            }))
            present(alertController, animated: true, completion: nil)
        case 3:
            let alert = UIAlertController(
                title: "联系我们",
                message: "请输入您的建议",
                preferredStyle: .alert
            )
            self.alert = alert
            alert.addAction(UIAlertAction(
                title: "发送",
                style: .default)
            { (action: UIAlertAction) -> Void in
                //从父ViewController中获取TextFields
                if let tf = self.alert?.textFields?.first {
                    //发送信息
                    if let text = tf.text {
                        Network.contactUs(string: text)
                    }
                }
            } )
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "说点啥"
            })
            alert.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    


}
