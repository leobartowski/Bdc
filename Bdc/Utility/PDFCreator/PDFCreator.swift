//
//  PDF.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 30/11/21
//  with the great help of:
//  https://stackoverflow.com/questions/59398853/swift-5-how-to-create-table-in-pdf-with-pdfkit
//

import PDFKit
import UIKit

class PDFCreator: NSObject {
    
    let defaultOffset: CGFloat = 20
    var titleHeight: CGFloat = 50
    let pdfTitle: String
    let tableDataHeaderTitles: [String]
    let tableDataItems: [PDFTableDataItem]

    init(tableDataItems: [PDFTableDataItem], tableDataHeaderTitles: [String], pdfTitle: String) {
        self.tableDataItems = tableDataItems
        self.tableDataHeaderTitles = tableDataHeaderTitles
        self.pdfTitle = pdfTitle
    }

    static func createPDFTitle(dates: [Date], _ rankingType: RankingType = .weekly) -> String {
        var daysToCreateTitle = dates.sorted(by: { $0 < $1 })
        daysToCreateTitle = daysToCreateTitle.filter { $0 <= Date.now }
        
        switch rankingType {
        case .weekly:
            let date1 = daysToCreateTitle.first ?? Date()
            let date2 = daysToCreateTitle.last ?? Date()
            let date1String = DateFormatter.dayAndMonthFormatter.string(from: date1)
            let date2String = DateFormatter.dayAndMonthFormatter.string(from: date2)
            
            return "Presenze BdC dal " + date1String + " al " + date2String
        case .monthly:
            
            let date = daysToCreateTitle.first ?? Date()
            let dateString = DateFormatter.verboseMonthYear.string(from: date)
            return "Presenze BdC " + dateString
            
        case .yearly:
            let date = daysToCreateTitle.first ?? Date()
            let dateString = DateFormatter.verboseYear.string(from: date)
            return "Presenze annuali del " + dateString
        }
    }

    func create() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "bdc",
            kCGPDFContextAuthor: "leobartowski",
            kCGPDFContextTitle: pdfTitle,
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        // default page format
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let numberOfElementsPerPage = self.calculateNumberOfElementsPerPage(with: pageRect)
        let tableDataChunked: [[PDFTableDataItem]] = self.tableDataItems.chunkedElements(into: numberOfElementsPerPage)

        let data = renderer.pdfData { context in
            for (i, tableDataChunk) in tableDataChunked.enumerated() {
                context.beginPage()
                let cgContext = context.cgContext
                if i == 0 { addTitle(pageRect: pageRect, titleText: pdfTitle) }

                drawTableHeaderRect(drawContext: cgContext, pageRect: pageRect)
                drawTableHeaderTitles(titles: tableDataHeaderTitles, drawContext: cgContext, pageRect: pageRect)
                drawTableContentInnerBordersAndText(drawContext: cgContext, pageRect: pageRect, tableDataItems: tableDataChunk)

                if i == 0 { titleHeight = 0 }
            }
            addCreationTime(pageRect: pageRect)
        }

        return data
    }

    func calculateNumberOfElementsPerPage(with pageRect: CGRect) -> Int {
        let rowHeight = (defaultOffset * 2)
        let number = Int((pageRect.height - rowHeight - self.titleHeight - 30) / rowHeight)
        return number
    }

    func addTitle(pageRect: CGRect, titleText _: String) {
        let titleFont = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        // 2
        let titleAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: titleFont,
             NSAttributedString.Key.foregroundColor: Theme.FSCalendarStandardSelectionColor]
        // 3
        let attributedTitle = NSAttributedString(
            string: pdfTitle,
            attributes: titleAttributes
        )
        // 4
        let titleStringSize = attributedTitle.size()
        // 5
        let titleStringRect = CGRect(
            x: (pageRect.width - titleStringSize.width) / 2.0,
            y: 20,
            width: titleStringSize.width,
            height: titleStringSize.height
        )
        // 6
        attributedTitle.draw(in: titleStringRect)
        // 7
        //      return titleStringRect.origin.y + titleStringRect.size.height
    }

    func addCreationTime(pageRect: CGRect) {
        let titleFont = UIFont.systemFont(ofSize: 15, weight: .bold)
        let timestampString = DateFormatter.creationDateFormatter.string(from: Date.now)
        let text = "Creato con ❤️ dall'app BdC il " + timestampString

        let titleAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: titleFont,
             NSAttributedString.Key.foregroundColor: UIColor.gray]

        let attributedTitle = NSAttributedString(
            string: text,
            attributes: titleAttributes
        )

        let titleStringSize = attributedTitle.size()

        let titleStringRect = CGRect(
            x: (pageRect.width - titleStringSize.width) / 2.0,
            y: 11 * 72.0 - 25, // 11 * 72.0 = pageHeight
            width: titleStringSize.width,
            height: titleStringSize.height
        )

        attributedTitle.draw(in: titleStringRect)
    }
}

// Drawings
extension PDFCreator {
    func drawTableHeaderRect(drawContext: CGContext, pageRect: CGRect) {
        drawContext.setStrokeColor(Theme.FSCalendarStandardSelectionColor.cgColor)
        drawContext.saveGState()
        drawContext.setLineWidth(3.0)

        // Draw header's 1 top horizontal line
        drawContext.move(to: CGPoint(x: self.defaultOffset, y: self.defaultOffset + self.titleHeight))
        drawContext.addLine(to: CGPoint(x: pageRect.width - self.defaultOffset, y: self.defaultOffset + self.titleHeight))
        drawContext.strokePath()

        // Draw header's 1 bottom horizontal line
        drawContext.move(to: CGPoint(x: self.defaultOffset, y: self.defaultOffset * 3 + self.titleHeight))
        drawContext.addLine(to: CGPoint(x: pageRect.width - self.defaultOffset, y: self.defaultOffset * 3 + self.titleHeight))
        drawContext.strokePath()

        // Draw header's 3 vertical lines
        drawContext.setLineWidth(2.0)
        drawContext.saveGState()
        let tabWidth = (pageRect.width - self.defaultOffset * 2) / CGFloat(3)
        for verticalLineIndex in 0 ..< 4 {
            let tabX = CGFloat(verticalLineIndex) * tabWidth
            drawContext.move(to: CGPoint(x: tabX + self.defaultOffset, y: self.defaultOffset + self.titleHeight))
            drawContext.addLine(to: CGPoint(x: tabX + self.defaultOffset, y: self.defaultOffset * 3 + self.titleHeight))
            drawContext.strokePath()
        }

        drawContext.restoreGState()
    }

    func drawTableHeaderTitles(titles: [String], drawContext _: CGContext, pageRect: CGRect) {
        // prepare title attributes
        let textFont = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        let titleAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont,
        ]

        // draw titles
        let tabWidth = (pageRect.width - self.defaultOffset * 2) / CGFloat(3)
        for titleIndex in 0 ..< titles.count {
            let attributedTitle = NSAttributedString(string: titles[titleIndex].capitalized, attributes: titleAttributes)
            let tabX = CGFloat(titleIndex) * tabWidth
            let textRect = CGRect(x: tabX + self.defaultOffset,
                                  y: self.defaultOffset * 3 / 2 + self.titleHeight,
                                  width: tabWidth,
                                  height: self.defaultOffset * 3)
            attributedTitle.draw(in: textRect)
        }
    }

    func drawTableContentInnerBordersAndText(drawContext: CGContext, pageRect: CGRect, tableDataItems: [PDFTableDataItem]) {
        drawContext.setLineWidth(1.0)
        drawContext.saveGState()

        let defaultStartY = self.defaultOffset * 2

        for elementIndex in 0 ..< tableDataItems.count {
            let yPosition = CGFloat(elementIndex) * defaultStartY + defaultStartY + 20

            // Draw content's elements texts
            let textFont = UIFont.systemFont(ofSize: 18, weight: .regular)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            let textAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: textFont,
            ]
            let tabWidth = (pageRect.width - self.defaultOffset * 2) / CGFloat(3)
            for titleIndex in 0 ..< 3 {
                var attributedText = NSAttributedString(string: "", attributes: textAttributes)
                switch titleIndex {
                case 0: attributedText = NSAttributedString(string: tableDataItems[elementIndex].personName, attributes: textAttributes)
                case 1: attributedText = NSAttributedString(string: tableDataItems[elementIndex].attendanceNumber, attributes: textAttributes)
                case 2: attributedText = NSAttributedString(string: tableDataItems[elementIndex].admonishmentNumber, attributes: textAttributes)
                default:
                    break
                }
                let tabX = CGFloat(titleIndex) * tabWidth
                let textRect = CGRect(x: tabX + self.defaultOffset,
                                      y: yPosition + self.defaultOffset + self.titleHeight - 10,
                                      width: tabWidth,
                                      height: self.defaultOffset * 2)
                attributedText.draw(in: textRect)
            }

            // Draw content's 3 vertical lines
            for verticalLineIndex in 0 ..< 4 {
                let tabX = CGFloat(verticalLineIndex) * tabWidth
                drawContext.move(to: CGPoint(x: tabX + self.defaultOffset, y: yPosition + self.titleHeight))
                drawContext.addLine(to: CGPoint(x: tabX + self.defaultOffset, y: yPosition + defaultStartY + self.titleHeight))
                drawContext.strokePath()
            }

            // Draw content's element bottom horizontal line
            drawContext.move(to: CGPoint(x: self.defaultOffset, y: yPosition + defaultStartY + self.titleHeight))
            drawContext.addLine(to: CGPoint(x: pageRect.width - self.defaultOffset, y: yPosition + defaultStartY + self.titleHeight))
            drawContext.strokePath()
        }
        drawContext.restoreGState()
    }
}
