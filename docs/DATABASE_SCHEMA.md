# Firestore Schema and Data Governance Document

## 1. Document Control
- Data platform: Cloud Firestore
- Scope: Production data model for Red2Green mobile workflows
- Last reviewed: 2026-03-20
- Primary owner: Data and Platform Engineering
- Supporting owners: Mobile Engineering, Security

## 2. Data Model Overview
Top-level collections:
- users
- issues
- events
- chat_rooms

Subcollections:
- chat_rooms/{chatRoomId}/messages

Design style:
- Document denormalization for read performance.
- Application-managed referential integrity.

## 3. Canonical Enumerations
Role enum values:
- public
- volunteer
- ngo

Issue status enum values:
- reported
- claimed
- resolved

Issue category enum values:
- garbage
- pothole
- drainage
- brokenProperty
- illegalPosters
- strayAnimals
- treeHazard
- waterLeakage

Severity enum values currently used by UI:
- Low
- Medium
- High

## 4. Collection Specifications

### 4.1 users
Path:
- users/{uid}

Primary key:
- uid from Firebase Auth

Fields:
- email: string, required
- displayName: string, required
- photoUrl: string, nullable
- role: string, required, enum Role
- isVerified: bool, required
- ngoUin: string, nullable
- ngoName: string, nullable
- phone: string, nullable
- fcmToken: string, nullable
- createdAt: timestamp, required
- stats: map, required

Validation constraints:
- role must be one of Role enum.
- ngoUin required when role is ngo.

### 4.2 issues
Path:
- issues/{issueId}

Primary key:
- Auto-generated issueId

Fields:
- reporterId: string, required
- reporterName: string, required
- reporterPhotoUrl: string, nullable
- location: geopoint, required
- photoUrl: string, required
- category: string, required, enum IssueCategory
- severity: string, required, enum Severity
- title: string, required
- description: string, required
- status: string, required, enum IssueStatus
- claimedByNgoId: string, nullable
- claimedByNgoName: string, nullable
- eventId: string, nullable
- chatRoomId: string, nullable
- createdAt: timestamp, required
- resolvedAt: timestamp, nullable
- resolvedImages: array<string>, required default empty
- isAnonymous: bool, required
- likes: array<string>, required default empty
- commentCount: int, required default zero

Validation constraints:
- resolvedAt and resolvedImages must be present only when status is resolved.
- claimedByNgoId required when status is claimed or resolved.

### 4.3 events
Path:
- events/{eventId}

Primary key:
- Auto-generated eventId

Fields:
- issueId: string, required
- ngoId: string, required
- ngoName: string, required
- chatRoomId: string, nullable
- scheduledTime: timestamp, nullable
- meetingPoint: string, nullable
- participants: array<string>, required
- isActive: bool, required
- createdAt: timestamp, required

Validation constraints:
- participants must include ngoId at creation.

### 4.4 chat_rooms
Path:
- chat_rooms/{chatRoomId}

Primary key:
- Auto-generated chatRoomId

Fields:
- eventId: string, required
- issueId: string, required
- ngoId: string, required
- ngoName: string, required
- title: string, required
- createdAt: timestamp, required
- participants: array<string>, required
- lastMessage: string, nullable
- lastMessageTime: timestamp, nullable

Validation constraints:
- participants must include ngoId.

### 4.5 messages subcollection
Path:
- chat_rooms/{chatRoomId}/messages/{messageId}

Fields:
- senderId: string, required
- senderName: string, required
- text: string, required
- timestamp: timestamp, required
- photoUrl: string, nullable

Validation constraints:
- senderId must be participant in parent chat room.

## 5. Logical Relationships
- users.uid -> issues.reporterId
- issues.eventId -> events.eventId
- issues.chatRoomId -> chat_rooms.chatRoomId
- events.issueId -> issues.issueId
- events.chatRoomId -> chat_rooms.chatRoomId
- chat_rooms.issueId -> issues.issueId
- chat_rooms.eventId -> events.eventId

## 6. Query Index Plan
Required composite and array indexes:
1. issues: status ascending, resolvedAt descending, createdAt descending
2. issues: reporterId ascending, createdAt descending
3. events: participants array-contains, createdAt descending
4. chat_rooms: participants array-contains
5. messages: timestamp ascending

Operational note:
- Keep firestore.indexes.json aligned with production query plan.

## 7. Data Retention and Lifecycle
Proposed retention policy:
- Chat messages retained for 24 months unless legal hold applies.
- Inactive events retained for 36 months.
- Resolved issues retained for analytics and audit for 36 months.

Deletion policy:
- Soft delete preferred for audit-sensitive collections.
- Hard delete only through controlled maintenance jobs.

## 8. Schema Evolution Rules
Migration principles:
1. Additive changes first.
2. Readers tolerate both old and new field sets.
3. Backfill jobs run before strict enforcement.
4. Remove deprecated fields only after two stable releases.

Required migration artifact per change:
- Purpose and impact statement.
- Forward and rollback path.
- Data backfill plan.
- Validation query checklist.

## 9. Access Governance Requirements
Production rules must enforce:
1. Users can read and write only allowed profile fields on their own document.
2. Only NGOs can claim issues.
3. Only claim owner can resolve or unclaim.
4. Only participants can read and write chat room content.
5. Server-side timestamps for createdAt and updatedAt where possible.

## 10. Data Quality Checks
Daily integrity checks recommended:
- Issues with status claimed or resolved and missing eventId.
- Events missing matching chat room.
- Chat rooms missing matching event or issue.
- Messages written by non-participants.

## 11. Current Gaps to Close
1. Add updatedAt and updatedBy fields to mutable entities.
2. Enforce enum constraints in security rules.
3. Ensure claim and unclaim consistency with transactions.
4. Maintain lastMessage and lastMessageTime from message writes.


