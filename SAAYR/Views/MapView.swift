import SwiftUI
import MapKit
import Combine

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    @State private var merchants: [MerchantLocation] = MerchantLocation.demo()
    @State private var selectedMerchant: MerchantLocation?
    @State private var isCheckingIn = false
    @State private var elapsedTime = 0
    @State private var progress: Double = 0

    let checkInDuration = 120
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: Computed
    var merchantsWithDistanceArray: [MerchantWithDistance] {
        merchants.enumerated().map { index, merchant in
            let distance = index < 2 ? 50.0 : Double(index + 1) * 500.0
            return MerchantWithDistance(merchant: merchant, distance: distance)
        }
    }

    var body: some View {
        ZStack {
            // MARK: Map
            Map(coordinateRegion: $region, annotationItems: merchantsWithDistanceArray) { item in
                MapAnnotation(coordinate: item.merchant.coordinate) {
                    MerchantMarkerView(
                        merchant: item.merchant,
                        isInRange: item.distance <= 100,
                        isActive: item.merchant.id == selectedMerchant?.id && isCheckingIn
                    )
                    .onTapGesture {
                        withAnimation {
                            selectedMerchant = item.merchant
                        }
                    }
                }
            }
            .ignoresSafeArea()

            // MARK: Top Header
            VStack {
                HeaderCard(nearbyCount: merchantsWithDistanceArray.filter { $0.distance <= 100 }.count)
                Spacer()
            }

            // MARK: Check-In Progress
            if isCheckingIn, let merchant = selectedMerchant {
                CheckInProgressCard(
                    merchant: merchant,
                    progress: progress,
                    remaining: checkInDuration - elapsedTime
                ) {
                    resetCheckIn()
                }
            }

            // MARK: Bottom Check-In CTA
            if !isCheckingIn, let merchant = selectedMerchant ?? merchantsWithDistanceArray.first(where: { $0.distance <= 100 })?.merchant {
                BottomCheckInCard(merchant: merchant) {
                    startCheckIn(merchant)
                }
            }
        }
        .onReceive(timer) { _ in
            guard isCheckingIn else { return }

            elapsedTime += 1
            progress = Double(elapsedTime) / Double(checkInDuration)

            if elapsedTime >= checkInDuration {
                completeCheckIn()
            }
        }
    }

    // MARK: Actions
    private func startCheckIn(_ merchant: MerchantLocation) {
        withAnimation {
            selectedMerchant = merchant
            isCheckingIn = true
            elapsedTime = 0
            progress = 0
        }
    }

    private func resetCheckIn() {
        withAnimation {
            isCheckingIn = false
            selectedMerchant = nil
            elapsedTime = 0
            progress = 0
        }
    }

    private func completeCheckIn() {
        resetCheckIn()
    }
}



struct HeaderCard: View {
    let nearbyCount: Int

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 40, height: 40)
                
                Image(systemName: "map")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Map")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                Text(nearbyCount > 0 ?
                     "\(nearbyCount) merchant\(nearbyCount > 1 ? "s" : "") nearby" :
                     "No merchants nearby")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}


struct MerchantMarkerView: View {
    let merchant: MerchantLocation
    let isInRange: Bool
    let isActive: Bool

    @State private var pulse = false

    var body: some View {
        ZStack {
            if isInRange && !isActive {
                Circle()
                    .fill(Color.green.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .scaleEffect(pulse ? 1.6 : 1)
                    .opacity(pulse ? 0 : 0.6)
                    .animation(
                        .easeOut(duration: 2).repeatForever(autoreverses: false),
                        value: pulse
                    )
            }

            RoundedRectangle(cornerRadius: 14)
                .fill(isActive ? Color.green : .white)
                .frame(width: 48, height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isInRange ? Color.green : Color.gray, lineWidth: 3)
                )
                .shadow(radius: 6)

            Text(merchant.emoji)
                .font(.system(size: 24))
        }
        .onAppear { pulse = true }
        .scaleEffect(isActive ? 1.15 : 1)
    }
}
struct CheckInProgressCard: View {
    let merchant: MerchantLocation
    let progress: Double
    let remaining: Int
    let onCancel: () -> Void

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                HStack {
                    Text(merchant.emoji)
                        .font(.largeTitle)

                    VStack(alignment: .leading) {
                        Text(merchant.name)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Checking in...")
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Spacer()
                }

                ProgressView(value: progress)
                    .progressViewStyle(
                        LinearProgressViewStyle(tint: .white)
                    )

                HStack {
                    Text("\(Int(progress * 100))%")
                    Spacer()
                    Text("\(remaining / 60):\(String(format: "%02d", remaining % 60))")
                }
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))

                Button("Cancel Check-in", action: onCancel)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.green)
            .cornerRadius(24)
            .padding()
            Spacer()
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
struct BottomCheckInCard: View {
    let merchant: MerchantLocation
    let onCheckIn: () -> Void

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    // Merchant Emoji
                    Text(merchant.emoji)
                        .font(.system(size: 48))

                    VStack(alignment: .leading, spacing: 4) {
                        // Merchant Name
                        HStack(spacing: 8) {
                            Text(merchant.name)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)

                            // Partner Badge
                            if merchant.category.lowercased() == "café" || merchant.category.lowercased() == "fast food" {
                                Text("Partner")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.green)
                                    )
                            }
                        }

                        // Category
                        Text(merchant.category)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)

                        // In-Range Indicator
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.green)
                            Text("In Range")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.green)
                        }
                    }

                    Spacer()
                }

                // Check-In Button
                Button(action: onCheckIn) {
                    HStack(spacing: 8) {
                        Image(systemName: "location.fill")
                        Text("Check In (+\(merchant.xpReward) XP)")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(Color.green)
                    .cornerRadius(16)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(24)
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}


struct MerchantLocation: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let emoji: String
    let xpReward: Int
    let coordinate: CLLocationCoordinate2D

    static func demo() -> [MerchantLocation] {
        [
            .init(name: "Starbucks", category: "Café", emoji: "☕", xpReward: 100,
                  coordinate: .init(latitude: 24.7136, longitude: 46.6753)),
            .init(name: "McDonald's", category: "Fast Food", emoji: "🍔", xpReward: 100,
                  coordinate: .init(latitude: 24.7150, longitude: 46.6760)),
            .init(name: "Dose Café", category: "Café", emoji: "☕", xpReward: 150,
                  coordinate: .init(latitude: 24.7140, longitude: 46.6770)),
            .init(name: "Al Baik", category: "Fast Food", emoji: "🍗", xpReward: 100,
                  coordinate: .init(latitude: 24.7160, longitude: 46.6780)),
            .init(name: "Extra Stores", category: "Shopping", emoji: "🏪", xpReward: 100,
                  coordinate: .init(latitude: 24.7170, longitude: 46.6790)),
            .init(name: "Jarir Bookstore", category: "Shopping", emoji: "📚", xpReward: 100,
                  coordinate: .init(latitude: 24.7180, longitude: 46.6800)),
            .init(name: "Dunkin' Donuts", category: "Café", emoji: "🍩", xpReward: 100,
                  coordinate: .init(latitude: 24.7190, longitude: 46.6810)),
            .init(name: "KFC", category: "Fast Food", emoji: "🍗", xpReward: 100,
                  coordinate: .init(latitude: 24.7200, longitude: 46.6820))
        ]
    }
}

struct MerchantWithDistance: Identifiable {
    let id = UUID()           // Make it Identifiable
    let merchant: MerchantLocation
    let distance: Double
}

#Preview {
    MapView()
        .environmentObject(LanguageManager())
        .environmentObject(UserManager())
}
