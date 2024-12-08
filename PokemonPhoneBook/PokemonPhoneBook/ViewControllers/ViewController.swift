//
//  ViewController.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/6/24.
//

import UIKit
import SnapKit
import CoreData

// Main ViewController
final class ViewController: UIViewController {
    
    // 테이블 뷰 데이터 소스
    private var dataSource: [PhoneBookData] = []
    
    // MARK: - ViewController UI
    private let tableView = UITableView()
    
    private let navigationTitle = UILabel()
    
    private let pushButton = UIButton()
    
    // MARK: - ViewController CoreData Container
    private var container: NSPersistentContainer!
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 코어 데이터와 연결
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        configUI() // UI 세팅
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readAllData() // 코어 데이터에서 데이터 불러오기
                        
        self.tableView.reloadData()
        self.navigationController?.navigationBar.isHidden = true // 뷰가 생성될 때마다 네비게이션 바 히든
    }
}

// MARK: - ViewController UI Setting Method
private extension ViewController {
    
    /// 뷰의 모든 UI를 세팅하는 메소드
    func configUI() {
        view.backgroundColor = .white
        [self.tableView,
         self.navigationTitle,
         self.pushButton].forEach { view.addSubview($0) }
        
        setupTableView()
        setupNavigationTitle()
        setupPushButtonView()
        setupUILayout()
    }
    
    /// 네비게이션 타이블 UI를 세팅하는 메소드
    func setupNavigationTitle() {
        navigationTitle.text = "친구 목록"
        navigationTitle.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        navigationTitle.textAlignment = .center
        navigationTitle.textColor = .black
        navigationTitle.backgroundColor = .clear
    }
    
    /// 테이블 뷰의 UI를 세팅하는 메소드
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PhoneBookCell.self, forCellReuseIdentifier: PhoneBookCell.id)
        self.tableView.backgroundColor = .clear
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.separatorInset.right = 20
    }
    
    /// 버튼의 UI를 세팅하는 메소드
    func setupPushButtonView() {
        var config = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString.init("추가")
        titleAttr.font = .systemFont(ofSize: 20, weight: .medium)
        
        config.attributedTitle = titleAttr
        config.baseForegroundColor = .systemBlue
        
        self.pushButton.configuration = config
        self.pushButton.backgroundColor = .clear
        self.pushButton.addTarget(self, action: #selector(pushDestinationView), for: .touchUpInside)
    }
    
    /// 버튼의 액션 메소드
    /// 버튼을 누르면 PhoneBookViewController 뷰가 쌓임
    @objc func pushDestinationView() {
        self.navigationController?.pushViewController(PhoneBookViewController(), animated: true)
        self.navigationController?.navigationBar.isHidden = false // 뷰가 쌓이면 네이게이션바를 보여줌
    }
    
    /// 뷰의 모든 레이아웃을 세팅하는 메소드
    func setupUILayout() {
        self.navigationTitle.snp.makeConstraints {
            $0.trailing.leading.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(60)
        }
        
        self.tableView.snp.makeConstraints {
            $0.trailing.leading.bottom.equalTo(view)
            $0.top.equalTo(self.navigationTitle.snp.bottom).inset(10)
        }
        
        self.pushButton.snp.makeConstraints {
            $0.top.bottom.equalTo(self.navigationTitle)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: - ViewController Private Method
private extension ViewController {
    func readAllData() {
        do {
            let phoneBooks = try self.container.viewContext.fetch(PhoneBookData.fetchRequest())
            // 데이터를 알파벳 순으로 정렬하여 데이터소스에 전달
            self.dataSource = phoneBooks.sorted(by: {
                if let lhs = $0.name, let rhs = $1.name {
                    return lhs < rhs
                } else {
                    return false
                }
            })
            print("데이터 불러오기 성공")
            
        } catch {
            print("데이터 불러오기 실패", error)
        }
    }
}

// MARK: - ViewController TableView DataSource Method
extension ViewController: UITableViewDataSource {
    
    // 테이블뷰의 셀 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    // 테이블뷰 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: PhoneBookCell.id) as? PhoneBookCell else {
            return UITableViewCell()
        }
        
        cell.updataCellUI(self.dataSource[indexPath.row])
        cell.selectionStyle = .none
                
        return cell
    }
    
    // 테이블뷰 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // 테이블뷰 헤더 크기
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // 테이블뷰 헤더 설정 = nil (표시하지 않음)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

// MARK: - ViewController TableView Delegate Method
extension ViewController: UITableViewDelegate {
    
}
