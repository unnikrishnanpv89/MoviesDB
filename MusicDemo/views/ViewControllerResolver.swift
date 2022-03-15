//
//  ViewControllerResolver.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/21.
//
import UIKit
import SwiftUI

final class ViewControllerResolver: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: ParentResolverViewController, context: Context) { }
    
    let onResolve: (UIViewController) -> Void
       
       init(onResolve: @escaping (UIViewController) -> Void) {
           self.onResolve = onResolve
       }
       
       func makeUIViewController(context: Context) -> ParentResolverViewController {
           ParentResolverViewController(onResolve: onResolve)
       }
}
class ParentResolverViewController: UIViewController {
    
    let onResolve: (UIViewController) -> Void
        
        required init?(coder: NSCoder) {
            
        }
            
        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            
            if let parent = parent {
                onResolve(parent)
            }
        }
}
