//
// Created by 王自鹏 on 2020/8/27.
// Copyright (c) 2020 wzp. All rights reserved.
//

import Foundation
/// 状态
public protocol StateType: Hashable { }
// 事件
public protocol EventType: Hashable { }

/// 状态管理
public class StateMachine<S: StateType, E: EventType> {
    // 状态转换
    public struct Transition<S: StateType, E: EventType> {
        let event: E
        let fromState: S
        let toState: S

        public var desc: String {
            "StateMachine: transit success! from stat [\(fromState)] to state [\(toState)]"
        }

        init(event: E, fromState: S, toState: S) {
            self.event = event
            self.fromState = fromState
            self.toState = toState
        }

    }

    // 状态转换响应
    private struct Operation<S: StateType, E: EventType> {
        let transition: Transition<S, E>
        let handleClosure: ((Transition<S, E>) -> Void)?
    }

    // 当前状态
    private(set) var currentState: S
    // 事件记录集合
    private var handles: [S: [E: Operation<S, E>]] = [: ]

    public init(_ state: S) {
        currentState = state
    }

    // 添加一个状态转换记录
    private func listen(_ event: E, transit fromState: S, to toState: S, handleClosure: ((Transition<S, E>) -> Void)?) {
        var handle = handles[fromState] ?? [: ]
        let transition = Transition(event: event, fromState: fromState, toState: toState)
        let operation = Operation(transition: transition, handleClosure: handleClosure)
        handle[event] = operation
        handles[fromState] = handle
    }

    /// 监听【添加】状态转换
    /// - Parameters:
    ///   - event: 事件
    ///   - fromStates: 支持的转换前状态
    ///   - toState: 转换后状态
    ///   - handleClosure: 该转换成功时的回调
    public func listen(_ event: E, transit fromStates: S..., to toState: S, handleClosure: ((Transition<S, E>) -> Void)?) {
        fromStates.forEach { (fromState: S) in
            listen(event, transit: fromState, to: toState, handleClosure: handleClosure)
        }
    }

    /// 转换状态
    /// - Parameter event: 触发事件
    /// - Throws: 异常（未监听的事件组合会返回异常）
    public func trigger(_ event: E) throws {
        guard let handle = handles[currentState]?[event] else {
            // 当前状态不能响应该事件
            throw NSError(domain: "StateMachine: the current state [\(currentState)] can't respond the event [\(event)]，you can add the operation use func listen()", code: 400)
        }
        handle.handleClosure?(handle.transition)
        currentState = handle.transition.toState
    }
}
