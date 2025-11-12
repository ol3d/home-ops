# Output Style: Deployment Checklist

## Purpose

Use when planning deployments to ensure all prerequisites, steps, and verification procedures are documented and followed.

## Template

````markdown
# Deployment Checklist

## Deployment Information

**Deployment Name**: [Brief title]
**Date/Time**: [Scheduled date and time]
**Environment**: [Production | Staging | Dev | Lab]
**Estimated Duration**: [Time estimate]
**Maintenance Window**: [Yes/No - if yes, specify window]

## Summary

**What We're Deploying**:
[Brief description]

**Why**:
[Business/technical justification]

**Risk Level**: [Low | Medium | High | Critical]

## Team & Contacts

- **Deployment Lead**: [Name]
- **Technical Contact**: [Name/On-call]
- **Stakeholders**: [Who needs to be informed]
- **Rollback Authority**: [Who can call rollback]

## Pre-Deployment Checklist

### Prerequisites

- [ ] All code changes reviewed and approved
- [ ] CI/CD pipeline passing
- [ ] Terraform plan reviewed
- [ ] Security audit completed
- [ ] Documentation updated
- [ ] Rollback plan tested
- [ ] Monitoring alerts configured
- [ ] Backups verified recent and restorable

### Communication

- [ ] Stakeholders notified of deployment window
- [ ] Maintenance mode notice posted (if applicable)
- [ ] Team on standby for deployment
- [ ] On-call schedule confirmed

### Environment Preparation

- [ ] Target environment accessible
- [ ] Required credentials available
- [ ] Resource capacity verified
- [ ] DNS/networking confirmed
- [ ] Dependencies are healthy

### Backup & Safety

- [ ] Full backup taken and verified
- [ ] Database snapshot created
- [ ] Configuration exported
- [ ] State files backed up
- [ ] Rollback artifacts prepared

## Deployment Steps

### Phase 1: Preparation (HH:MM - HH:MM)

1. **[Step Name]**
   ```bash
   [Command to execute]
   ```
````

**Expected Output**: [What success looks like]
**If Fails**: [What to do]

2. **[Next Step]**
   ```bash
   [Command]
   ```
   **Validation**: [How to verify]

### Phase 2: Execution (HH:MM - HH:MM)

[Continue with numbered steps]

### Phase 3: Verification (HH:MM - HH:MM)

[Verification steps]

## Health Checks

**After Each Phase, Verify**:

- [ ] **Service Health**

  ```bash
  [Health check command]
  ```

  Expected: [Healthy state indicator]

- [ ] **Application Metrics**

  - CPU: [Threshold]
  - Memory: [Threshold]
  - Response Time: [Threshold]

- [ ] **Logs**

  ```bash
  [Command to check logs]
  ```

  Look for: [No errors, specific success messages]

- [ ] **Endpoints**
  ```bash
  curl -I https://service.example.com/health
  ```
  Expected: HTTP 200 OK

## Go/No-Go Decision Points

### Before Phase 2 (Main Deployment)

**Stop if ANY are true**:

- [ ] Health checks failing
- [ ] Backup failed or unverified
- [ ] Critical dependency unavailable
- [ ] Deployment lead not available

**Decision**: [✅ Proceed | 🔄 Delay | ❌ Abort]
**By**: [Name/Role]

### Before Phase 3 (Final Cutover)

**Stop if ANY are true**:

- [ ] Errors in logs
- [ ] Performance degradation
- [ ] Data inconsistencies
- [ ] Failed smoke tests

**Decision**: [✅ Proceed | 🔄 Rollback]
**By**: [Name/Role]

## Rollback Plan

**Trigger Conditions**:

- Service unavailable for > [X minutes]
- Error rate > [X%]
- Critical functionality broken
- Data corruption detected

**Rollback Steps**:

1. **Announce Rollback**

   ```bash
   [Notification command/message]
   ```

2. **Stop New Deployment**

   ```bash
   [Command to halt deployment]
   ```

3. **Restore Previous State**

   ```bash
   [Rollback commands - numbered and specific]
   ```

4. **Verify Rollback Success**
   - [ ] Service responding normally
   - [ ] Health checks passing
   - [ ] No errors in logs
   - [ ] Metrics returned to baseline

**Estimated Rollback Time**: [X minutes]

## Post-Deployment Checklist

### Immediate (Within 30 Minutes)

- [ ] All health checks passing
- [ ] No critical errors in logs
- [ ] Key functionality verified
- [ ] Performance metrics normal
- [ ] Monitoring dashboards reviewed
- [ ] Stakeholders notified of completion

### Short Term (Within 24 Hours)

- [ ] Extended monitoring reviewed
- [ ] User feedback collected
- [ ] Error rates analyzed
- [ ] Performance trends reviewed
- [ ] Documentation verified accurate

### Follow-Up (Within 1 Week)

- [ ] Post-deployment review completed
- [ ] Lessons learned documented
- [ ] Runbook updated
- [ ] Metrics dashboard updated
- [ ] Team retrospective held

## Monitoring & Observability

### Key Dashboards

- [Dashboard name/link] - [What it shows]
- [Dashboard name/link] - [What it shows]

### Critical Alerts

- [Alert name] - [Threshold] - [Action required]
- [Alert name] - [Threshold] - [Action required]

### Log Queries

```bash
# Check for errors
[Log query command]

# Monitor specific operation
[Log query command]
```

## Success Criteria

Deployment is considered successful when ALL are true:

- [✅] All deployment steps completed without errors
- [✅] Health checks passing for 30+ minutes
- [✅] No increase in error rates
- [✅] Performance metrics within acceptable range
- [✅] Key user journeys verified functional
- [✅] No P1/P0 incidents triggered
- [✅] Stakeholders confirm acceptance

## Notes & Observations

[Space for deployment team to log observations, issues encountered, timing adjustments, etc.]

---

**Deployment Status**: [⏳ Pending | 🚀 In Progress | ✅ Completed | ❌ Rolled Back | ⏸️ Paused]

**Actual Duration**: [Filled after completion]

**Issues Encountered**: [List any problems and resolutions]

**Lessons Learned**: [What went well, what could improve]

````

## Guidelines

**Be Specific**:
- Exact commands with parameters
- Specific time windows
- Named individuals
- Measurable success criteria
- Clear go/no-go conditions

**Include Context**:
- Why each step is necessary
- What successful output looks like
- What to do if steps fail
- How long each phase should take

**Safety First**:
- Always have rollback plan
- Test rollback before deployment
- Define clear abort conditions
- Multiple verification points

**Communication**:
- Who needs to know what, when
- How to escalate issues
- Where to log progress
- How to declare success/failure

## Example

```markdown
# Deployment Checklist

## Deployment Information

**Deployment Name**: K3s Cluster Upgrade to v1.28.5
**Date/Time**: 2025-11-06 02:00 AM UTC
**Environment**: Production Lab
**Estimated Duration**: 90 minutes
**Maintenance Window**: Yes - 02:00-04:00 AM UTC

## Summary

**What We're Deploying**:
Upgrade K3s cluster from v1.27.9 to v1.28.5, including control plane and all agent nodes

**Why**:
- Security patches for CVE-2024-XXXX
- New features for workload management
- Improved stability and performance

**Risk Level**: Medium (requires node restart, minimal downtime with rolling update)

## Team & Contacts

- **Deployment Lead**: ol3d
- **Technical Contact**: On-call (Slack: #infrastructure)
- **Stakeholders**: Homelab users (self)
- **Rollback Authority**: ol3d

## Pre-Deployment Checklist

### Prerequisites
- [x] K3s v1.28.5 release notes reviewed
- [x] Backup of etcd/k3s data taken
- [x] Helm charts compatibility verified
- [x] Test deployment successful in staging
- [x] Node health verified (all Ready)
- [x] No pods in CrashLoopBackOff
- [x] Monitoring dashboards accessible

### Communication
- [x] No external stakeholders (homelab)
- [x] Maintenance window scheduled (2AM-4AM)
- [x] Calendar blocked

### Environment Preparation
- [x] SSH access to all nodes verified
- [x] Ansible inventory updated
- [x] kubectl working from laptop
- [x] VPN connection stable
- [x] All nodes pingable

### Backup & Safety
- [x] Full cluster backup via Velero
- [x] etcd snapshot taken
- [x] Cluster configuration exported
- [x] Critical workload manifests exported
- [x] Rollback ansible playbook tested

## Deployment Steps

### Phase 1: Pre-Flight Checks (02:00 - 02:15)

1. **Verify Cluster Health**
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces | grep -v Running
````

**Expected Output**: All nodes Ready, no non-Running pods
**If Fails**: Investigate and resolve before proceeding

2. **Drain First Master Node**

   ```bash
   kubectl drain k3s-master-01 --ignore-daemonsets --delete-emptydir-data
   ```

   **Validation**: Node status shows SchedulingDisabled

3. **Take Final Backup**
   ```bash
   k3s etcd-snapshot save --name pre-upgrade-$(date +%Y%m%d-%H%M)
   ```

### Phase 2: Control Plane Upgrade (02:15 - 02:45)

1. **Upgrade First Master**

   ```bash
   ansible-playbook -i kubernetes/inventory kubernetes/playbooks/upgrade-k3s.yml \
     --limit k3s-master-01 \
     --extra-vars "k3s_version=v1.28.5+k3s1"
   ```

   **Expected**: Playbook completes successfully
   **If Fails**: Rollback immediately

2. **Verify First Master**

   ```bash
   kubectl get node k3s-master-01
   ssh k3s-master-01 "k3s --version"
   ```

   **Expected**: Node Ready, version shows v1.28.5

3. **Uncordon First Master**

   ```bash
   kubectl uncordon k3s-master-01
   ```

4. **Repeat for Remaining Masters**
   - Drain k3s-master-02
   - Upgrade k3s-master-02
   - Verify and uncordon
   - Drain k3s-master-03
   - Upgrade k3s-master-03
   - Verify and uncordon

### Phase 3: Agent Upgrade (02:45 - 03:30)

1. **Upgrade Agents in Rolling Fashion**
   ```bash
   for node in k3s-agent-01 k3s-agent-02 k3s-agent-03; do
     echo "Upgrading $node..."
     kubectl drain $node --ignore-daemonsets --delete-emptydir-data --timeout=5m
     ansible-playbook -i kubernetes/inventory kubernetes/playbooks/upgrade-k3s.yml \
       --limit $node --extra-vars "k3s_version=v1.28.5+k3s1"
     kubectl uncordon $node
     sleep 60  # Wait for node to stabilize
   done
   ```

### Phase 4: Verification (03:30 - 04:00)

1. **Verify All Nodes**

   ```bash
   kubectl get nodes -o wide
   ```

   **Expected**: All nodes Ready, all showing v1.28.5

2. **Check Pod Status**
   ```bash
   kubectl get pods --all-namespaces
   ```
   **Expected**: All pods Running or Completed

## Health Checks

**After Each Master Upgrade**:

- [ ] **Node Health**

  ```bash
  kubectl get node <node-name>
  ```

  Expected: Ready status

- [ ] **etcd Health**

  ```bash
  kubectl -n kube-system exec -it etcd-<master> -- etcdctl member list
  ```

  Expected: All members healthy

- [ ] **API Server**
  ```bash
  kubectl cluster-info
  ```
  Expected: Kubernetes control plane running

## Go/No-Go Decision Points

### Before Upgrading First Master

**Stop if ANY are true**:

- [x] Any node not Ready - CHECKED: All Ready
- [x] Backup failed - CHECKED: Successful
- [x] Non-Running pods present - CHECKED: All Running
- [x] High cluster load - CHECKED: Normal load

**Decision**: ✅ Proceed
**By**: ol3d (02:14 AM)

### Before Agent Upgrades

**Stop if ANY are true**:

- [ ] Master upgrades had errors
- [ ] Control plane unhealthy
- [ ] Workload failures detected

**Decision**: [Pending - complete after Phase 2]

## Rollback Plan

**Trigger Conditions**:

- API server unreachable for > 5 minutes
- More than 1 master node failing
- Critical workloads failing
- etcd corruption detected

**Rollback Steps**:

1. **Stop Upgrade Process**

   ```bash
   # Cancel any running Ansible playbooks
   ^C  # If manual, or kill process
   ```

2. **Restore etcd from Snapshot**

   ```bash
   k3s server --cluster-reset --cluster-reset-restore-path=/var/lib/rancher/k3s/server/db/snapshots/pre-upgrade-*.db
   ```

3. **Rollback Nodes to Previous Version**

   ```bash
   ansible-playbook -i kubernetes/inventory kubernetes/playbooks/upgrade-k3s.yml \
     --extra-vars "k3s_version=v1.27.9+k3s1"
   ```

4. **Verify Cluster**
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

**Estimated Rollback Time**: 30 minutes

## Post-Deployment Checklist

### Immediate (Within 30 Minutes)

- [ ] All nodes showing v1.28.5
- [ ] No CrashLoopBackOff pods
- [ ] etcd healthy across all masters
- [ ] Metrics server responding
- [ ] Sample workload deployed successfully

### Short Term (Within 24 Hours)

- [ ] Monitoring shows stable metrics
- [ ] No unexpected restarts
- [ ] Log analysis shows no errors
- [ ] Workload performance normal

### Follow-Up (Within 1 Week)

- [ ] Update runbook with any issues encountered
- [ ] Document new K3s v1.28 features used
- [ ] Review upgrade timing for future reference

## Monitoring & Observability

### Key Dashboards

- Grafana K3s Cluster Dashboard - Node health, resource usage
- Prometheus Alerts - Any firing alerts

### Critical Alerts

- KubeletDown - Node unreachable - Check node immediately
- PodCrashLooping - Pod restart loop - Investigate workload

### Log Queries

```bash
# Check k3s service logs on any node
ssh <node> "journalctl -u k3s -f --since '2 hours ago'"

# Check for errors
kubectl logs -n kube-system <pod> --tail=50
```

## Success Criteria

Deployment is considered successful when ALL are true:

- [x] All nodes upgraded to v1.28.5
- [ ] All pods Running for 30+ minutes
- [ ] No increase in pod restarts
- [ ] API server latency < 100ms
- [ ] etcd cluster healthy
- [ ] Sample workload operates correctly

## Notes & Observations

02:14 - Pre-flight checks complete, all systems go
02:18 - Master-01 upgrade started
02:23 - Master-01 upgrade complete, node Ready
[Continue logging as deployment progresses...]

---

**Deployment Status**: 🚀 In Progress

**Actual Duration**: [TBD]

**Issues Encountered**: [None so far]

**Lessons Learned**: [Fill after completion]

```

```
