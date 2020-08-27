//
//  ViewController.swift
//  StateMachineDemo
//
//  Created by 王自鹏 on 2020/8/27.
//  Copyright © 2020 王自鹏. All rights reserved.
//

import UIKit

// 人的状态
enum ManState: StateType {
    case idle   // 空闲
    case work   // 工作
    case play   // 玩耍
}

// 人的动作
enum ManEvent: EventType {
    case goToWork   // 去上班
    case goToPlay   // 去玩
    case busyEnd    // 忙完了（一切工作、娱乐结束）
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // 初始化状态机，默认空闲状态
        let stateMachine = StateMachine<ManState, ManEvent>(.idle)

        // 注册忙结束事件（可以从工作、玩耍状态转换到空闲状态）
        stateMachine.listen(.busyEnd, transit: .play, .work, to: .idle) { transition in
            print("躺着了：\(transition.desc)")
        }

        // 注册去上班事件（可以从空闲、玩耍转换到空闲状态）
        stateMachine.listen(.goToWork, transit: .idle, .play, to: .work) { transition in
            print("上班了：\(transition.desc)")
        }

        // 注册去玩耍事件（只可以从空闲状态转换到玩耍状态）
        stateMachine.listen(.goToPlay, transit: .idle, to: .play) { transition in
            print("玩耍中：\(transition.desc)")
        }

        do {
            // 不可以转换成功，从空闲到空闲（不能在相同状态下转换）
            try stateMachine.trigger(.busyEnd)
        } catch {
            print(error.localizedDescription)
        }

        do {
            // 可以转换成功，从空闲去上班
            try stateMachine.trigger(.goToWork)
        } catch {
            print(error.localizedDescription)
        }

        do {
            // 可以转换成功，从工作到空闲
            try stateMachine.trigger(.busyEnd)
        } catch {
            print(error.localizedDescription)
        }

        do {
            // 可以转换成功，从空闲到工作
            try stateMachine.trigger(.goToWork)
        } catch {
            print(error.localizedDescription)
        }

        do {
            // 不可以转换成功，不能在上班到过程中去玩耍
            try stateMachine.trigger(.goToPlay)
        } catch {
            print(error.localizedDescription)
        }
    }
}
