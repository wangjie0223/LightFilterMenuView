//
//  ViewController.swift
//  LightFilterMenuView
//
//  Created by wangjie0223 on 09/13/2021.
//  Copyright (c) 2021 wangjie0223. All rights reserved.
//

import UIKit
import LightFilterMenuView

let STATUSBAR_HEIGHT = (UIApplication.shared.connectedScenes.map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.first?.safeAreaInsets.top)!
let NAV_HEIGHT = STATUSBAR_HEIGHT + 44

class ViewController: UIViewController {

    private lazy var menuView: FilterMenuView = {
        let menu = FilterMenuView.init(frame: .init(x: 0, y: NAV_HEIGHT, width: view.frame.width, height: 45))
        menu.backgroundColor = .white
        menu.delegate = self
        menu.menuViewBgColor = .cyan
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let bgImageView = UIImageView.init(image: .init(named: "picture"))
        bgImageView.contentMode = .bottom
        bgImageView.frame = view.bounds
        bgImageView.backgroundColor = .brown
        view.addSubview(bgImageView)
        
        view.addSubview(menuView)
        menuView.maxHeight = UIScreen.main.bounds.size.height - NAV_HEIGHT
        
        let stepper = UIStepper.init(frame: .init(x: 10, y: STATUSBAR_HEIGHT, width: 300, height: 100))
        view.addSubview(stepper)
        stepper.addTarget(self, action: #selector(click(steper:)), for: .valueChanged)
        
        let stepper2 = UIStepper.init(frame: .init(x: UIScreen.main.bounds.size.width - 100, y: STATUSBAR_HEIGHT, width: 300, height: 100))
        view.addSubview(stepper2)
        stepper2.addTarget(self, action: #selector(click2(steper:)), for: .valueChanged)
        
        let resetButton = UIButton()
        resetButton.backgroundColor = .white
        resetButton.setTitle("重置", for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.frame = .init(x: stepper.frame.maxX + 50, y: STATUSBAR_HEIGHT, width: 80, height: 40)
        resetButton.addTarget(self, action: #selector(click3(button:)), for: .touchUpInside)
        view.addSubview(resetButton)
        
        createData()
        menuView.beginShowMenuView()

    }
    
    func createData() {
        // 第0列数据
        let item00 = FilterItemModel()
        item00.name = "C1"
        let item01 = FilterItemModel()
        item01.name = "C1"
        let item02 = FilterItemModel()
        item02.name = "C3"
        
        // 第1列数据
        let item10 = FilterItemModel()
        item10.name = "班型1"
        let item11 = FilterItemModel()
        item11.name = "班型2"
        let item12 = FilterItemModel()
        item12.name = "班型3"
        let item13 = FilterItemModel()
        item13.name = "班型4"
        
        // 第2列数据
        let item20 = FilterItemModel()
        item20.name = "科目一"
        let item21 = FilterItemModel()
        item21.name = "科目二"
        let item22 = FilterItemModel()
        item22.name = "科目三"
        let item23 = FilterItemModel()
        item23.name = "科目四"
        
        let certificateType = FilterModel()
        certificateType.name = "证型"
        certificateType.model = [item00, item01, item02]
        
        let classType = FilterModel()
        classType.name = "班型"
        classType.model = [item10, item11, item12, item13]
        
        let subject = FilterModel()
        subject.name = "科目"
        subject.model = [item20, item21, item22, item23]
        
        var dataArr = [FilterModel]()
        dataArr.append(certificateType)
        dataArr.append(classType)
        dataArr.append(subject)

        menuView.dataArr = dataArr
    }
    
    @objc func click(steper: UIStepper) {
        print("click",steper.value)
        UIView.animate(withDuration: 0.2) {
            self.menuView.frame = .init(x: 0, y: NAV_HEIGHT + 100 + CGFloat(steper.value)*20, width: self.view.frame.width, height: 45)
        }
    }
    
    @objc func click2(steper: UIStepper) {
        print("click",steper.value)
        UIView.animate(withDuration: 0.2) {
            self.menuView.frame = .init(x: 0, y: self.menuView.frame.minY, width: self.view.frame.width, height: 45 + CGFloat(steper.value)*20)
        }
    }
    
    @objc func click3(button: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.menuView.frame = .init(x: 0, y: NAV_HEIGHT, width: self.view.frame.width, height: 45)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: FilterMenuViewDelegate {
    func didSelectConfirm(menuView: FilterMenuView, at menuIndex: Int, at index: Int) {
//        print(menuView.dataArr[menuIndex].model?[index].name ?? "")
    }
    
    func selectMenum(menuView: FilterMenuView, at index: Int) {
        // print("ViewController:点击了", menuView.titleArr[index])
    }
}
