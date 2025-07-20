#!/bin/bash

RESET='\033[0m'       # Text Reset

# Regular Colors (Foreground)
BLACK='\033[0;30m'        # Black
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue
MAGENTA='\033[0;35m'      # Magenta
CYAN='\033[0;36m'         # Cyan
WHITE='\033[0;37m'        # White

# Bold
BBLACK='\033[1;30m'       # Black
BRED='\033[1;31m'         # Red
BGREEN='\033[1;32m'       # Green
BYELLOW='\033[1;33m'      # Yellow
BBLUE='\033[1;34m'        # Blue
BMAGENTA='\033[1;35m'     # Magenta
BCYAN='\033[1;36m'        # Cyan
BWHITE='\033[1;37m'       # White

# Underline
UBLACK='\033[4;30m'       # Black
URED='\033[4;31m'         # Red
UGREEN='\033[4;32m'       # Green
UYELLOW='\033[4;33m'      # Yellow
UBLUE='\033[4;34m'        # Blue
UMAGENTA='\033[4;35m'     # Magenta
UCYAN='\033[4;36m'        # Cyan
UWHITE='\033[4;37m'       # White

# Background
BG_BLACK='\033[40m'       # Black
BG_RED='\033[41m'         # Red
BG_GREEN='\033[42m'       # Green
BG_YELLOW='\033[43m'      # Yellow
BG_BLUE='\033[44m'        # Blue
BG_MAGENTA='\033[45m'     # Magenta
BG_CYAN='\033[46m'        # Cyan
BG_WHITE='\033[47m'       # White

# High Intensity Backgrounds
BG_IBLACK='\033[0;100m'   # Black
BG_IRED='\033[0;101m'     # Red
BG_IGREEN='\033[0;102m'   # Green
BG_IYELLOW='\033[0;103m'  # Yellow
BG_IBLUE='\033[0;104m'    # Blue
BG_IMAGENTA='\033[0;105m' # Magenta
BG_ICYAN='\033[0;106m'    # Cyan
BG_IWHITE='\033[0;107m'   # White

echo -e "${BG_GREEN}"
cat << "EOF"
 >> Cloud Storage: Qwik Start - Cloud Console | Automated Lab Solution << 

EOF
echo -e "${BG_BLACK}${UGREEN}"
cat << "EOF"
                                                                     
 ██████╗ ███████╗██╗   ██╗██████╗ ███████╗██████╗ ██╗   ██╗ ██████╗  
 ██╔══██╗██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗██║   ██║██╔════╝  
 ██║  ██║█████╗  ██║   ██║██║  ██║█████╗  ██████╔╝██║   ██║██║  ███╗ 
 ██║  ██║██╔══╝  ╚██╗ ██╔╝██║  ██║██╔══╝  ██╔══██╗██║   ██║██║   ██║ 
 ██████╔╝███████╗ ╚████╔╝ ██████╔╝███████╗██████╔╝╚██████╔╝╚██████╔╝ 
 ╚═════╝ ╚══════╝  ╚═══╝  ╚═════╝ ╚══════╝╚═════╝  ╚═════╝  ╚═════╝  
EOF
echo -e "${RESET}"

# CODE--------------------------------------------------------------------------------------------
export BUCKET_NAME="gs://${DEVSHELL_PROJECT_ID}"
export IMAGE_FILE="kitten.png"
export IMAGE_URL="https://cdn.qwiklabs.com/8tnHNHkj30vDqnzokQ%2FcKrxmOLoxgfaswd9nuZkEjd8%3D"


echo -e "\n${RED} Starting the DEVDEBUG automation script... ${RESET}\n"

echo -e "${BG_MAGENTA} Step 1: Creating a Cloud Storage bucket named ${BUCKET_NAME} in ${REGION}...${RESET}"
gsutil mb -l $REGION -c Standard $BUCKET_NAME

echo -e "${BG_MAGENTA} Step 2: Downloading the kitten picture... ${RESET}"
curl -o $IMAGE_FILE $IMAGE_URL

echo -e "${BG_MAGENTA} Step 3: Uploading the picture to your bucket... ${RESET}"
gsutil cp $IMAGE_FILE $BUCKET_NAME/$IMAGE_FILE

echo -e "${BG_MAGENTA} Step 4: Sharing the picture with the world by making it public... ${RESET}"
gsutil iam ch allUsers:objectViewer $BUCKET_NAME

# CODE--------------------------------------------------------------------------------------------

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
echo -e "And don't forget to subscribe${BG_GREEN} DevDebug ${RESET}."
echo -e "${RESET}"


