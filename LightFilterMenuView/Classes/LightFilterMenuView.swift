import UIKit

open class FilterItemModel: NSObject {
    public var name: String?
    public var id: String?
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
    
    public var divideLineHeight: CGFloat? {
        didSet {
            
        }
    }
    
    // 分割线颜色
    public var divideLineBgColor: UIColor? {
        didSet {
            
        }
    }
    
    /// 菜单普通状态按钮颜色
    public var menuButtonTitleNorColor: UIColor? {
        didSet {
            
        }
    }
    
    /// 菜单选中状态按钮颜色
    public var menuButtonTitleSelColor: UIColor? {
        didSet {
            
        }
    }
    
    /// 菜单普通状态 Image
    public var menuButtonTitleNorImage: UIImage? {
        didSet {
            
        }
    }
    
    /// 菜单选中状态 Image
    public var menuButtonTitleSelImage: UIImage? {
        didSet {
            
        }
    }
    
    /// 菜单按钮font
    public var menuButtonTitleFont: UIFont? {
        didSet {
            
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
            button.setTitleColor(menuButtonTitleNorColor ?? .lightGray, for: .normal)
            button.setTitleColor(menuButtonTitleSelColor ?? .black, for: .selected)
            let norImage = menuButtonTitleNorImage ?? .init(named: "slideup")
            let selImage = menuButtonTitleSelImage ?? .init(named: "slideupDown")
            button.semanticContentAttribute = .forceRightToLeft
            button.setImage(norImage, for: .normal)
            button.setImage(selImage, for: .selected)
            button.titleLabel?.font = menuButtonTitleFont ?? .systemFont(ofSize: 15, weight: .regular)
            addSubview(button)
            button.tag = index;
            let titlePositionX = buttonInterval * CGFloat(index)
            let linePositionX = buttonInterval * CGFloat(index + 1)

            button.frame = .init(x: titlePositionX, y: 0, width: buttonInterval , height: frame.size.height)
            let divideLine = UIView()
            addSubview(divideLine)
            divideLine.backgroundColor = divideLineBgColor ?? .black
            let divideHeight: CGFloat = divideLineHeight ?? 0
            print(divideHeight)
            divideLine.frame = .init(x: linePositionX, y: (frame.size.height - divideHeight)/2, width: 1 , height: divideHeight)
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
        tableV.register(FilterTableViewCell.self, forCellReuseIdentifier: Self.ItemCellId)
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


