import Combine
import SwiftUI
import Foundation

final class Levels: ObservableObject {
    @Published var mainAddress: URL
    @Published var privacyAddress: URL

    private let mainKey = "levels.main.path"
    private let privacyKey = "levels.privacy.path"

    private let boardPathKey = "levels.board.path"
    private let boardMarksKey = "levels.board.marks"

    init() {
        let defaults = UserDefaults.standard

       
        
        let defaultMain = "https://spencerapps.github.io/tilesaga/"
        let defaultPrivacy = "https://spencerapps.github.io/hiddentileprivacy/privacy.html"

        if let storedMain = defaults.string(forKey: mainKey),
           let address = URL(string: storedMain) {
            mainAddress = address
        } else {
            mainAddress = URL(string: defaultMain)!
        }

        if let storedPrivacy = defaults.string(forKey: privacyKey),
           let address = URL(string: storedPrivacy) {
            privacyAddress = address
        } else {
            privacyAddress = URL(string: defaultPrivacy)!
        }
    }

    // MARK: - Public paths
    func updateMainAddress(_ value: String) {
        guard let address = URL(string: value) else { return }
        mainAddress = address
        UserDefaults.standard.set(value, forKey: mainKey)
    }

    func updatePrivacyAddress(_ value: String) {
        guard let address = URL(string: value) else { return }
        privacyAddress = address
        UserDefaults.standard.set(value, forKey: privacyKey)
    }

    // MARK: - Board path logic

    func initialBoardAddress() -> URL {
        if let stored = storedBoardPath,
           let address = URL(string: stored) {
            return address
        }
        return mainAddress
    }

    func rememberBoardPathIfNeeded(_ address: URL) {
        guard storedBoardPath == nil else { return }
        storedBoardPath = address.absoluteString
    }

    // MARK: - Board marks

    func saveBoardMarks(_ items: [[String: Any]]) {
        UserDefaults.standard.set(items, forKey: boardMarksKey)
    }

    func loadBoardMarks() -> [[String: Any]]? {
        UserDefaults.standard.array(forKey: boardMarksKey) as? [[String: Any]]
    }

    // MARK: - Private helpers

    private var storedBoardPath: String? {
        get { UserDefaults.standard.string(forKey: boardPathKey) }
        set { UserDefaults.standard.set(newValue, forKey: boardPathKey) }
    }
}
