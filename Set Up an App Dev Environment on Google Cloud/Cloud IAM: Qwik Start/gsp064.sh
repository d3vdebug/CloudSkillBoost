#!/bin/bash

# --- Color and Formatting Variables ---
RESET='\033[0m'       # Text Reset
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
MAGENTA='\033[0;35m'      # Magenta
BG_BLACK='\033[40m'       # Black Background
BG_GREEN='\033[42m'       # Green Background
BG_MAGENTA='\033[45m'     # Magenta Background
UGREEN='\033[4;32m'       # Underline Green

# --- Banner Section ---
echo -e "${BG_GREEN} >> Cloud IAM: Qwik Start | Automated Lab Solution << ${RESET}"

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


# --- Script Configuration ---
export BUCKET_NAME="gs://$(gcloud config get-value project)"
export SAMPLE_FILE="sample.txt"


# --- Script Execution ---
echo -e "\n${RED} Starting the DEVDEBUG automation script... ${RESET}\n"

echo -e "${BG_MAGENTA} Step 1: Creating a sample file... ${RESET}"
touch $SAMPLE_FILE

echo -e "${BG_MAGENTA} Step 2: Creating a Cloud Storage bucket named ${BUCKET_NAME}... ${RESET}"
gsutil mb $BUCKET_NAME

echo -e "${BG_MAGENTA} Step 3: Uploading the sample file to the bucket... ${RESET}"
gsutil cp $SAMPLE_FILE $BUCKET_NAME

echo -e "${BG_MAGENTA} Step 4: Removing the 'Project Viewer' role from ${USERNAME_2}... ${RESET}"
gcloud projects remove-iam-policy-binding $(gcloud config get-value project) \
    --member="user:${USERNAME_2}" \
    --role="roles/viewer"

echo -e "${BG_MAGENTA} Step 5: Granting the 'Storage Object Viewer' role to ${USERNAME_2}... ${RESET}"
gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
    --member="user:${USERNAME_2}" \
    --role="roles/storage.objectViewer"


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
