# Deployment and Release Guide

## 1. Release Strategy
- Branch model: protected main branch with pull request reviews.
- Promotion flow: development -> staging -> production.
- Rollout style: phased mobile rollout with monitoring gates.

## 2. Environment Strategy
Minimum environments:
1. Development
2. Staging
3. Production

Environment separation requirements:
- Separate Firebase project per environment.
- Separate media upload credentials per environment.
- Separate analytics and alert channels.

## 3. Build and Validation Pipeline
Required pipeline stages:
1. Dependency resolution and lockfile validation.
2. Static analysis.
3. Unit and widget tests.
4. Integration smoke tests.
5. Artifact signing and publish.

## 4. Configuration Management
- Store non-secret config in environment-specific files.
- Store secrets in secure secret manager.
- Never commit production secrets to repository.

## 5. Database and Rule Changes
Change controls:
1. Rule changes must be peer reviewed.
2. Index changes must be applied before app rollout if queries depend on them.
3. Schema changes should be backward compatible during rollout window.

## 6. Release Acceptance Criteria
A release candidate is production-eligible only when:
1. No critical security findings are open.
2. No Sev1 or Sev2 defects are open for release scope.
3. Core user journeys pass smoke matrix on staging.
4. Observability dashboards and alerts are green.

## 7. Rollback Plan
Rollback triggers:
- Elevated crash rates.
- Sustained critical backend operation failures.
- Security incident requiring immediate rollback.

Rollback actions:
1. Halt rollout progression.
2. Revert to previous stable mobile release.
3. Restore previous rule and config baseline where required.
4. Confirm service health before reopening rollout.

## 8. Release Documentation Requirements
Each release must include:
- Change summary.
- Risk assessment.
- Migration notes.
- Rollback instructions.
- Owner and approver list.
