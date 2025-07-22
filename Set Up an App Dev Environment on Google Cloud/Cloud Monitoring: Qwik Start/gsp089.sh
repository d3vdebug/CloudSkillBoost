#!/bin/bash

# --- Color and Formatting Variables ---
RESET='\033[0m'       # Text Reset
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue
MAGENTA='\033[0;35m'      # Magenta
CYAN='\033[0;36m'         # Cyan
BG_GREEN='\033[42m'       # Green Background
BG_MAGENTA='\033[45m'     # Magenta Background
BOLD=$(tput bold)

# --- Banner Section ---
echo -e "${BG_GREEN}"
cat << "EOF"
 >> Cloud Monitoring: Qwik Start | Automated Lab Solution << 
EOF
echo -e "${GREEN}"
cat << "EOF"
                                                                     
 ██████╗ ███████╗██╗   ██╗██████╗ ███████╗██████╗ ██╗   ██╗ ██████╗  
 ██╔══██╗██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗██║   ██║██╔════╝  
 ██║  ██║█████╗  ██║   ██║██║  ██║█████╗  ██████╔╝██║   ██║██║  ███╗ 
 ██║  ██║██╔══╝  ╚██╗ ██╔╝██║  ██║██╔══╝  ██╔══██╗██║   ██║██║   ██║ 
 ██████╔╝███████╗ ╚████╔╝ ██████╔╝███████╗██████╔╝╚██████╔╝╚██████╔╝ 
 ╚═════╝ ╚══════╝  ╚═══╝  ╚═════╝ ╚══════╝╚═════╝  ╚═════╝  ╚═════╝  
EOF
echo -e "${RESET}"

# --- Script Execution ---
echo -e "\n${RED} Starting the DEVDEBUG automation script... ${RESET}\n"



# --- Script Execution ---
echo -e "\n${RED} Starting the DEVDEBUG automation script... ${RESET}\n"

# Step 1: Set PROJECT_ID, PROJECT_NUMBER, ZONE & REGION
echo -e "${BG_MAGENTA} Setting PROJECT_ID, PROJECT_NUMBER, ZONE & REGION${RESET}"
export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

# Step 2: Enable OS Config Service
echo -e "${BG_MAGENTA} Enabling OS Config Service${RESET}"
gcloud services enable osconfig.googleapis.com

# Step 3: Configure gcloud settings
echo -e "${BG_MAGENTA} Configuring gcloud settings${RESET}"
gcloud config set compute/zone $ZONE
gcloud config set compute/region $REGION

# Step 4: Create Compute Instance
echo -e "${BG_MAGENTA} Creating Compute Instance${RESET}"
gcloud compute instances create lamp-1-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-osconfig=TRUE,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --tags=http-server --create-disk=auto-delete=yes,boot=yes,device-name=lamp-1-vm,image=projects/debian-cloud/global/images/debian-12-bookworm-v20250311,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ops-agent-policy=v2-x86-template-1-4-0,goog-ec-src=vm_add-gcloud --reservation-affinity=any && printf 'agentsRule:\n  packageState: installed\n  version: latest\ninstanceFilter:\n  inclusionLabels:\n  - labels:\n      goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml && gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-$ZONE --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --file=config.yaml && gcloud compute resource-policies create snapshot-schedule default-schedule-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION --max-retention-days=14 --on-source-disk-delete=keep-auto-snapshots --daily-schedule --start-time=22:00 && gcloud compute disks add-resource-policies lamp-1-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --resource-policies=projects/$DEVSHELL_PROJECT_ID/regions/$REGION/resourcePolicies/default-schedule-1

# Step 5: Create Firewall Rule for HTTP
echo -e "${BG_MAGENTA}Creating Firewall Rule for HTTP${RESET}"
gcloud compute firewall-rules create allow-http \
    --project=$DEVSHELL_PROJECT_ID \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=http-server

sleep 45

# Step 6: Create and Transfer Startup Script
echo -e "${BG_MAGENTA}Creating and Transferring Startup Script${RESET}"
cat > prepare_disk.sh <<'EOF_END'

sudo apt-get update
sudo apt-get install -y apache2 php7.0
sudo service apache2 restart

EOF_END

# Step 7: Execute Startup Script on VM
echo -e "${BG_MAGENTA} Executing Startup Script on VM${RESET}"
gcloud compute scp prepare_disk.sh lamp-1-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet
gcloud compute ssh lamp-1-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"

# Step 8: Get Instance ID
echo -e "${BG_MAGENTA} Retrieving Instance ID${RESET}"
export INSTANCE_ID=$(gcloud compute instances list --filter=lamp-1-vm --zones $ZONE --format="value(id)")

# Step 9: Setup Uptime Check
echo -e "${BG_MAGENTA} Setting Up Uptime Check${RESET}"
curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" \
  "https://monitoring.googleapis.com/v3/projects/$DEVSHELL_PROJECT_ID/uptimeCheckConfigs" \
  -d "$(cat <<EOF
{
  "displayName": "Lamp Uptime Check",
  "httpCheck": {
    "path": "/",
    "port": 80,
    "requestMethod": "GET"
  },
  "monitoredResource": {
    "labels": {
      "instance_id": "$INSTANCE_ID",
      "project_id": "$DEVSHELL_PROJECT_ID",
      "zone": "$ZONE"
    },
    "type": "gce_instance"
  }
}
EOF
)"

# Step 10: Create Email Notification Channel
echo -e "${BG_MAGENTA} Creating Email Notification Channel${RESET}"
cat > email-channel.json <<EOF_END
{
  "type": "email",
  "displayName": "DevDebug",
  "description": "CloudSkillBoost",
  "labels": {
    "email_address": "$USER_EMAIL"
  }
}
EOF_END

gcloud beta monitoring channels create --channel-content-from-file="email-channel.json"

# Step 11: Get Notification Channel ID
echo -e "${BG_MAGENTA} Retrieving Notification Channel ID${RESET}"
email_channel_info=$(gcloud beta monitoring channels list)
email_channel_id=$(echo "$email_channel_info" | grep -oP 'name: \K[^ ]+' | head -n 1)

# Step 12: Create Alerting Policy
echo -e "${BG_MAGENTA} Creating Alerting Policy${RESET}"
cat > awesome.json <<EOF_END
{
  "displayName": "Inbound Traffic Alert",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "VM Instance - Network traffic",
      "conditionThreshold": {
        "filter": "resource.type = \"gce_instance\" AND metric.type = \"agent.googleapis.com/interface/traffic\"",
        "aggregations": [
          {
            "alignmentPeriod": "300s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_RATE"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "60s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 500
      }
    }
  ],
  "alertStrategy": {
    "notificationPrompts": [
      "OPENED"
    ]
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [
    "$email_channel_id"
  ],
  "severity": "SEVERITY_UNSPECIFIED"
}
EOF_END

gcloud alpha monitoring policies create --policy-from-file="awesome.json"


# --- Final Message ---
echo -e "${GREEN}"
cat << "EOF"

 __         ______     ______        ______   __     __   __     __     ______     __  __     ______     _____    
/\ \       /\  __ \   /\  == \      /\  ___\ /\ \   /\ "-.\ \   /\ \   /\  ___\   /\ \_\ \   /\  ___\   /\  __-.  
\ \ \____  \ \  __ \  \ \  __<      \ \  __\ \ \ \  \ \ \-.  \  \ \ \  \ \___  \  \ \  __ \  \ \  __\   \ \ \/\ \ 
 \ \_____\  \ \_\ \_\  \ \_____\     \ \_\    \ \_\  \ \_\\"\_\  \ \_\  \/\_____\  \ \_\ \_\  \ \_____\  \ \____- 
  \/_____/   \/_/\/_/   \/_____/      \/_/     \/_/   \/_/ \/_/   \/_/   \/_____/   \/_/\/_/   \/_____/   \/____/ 
                                                                                                                  
EOF
echo -e "${RESET}"

echo -e "Feel free to let me know if you run into any issues while running the code."
echo -e "You can now go back to the lab page and click the 'Check my progress' buttons."
echo -e "And don't forget to subscribe to ${BG_GREEN} DevDebug ${RESET}."
echo -e "${RESET}"

