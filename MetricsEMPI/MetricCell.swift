//
//  MetricCell.swift
//  MetricsEMPI
//
//  Created by Vladyslav Vdovychenko on 5/25/19.
//  Copyright © 2019 Vladyslav Vdovychenko. All rights reserved.
//

import UIKit

class MetricCell: UITableViewCell {
    
    static let gradients: [[UIColor]] = [
    [UIColor(red: 76, green: 161, blue: 175), UIColor(red: 196, green: 224, blue: 229)],
    [UIColor(red: 255, green: 95, blue: 109), UIColor(red: 255, green: 195, blue: 113)],
    [UIColor(red: 195, green: 55, blue: 100), UIColor(red: 29, green: 38, blue: 113)],
    [UIColor(red: 237, green: 66, blue: 100), UIColor(red: 255, green: 237, blue: 188)],
    [UIColor(red: 86, green: 171, blue: 47), UIColor(red: 168, green: 224, blue: 99)],
    [UIColor(red: 238, green: 205, blue: 163), UIColor(red: 239, green: 98, blue: 159)],
    [UIColor(red: 0, green: 4, blue: 40), UIColor(red: 0, green: 78, blue: 146)],
    [UIColor(red: 123, green: 67, blue: 151), UIColor(red: 220, green: 36, blue: 48)]
    ]
    
    let gradientView: UIView = {
        let v = UIView()
        return v
    }()
    
    let metricNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Helvetica-Neue", size: 16)
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    let valueLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Helvetica-Bold", size: 22)
        lbl.textColor = UIColor.white
        lbl.layer.cornerRadius = 15
        //lbl.clipsToBounds = true
        lbl.textAlignment = .center
        return lbl
    }()

   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: Extensions.shared.screenSize.width, height: 100)
        valueLabel.frame = CGRect(x: 10, y: frame.height/2 - 22/2, width: frame.width - 20, height: 22)
        metricNameLabel.frame = CGRect(x: 20, y: frame.height/2 - 20/2, width: 100, height: 20)
        gradientView.frame = CGRect(x: 10, y: 5, width: frame.width - 20, height: frame.height - 10)
        addSubviews(gradientView, metricNameLabel, valueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
