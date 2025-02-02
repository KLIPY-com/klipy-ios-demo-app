//
//  MainMenuView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//


import SwiftUI

struct MainMenuView: View {
    let onSend: () -> Void
    let onReportTap: () -> Void
    let offset: CGFloat
    
    var body: some View {
        VStack(spacing: MenuConfiguration.Layout.itemSpacing) {
            MenuButton(
                icon: "paperplane.fill",
                title: "Send",
                action: onSend
            )
            
            Divider()
            
            MenuButton(
                icon: "exclamationmark.triangle.fill",
                title: "Report",
                trailingIcon: "chevron.right",
                action: onReportTap
            )
        }
        .offset(x: offset)
        .animation(MenuConfiguration.Animation.spring, value: offset)
    }
}