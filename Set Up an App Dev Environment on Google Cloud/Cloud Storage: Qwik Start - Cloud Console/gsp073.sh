#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BRED='\033[1;31m'
NC='\033[0m'

echo -e "${GREEN}"
cat << "EOF"
██████╗ ███████╗██╗   ██╗██████╗ ███████╗██████╗ ██╗   ██╗ ██████╗ 
██╔══██╗██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗██║   ██║██╔════╝ 
██║  ██║█████╗  ██║   ██║██║  ██║█████╗  ██████╔╝██║   ██║██║  ███╗
██║  ██║██╔══╝  ╚██╗ ██╔╝██║  ██║██╔══╝  ██╔══██╗██║   ██║██║   ██║
██████╔╝███████╗ ╚████╔╝ ██████╔╝███████╗██████╔╝╚██████╔╝╚██████╔╝
╚═════╝ ╚══════╝  ╚═══╝  ╚═════╝ ╚══════╝╚═════╝  ╚═════╝  ╚═════╝ 

>> Cloud Storage: Qwik Start - Cloud Console | Automated Lab Solution <<

EOF
echo -e "${NC}"

export BUCKET_NAME="gs://${DEVSHELL_PROJECT_ID}"
export IMAGE_FILE="kitten.png"
export IMAGE_URL="https://cdn.qwiklabs.com/8tnHNHkj30vDqnzokQ%2FcKrxmOLoxgfaswd9nuZkEjd8%3D"


echo -e "\n${YELLOW}🚀 Starting the DEVDEBUG automation script...${NC}\n"

echo -e "${GREEN}✅ Step 1: Creating a Cloud Storage bucket named ${BUCKET_NAME} in ${REGION}...${NC}"
gsutil mb -l $REGION -c Standard $BUCKET_NAME

echo -e "${GREEN}✅ Step 2: Downloading the kitten picture... 🖼️${NC}"
curl -o $IMAGE_FILE $IMAGE_URL

echo -e "${GREEN}✅ Step 3: Uploading the picture to your bucket...${NC}"
gsutil cp $IMAGE_FILE $BUCKET_NAME/$IMAGE_FILE

echo -e "${GREEN}✅ Step 4: Sharing the picture with the world by making it public... 🌐${NC}"
gsutil iam ch allUsers:objectViewer $BUCKET_NAME


echo -e "\n${YELLOW}-----------------------------------------------------------------------${NC}"
echo -e "${GREEN}              🎉🎉 SCRIPT FINISHED SUCCESSFULLY! 🎉🎉                  ${NC}"
echo -e "${YELLOW}-----------------------------------------------------------------------${NC}"
echo "The required resources have been created and configured."
echo "You can now go back to the lab page and click the 'Check my progress' buttons."
echo -e "Thanks for using the ${GREEN}DEVDEBUG${NC} script! 👍\n"

echo -e "${BRED}"
cat << "EOF"

███████╗██╗   ██╗██████╗ ███████╗ ██████╗██████╗ ██╗██████╗ ███████╗    ████████╗ ██████╗     ██████╗ ███████╗██╗   ██╗██████╗ ███████╗██████╗ ██╗   ██╗ ██████╗ 
██╔════╝██║   ██║██╔══██╗██╔════╝██╔════╝██╔══██╗██║██╔══██╗██╔════╝    ╚══██╔══╝██╔═══██╗    ██╔══██╗██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗██║   ██║██╔════╝ 
███████╗██║   ██║██████╔╝███████╗██║     ██████╔╝██║██████╔╝█████╗         ██║   ██║   ██║    ██║  ██║█████╗  ██║   ██║██║  ██║█████╗  ██████╔╝██║   ██║██║  ███╗
╚════██║██║   ██║██╔══██╗╚════██║██║     ██╔══██╗██║██╔══██╗██╔══╝         ██║   ██║   ██║    ██║  ██║██╔══╝  ╚██╗ ██╔╝██║  ██║██╔══╝  ██╔══██╗██║   ██║██║   ██║
███████║╚██████╔╝██████╔╝███████║╚██████╗██║  ██║██║██████╔╝███████╗       ██║   ╚██████╔╝    ██████╔╝███████╗ ╚████╔╝ ██████╔╝███████╗██████╔╝╚██████╔╝╚██████╔╝
╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═════╝ ╚══════╝       ╚═╝    ╚═════╝     ╚═════╝ ╚══════╝  ╚═══╝  ╚═════╝ ╚══════╝╚═════╝  ╚═════╝  ╚═════╝ 
                                                                                                                                                              
EOF
echo -e "${NC}"
