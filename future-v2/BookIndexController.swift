//
//  BookIndexController.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just;

class BookIndexController: UIViewController {
    
    // 控件
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var categoryCollectionView: CategoryCollectionView!
    @IBOutlet weak var hotCollectionView: HotCollectionView!
    @IBOutlet weak var moreHotBtn: UIButton!
    @IBOutlet weak var favoriteCollectionView: FavoriteCollectionView!
    @IBOutlet weak var moreFavoriteBtn: UIButton!
    
    // 数据
    var categories = [Category]();
    var hotBooks = [Book]();
    
    // 数据库
    let bookDao = BookDao();
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView();
        
        initData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 导航条
        parent?.navigationItem.title = "小说";
        
        // 加载我的收藏
        let books = bookDao.findFavoriteBooks(4);
        if books.count < 4 {
            self.moreFavoriteBtn.isEnabled = false;
        } else {
            self.moreFavoriteBtn.isEnabled = true;
        }
        self.favoriteCollectionView.loadData(books);
    }
    
    // 初始化数据
    func initData() {
        // 加载分类
        if categories.isEmpty {
            // 使用异步请求
            Http.post(UrlConstants.CATEGORY_ALL, callback: categoryCallback);
            
        }
        
        // 加载推荐小说
        if hotBooks.isEmpty {
            // 使用异步请求
            Http.post(UrlConstants.BOOK_HOTS, params: ["pageSize": "4"], callback: hotBooksCallback);
        }
    }
    
    // 加载推荐小说的回调
    func hotBooksCallback(res: HTTPResult) {
        let result = Http.parse(res);
        
        if result.0 {
            DispatchQueue.main.async {
                let books = result.2["books"] as! NSArray;
                for b in books {
                    let bk = b as! NSDictionary
                    let book = Book(bk);
                    
                    self.hotBooks.append(book);
                }
                
                if self.hotBooks.count < 4 {
                    self.moreHotBtn.isEnabled = false;
                } else {
                    self.moreHotBtn.isEnabled = true;
                }
                
                self.hotCollectionView.loadData(self.hotBooks);
            }
        }
    }
    
    // 加载分类的回调
    func categoryCallback(res: HTTPResult) {
        let result = Http.parse(res);
        
        if result.0 {
            let categories = result.2["categories"] as! NSArray;
            DispatchQueue.main.async {
                for c in categories {
                    let cc = c as! NSDictionary
                    let category = Category(cc);
                    
                    self.categories.append(category);
                }
                
                // 渲染
                self.categoryCollectionView.loadData(self.categories);
            }
        }
    }
    
    // 初始化界面
    func initView() {
        parent?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        
        // 绑定
        categoryCollectionView.delegate = categoryCollectionView;
        categoryCollectionView.dataSource = categoryCollectionView;
        hotCollectionView.delegate = hotCollectionView;
        hotCollectionView.dataSource = hotCollectionView;
        favoriteCollectionView.delegate = favoriteCollectionView;
        favoriteCollectionView.dataSource = favoriteCollectionView;
        
        // 引用传递
        categoryCollectionView.viewController = self;
        hotCollectionView.viewController = self;
        favoriteCollectionView.viewController = self
        
        // 搜索框
        searchInput.layer.borderWidth = 1;
        searchInput.layer.cornerRadius = 3;
        searchInput.layer.borderColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1).cgColor;
        ViewUtil.addLeftView(searchInput, withIcon: "search", width: 25, height: 25);
        
        // 搜索按钮
        searchBtn.layer.cornerRadius = 5;
    }
    
    // 搜索
    @IBAction func search(_ sender: Any) {
        if isLoading() {
            return;
        }
        
        // 收起键盘
        UIApplication.shared.keyWindow?.endEditing(true);
        
        // 关键字
        let key = searchInput.text!;
        
        // 判断非空
        if key.isEmpty {
            Toast.showMessage("请输入搜索内容！", onView: self.view);
            return;
        }
        
        // 加载中菊花
        loadingView = ViewUtil.loadingView(self.view);
        
        // 异步加载
        Http.post(UrlConstants.BOOK_SEARCH, params: ["key": key], callback: bookSearchCallback)
    }
    
    // 搜索小说的回调
    func bookSearchCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        var resBooks = [Book]();
        if result.0 {
            let books = result.2["books"] as! NSArray;
            for b in books {
                let bk = b as! NSDictionary
                let book = Book(bk);
                
                resBooks.append(book);
            }
        } else {
            Toast.showMessage(result.1, onView: self.view)
            return;
        }
        
        if resBooks.isEmpty {
            Toast.showMessage("没有符合条件的小说", onView: self.view);
            return;
        }
        
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookTableViewController") as! BookTableViewController;
            vc.books = resBooks;
            vc.refreshNav("搜索结果")
            self.parent?.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    // 加载更多推荐小说
    @IBAction func loadMoreHotBooks(_ sender: Any) {
        if isLoading() {
            return;
        }
        
        // 加载中菊花
        loadingView = ViewUtil.loadingView(self.view);
        
        // 异步加载
        Http.post(UrlConstants.BOOK_HOTS, params: ["pageSize": "50"], callback: moreHotBooksCallback)
    }
    
    // 更多推荐小说的回调
    func moreHotBooksCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        var resBooks = [Book]();
        if result.0 {
            let books = result.2["books"] as! NSArray;
            for b in books {
                let bk = b as! NSDictionary
                let book = Book(bk);
                
                resBooks.append(book);
            }
        } else {
            Toast.showMessage(result.1, onView: self.view)
            return;
        }
        
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookTableViewController") as! BookTableViewController;
            vc.books = resBooks;
            vc.refreshNav("站长推荐")
            self.parent?.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    // 加载更多收藏小说
    @IBAction func loadMoreFavoriteBooks(_ sender: Any) {
        let books = bookDao.findFavoriteBooks(100);
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookTableViewController") as! BookTableViewController;
        vc.books = books;
        vc.refreshNav("我的收藏")
        self.parent?.navigationController?.pushViewController(vc, animated: true);
    }
    
    // 判断是否正在加载
    func isLoading() -> Bool {
        return loadingView != nil && loadingView.isAnimating;
    }
    
    // 停止加载中动画
    func stopLoading() {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
        }
    }
    
    
}
