# 🔐 W-Secure

**W-Secure** is a hybrid project that combines mobile app-based safety features with AI-powered CCTV surveillance to enhance women's safety in public and private spaces.

---

## 📱 Mobile App Features

The **W-Secure Android App** is designed with discreet but powerful security tools to help women in distress:

- 🛰️ **Live Location Sharing**: Send real-time location updates to emergency contacts instantly.
- ☎️ **Quick Helpline Calling**: One-tap call to predefined emergency numbers.
- 🎥 **Stealth Video Recording**: Automatically records video in the background without opening the camera UI. The footage is stored on a secure cloud server to prevent tampering or deletion.
- 🗺️ **Safe Space Mapping**: View and mark nearby safe zones where help can be sought.
- 🆘 **SOS Mode**: Emergency trigger button that shares live location with trusted contacts and initiates other security protocols.
- 🔒 **Shutdown Protection**: Prevents unauthorized attempts to power off the phone during an emergency.

> 🔄 **Update in Progress**: Safe spots and police stations are now looked up live against the user's current position — safe spots from OpenStreetMap, police stations from Google Places. Deeper analysis of the surrounding area, using geofencing and real-time data, is still to come. See [Setup](#️-setup) for the API key this needs.

---

## 🧠 AI-Powered CCTV Monitoring (Backend Model)

The backend AI system is designed to integrate with CCTV feeds in public spaces and includes the following capabilities:

- 👥 **Suspicious Following Detection**:
  - Tracks individuals and identifies situations where one woman is being followed by a group of men.
  - Uses object detection and person tracking models to analyze motion patterns.

- ✋ **Distress Gesture Recognition**:
  - Recognizes gestures such as raised hands or rapid arm movements that may indicate distress.
  - Uses lightweight gesture recognition models based on MediaPipe or custom CNN-RNN architectures.

- 🚨 **Alert Triggering**:
  - When a threat is detected, the system can trigger automated alerts to local authorities or monitoring teams.

---

## 🧩 Tech Stack

### 📱 Mobile App:
- **Platform**: Flutter (Android)
- **Architecture**: Feature-based MVVM with Riverpod for state management and `go_router` for navigation
- **Backend**: Firebase (Firestore, Storage, Authentication)
- **APIs**: OpenStreetMap Overpass (safe spots), Google Places (police stations), MapTiler (map tiles), Geolocation Services
- **Cloud**: Firebase/Google Cloud for media storage

### 🧠 AI Models:
- **YOLOv8**: For real-time person detection.
- **ResNet-50**: For gender classification.
- **MediaPipe**: For gesture detection.
- **OpenCV & DeepSORT**: For multi-person tracking in CCTV feeds.

---

## ⚙️ Setup

Nearby lookups use two sources, chosen per category by which one actually has the data:

| Part | Source | Cost | Key needed |
|---|---|---|---|
| **Map background** (tiles) | [MapTiler](https://www.maptiler.com/) | free tier | yes |
| **Safe spots** | OpenStreetMap ([Overpass](https://wiki.openstreetmap.org/wiki/Overpass_API)) | free, unmetered | **no** |
| **Police stations** | Google [Places API (New)](https://developers.google.com/maps/documentation/places/web-service/nearby-search) | free tier, then paid | yes |

Overpass is OpenStreetMap's query API — it answers "what hospitals are within 10 km of this point". No account, no key, no billing. It supplies the place *data*; MapTiler supplies the map *picture*. They are unrelated.

OSM maps hospitals, pharmacies and malls well — a sample around Greater Noida found 29 within 10 km, the nearest 400 m away. Its coverage of Indian police stations is much weaker: the same sample put the nearest station 10 km out when one sits 2 km away. That is the one list where being wrong is dangerous, so it stays on Google.

Note that OSM's own tile server (`tile.openstreetmap.org`) is **not** an option for a published app — [OSMF policy](https://operations.osmfoundation.org/policies/tiles/) forbids it without prior permission.

**Safe spots work with no setup at all.** The map needs a MapTiler key for its background; without one it still shows markers and your location over a blank canvas, with a notice saying why.

### MapTiler key (map background)

Sign up at [maptiler.com](https://www.maptiler.com/), copy the key into `dart_defines.json` as `MAPTILER_API_KEY`. The free tier covers 100k map loads a month.

`MAPTILER_STYLE` picks the look (default `streets-v4`); any slug from MapTiler's style list works, e.g. `basic-v2` or `dataviz-light`.

### Google Places API key (police stations only)

1. In the [Google Cloud console](https://console.cloud.google.com/), create a project and **enable billing** — Maps Platform is pay-as-you-go and rejects requests from projects with no billing account attached.
2. Enable **Places API (New)** for that project.
3. Create an API key and restrict it to Places API (New).
4. **Cap the quota** under *APIs & Services → Quotas* so overage is impossible rather than merely unlikely.
5. Copy the template and paste your key into it:

   ```bash
   cp dart_defines.example.json dart_defines.json
   ```

6. Run or build with it:

   ```bash
   flutter run --dart-define-from-file=dart_defines.json
   flutter build apk --dart-define-from-file=dart_defines.json
   ```

`dart_defines.json` is git-ignored — the key is never committed. Without one, the police screen shows "Google Maps API key is missing" and offers a retry; everything else is unaffected.

### What it costs

Google's free allowance is **5,000 Pro-tier calls a month**. Two things keep usage far below that:

- **Results are cached on disk** and reused until the user moves more than **1 km** from where the lookup ran (`CachedPlaces.reuseRadiusMeters`). A cold start at home costs nothing after the first run. Pull to refresh always re-queries.
- **Distances are recomputed from the current position** even on a cache hit, so the list stays accurate inside that radius.

A typical user costs a handful of calls a month. There is no expiry, so a station that opens or closes is only picked up when the user moves 1 km or pulls to refresh — add a `fetchedAt` check in `CachedPlaces` if you want one.

The field mask in [`places_service.dart`](lib/core/services/places_service.dart) requests **Pro**-tier fields only (name, address, location, types). Adding `places.nationalPhoneNumber` or `places.regularOpeningHours` moves *every* request to the Enterprise tier, whose free allowance is five times smaller. Check [current pricing](https://developers.google.com/maps/billing-and-pricing/pricing) before extending it.

### Overpass reliability and fair use

The public Overpass instances are free and keyless but run at capacity often — during development this one answered `502 at capacity` for over an hour straight — and they ask callers to back off rather than hammer them. Three things absorb that:

1. **Several instances.** `OVERPASS_BASE_URLS` is a comma-separated list tried in order; a busy instance is stepped over before the user sees anything.
2. **The disk cache.** Most screen opens never hit the network at all.
3. **Stale results beat an error.** If every instance is busy and a cached list exists, that list is shown rather than an error screen — someone who needs the nearest hospital is better served by yesterday's answer than by a retry button. Distances are recomputed from the current position, so anything too far away is visibly too far away.

Point it at a self-hosted or paid instance if this app ever sends real volume:

```bash
--dart-define=OVERPASS_BASE_URLS=https://your-overpass.example.com
```

OSM data is © OpenStreetMap contributors; the map carries the required attribution.

### Shipping the Google key

A Places key inside an installed APK can be extracted, and Android app restrictions do not apply to web-service calls like this one — such a key can only be left unrestricted. For a public release, put a proxy you control in front of Google, keep the key server-side, and point the app at the proxy:

```bash
--dart-define=PLACES_BASE_URL=https://your-proxy.example.com
```

Nothing above the HTTP client needs to change.

---

## 🧪 Testing

Unit tests cover the models, repositories, and view-models feature by feature
(`profile`, `alerts`, `police_stations`, `safe_spots`, `auth`, `home`), the
shared `core` utilities, and the network layer (Places, Overpass, and the
distance cache). Firebase, platform, and HTTP dependencies are replaced with
in-memory fakes, so the suite runs without any device or network:

```bash
flutter test
```

---

## 🚧 Current Work & Future Plans

- [x] Implement background video recording with stealth mode.
- [x] Enable live SOS location sharing.
- [x] Integrate Safe Space tagging on maps.
- [x] Add unit tests across features (models, repositories, view-models).
- [x] Look up safe spots and police stations live from the user's location (OpenStreetMap + Google Places).
- [ ] Make Safe Space detection more dynamic using clustering and live crowd data.
- [ ] Deploy AI model on edge devices/CCTV systems.
- [ ] Improve gesture recognition accuracy.
- [ ] Create centralized admin dashboard for authorities.


---

## 🤝 Contributing

We welcome contributions and collaborations from developers, researchers, and security experts. If you're passionate about using AI and tech for social good, feel free to open a pull request or reach out.

---

## 📫 Contact

- 📧 Email: [hi@mayank4352.me]
- 🧑‍💻 Developer: [Mayank Sharma]
- 🔗 LinkedIn: [[Mayank4352](https://www.linkedin.com/in/mayank4352/)]

---

## ⚠️ Disclaimer

This project is built with the intention of helping people and enhancing safety. The AI-based surveillance is intended for **authorized and ethical use only** and must comply with local data privacy laws and regulations.

---
