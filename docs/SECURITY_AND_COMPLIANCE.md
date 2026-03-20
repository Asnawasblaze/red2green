# Security and Compliance Baseline

## 1. Purpose
This document defines minimum security controls required to operate Red2Green in production.

## 2. Data Classification
- Public data: issue category labels and non-sensitive aggregate stats.
- Internal data: operational logs without direct identifiers.
- Sensitive data: email, phone, ngoUin, location, user-generated media links, chat content.

## 3. Identity and Access Control
1. Firebase Authentication is the identity authority.
2. Firestore rules are the authorization authority.
3. Role checks in client are advisory and must not grant final access.
4. Privileged operations require ownership checks in rules.

## 4. Secret Management
1. No signing secrets in mobile client binaries.
2. Cloudinary signing secret must be stored in managed secret service.
3. Secrets rotation interval target is 90 days.
4. Emergency key revocation runbook must be documented and tested.

## 5. Network and Transport
- TLS required for all network communication.
- Enforce HTTPS-only endpoints for media and API operations.
- Certificate pinning should be evaluated for high-risk environments.

## 6. Logging and Privacy
- Do not log passwords, tokens, ngoUin, precise coordinates, or raw chat content in plaintext logs.
- Redact identifiers before exporting logs to analytics systems.
- Apply data minimization to telemetry payloads.

## 7. Firestore Rule Requirements
Mandatory guardrails:
1. User can modify only own profile except approved admin fields.
2. Only NGO role can claim issue.
3. Only claiming NGO can resolve or unclaim issue.
4. Only participants can read or write room messages.
5. Enforce enum values for role, status, category, and severity.

## 8. Media Security Requirements
1. Upload policy must restrict size and file type.
2. Signed uploads must be short-lived.
3. Virus scanning or content safety scanning should be introduced before broad rollout.
4. Public media URLs must follow retention policy.

## 9. Vulnerability Management
- Static analysis on every pull request.
- Dependency audit before release candidate promotion.
- Critical vulnerabilities must be remediated before production rollout.

## 10. Incident Security Response
Severity triggers:
- Credential leak.
- Unauthorized data access.
- Rule bypass exploit.

Response steps:
1. Contain affected credentials or access path.
2. Rotate secrets and invalidate active tokens if needed.
3. Assess blast radius and affected records.
4. Communicate impact and remediation timeline.
5. Publish post-incident report with corrective controls.

## 11. Compliance Readiness
- Maintain data retention policy and deletion process.
- Maintain evidence of access rule reviews.
- Maintain release approvals for security-sensitive changes.
