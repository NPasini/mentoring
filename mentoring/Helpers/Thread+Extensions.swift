//
//  Thread+Extensions.swift
//  mentoring
//
//  Created by Nicolò Pasini on 08/03/22.
//

import Foundation

extension Thread {

    static var currentThreadName: String {
        if Thread.isMainThread {
            return "main"
        } else {
            if let threadName = Thread.current.name, !threadName.isEmpty {
                return"\(threadName)"
            } else if let queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)), !queueName.isEmpty {
                return"\(queueName)"
            } else {
                return String(format: "%p", Thread.current)
            }
        }
    }

    static var currentThreadQos: String {
        String(describing: Thread.current.qualityOfService)
    }

    static func guaranteeMainThread(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}
