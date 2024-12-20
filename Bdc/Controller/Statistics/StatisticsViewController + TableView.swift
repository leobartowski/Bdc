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
                return self.isIndividualStats ? UITableView.automaticDimension : 0
            case 1: // First Labels Cell
                return self.isIndividualStats ? 124 : 103 // 10 + 10 + 10 + 10 + 21 (42) + 42
            case 2: // Divider Best Pal Podium
                return self.isIndividualStats ? UITableView.automaticDimension : 0
            case 3: // Best Pal Podium Cell
                return self.isIndividualStats ? 276 : 0
            case 4: // Segmented control
                return 53 // 10 + 10 + 33
            case 5: // Divider Label Bar Chart
                return UITableView.automaticDimension
            case 6: // Line chart
                return 285 // 10 + 15 + 10 + 250
            case 7: // Period Growth Label cell
                return 82 // 10 + 10 + 10 + 10 + 42
            case 8: // Divider Label Bar Chart
//                return 41 // 10 + 10 + 21
                return UITableView.automaticDimension // 10 + 10 + 21
            case 9: // Slot Line chart
                return 305 // 10 + 35 + 10 + 250
            case 10: // Ratio Morning Label cell
                return 82 //  10 + 10 + 10 + 10 + 42
            case 11: // Divider Label Bar Chart
                return self.chartPeriodType == .yearly ? 0 : UITableView.automaticDimension
            case 12: // Bar Chart weekly
                return self.chartPeriodType == .yearly ? 0 : 220 // 200 + 10 + 10
            default:
                return 0
            }
        }
        return 0
    }
}
