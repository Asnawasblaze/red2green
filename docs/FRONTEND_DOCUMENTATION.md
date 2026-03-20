# Frontend Architecture and Delivery Document

## 1. Document Control
- System: Red2Green Mobile Frontend
- Scope: Flutter client application in lib/
- Last reviewed: 2026-03-20
- Primary owner: Mobile Engineering
- Supporting owners: Product, QA, Security

## 2. Purpose
This document defines production expectations for the client application including architecture boundaries, module contracts, quality gates, release requirements, and operational readiness criteria.

## 3. Technology Baseline
- Framework: Flutter
- Language: Dart
- State management: Provider
- Data and identity: Firebase SDKs
- Mapping: flutter_map
- Media acquisition: image_picker
- Location: geolocator

## 4. Runtime Entry and Composition
Bootstrap path:
- lib/main.dart

Startup sequence:
1. Flutter bindings initialization.
2. Firebase app initialization from lib/firebase_options.dart.
3. Provider graph creation for AuthProvider, IssueProvider, and ChatProvider.
4. Route guard via lib/screens/wrapper.dart.

Route guard outcomes:
- Authenticated user -> HomeScreen.
- Unauthenticated user -> GatewayScreen.

## 5. Navigation and Module Topology
Top-level navigation owner:
- lib/screens/home/home_screen.dart

Bottom navigation modules:
1. Watch module: issue feed and filtering.
2. Do module: map interaction and event actions.
3. Post module: issue reporting flow.
4. Message module: event chat and chat operations.
5. Profile module: identity and account actions.

Retention model:
- IndexedStack preserves state for Watch, Do, Message, Profile.
- Post is intentionally pushed as a separate route.

## 6. Feature Contracts

### 6.1 Authentication Module
Files:
- lib/screens/auth/gateway_screen.dart
- lib/screens/auth/login_screen.dart
- lib/screens/auth/register_screen.dart
- lib/screens/auth/ngo_register_screen.dart

Contract:
- Supports email and password flows.
- Supports Google sign-in via AuthProvider path.
- Persists role-bearing user profile state after registration.

### 6.2 Watch Module
Files:
- lib/screens/watch/watch_screen.dart
- lib/widgets/issue_card.dart
- lib/widgets/issue_detail_popup.dart

Contract:
- Renders realtime issue stream.
- Supports status filter states reported, claimed, resolved.
- Supports role-based action prompts from issue detail UI.

### 6.3 Do Map Module
Files:
- lib/screens/do_map/do_screen.dart
- lib/widgets/event_card_popup.dart

Contract:
- Displays geospatial markers from issue location fields.
- Supports claim, join, and open chat flows with role-aware controls.
- Handles location permission and service state transitions.

### 6.4 Post Module
Files:
- lib/screens/post/post_screen.dart

Contract:
- Requires title, description, category, severity, and image.
- Captures current device location before report creation.
- Uploads image and persists resulting URL in issue document.

### 6.5 Messaging Module
Files:
- lib/screens/message/message_screen.dart
- lib/screens/message/chat_room_screen.dart
- lib/screens/message/chat_settings_screen.dart
- lib/screens/resolve/resolve_issue_screen.dart
- lib/widgets/chat_bubble.dart

Contract:
- Lists chat rooms by participant membership.
- Streams message timeline in event room.
- Exposes NGO owner-only controls for rename, resolve, and unclaim.

### 6.6 Profile Module
Files:
- lib/screens/profile/profile_screen.dart

Contract:
- Displays user identity, role badge, and report summary.
- Supports sign-out and route reset.

## 7. State Management and Dependency Boundaries
Provider ownership:
- AuthProvider: authentication state, user profile hydration.
- IssueProvider: issue streams, filtering, issue write actions.
- ChatProvider: event stream and message send actions.

Boundary rule:
- UI layer depends on providers.
- Providers depend on services.
- Services own external IO and data mapping.

## 8. Security and Privacy Requirements for Frontend
- Do not embed long-lived secrets in client code.
- Do not trust frontend role checks for authorization enforcement.
- Restrict personally identifiable information in logs.
- Minimize local persistence of sensitive data.
- Ensure image metadata handling follows privacy policy.

Current gap requiring remediation:
- Cloudinary credentials are present in client code and must be removed for production release.

## 9. Non-Functional Requirements
Performance targets:
- Time to first meaningful screen after cold start: target less than 2.5 seconds on reference Android mid-tier device.
- Scroll performance in feed and chat: target 60 fps median.
- Image upload UX: visible progress state within 300 ms of submit.

Reliability targets:
- No crash loops on missing location permission.
- Offline or degraded network actions must show deterministic user feedback.

Accessibility targets:
- Minimum tap target size 44 dp.
- Contrast ratio compliance for primary text and controls.
- Screen text must remain readable under font scaling.

## 10. Observability Requirements
Minimum telemetry events:
- auth_login_success
- auth_login_failure
- issue_created
- issue_claimed
- issue_resolved
- event_joined
- chat_message_sent

Minimum error telemetry:
- Upload failures.
- Firestore write failures.
- Location permission and service failures.

Current state:
- Telemetry framework is not yet integrated and should be added before production release.

## 11. Test Strategy and Release Gates
Required test levels:
- Unit tests for providers and service adapters.
- Widget tests for authentication and report submission forms.
- Integration tests for issue claim to chat flow and resolve flow.

Release gate checklist:
1. Flutter analyze passes with zero new warnings for changed modules.
2. Core user journeys pass on Android and iOS smoke test matrix.
3. Security review completed for any auth or data flow changes.
4. Known issue log updated with severity and owner.

## 12. Known Risks and Mitigations
Risk:
- Chat preview staleness due to missing last message denormalization updates.

Mitigation:
- Update backend write path or trigger function to maintain lastMessage and lastMessageTime.

Risk:
- Placeholder controls not wired can create misleading affordances.

Mitigation:
- Hide or disable non-functional controls until implemented.

## 13. Frontend Ownership Map
- Authentication and onboarding: Auth and Identity workstream.
- Watch and Do modules: Civic Reporting workstream.
- Messaging and event coordination: Collaboration workstream.
- Shared theme and components: Design System workstream.


