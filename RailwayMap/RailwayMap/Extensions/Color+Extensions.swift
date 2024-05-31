//
//  Color+Extensions.swift
//  RailwayMap
//
//  Created by Lukasz on 25/05/2024.
//
// https://medium.com/ios-os-x-development/ios-extend-uicolor-with-custom-colors-93366ae148e6

import SwiftUI

extension Color {
    init(withHex: Int) {
        self.init(red: Double((withHex >> 16) & 0xff) / 255.0,
                  green: Double((withHex >> 8) & 0xff) / 255.0,
                  blue: Double(withHex & 0xff) / 255.0)
    }
    
    struct FlatColor {
        struct Blue {
            static let PictonBlue = Color(withHex: 0x5CADCF)
            static let Mariner = Color(withHex: 0x3585C5)
            static let CuriousBlue = Color(withHex: 0x4590B6)
            static let Denim = Color(withHex: 0x2F6CAD)
            static let Chambray = Color(withHex: 0x485675)
            static let BlueWhale = Color(withHex: 0x29334D)
        }

        struct Green {
            static let Fern = Color(withHex: 0x6ABB72)
            static let MountainMeadow = Color(withHex: 0x3ABB9D)
            static let ChateauGreen = Color(withHex: 0x4DA664)
            static let PersianGreen = Color(withHex: 0x2CA786)
        }
        
        struct Violet {
            static let Wisteria = Color(withHex: 0x9069B5)
            static let BlueGem = Color(withHex: 0x533D7F)
        }
        
        struct Yellow {
            static let Energy = Color(withHex: 0xF2D46F)
            static let Turbo = Color(withHex: 0xF7C23E)
        }
        
        struct Orange {
            static let NeonCarrot = Color(withHex: 0xF79E3D)
            static let Sun = Color(withHex: 0xEE7841)
        }
        
        struct Red {
            static let TerraCotta = Color(withHex: 0xE66B5B)
            static let Valencia = Color(withHex: 0xCC4846)
            static let Cinnabar = Color(withHex: 0xDC5047)
            static let WellRead = Color(withHex: 0xB33234)
        }
    
        struct Gray {
            static let AlmondFrost = Color(withHex: 0xA28F85)
            static let WhiteSmoke = Color(withHex: 0xEFEFEF)
            static let Iron = Color(withHex: 0xD1D5D8)
            static let IronGray = Color(withHex: 0x75706B)
        }
    }
    
    static let tracksRailways = Color.FlatColor.Blue.Denim
    static let tracksLightRailways = Color.FlatColor.Green.MountainMeadow
    static let tracksNarrowGauge = Color.FlatColor.Blue.PictonBlue
    static let tracksSubways = Color.FlatColor.Red.Cinnabar
    static let tracksTramways = Color.FlatColor.Violet.BlueGem
    static let tracksDisused = Color.FlatColor.Yellow.Turbo
    
    static let stationRailway = Color.FlatColor.Red.Cinnabar
    static let stationLightRailway = Color.FlatColor.Red.WellRead
    static let stationSubway = Color.FlatColor.Violet.Wisteria
    static let stationTram = Color.FlatColor.Orange.NeonCarrot
}
