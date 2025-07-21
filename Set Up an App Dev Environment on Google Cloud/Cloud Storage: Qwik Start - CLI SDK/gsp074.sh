
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

echo -e "${BG_MAGENTA} Step 1: Setting the default region to ${REGION}... ${RESET}"
gcloud config set compute/region $REGION

# This command now includes the required location flag to pass the lab check.
echo -e "${BG_MAGENTA} Step 2: Creating a Cloud Storage bucket in ${REGION}... ${RESET}"
gsutil mb -l $REGION gs://$DEVSHELL_PROJECT_ID

echo -e "${BG_MAGENTA} Step 3: Downloading the Ada Lovelace portrait... ${RESET}"
curl https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/800px-Ada_Lovelace_portrait.jpg --output ada.jpg

echo -e "${BG_MAGENTA} Step 4: Uploading the image to the bucket... ${RESET}"
gsutil cp ada.jpg gs://$DEVSHELL_PROJECT_ID

echo -e "${BG_MAGENTA} Step 5: Copying the image from the bucket back to the local directory... ${RESET}"
gsutil cp -r gs://$DEVSHELL_PROJECT_ID/ada.jpg .

echo -e "${BG_MAGENTA} Step 6: Copying the image to the 'image-folder'... ${RESET}"
gsutil cp gs://$DEVSHELL_PROJECT_ID/ada.jpg gs://$DEVSHELL_PROJECT_ID/image-folder/

echo -e "${BG_MAGENTA} Step 7: Making the original image public... ${RESET}"
gsutil acl ch -u AllUsers:R gs://$DEVSHELL_PROJECT_ID/ada.jpg


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

