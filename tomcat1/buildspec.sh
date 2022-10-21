#
# Parameters:
#   1 - Image name to be created
#   2 - Application version to be used in the tagging of the image
#   3 - One-up build number to generate
#
# Usage: . buildspec.sh <imageName> <version> <number>
#   Example: . buildspec.sh tomcat 8.5.82 1 dockergenius17
#
IMAGE_REPO_NAME=$1
APP_VERSION=$2
BUILD_NUM=$3
ACCOUNT_INFO=$4 #<your docker hub account>

echo "Building the Docker image..."
docker build -t $IMAGE_REPO_NAME:$APP_VERSION-$BUILD_NUM .
#Setup for pushing to remote docker repository
docker tag $IMAGE_REPO_NAME:$APP_VERSION-$BUILD_NUM $ACCOUNT_INFO/$IMAGE_REPO_NAME:$APP_VERSION-$BUILD_NUM
docker push $ACCOUNT_INFO/$IMAGE_REPO_NAME:$APP_VERSION-$BUILD_NUM