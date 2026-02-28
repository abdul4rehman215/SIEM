# scripts/generate_report.sh
#!/bin/bash
echo "Security Report Summary"
grep -i "error" /opt/zeek/logs/current/*.log > summary.log
