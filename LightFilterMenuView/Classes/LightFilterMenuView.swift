import UIKit

open class FilterItemModel: NSObject {
    public var name: String?
    var id: String?
    var isSel = false
}

open class FilterModel: NSObject {
    public var name: String?
    public var model: [FilterItemModel]?
}

public protocol FilterMenuViewDelegate {
    /// 点击某个菜单
    /// - Parameters:
    ///   - menuView: menuView
    ///   - index: 按钮索引
    func selectMenum(menuView: FilterMenuView, at index: Int)
    
    /// 点击某个菜单下的某个筛选条件
    /// - Parameters:
    ///   - menuView: menuView
    ///   - menuIndex: 按钮索引
    ///   - index: 列表索引
    func didSelectConfirm(menuView: FilterMenuView, at menuIndex: Int, at index: Int);
}

open class FilterMenuView: UIView {
    static let ItemCellId = "item"
    
    public var dataArr = [FilterModel]()
    
    var buttonArr = [UIButton]()
    
    public var delegate: FilterMenuViewDelegate?
    
    // 用户选中的 tab 索引
    var selectedTabIndex = -1
    
    var tableHeight: CGFloat = 0
    
    public var maxHeight: CGFloat? {
        didSet {

        }
    }
    
    public var menuViewBgColor: UIColor? {
        set {
            backgroundColor = newValue
        }
        get {
            backgroundColor
        }
    }
    
    public override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 开始调用以显示
    public func beginShowMenuView() {
        // 第一个按钮距离
        let buttonInterval = frame.size.width / CGFloat(dataArr.count)

        for index in 0..<dataArr.count {
            let button = UIButton()
            button.setTitle(dataArr[index].name, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.setImage(.init(named: "slideup"), for: .normal)
            button.setImage(.init(named: "slideupDown"), for: .selected)
            addSubview(button)
            button.tag = index;
            let titlePositionX = buttonInterval * CGFloat(index)
            button.frame = .init(x: titlePositionX, y: 0, width: buttonInterval , height: frame.size.height)
            button.addTarget(self, action: #selector(menuTapped(button:)), for: .touchUpInside)
            buttonArr.append(button)
        }
    }

    @objc func menuTapped(button: UIButton) {
        menuTapped(tapIndex: button.tag)
    }

    /// 外部快捷调用展开菜单列表
    func menuTapped(tapIndex: Int) {
        // 点击菜单回调
        if let delegate = delegate {
            delegate.selectMenum(menuView: self, at: tapIndex)
        }

        if selectedTabIndex == tapIndex {
            animateMenuViewWithShow(show: false)
        } else {
            selectedTabIndex = tapIndex
            animateMenuViewWithShow(show: true)
        }
    }

    /// 筛选视图显示&关闭
    /// - Parameter show: false 关闭
    func animateMenuViewWithShow(show: Bool) {
        if show {
            backGroundView.frame = .init(x: 0, y: self.frame.maxY, width: frame.size.width, height: maxHeight ?? 0)
            superview?.bringSubviewToFront(self)
            superview?.addSubview(backGroundView)
            backGroundView.backgroundColor = .init(white: 0, alpha: 0.5)
            myTableView.frame = .init(x: frame.origin.x, y: self.frame.maxY, width: frame.size.width, height: tableHeight)
            superview?.addSubview(myTableView)
            UIView.animate(withDuration: 0.25) {
                let count = self.dataArr[self.selectedTabIndex].model?.count ?? 0
                self.myTableView.frame = .init(x: self.frame.minX, y: self.frame.maxY, width: self.frame.width, height: CGFloat(40*count))
                self.tableHeight = CGFloat(40*count)
            }
            myTableView.reloadData()
            buttonArr.forEach { item in
                item.isSelected = false
            }
            buttonArr[selectedTabIndex].isSelected = true
        } else {
            tableHeight = 0
            UIView.animate(withDuration: 0.2) {
                self.myTableView.frame = .init(x: self.frame.minX, y: self.frame.maxY, width: self.frame.width, height: self.tableHeight)
            } completion: { finish in
                self.backGroundView.removeFromSuperview()
                self.myTableView.removeFromSuperview()
            }
            buttonArr.forEach { item in
                item.isSelected = false
            }
            selectedTabIndex = -1
        }
    }

    private lazy var myTableView: UITableView = {
        let tableV = UITableView.init(frame: CGRect.zero, style: .plain)
        tableV.backgroundColor = .white
        tableV.delegate = self
        tableV.dataSource = self
        tableV.rowHeight = 40
        tableV.isScrollEnabled = false
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: Self.ItemCellId)
        return tableV
    }()

    private lazy var backGroundView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(white: 0, alpha: 0)
        bgView.isOpaque = false
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGesAction(_:)))
        bgView.addGestureRecognizer(tapGes)
        return bgView
    }()

    // 方法
    @objc func tapGesAction(_ tapGes : UITapGestureRecognizer){
        animateMenuViewWithShow(show: false)
    }

}

extension FilterMenuView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArr[selectedTabIndex].model?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.ItemCellId, for: indexPath)
        guard let model = dataArr[selectedTabIndex].model?[indexPath.row]  else { return cell }
        cell.textLabel?.text = model.name
        cell.textLabel?.textColor = model.isSel ? UIColor.darkGray : UIColor.lightGray
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 点击列表回调
        if let delegate = delegate {
            delegate.didSelectConfirm(menuView: self, at: selectedTabIndex, at: indexPath.row)
        }
        guard let model = dataArr[selectedTabIndex].model?[indexPath.row]  else { return }
        dataArr[selectedTabIndex].model?.forEach({ item in
            item.isSel = false
        })
        model.isSel = true
        buttonArr[selectedTabIndex].setTitle(dataArr[selectedTabIndex].model?[indexPath.row].name, for: .normal)
        animateMenuViewWithShow(show: false)
    }
}


