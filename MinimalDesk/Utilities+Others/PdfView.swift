//
//  PdfView.swift
//  MinimalDesk
//
//  Created by Tipu Sultan on 5/25/25.
//

import SwiftUI
import PDFKit

struct PDFViewerView: View {
    let pdfName: String
    
    var body: some View {
        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf"),
           let pdfDocument = PDFDocument(url: url) {
            PDFKitRepresentedView(pdfDocument: pdfDocument)
                .navigationTitle("Instructions")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            Text("Unable to load PDF.")
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let pdfDocument: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
