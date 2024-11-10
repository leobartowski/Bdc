//
//  StatisticsViewController - TableView.swift
//  Bdc
//
//  Created by leobartowski on 23/10/24.
//
 
import UIKit

extension StatisticsViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: // Profile Pic Cell Individual
                return self.isIndividualStats ? 180 : 0
            case 1: // First Label Cell
//                return 103
                return self.isIndividualStats ? 0 : 103 // 10 + 10 + 10 + 10 + 21 + 42
            case 2: // Segmented control
                return 53 // 10 + 10 + 33
            case 3: // Divider Label Bar Chart
                return UITableView.automaticDimension
            case 4: // Line chart
                return 285 // 10 + 15 + 10 + 250
            case 5: // Period Growth Label cell
                return 82 // 10 + 10 + 10 + 10 + 42
            case 6: // Divider Label Bar Chart
//                return 41 // 10 + 10 + 21
                return UITableView.automaticDimension // 10 + 10 + 21
            case 7: // Slot Line chart
                return 305 // 10 + 35 + 10 + 250
            case 8: // Ratio Morning Label cell
                return 82 //  10 + 10 + 10 + 10 + 42
            case 9: // Divider Label Bar Chart
                return self.chartPeriodType == .yearly ? 0 : UITableView.automaticDimension
            case 10: // Bar Chart weekly
                return self.chartPeriodType == .yearly ? 0 : 220 // 200 + 10 + 10
            default:
                return 0
            }
        }
        return 0
    }
}
