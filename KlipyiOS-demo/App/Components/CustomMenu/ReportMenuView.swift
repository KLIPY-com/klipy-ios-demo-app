//
//  ReportMenuView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//


import SwiftUI

struct ReportMenuView: View {
    let onBack: () -> Void
    let onReasonSelect: (ReportReason) -> Void
    let offset: CGFloat
    
    var body: some View {
        VStack(spacing: MenuConfiguration.Layout.itemSpacing) {
            BackButton(action: onBack)
            
            Divider()
            
            reasonsList
        }
        .offset(x: offset)
        .animation(MenuConfiguration.Animation.spring, value: offset)
    }
    
    private var reasonsList: some View {
        ForEach(ReportReason.allCases, id: \.self) { reason in
            VStack(spacing: 0) {
                MenuButton(
                    icon: reason.icon,
                    title: reason.rawValue,
                    action: { onReasonSelect(reason) }
                )
                
                if reason != ReportReason.allCases.last {
                    Divider()
                }
            }
        }
    }
}