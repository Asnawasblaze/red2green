# Operations Runbook

## 1. Purpose
This runbook defines operational procedures for monitoring, incident response, and recovery for Red2Green.

## 2. Service Ownership
- Incident commander: Platform Engineering on-call.
- Domain support: Mobile Engineering.
- Security escalation: Security on-call.

## 3. Golden Signals
Monitor at minimum:
1. Auth success and failure rates.
2. Firestore read and write error rates.
3. Claim, join, resolve operation success rates.
4. Message send latency and failure rates.
5. Media upload timeout and failure rates.

## 4. Alert Thresholds
- Sev1 alert: Auth outage or broad write failures over 10 percent for 5 minutes.
- Sev2 alert: Claim or chat failure rate over 5 percent for 10 minutes.
- Sev3 alert: Elevated latency without data loss.

## 5. Incident Playbook
1. Acknowledge alert and assign incident commander.
2. Establish impact scope and affected user journeys.
3. Apply mitigation:
   - Roll back risky release.
   - Disable unstable feature path by configuration if available.
4. Verify recovery against success metrics.
5. Publish incident summary and action items.

## 6. Common Failure Scenarios

### 6.1 Firestore permission errors
Symptoms:
- Users cannot read feed or send chat messages.

Actions:
1. Validate latest rule deployment.
2. Reproduce with test user role matrix.
3. Roll back rules to last known good baseline if needed.

### 6.2 Claim and unclaim inconsistency
Symptoms:
- Orphan chat rooms or broken event pointers.

Actions:
1. Run integrity check query set.
2. Repair orphan records using controlled admin script.
3. Prioritize transactional write fix before next release.

### 6.3 Media upload failures
Symptoms:
- Report creation fails after image capture.

Actions:
1. Check Cloudinary status and quota.
2. Verify signing endpoint or secret validity.
3. Enable fallback messaging and retry guidance.

## 7. Recovery Objectives
Target objectives:
- RTO: 30 minutes for Sev1 and Sev2 incidents.
- RPO: 5 minutes for critical state transitions.

## 8. Pre-Release Operational Checklist
1. Dashboards and alerts verified.
2. On-call coverage confirmed.
3. Rollback path tested.
4. Migration and compatibility checks complete.
5. Incident communication template prepared.

## 9. Post-Release Verification
1. Monitor first-hour error and latency trends.
2. Validate issue claim and chat send flows.
3. Confirm no new high-severity log signatures.
4. Close release watch only after stability window passes.
