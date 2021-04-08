//
//  UIColor+ColorExtensions.swift
//  (This file was autogenerated by RMRHexColorGen, which parsed an input file of: AppColors.palette.
//  Do not modify as it can easily be overwritten.)

import UIKit

extension UIColor {

    //-------- Defined Colors with Provided Hex Values

    /// #36383C -  BreakingIT!   Testing some stuff here.
    static var app_myBlack: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.2117647081613541, green: 0.2196078449487686, blue: 0.2352941185235977, alpha: 1)
                } else {
                    return UIColor(red: 0.2117647081613541, green: 0.2196078449487686, blue: 0.2352941185235977, alpha: 1)
                }
            }
        } else {
            // Return a fallback color for iOS 12 and lower.  Uses Light Mode only. 
            return UIColor(red: 0.2117647081613541, green: 0.2196078449487686, blue: 0.2352941185235977, alpha: 1)
        }
    }()

    /// #3D78FE - Basic Blue for the app
    static var app_myBlue: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.1411764770746231, green: 0.4705882370471954, blue: 0.9960784316062927, alpha: 1)
                } else {
                    return UIColor(red: 0.239215686917305, green: 0.4705882370471954, blue: 0.9960784316062927, alpha: 1)
                }
            }
        } else {
            // Return a fallback color for iOS 12 and lower.  Uses Light Mode only. 
            return UIColor(red: 0.239215686917305, green: 0.4705882370471954, blue: 0.9960784316062927, alpha: 1)
        }
    }()

    /// #7C8089
    static var app_myGrey: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.4862745106220245, green: 0.501960813999176, blue: 0.5372549295425415, alpha: 1)
                } else {
                    return UIColor(red: 0.4862745106220245, green: 0.501960813999176, blue: 0.5372549295425415, alpha: 1)
                }
            }
        } else {
            // Return a fallback color for iOS 12 and lower.  Uses Light Mode only. 
            return UIColor(red: 0.4862745106220245, green: 0.501960813999176, blue: 0.5372549295425415, alpha: 1)
        }
    }()



    //-------- Color Aliases who are references to defined colors above:

    /// #3D78FE
    static var app_primaryAppColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.1411764770746231, green: 0.4705882370471954, blue: 0.9960784316062927, alpha: 1)
                } else {
                    return UIColor(red: 0.239215686917305, green: 0.4705882370471954, blue: 0.9960784316062927, alpha: 1)
                }
            }
        } else {
            // Return a fallback color for iOS 12 and lower.  Uses Light Mode only. 
            return UIColor(red: 0.239215686917305, green: 0.4705882370471954, blue: 0.9960784316062927, alpha: 1)
        }
    }()

    /// #36383C - BreakingIT! Testing some stuff here.
    static var app_primaryTextColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.2117647081613541, green: 0.2196078449487686, blue: 0.2352941185235977, alpha: 1)
                } else {
                    return UIColor(red: 0.2117647081613541, green: 0.2196078449487686, blue: 0.2352941185235977, alpha: 1)
                }
            }
        } else {
            // Return a fallback color for iOS 12 and lower.  Uses Light Mode only. 
            return UIColor(red: 0.2117647081613541, green: 0.2196078449487686, blue: 0.2352941185235977, alpha: 1)
        }
    }()

}
