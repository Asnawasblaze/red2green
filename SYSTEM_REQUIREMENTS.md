# 1.3 SYSTEM SPECIFICATIONS

The system is adjusted for high-speed performance within the local confines of a mobile device, maintaining a balance with a seamless user experience. To achieve real-time issue reporting and geospatial visualization, it utilizes a cloud-synced architecture powered by Firebase and Cloudinary. 

The specifications below are required to ensure that the application runs efficiently without causing memory or processing bottlenecks:

## Hardware Requirements
- **Architecture**: 64-bit (ARMv8/arm64) for optimal performance and hardware-level security.
- **RAM**: Minimum 4 GB available to allocate the map tiles, location services, and image processing in real-time.
- **Camera**: Support for photo capturing with high-resolution sensors for detailed issue documentation.
- **GPS**: High-accuracy positioning support for precise geographical tagging of urban reports.

## Software Requirements
- **SDKs**: Flutter SDK v3.2.3 and Dart SDK v3.0.0+.
- **Primary Operating System**: Android 8.0 (Oreo) or higher (API Level 26+).
- **Cloud Infrastructure**: The system relies on Firebase Core for authentication, real-time database syncing, and serverless logic.

## Key Dependencies
- **flutter_map**: For local, high-performance geospatial rendering of issues.
- **cloudinary_flutter**: For optimized cloud-based image storage and transformation.
- **geolocator**: For real-time user location tracking and report validation.
- **provider**: For reactive state management to ensure seamless UI updates across components.

---

## Technical Specification Summary

| Category | Item | Specification |
|:---:|:---:|:---:|
| **Hardware** | Architecture | 64-bit ARMv8 / arm64 |
| | RAM | Minimum 4 GB |
| | Camera | High-resolution support |
| | Location | GPS / GNSS Positioning |
| **Software** | SDKs | Flutter v3.2.3, Dart v3.0.0+ |
| | OS | Android 8.0+ (API 26+) |
| | Backend | Firebase (Auth, Firestore, Cloud Functions) |
| **Dependencies** | Maps / GIS | flutter_map ^7.0.2 |
| | Cloud Storage | cloudinary_flutter ^1.3.0 |
| | Location | geolocator ^10.1.0 |
| | State Management | provider ^6.1.1 |
| **Infrastructure** | Database | Cloud Firestore (NoSQL) |
| | Media Delivery | Cloudinary CDN |
| | Notifications | Firebase Cloud Messaging (FCM) |
