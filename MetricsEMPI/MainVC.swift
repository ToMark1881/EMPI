//
//  ViewController.swift
//  MetricsEMPI
//
//  Created by Vladyslav Vdovychenko on 5/24/19.
//  Copyright © 2019 Vladyslav Vdovychenko. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var fileUrls = [URL]()
    var files = [String]()
    var metrics: [[String: Double]] = [ [:], [:] ]
    
    let sections = ["Прямые метрики", "Непрямые метрики"]
    
    
    let cellId = "MetricCell"
    
    let enterPathLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.black
        lbl.text = "Введите путь: "
        lbl.textAlignment = .center
        return lbl
    }()
    
    let pathTextField: UITextField = {
        let tf = UITextField()
        tf.smartQuotesType = .no
        tf.smartDashesType = .no
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.adjustsFontSizeToFitWidth = true
        tf.contentScaleFactor = 0.2
        tf.minimumFontSize = 8
        tf.borderStyle = UITextField.BorderStyle.roundedRect
        return tf
    }()
    
    let openFilesButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Открыть", for: .normal)
        btn.addTarget(self, action: #selector(openFiles), for: .touchUpInside)
        return btn
    }()
    
    let filesCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.black
        lbl.text = "Количество файлов: 0"
        lbl.textAlignment = .center
        return lbl
    }()
    
    let metricsTableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 100
        tv.separatorStyle = .none
        return tv
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metrics[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MetricCell
        let (name, value) = Array(metrics[indexPath.section])[indexPath.row]
        cell.metricNameLabel.text = name
        cell.valueLabel.text = String(value)
        cell.gradientView.addGradientBackground(firstColor: MetricCell.gradients[indexPath.row][0], secondColor: MetricCell.gradients[indexPath.row][1])
        cell.gradientView.dropShadow()        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }
    
    fileprivate func setUpViews() {
        guard let topBarFrame = self.navigationController?.navigationBar.frame else {return}
        self.navigationItem.title = "Metrics Calculator"
        enterPathLabel.frame = CGRect(x: Extensions.shared.screenSize.width/2 - 200/2, y: topBarFrame.maxY + 12, width: 200, height: 20)
        pathTextField.frame = CGRect(x: 30, y: enterPathLabel.frame.maxY + 6, width: Extensions.shared.screenSize.width - 60, height: 20)
        openFilesButton.frame = CGRect(x: Extensions.shared.screenSize.width/2 - 80/2, y: pathTextField.frame.maxY + 10, width: 80, height: 14)
        filesCountLabel.frame = CGRect(x: Extensions.shared.screenSize.width/2 - 250/2, y: openFilesButton.frame.maxY + 12, width: 250, height: 20)
        metricsTableView.frame = CGRect(x: 0, y: filesCountLabel.frame.maxY + 6, width: Extensions.shared.screenSize.width, height: Extensions.shared.screenSize.height - (filesCountLabel.frame.maxY + 12))
        
        view.addSubviews(enterPathLabel, pathTextField, openFilesButton, filesCountLabel, metricsTableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setUpViews()
        metricsTableView.delegate = self
        metricsTableView.dataSource = self
        metricsTableView.register(MetricCell.self, forCellReuseIdentifier: cellId)
        metricsTableView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func openFiles() {
        guard let path = pathTextField.text else {return}
        self.fileUrls.removeAll()
        self.files.removeAll()
        let fileManager = FileManager.default
        let urls = fileManager.listFiles(path: path, fileExtension: "java")
        self.fileUrls = urls
        self.filesCountLabel.text = "Количество файлов: \(fileUrls.count)"
        openFilesAsText()
    }
    
    fileprivate func openFilesAsText() {
        let fm = FileManager.default
        for fileUrl in fileUrls {
            guard let data = fm.contents(atPath: fileUrl.path) else {print("err1"); return}
            guard let fileString = String(data: data, encoding: .utf8) else {print("err2"); return}
            self.files.append(fileString)
        }
        findMetrics()
    }
    
    
    fileprivate func findMetrics() {
        if files.count > 0 {
            metricsTableView.isHidden = false
            let NOC = MetricsCalculator.shared.findNOC(files)
            self.metrics[0].updateValue(NOC, forKey: "NOC")
            metricsTableView.reloadData()
            
            let NOM = MetricsCalculator.shared.findNOM(files)
            self.metrics[0].updateValue(NOM, forKey: "NOM")
            metricsTableView.reloadData()

            let CALL = MetricsCalculator.shared.findCALL(files)
            self.metrics[0].updateValue(CALL, forKey: "CALL")
            metricsTableView.reloadData()

            let CYCLO = MetricsCalculator.shared.findCYCLO(files)
            self.metrics[0].updateValue(CYCLO, forKey: "CYCLO")
            metricsTableView.reloadData()

            let FOUT = MetricsCalculator.shared.findFOUT(files)
            self.metrics[0].updateValue(FOUT, forKey: "FOUT")
            metricsTableView.reloadData()

            let AMW = MetricsCalculator.shared.findAMW(files)
            self.metrics[1].updateValue(AMW, forKey: "AMW")
            metricsTableView.reloadData()

            let ATFD = MetricsCalculator.shared.findATFD(files)
            self.metrics[1].updateValue(ATFD, forKey: "ATFD")
            metricsTableView.reloadData()

            let BOvR = MetricsCalculator.shared.findBOvR(files)
            self.metrics[1].updateValue(BOvR, forKey: "BOvR")
            metricsTableView.reloadData()


        }
    }

}

