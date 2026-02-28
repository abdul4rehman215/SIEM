# Kibana Saved Query Notes (Lab 21)

## Goal
Save a frequently used investigation query so it can be reused instantly without retyping.

## Saved Query / Saved Search Created
- Name: `Error_Logs_Last_24_Hours`
- Query (KQL): `severity:error`
- Time range: `Last 24 hours`

## Kibana Steps (Discover)
1. Open Kibana → Discover
2. Select data view that matches the index:
   - `logs-demo*` (data view pointing to `logs-demo`)
3. Enter KQL query:
   - `severity:error`
4. Set time picker to:
   - `Last 24 hours`
5. Click **Save** (Saved query / saved search depending on Kibana UI)
6. Confirm it appears under Saved searches / Saved queries list

## CLI Proof (Saved Objects API)
You can confirm from terminal:
```bash
curl -s -X GET "http://localhost:5601/api/saved_objects/_find?type=search&search_fields=title&search=Error_Logs_Last_24_Hours" \
-H 'kbn-xsrf: true' | jq '.total, (.saved_objects[] | {id, type, title: .attributes.title})'
