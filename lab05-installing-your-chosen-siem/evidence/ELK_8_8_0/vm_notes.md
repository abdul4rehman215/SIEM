# ELK 8.8.0 Lab Notes

## Lab Context
- Cloud Ubuntu environment (Ubuntu 24.04.1 LTS)
- Installed ELK components using direct `.deb` downloads from Elastic artifacts
- Verified services using curl and systemctl

## Installation Directory
- Working directory used for package downloads:
  - `~/ELK_8_8_0/`

## Verification Commands
- Elasticsearch:
  - `curl -X GET "localhost:9200/"`
- Kibana:
  - `curl -I http://localhost:5601 | head -n 5`
- Ports:
  - `ss -lntp | grep -E '(:9200|:5601)'`
