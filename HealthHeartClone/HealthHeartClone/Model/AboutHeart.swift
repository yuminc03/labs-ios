//
//  AboutHeart.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/26.
//

import Foundation

struct AboutHeart: Equatable {
  let title: String
  let articles: [Article]
  
  struct Article: Equatable {
    let imageName: String
    let title: String
    let contents: String
  }
  
  static let dummy: AboutHeart = .init(
    title: "심장에 관하여",
    articles: [
      .init(
        imageName: "digital_reality",
        title: "유산소 피트니스가 낮은 경우 무엇을 의미하는지 알아보기",
        contents: "이와 관련하여 할 수 있는 일에 대해서 알아봅시다."
      ),
      .init(
        imageName: "heart_rate",
        title: "유산소 피트니스에 관하여 더 알아보기",
        contents: "어떻게 측정되고, 왜 중요한지, 어떻게 향상시킬지에 대해 알아봅시다."
      ),
      .init(
        imageName: "heart_beat",
        title: "심방세동 부담에 관하여 알아보기",
        contents: "심방세동 부담의 개념 및 주의해야 하는 이유"
      )
    ]
  )
}
