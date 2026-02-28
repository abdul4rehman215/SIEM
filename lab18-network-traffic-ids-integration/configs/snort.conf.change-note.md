# Snort Configuration Change Notes (Lab 18)

File edited:
- `/etc/snort/snort.conf`

Change made (per lab instruction):
- Enabled community rules include by ensuring the following line is present (uncommented):

```conf
include $RULE_PATH/community.rules
