import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet private var searchCityName: UITextField!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var iconLabel: UILabel!
    @IBOutlet private var cityNameLabel: UILabel!

    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        style()

        // 默认显示数据
        ApiController.shared.currentWeather(for: "London")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { data in
                self.tempLabel.text = "\(data.temperature)° C"
                self.iconLabel.text = data.icon
                self.humidityLabel.text = "\(data.humidity)%"
                self.cityNameLabel.text = data.cityName
            })
            .disposed(by: bag)

        // 抑制不必要的网络请求，只有当用户点击键盘上的 “Search” 按钮时，应用程序才会检索天气信息
        let search = searchCityName.rx.controlEvent(.editingDidEndOnExit)
            .map { self.searchCityName.text ?? "" }
            .filter { !$0.isEmpty } // 过滤空值
            .flatMapLatest { text in
                ApiController.shared.currentWeather(for: text).catchAndReturn(.empty)
            }
            .asDriver(onErrorJustReturn: .empty)

        // 通过名为 search 的源可观察序列，将不同的数据片段绑定到不同的 UILabel 上
        search.map { "\($0.temperature)° C" }.drive(tempLabel.rx.text).disposed(by: bag)
        search.map(\.icon).drive(iconLabel.rx.text).disposed(by: bag)
        search.map { "\($0.humidity)%" }.drive(humidityLabel.rx.text).disposed(by: bag)
        search.map(\.cityName).drive(cityNameLabel.rx.text).disposed(by: bag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        Appearance.applyBottomLine(to: searchCityName)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Style

    private func style() {
        view.backgroundColor = UIColor.aztec
        searchCityName.attributedPlaceholder = NSAttributedString(string: "City's Name",
                                                                  attributes: [.foregroundColor: UIColor.textGrey])
        searchCityName.textColor = UIColor.ufoGreen
        tempLabel.textColor = UIColor.cream
        humidityLabel.textColor = UIColor.cream
        iconLabel.textColor = UIColor.cream
        cityNameLabel.textColor = UIColor.cream
    }
}
