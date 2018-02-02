DOCKER_IMAGE_NAME=$1
DOCKER_IMAGE_VERSION=$2

# If script run to error, exist -1;
function _do() 
{
        "$@" || { echo "exec failed: ""$@"; exit -1; }
}

build_image(){
    echo "${DOCKER_PASSWORD}" | _do docker login -u="${DOCKER_USERNAME}" --password-stdin	
    _do cd ${DOCKER_IMAGE_NAME}"/"${DOCKER_IMAGE_VERSION}
    _do docker build -t "${DOCKER_IMAGE_NAME}" .
    _do cd $TRAVIS_BUILD_DIR    
    testBuildImage=$(docker images | grep "${DOCKER_IMAGE_NAME}")
    if [ -z "${testBuildImage}" ]; then 
        echo "FAILED - Build fail!!!"
        exit 1
    else
        echo "${testBuildImage}"        
        echo "PASSED - Build Successfully!!!."
        echo "PASSED - Build Successfully!!!." >> result.log
    fi
}

setTag_push_rm(){
    echo "TAG: ${TAG}"
    _do docker tag "${DOCKER_IMAGE_NAME}" "${DOCKER_USERNAME}"/"${DOCKER_IMAGE_NAME}":"${TAG}"
    testBuildImage=$(docker images | grep "$TAG")
    if [ -z "${testBuildImage}" ]; then 
        echo "FAILED - Set TAG Failed!!!"
        exit 1
    else
        echo "${testBuildImage}"
        echo "${testBuildImage}" >> result.log
        echo "PASSED - Set TAG Successfully!."
        echo "PASSED - Set TAG Successfully!." >> result.log
    fi
    _do docker push "${DOCKER_USERNAME}"/"${DOCKER_IMAGE_NAME}":"${TAG}"
    echo "PASSED - Pushed  ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${TAG} Successfully!."
    echo "PASSED - Pushed  ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${TAG} Successfully!." >> result.log
    echo "INFORMATION: Before rmi - docker images"
    _do docker images
    echo "INFORMATION - RM ""${DOCKER_USERNAME}"/"${DOCKER_IMAGE_NAME}":"${TAG}"
    _do docker rmi "${DOCKER_USERNAME}"/"${DOCKER_IMAGE_NAME}":"${TAG}"
    echo "INFORMATION - After rmi - docker images"
    _do docker images
}

echo "Stage2 - Build Image"
echo "INFORMATION - Start to Build......"
echo "INFORMATION - Start to Build......"${DOCKER_IMAGE_NAME}":"$DOCKER_IMAGE_VERSION >> result.log
build_image
echo "========================================"
echo "========================================" >> result.log

echo "Stage3 - Set Tag and Push"
echo "Stage3 - Set Tag and Push" >> result.log
echo "Build Number: ${TRAVIS_BUILD_NUMBER}"
echo "TRAVIS_EVENT_TYPE: ${TRAVIS_EVENT_TYPE}"
echo "TRAVIS_COMMIT_MESSAGE: ${TRAVIS_COMMIT_MESSAGE}"

pushed="false"
# "#sign-off exist!"
if [ "$DOCKER_USERNAME" == "$PROD_DOCKER_USERNAME" ]; then
    echo "INFORMATION - This time, push to production environment......"
    TAG=${DOCKER_IMAGE_VERSION}
    echo "INFORMATION - Set TAG as ""${TAG}"" and push......" 
    setTag_push_rm
    pushed="true"
fi
if [ "${pushed}" == "false" ]; then
        TAG=${DOCKER_IMAGE_VERSION}"-"${TRAVIS_BUILD_NUMBER}
        echo "INFORMATION: Set TAG as ""${TAG}"" and push......"
        setTag_push_rm
fi

echo "========================================"
echo "Stage4 - PULL and Verify"
echo "INFORMATION - Start to Pull ""${DOCKER_USERNAME}"/"${DOCKER_IMAGE_NAME}":"${TAG}"
echo "INFORMATION - Before Pull - docker images"
_do docker images
_do docker run -d -p 80:80 --name testdocker $DOCKER_USERNAME/${DOCKER_IMAGE_NAME}:"$TAG"
echo "INFORMATION: After Pull - docker images"
_do docker images
testBuildImage=$(docker images | grep "${TAG}")
    if [ -z "$testBuildImage" ]; then 
        echo "FAILED - Docker pull and run Failed!!!"
        docker images
        exit 1
    else
        echo "$testBuildImage"
        echo "$testBuildImage" >> result.log
        echo "PASSED - Docker image pull and run Successfully!. You can manually verify it!"
        echo "PASSED - Docker image pull and run Successfully!. You can manually verify it!" >> result.log
    fi
_do docker stop testdocker
_do docker rm testdocker
_do docker rmi ${DOCKER_USERNAME}"/"${DOCKER_IMAGE_NAME}":"${TAG}
echo "========================================"
echo "========================================" >> result.log

