DOCKER_IMAGE_NAME=$1
DOCKER_IMAGE_VERSION=$2

# If script run to error, exist -1;
function _do() 
{
        "$@" || { echo "exec failed: ""$@"; exit -1; }
}

test_Dockerfile(){
    testSSH=$(cat Dockerfile | grep EXPOSE | grep 2222)
    if [ -z "${testSSH}" ]; then 
        echo "FAILED - PORT 2222 isn't opened, SSH isn't working!!!"
        exit 1
    else
        echo "${testSSH}"
        echo "PASSED - PROT 2222 is opened."
    fi

    testVOLUME=$(cat Dockerfile | grep VOLUME)
    if [ -z "${testVOLUME}" ]; then 
        echo "PASSED - Great, there is no VOLUME lines."    
    else
        echo "${testVOLUME}"
        echo "FAILED - These VOLUME lines should not be existed!!!"
        exit 1
    fi
}


echo "========================================"
echo "========================================" >> result.log
echo "Stage1 - Verify Dockerfile"
echo "Stage1 - Verify Dockerfile" >> result.log
echo "INFORMATION: Start to Verifiy Dockerfile......"
echo "Docker: "${DOCKER_IMAGE_NAME}"/"${DOCKER_IMAGE_VERSION}
echo "Docker: "${DOCKER_IMAGE_NAME}"/"${DOCKER_IMAGE_VERSION} >> result.log
_do cd ${DOCKER_IMAGE_NAME}"/"${DOCKER_IMAGE_VERSION}
test_Dockerfile
_do cd ..
_do cd ..
echo "PASSED - Passed this stage." >> result.log
echo "========================================"



