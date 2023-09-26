//
//  MoreMemory.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/26.
//

import Foundation

struct MoreMemory: Equatable {
  let title: String
  let settings: [Setting]
  
  struct Setting: Equatable {
    let title: String
    let contents: String
  }
  
  static let dummy: MoreMemory = .init(
    title: "건강 앱에서 더 알아보기",
    settings: [
      .init(
        title: "심방세동 기록",
        contents: "심방세동이 있는 경우 심장이 불규칙적으로 뛰는 빈도를 파악하는 데 Apple Watch가 도움이 될 수 있습니다."
      ),
      .init(
        title: "Apple Watch에서 심전도 검사를 할 수 있습니다.",
        contents: "심전도 앱은 Apple Watch의 Digital Crown을 사용하여 사용자의 심장 박동을 기록하고 불규치간 심장 박동의 한 형태인 심방세동이 있는지 검사합니다."
      )
    ]
  )
}
