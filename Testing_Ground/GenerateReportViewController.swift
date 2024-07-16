////
////  GenerateReportViewController.swift
////  Testing_Ground
////
////  Created by Vivek Vangala on 2/18/24.
////
//
//import UIKit
//import PDFKit
//
//class GenerateReportViewController: UIViewController {
//    var selectedEntries: [ScoreViewController.SurveyEntry] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        print("GenerateReportViewController loaded. Number of selected entries: \(selectedEntries.count)")
//        generatePDFReport()
//    }
//
//    func generatePDFReport() {
//        print("Starting PDF generation...")
//        
//        let pdfMetaData = [
//            kCGPDFContextCreator as String: "Your App Name",
//            kCGPDFContextAuthor as String: "Author Name"
//        ]
//        let format = UIGraphicsPDFRendererFormat()
//        format.documentInfo = pdfMetaData
//
//        let pageWidth = 8.5 * 72.0  // 8.5 inches by 72 points/inch
//        let pageHeight = 11 * 72.0  // 11 inches by 72 points/inch
//        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
//
//        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
//
//        let data = renderer.pdfData { (context) in
//            context.beginPage()
//            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
//            print("PDF page context started...")
//
//            var yPos: CGFloat = 20.0
//            for entry in selectedEntries {
//                let text = "Sum: \(entry.sum) - Date: \(formatDate(entry.date))"
//                print("Drawing text for entry: \(text)")
//                let textRect = CGRect(x: 20, y: yPos, width: pageRect.width - 40, height: 20)
//                text.draw(in: textRect, withAttributes: attributes)
//                yPos += 20
//            }
//        }
//
//        if data.isEmpty {
//            print("PDF data is empty.")
//        } else {
//            print("PDF data generated successfully.")
//        }
//
//        // Load the PDF data directly into a PDFDocument
//        if let pdfDocument = PDFDocument(data: data) {
//            let pdfView = PDFView(frame: view.bounds)
//            pdfView.autoScales = true
//            pdfView.document = pdfDocument
//            view.addSubview(pdfView)
//            
//            pdfView.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//                pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//                pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//                pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//            ])
//            print("PDFView added to the view hierarchy.")
//        } else {
//            print("Failed to create PDFDocument from data.")
//        }
//    }
//
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        return formatter.string(from: date)
//    }
//}
