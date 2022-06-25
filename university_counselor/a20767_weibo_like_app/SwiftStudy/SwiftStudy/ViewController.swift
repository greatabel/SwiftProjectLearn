import UIKit
import SnapKit
import Alamofire
import AlamofireImage
import GDPerformanceView_Swift
import Kingfisher

class ViewController: UIViewController {
    //隐藏状态栏
    var isStatusBarHidden = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var prefersStatusBarHidden: Bool {
        get {
            return isStatusBarHidden
        }
    }
    //懒加载
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        //        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.allowsSelection = false
        tableView.register(SLTableViewCell.self, forCellReuseIdentifier: "cellId")
        return tableView
    }()
    //中介 负责处理数据和事件
    lazy var presenter : SLPresenter = {
        let presenter = SLPresenter()
        return presenter
    }()
    var dataArray = NSMutableArray()
    var layoutArray = NSMutableArray()
    
    // MARK: UI
    override func viewDidLoad() {
        super.viewDidLoad()
        //性能监测工具
        PerformanceMonitor.shared().start()
        //中间者 处理数据和事件
        self.presenter.getData { (dataArray, layoutArray) in
            //            print("刷新")
            self.dataArray = dataArray
            self.layoutArray = layoutArray
            self.tableView.reloadData()
        }
        self.presenter.fullTextBlock = { (indexPath) in
            self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        }
        //限制内存高速缓存大小为50MB
        ImageCache.default.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
        //限制内存缓存最多可容纳150张图像
        ImageCache.default.memoryStorage.config.countLimit = 150
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //安全距离什么时候被改变
    override func viewSafeAreaInsetsDidChange() {
        // 考虑安全距离
        let insets: UIEdgeInsets = self.view.safeAreaInsets
        print(insets)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(insets.top)
            make.bottom.equalToSuperview()
        }
    }
    func setupUI() {
        self.navigationItem.title = "微博列表模拟"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "注册/登录", style: UIBarButtonItem.Style.done, target: self, action: #selector(jump_login_register))
        
//        let backBTN = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: AbelLoginRegisterVC.self,
//        action: #selector(UINavigationController.popViewController(animated:)))

//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "login/register", style: UIBarButtonItem.Style.plain, target: AbelLoginRegisterVC.self, action: #selector(jump_login_register))
//
        
        self.view.addSubview(self.tableView)
    }
    
    // MARK: Events
//    @objc func clearCache() {
//        ImageCache.default.clearMemoryCache()
//        ImageCache.default.clearDiskCache {
//            print("图片清除缓存完毕")
//        }
//    }
    
    
    @objc func jump_login_register() {
        
//          //实例化一个登陆界面
//          let loginView = AbelLoginRegisterVC()
//          //从下弹出一个界面作为登陆界面，completion作为闭包，可以写一些弹出loginView时的一些操作
//        self.present(loginView, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AbelLoginRegisterVC") as! AbelLoginRegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
        print("jump_login_register")
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > self.layoutArray.count - 1 { return 0 }
        let layout : SLLayout = self.layoutArray[indexPath.row] as! SLLayout
        return layout.cellHeight
    }
    func tableView(_ tableVdiew: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SLTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SLTableViewCell
        let model:SLModel = self.dataArray[indexPath.row] as! SLModel
        var layout:SLLayout?
        if indexPath.row <= self.layoutArray.count - 1 {
            layout = self.layoutArray[indexPath.row] as? SLLayout
        }
        cell.delegate = self.presenter
        cell.cellIndexPath = indexPath
        cell.configureCell(model: model, layout: layout)
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
