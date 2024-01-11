//
//  Streetcode_com_uaApp.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

private struct DIContainerKey: EnvironmentKey {
  typealias Value = DIContainerable

  static var defaultValue: Value = DIContainer()
}

extension EnvironmentValues {
  var diContainer: DIContainerable {
    get { self[DIContainerKey.self] }
    set { self[DIContainerKey.self] = newValue }
  }
}

@main
struct StreetcodeComUaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
          CatalogView(viewmodel: CatalogVM(container: appDelegate.container))
//            .environment(\.diContainer, appDelegate.container)
        }
    }
}
