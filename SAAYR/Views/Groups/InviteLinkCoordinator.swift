//
//  InviteLinkCoordinator.swift
//  SAAYR
//
//  Turns a shared invite link into an opened group.
//
//  A link is `https://saayr.sa/invite/<code>` — a universal link, so tapping
//  it anywhere on the phone comes straight here when the app is installed.
//  The same code also arrives as `saayr://invite/<code>`, which is what the
//  web landing page's "Open in app" button uses and what a simulator run can
//  be driven with before the domain serves its association file.
//
//  The code is single-use: redeeming it joins the group outright, with no
//  request to approve, so the only thing left to do afterwards is show the
//  player where they landed. Everything here is one-shot and sticky rather
//  than an event stream — a link can arrive while the app is cold, or while
//  the player is signed out, and the intent has to survive both.
//

import Combine
import Foundation

final class InviteLinkCoordinator: ObservableObject {

    /// The group a redeemed link landed in, held until a screen takes it.
    /// Sticky on purpose: the tab, the cover and the stack each have to see
    /// it, and none of them is guaranteed to be in the hierarchy at the
    /// moment the redeem returns.
    @Published var pendingGroup: GroupDetailDTO?

    /// Why the link didn't work, in the server's own words where it gave any.
    @Published var failure: String?

    @Published private(set) var isRedeeming = false

    /// Held while there is no one signed in to redeem as.
    private var pendingCode: String?
    /// The last code taken off a URL, so a link delivered twice — iOS hands a
    /// cold launch to both `onOpenURL` and the user-activity callback — is
    /// redeemed once.
    private var handledCode: String?

    private let scheme = "saayr"
    private let marker = "invite"

    // MARK: - Parsing

    /// The code out of an invite URL, or nil if this isn't one.
    ///
    /// The host is deliberately not checked. Which domains can reach the app
    /// is already decided by the associated-domains entitlement, and checking
    /// it again here would only mean a second place to edit when the domain
    /// changes.
    static func code(from url: URL) -> String? {
        var segments = url.pathComponents.filter { $0 != "/" }
        // A custom-scheme URL puts the first segment in the host:
        // `saayr://invite/ABC` is host `invite`, path `/ABC`.
        if url.scheme?.lowercased() == "saayr", let host = url.host, !host.isEmpty {
            segments.insert(host, at: 0)
        }
        guard let marker = segments.firstIndex(where: { $0.lowercased() == "invite" }),
              segments.index(after: marker) < segments.endIndex
        else { return nil }

        let code = segments[segments.index(after: marker)]
        let allowed = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")
        guard !code.isEmpty, code.count <= 128, code.allSatisfy(allowed.contains) else { return nil }
        return code
    }

    // MARK: - Intake

    /// Takes a URL the system delivered. Answers whether it was an invite, so
    /// the caller can leave anything else alone.
    @discardableResult
    func handle(_ url: URL, isAuthenticated: Bool, isEnglish: Bool) -> Bool {
        guard let code = Self.code(from: url) else { return false }
        guard code != handledCode else { return true }

        handledCode = code
        pendingCode = code
        failure = nil
        if isAuthenticated { redeemIfPending(isEnglish: isEnglish) }
        return true
    }

    /// Called again once there's a session. A link opened by a signed-out
    /// player waits here through the whole phone-number-and-OTP flow.
    func redeemIfPending(isEnglish: Bool) {
        guard let code = pendingCode, !isRedeeming else { return }
        isRedeeming = true

        GroupsAPI.shared.redeemInvite(code: code) { [weak self] result in
            guard let self else { return }
            isRedeeming = false
            switch result {
            case .success(let group):
                pendingCode = nil
                pendingGroup = group
            case .failure(let error):
                // A used, expired or revoked code is a dead end — there is no
                // retry that would help, so it is dropped rather than left to
                // fire again on the next sign-in. `handledCode` stays set so
                // re-tapping the same link doesn't re-run a call we know fails.
                pendingCode = nil
                failure = error.displayMessage(isEnglish: isEnglish)
            }
        }
    }

    /// Taken by the screen that acted on it.
    func consume() {
        pendingGroup = nil
    }

    func clearFailure() {
        failure = nil
        // The player has seen the message; let them try the link again if
        // they think it was a fluke.
        handledCode = nil
    }
}
