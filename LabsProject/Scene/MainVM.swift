//
//  MainVM.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/23.
//

import Foundation

final class MainVM {
    
    let pageNames = [
        Page(
            category: "PRACTICE",
            childPages: [
                "Practise Then library",
                "WebView Test",
                "WebView Cookie Test"
            ]
        ),
        Page(
            category: "TEST",
            childPages: [
                "Todos"
            ]
        ),
        Page(
            category: "UIKIT + TCA - GETTING STARTED",
            childPages: [
                "Basics",
                "Combining reducers",
                "Bindings",
                "Form bindings",
                "Optional state",
                "Shared state",
                "Alerts and Confirmation Dialogs"
            ]
        ),
        Page(
            category: "UIKIT + TCA - EFFECTS",
            childPages: [
                "Basics",
                "Cancellation",
                "Long-living effects",
                "Refreshable",
                "Timers"
            ]
        ),
        Page(
            category: "UIKit + TCA - Case Studies",
            childPages: [
                "Lists",
                "Navigate and load",
                "Load then navigate"
            ]
        )
    ]
    var numberOfSection: Int {
        return pageNames.count
    }
    
    func numberOfRowsInSection(on section: Int) -> Int {
        return pageNames[section].childPages.count
    }
    
    func titleOfSection(section: Int) -> String {
        return pageNames[section].category
    }
    
    func titleOfGroup(section: Int) -> String {
        return pageNames[section].category
    }
    
    func titleOfPage(section: Int, index: Int) -> String {
        return pageNames[section].childPages[index]
    }
}
