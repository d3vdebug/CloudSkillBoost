
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
echo -e "${BG_GREEN}"
cat << "EOF"
 >> Cloud Storage: Qwik Start - CLI/SDK | Automated Lab Solution << 
EOF
echo -e "$GREEN}"
cat << "EOF"
                                                                     
 ██████╗ ███████╗██╗   ██╗██████╗ ███████╗██████╗ ██╗   ██╗ ██████╗  
 ██╔══██╗██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗██║   ██║██╔════╝  
 ██║  ██║█████╗  ██║   ██║██║  ██║█████╗  ██████╔╝██║   ██║██║  ███╗ 
 ██║  ██║██╔══╝  ╚██╗ ██╔╝██║  ██║██╔══╝  ██╔══██╗██║   ██║██║   ██║ 
 ██████╔╝███████╗ ╚████╔╝ ██████╔╝███████╗██████╔╝╚██████╔╝╚██████╔╝ 
 ╚═════╝ ╚══════╝  ╚═══╝  ╚═════╝ ╚══════╝╚═════╝  ╚═════╝  ╚═════╝  
EOF
echo -e "${RESET}"




export BUCKET_NAME="gs://$(gcloud config get-value project)"
export DOWNLOADED_FILENAME="sad-cat.jpg"
export UPLOAD_FILENAME="sad-cat.jpg"
export FOLDER_NAME="images"
export IMAGE_URL="https://storage.googleapis.com/cloud-training/gsp313/sad-cat.jpg"


# --- Script Execution ---
echo -e "\n${RED} Starting the DEVDEBUG automation script... ${RESET}\n"

echo -e "${BG_MAGENTA} Step 1: Setting the default region to ${REGION}... ${RESET}"
gcloud config set compute/region $REGION

echo -e "${BG_MAGENTA} Step 2: Creating a Cloud Storage bucket in ${REGION}... ${RESET}"
gsutil mb -l $REGION $BUCKET_NAME

echo -e "${BG_MAGENTA} Step 3: Downloading the Ada Lovelace portrait... ${RESET}"
curl ${IMAGE_URL} --output ${IMAGE_FILE}

echo -e "${BG_MAGENTA} Step 4: Uploading the image to the bucket... ${RESET}"
gsutil cp ${IMAGE_FILE} ${BUCKET_NAME}

echo -e "${BG_MAGENTA} Step 5: Copying the image back to the local directory... ${RESET}"
gsutil cp -r ${BUCKET_NAME}/${IMAGE_FILE} .

echo -e "${BG_MAGENTA} Step 6: Copying the image to the '${FOLDER_NAME}' folder... ${RESET}"
gsutil cp ${BUCKET_NAME}/${IMAGE_FILE} ${BUCKET_NAME}/${FOLDER_NAME}/

echo -e "${BG_MAGENTA} Step 7: Making the original image public... ${RESET}"
gsutil acl ch -u AllUsers:R ${BUCKET_NAME}/${IMAGE_FILE}


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

