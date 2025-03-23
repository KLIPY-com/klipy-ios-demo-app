//
//  AnimationCoordinator.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 23.03.25.
//


import SwiftUI

// Animation presets for consistent feel across the app
extension Animation {
  /// A smooth sheet animation with natural feel - slower and more elegant
  static var smoothSheet: Animation {
    .spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3)
  }
  
  /// Animation for dismissing the sheet - slightly faster
  static var dismissSheet: Animation {
    .spring(response: 0.4, dampingFraction: 0.65, blendDuration: 0.2)
  }
  
  /// Very subtle motion for small UI elements
  static var subtle: Animation {
    .spring(response: 0.35, dampingFraction: 0.8, blendDuration: 0.2)
  }
}

// Extension for view transitions with more polish
extension AnyTransition {
  /// A smooth slide transition for sheets
  static var smoothSlide: AnyTransition {
    .asymmetric(
      insertion: .offset(y: UIScreen.main.bounds.height).combined(with: .opacity),
      removal: .offset(y: UIScreen.main.bounds.height).combined(with: .opacity)
    )
  }
}

// Advanced animation coordinator to help with complex multi-part animations
class AnimationCoordinator: ObservableObject {
  @Published var stage: AnimationStage = .initial
  
  enum AnimationStage {
    case initial
    case contentMoving
    case sheetAppearing
    case complete
    case dismissing
  }
  
  func presentSheet() {
    // Sequence the animation for smoother feel
    withAnimation(.smoothSheet) {
      stage = .contentMoving
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
      withAnimation(.smoothSheet) {
        self.stage = .sheetAppearing
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        withAnimation(.subtle) {
          self.stage = .complete
        }
      }
    }
  }
  
  func dismissSheet() {
    withAnimation(.dismissSheet) {
      stage = .dismissing
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      withAnimation(.subtle) {
        self.stage = .initial
      }
    }
  }
}
