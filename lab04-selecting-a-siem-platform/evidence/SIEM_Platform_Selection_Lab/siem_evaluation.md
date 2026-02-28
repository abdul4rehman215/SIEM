# SIEM Platform Evaluation (Small/Medium Org)

## Evaluation Factors
- Cost (license + hardware + maintenance)
- Complexity (setup + tuning + daily operations)
- Scalability (can it grow with log volume/users?)
- Support (community vs paid support)

## Elastic Stack (ELK)
**Pros**
- No licensing cost (basic OSS usage)
- Powerful search + dashboards
- Highly scalable with the right architecture

**Cons**
- Steep learning curve
- Requires tuning (pipelines, mappings, performance)
- Ongoing maintenance and upgrades needed

## Wazuh
**Pros**
- Security-focused out of the box (FIM, HIDS, rules, alerts)
- Strong community support
- Good fit for small environments

**Cons**
- Often paired with ELK/OpenSearch for full dashboarding
- Some advanced SIEM use-cases require integrations

## Commercial Note (Splunk / QRadar)
- Very strong features and support, but higher cost.
- Typically chosen when budgets and compliance requirements are strict.
