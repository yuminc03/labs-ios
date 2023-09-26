//
//  HeartBeat.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/26.
//

import Foundation

struct HeartBeat: Equatable {
  let headerTitle: String
  let data: [Heart]
  
  struct Heart: Equatable {
    let title: String
    let measuredTime: String
    let heartBeatCount: Int
    let unit: String
  }
  static let dummy: [HeartBeat] = [
    .init(
      headerTitle: "오늘",
      data: [
        .init(title: "심박수", measuredTime: "오후 6:06", heartBeatCount: 135, unit: "BPM"),
        .init(title: "휴식기 심박수", measuredTime: "오후 5:12", heartBeatCount: 67, unit: "BPM"),
        .init(title: "심박 변이", measuredTime: "오후 4:13", heartBeatCount: 36, unit: "밀리초"),
        .init(title: "걷기 심박수 평균", measuredTime: "오전 7:29", heartBeatCount: 135, unit: "BPM")
      ]
    ),
    .init(
      headerTitle: "최근 7일",
      data: [
        .init(title: "유산소 피트니스", measuredTime: "어제", heartBeatCount: 0, unit: "30.1최대산소섭취량")
      ]
    ),
    .init(
      headerTitle: "최근 12개월",
      data: [
        .init(title: "심박수 회복", measuredTime: "2022년 12월", heartBeatCount: 27, unit: "BPM")
      ]
    )
  ]
}
