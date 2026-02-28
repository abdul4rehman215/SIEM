# Snort Configuration Change Notes (Lab 18)

File edited:
- `/etc/snort/snort.conf`

Change made (per lab instruction):
- Enabled community rules include by ensuring the following line is present (uncommented):

```conf
include $RULE_PATH/community.rules
```
## Why this matters:

Community rules provide basic, known threat signatures.
This enables Snort to load additional detection rules beyond the default ruleset.
If the include path is incorrect or commented out, Snort may run with fewer rules and miss detections.
