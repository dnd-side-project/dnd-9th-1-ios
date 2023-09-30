//
//  NetworkMonitor.swift
//  Milestone
//
//  Created by 서은수 on 2023/09/28.
//

import Foundation

import Network
import RxRelay

// MARK: - 네트워크 연결을 모니터링

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected = BehaviorRelay<Bool>(value: false)
    public private(set) var connectionType: ConnectionType = .unknown
    
    /// 연결 타입
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        Logger.debugDescription("init 호출")
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        Logger.debugDescription("startMonitoring 호출")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            Logger.debugDescription("path :\(path)")
            
            self?.isConnected.accept(path.status == .satisfied)
            self?.getConenctionType(path)
            
            if self?.isConnected.value == true {
                Logger.debugDescription("연결됨")
            } else {
                Logger.debugDescription("연결 끊김")
                
            }
        }
    }
    
    public func stopMonitoring() {
        Logger.debugDescription("stopMonitoring 호출")
        monitor.cancel()
    }
    
    private func getConenctionType(_ path: NWPath) {
        Logger.debugDescription("getConenctionType 호출")
        
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
            Logger.debugDescription("wifi에 연결")
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
            Logger.debugDescription("cellular에 연결")
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
            Logger.debugDescription("wiredEthernet에 연결")
        } else {
            connectionType = .unknown
            Logger.debugDescription("unknown ..")
        }
    }
}
