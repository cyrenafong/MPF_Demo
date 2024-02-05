//
//  SummaryViewController.swift
//  MPFManager
//
//  Created by Cyrena Fong on 12/11/2019.
//  Copyright © 2019 EE4304. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    private let viewModel = ChartViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.initial()
        
        setChart(dataPoints: viewModel.name, values: viewModel.value)
    }
    
    func setChart(dataPoints: [String], values: [Double]){
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry.init(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Company")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChart.data = pieChartData
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        pieChartDataSet.colors = colors
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
