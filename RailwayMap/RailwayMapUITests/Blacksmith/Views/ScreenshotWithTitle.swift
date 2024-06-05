//
//  ScreenshotWithTitle.swift
//  Blacksmith
//
//  Created by Florian Schweizer on 03.01.22.
//

import SwiftUI

public struct ScreenshotWithTitle: View, CapturingView {
    public let title: String
    public let image: Image
    public let background: ImageBackground
    public let exportSize: ExportSize
    public let alignment: TitleAlignment
    public let font: Font
    public let foregroundColor: Color
    private let screenshotImageScale: Double
    private let frameImageScale: Double
    
    public init(
        title: String,
        image: Image,
        background: ImageBackground,
        exportSize: ExportSize,
        alignment: TitleAlignment = .titleAbove,
        font: Font = .system(size: 70, weight: .regular, design: .rounded),
        foregroundColor: Color = .primary
    ) {
        self.title = title
        self.image = image
        self.screenshotImageScale = exportSize == .iPhone_6_7_Inches ? 0.72
        : exportSize == .iPhone_6_5_Inches ? 0.80
                                    : exportSize == .iPadPro_12_9_Inches ? 0.755 : 1
        
        self.frameImageScale = exportSize == .iPhone_6_7_Inches ? 0.715 * 1.17
                               : exportSize == .iPhone_6_5_Inches ? 0.715 * 1.17
                               : exportSize == .iPadPro_12_9_Inches ? 0.715 * 1.17 : 1
        
        self.background = background
        self.exportSize = exportSize
        self.alignment = alignment
        self.font = font
        self.foregroundColor = foregroundColor
    }
    
    public var body: some View {
        ZStack {
            switch background {
            case .color(let color):
                color
                
            case .gradient(let linearGradient):
                linearGradient
                
            case .image(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: exportSize.size.width, height: exportSize.size.height)
                    .clipped()
                
            case .deviceFrame(let color):
                color
            }
            
            VStack {
                Spacer()
                
                if case .titleAbove = alignment {
                    if self.title.count > 0 {
                        VStack {
                            Spacer()
                            Text(title)
                                .font(font)
                                .padding(.top, 35)
                                .foregroundColor(foregroundColor)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                
                            Spacer()
                        }
                        .frame(width: exportSize.size.width, height: 290)
                    }
                }
                
                ZStack {
                    image
                        .resizable()
                        
                        .cornerRadius(exportSize.cornerRadius)
                        .scaledToFit()
                        .scaleEffect(CGSize(width: screenshotImageScale, height: screenshotImageScale))
                        .padding()
                    
                    if case .deviceFrame(_) = background {

                        if let backgroundImage = UIImage(named: exportSize == ExportSize.iPhone_6_7_Inches ? "frame_iPhone15ProMax"
                                                         : exportSize == ExportSize.iPhone_6_5_Inches ? "frame_iPhone11ProMax"
                                                         : exportSize == ExportSize.iPadPro_12_9_Inches ? "frame_iPadPro" : "",
                                                         in: Bundle(for: RailwayMapUITests.self), compatibleWith: nil)
                        {
                            Image(uiImage: backgroundImage)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(CGSize(width: frameImageScale, height: frameImageScale /* 0.955*/))
                        }
                    }
                }
                
//                if case .titleBelow = alignment {
//                    if self.title.count > 0 {
//                        Spacer()
//                        
//                        Text(title)
//                            .font(font)
//                            .padding(.bottom)
//                            .foregroundColor(foregroundColor)
//                    }
//                }
            }
            .padding()
        }
        .frame(width: exportSize.size.width, height: exportSize.size.height)
    }
}

#Preview {
    ScreenshotWithTitle(title: "Sample title",
                        image: Image(uiImage: UIImage(named: "screenshot_pl0_iPhone11ProMax")!),
                        background: .deviceFrame(Color.init(withHex: 0xF7F3E6)),
                        exportSize: .iPhone_6_5_Inches)
}
