//
//  CustomMenu.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//


import SwiftUI

struct CustomMenu: View {
    let onAction: (MenuAction) -> Void
    @Binding var isPresented: Bool
    @State private var showingReportMenu = false
    
    var body: some View {
        ZStack {
            MainMenuView(
                onSend: handleSend,
                onReportTap: showReportMenu,
                offset: showingReportMenu ? -UIScreen.main.bounds.width : 0
            )
            
            ReportMenuView(
                onBack: hideReportMenu,
                onReasonSelect: handleReport,
                offset: showingReportMenu ? 0 : UIScreen.main.bounds.width
            )
        }
        .frame(
            width: MenuConfiguration.Layout.menuWidth,
            height: showingReportMenu ? 
                MenuConfiguration.Layout.reportMenuHeight : 
                MenuConfiguration.Layout.mainMenuHeight
        )
        .background(menuBackground)
    }
    
    private var menuBackground: some View {
        RoundedRectangle(cornerRadius: MenuConfiguration.Layout.cornerRadius)
            .fill(Color(.systemBackground))
            .shadow(radius: 5)
    }
    
    // MARK: - Action Handlers
    
    private func handleSend() {
        isPresented = false
        onAction(.send)
    }
    
    private func handleReport(_ reason: ReportReason) {
        isPresented = false
        onAction(.report(reason))
    }
    
    private func showReportMenu() {
        withAnimation(MenuConfiguration.Animation.spring) {
            showingReportMenu = true
        }
    }
    
    private func hideReportMenu() {
        withAnimation(MenuConfiguration.Animation.spring) {
            showingReportMenu = false
        }
    }
}