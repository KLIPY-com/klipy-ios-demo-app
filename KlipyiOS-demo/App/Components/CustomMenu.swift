//
//  to.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 21.01.25.
//


import SwiftUI

enum MenuAction {
  case send
  case report(ReportReason)
}

enum ReportReason: String, CaseIterable {
  case violence = "Violence"
  case pornography = "Pornography"
  case childAbuse = "Child Abuse"
  case copyright = "Copyright"
  case other = "Other"
}

struct CustomMenu: View {
  let onAction: (MenuAction) -> Void
  @Binding var isPresented: Bool
  @State private var showingReportMenu = false
  
  var body: some View {
    ZStack {
      mainMenu
        .offset(x: showingReportMenu ? -UIScreen.main.bounds.width : 0)
        .animation(.spring(duration: 0.3), value: showingReportMenu)

      reportMenu
        .offset(x: showingReportMenu ? 0 : UIScreen.main.bounds.width)
        .animation(.spring(duration: 0.3), value: showingReportMenu)
    }
    .frame(width: 200)
    .frame(height: showingReportMenu ? 300 : 100)
    .background(
      RoundedRectangle(cornerRadius: 14)
        .fill(Color(.systemBackground))
        .shadow(radius: 5)
    )
  }
  
  private var mainMenu: some View {
    VStack(spacing: 0) {
      // Send Button
      Button(action: {
        isPresented = false
        onAction(.send)
      }) {
        HStack {
          Image(systemName: "paperplane.fill")
          Text("Send")
          Spacer()
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
      }
      
      Divider()

      Button(action: {
        withAnimation {
          showingReportMenu = true
        }
      }) {
        HStack {
          Image(systemName: "exclamationmark.triangle.fill")
          Text("Report")
          Spacer()
          Image(systemName: "chevron.right")
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
      }
    }
  }
  
  private var reportMenu: some View {
    VStack(spacing: 0) {
      HStack {
        Button(action: {
          withAnimation {
            showingReportMenu = false
          }
        }) {
          HStack(spacing: 4) {
            Image(systemName: "chevron.left")
            Text("Back")
          }
          .foregroundColor(.blue)
          Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
      }
      
      Divider()

      ForEach(ReportReason.allCases, id: \.self) { reason in
        VStack(spacing: 0) {
          Button(action: {
            isPresented = false
            onAction(.report(reason))
          }) {
            HStack {
              Text(reason.rawValue)
                .foregroundColor(.primary)
              Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
          }
          
          if reason != ReportReason.allCases.last {
            Divider()
          }
        }
      }
    }
  }
}

// Example usage view
struct MenuExampleView: View {
  @State private var showingMenu = false
  
  var body: some View {
    Button("Show Menu") {
      showingMenu = true
    }
    .popover(isPresented: $showingMenu) {
      CustomMenu(onAction: handleMenuAction, isPresented: $showingMenu)
        .presentationCompactAdaptation(.popover)
    }
  }
  
  private func handleMenuAction(_ action: MenuAction) {
    switch action {
    case .send:
      print("Send action triggered")
    case .report(let reason):
      print("Report action triggered with reason: \(reason.rawValue)")
    }
  }
}

#Preview {
  MenuExampleView()
}
