# Backend Architecture and Operations Document

## 1. Document Control
- System: Red2Green Backend Services
- Scope: Firebase, Firestore domain logic, media pipeline, and operational controls
- Last reviewed: 2026-03-20
- Primary owner: Platform Engineering
- Supporting owners: Security, SRE, Mobile Engineering

## 2. Architecture Summary
Current backend is serverless and client-orchestrated:
- Identity: Firebase Authentication
- Data store: Cloud Firestore
- Media store and CDN: Cloudinary
- Realtime transport: Firestore snapshots

Declared but not used in active flows:
- Cloud Functions dependency in pubspec
- Firebase Messaging dependency in pubspec

## 3. Backend Service Boundary in Client Code
Backend-facing adapters:
- lib/services/auth_service.dart
- lib/services/database_service.dart
- lib/services/cloudinary_service.dart

Boundary contract:
- Frontend UI cannot directly mutate backend state outside service abstractions.
- Service layer owns request shape, persistence order, and error mapping.

## 4. Identity and Access Model
Identity source:
- Firebase Auth UID

Role source:
- users collection role field in Firestore

Roles used by product flows:
- public
- volunteer
- ngo

Authorization principle:
- UI role checks improve UX only.
- Firestore security rules must enforce final authorization in production.

## 5. Domain Workflows

### 5.1 Report Issue
1. Client uploads image to media layer.
2. Client captures location.
3. Client writes new issues document.
4. Feed subscribers receive new issue in realtime.

### 5.2 Claim Issue
1. Validate issue exists and is claimable.
2. Create event document.
3. Create chat room document.
4. Link event and chat room references.
5. Update issue to claimed with foreign pointers.
6. Write system welcome message.

### 5.3 Join Event
1. Add user to events participants array.
2. Add user to chat room participants array.
3. Write system message to chat timeline.

### 5.4 Resolve Issue
1. Upload one or more proof images.
2. Validate NGO authorization for claim ownership.
3. Update issue status to resolved and set resolved metadata.

## 6. Data Consistency and Transactional Requirements
Current concern:
- Claim and unclaim are multi-document operations without atomic transaction guarantees.

Production requirement:
- Use Firestore transaction or batched write for all linked mutations in claim and unclaim paths.
- Apply idempotency guard for retries.

Minimum consistency guarantees:
- No issue points to missing event or chat room after successful claim.
- No orphan chat room remains after successful unclaim.

## 7. Media Pipeline Requirements
Current implementation:
- Client computes Cloudinary signature and uploads directly.

Production requirement:
- Remove Cloudinary secret material from client binaries.
- Provide signed upload operation from trusted backend component.
- Enforce upload constraints:
  - File type allowlist.
  - File size threshold.
  - Per-user rate limits.

## 8. Security Controls
Mandatory controls for production readiness:
1. Firestore rules enforce role and ownership.
2. Event chat writes limited to participants.
3. Resolution and unclaim restricted to owning NGO.
4. PII and secrets excluded from logs and analytics payloads.
5. API keys and signing secrets stored in managed secret service.

## 9. SLOs and Error Budget
Suggested baseline service objectives:
- Auth success availability: 99.9 percent monthly.
- Read freshness for feed and chat: under 3 seconds p95.
- Issue claim write success: 99.5 percent monthly.
- Message send success: 99.5 percent monthly.

Operational policy:
- Error budget exhaustion triggers release freeze for backend-affecting features.

## 10. Observability and Diagnostics
Required signals:
- Structured application events for issue lifecycle transitions.
- Failure counters by operation type.
- Latency histograms for upload, claim, join, resolve, and message send.
- Correlation ID propagation for multi-step workflow diagnostics.

Required dashboards:
- Realtime write failures by collection.
- Auth failures by provider.
- Media upload failure and timeout rates.

## 11. Incident Response Expectations
Severity model:
- Sev1: Complete auth failure, data corruption, or widespread write failure.
- Sev2: High error rates in claim or chat workflows.
- Sev3: Non-blocking backend degradation.

Runbook minimums:
1. Triage ownership and handoff chain.
2. Rollback and mitigation options.
3. Communication template for user impact.
4. Post-incident corrective actions with owner and due date.

## 12. Deployment and Change Management
Required controls:
- Rule changes reviewed by security and platform owner.
- Staged rollout for risky backend-affecting client releases.
- Backward-compatible schema changes before client rollout.
- Versioned migration notes for data model changes.

## 13. Current Gaps to Close Before Production
1. Remove Cloudinary secrets from client code.
2. Add Firestore rule set for role and ownership enforcement.
3. Add transactional claim and unclaim implementation.
4. Maintain chat room last message denormalized fields.
5. Add observability instrumentation and alerting.


