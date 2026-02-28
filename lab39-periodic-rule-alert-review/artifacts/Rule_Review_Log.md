# artifacts/Rule_Review_Log.md
# Rule Review Log (Lab 39)

## Review Entry 1
- **Rule ID**: HighCPUUsage_SIEMHost
- **Description**: Alerts when SIEM host CPU usage stays high for a sustained period.
- **Last Triggered**: Not triggered in lab environment (CPU stable ~6–8% during review)
- **Decision**: Revise
- **Comments**:
  - Original threshold was **>95% for 10 minutes**.
  - Risk: may miss early performance degradation during high ingestion periods.
  - Updated threshold to **>85% for 10 minutes** to provide earlier warning while limiting noise.
  - Rule remains relevant for SIEM health monitoring and ingestion stability.
