import Combine
import SwiftUI
import StoreKit
import UIKit

final class RateManager {
    static let shared = RateManager()

    private let launchesKey = "rate.launches.count"
    private let playsKey = "rate.plays.count"
    private let lastRequestKey = "rate.last.request"

    private let minLaunches = 4
    private let minPlays = 6
    private let minDaysBetweenRequests = 7

    private init() {
        registerLaunch()
    }

    private var launches: Int {
        get { UserDefaults.standard.integer(forKey: launchesKey) }
        set { UserDefaults.standard.set(newValue, forKey: launchesKey) }
    }

    private var plays: Int {
        get { UserDefaults.standard.integer(forKey: playsKey) }
        set { UserDefaults.standard.set(newValue, forKey: playsKey) }
    }

    private var lastRequestDate: Date? {
        get {
            guard let value = UserDefaults.standard.object(forKey: lastRequestKey) as? TimeInterval else {
                return nil
            }
            return Date(timeIntervalSince1970: value)
        }
        set {
            if let date = newValue {
                UserDefaults.standard.set(date.timeIntervalSince1970, forKey: lastRequestKey)
            } else {
                UserDefaults.standard.removeObject(forKey: lastRequestKey)
            }
        }
    }

    func registerLaunch() {
        launches += 1
    }

    func registerPlaySession() {
        plays += 1
        evaluateIfNeeded()
    }

    func askFromButton() {
        requestReview(force: true)
    }

    private func evaluateIfNeeded() {
        guard launches >= minLaunches, plays >= minPlays else { return }

        if let last = lastRequestDate {
            let days = Calendar.current.dateComponents([.day], from: last, to: Date()).day ?? 0
            guard days >= minDaysBetweenRequests else { return }
        }

        requestReview(force: false)
    }

    private func requestReview(force: Bool) {
        DispatchQueue.main.async {
            guard let scene = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) else {
                    return
                }

            if force {
                SKStoreReviewController.requestReview(in: scene)
                self.lastRequestDate = Date()
                return
            }

            SKStoreReviewController.requestReview(in: scene)
            self.lastRequestDate = Date()
        }
    }
}
