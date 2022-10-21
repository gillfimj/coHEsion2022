# 
# Parameters:
#   1 - Container name
#   2 - Image name to be created
#   3 - Application version to be used in the tagging of the image
#   4 - Local port which the application will be mapped to once started
#
# Usage: . build.sh <containerName> <imageName> <version> <port>
#
CNTRNAME=$1
APPIMG=$2
APPVER=$3
PORTNUM=$4

echo "Shutting down container..."
docker stop $CNTRNAME
docker rm $CNTRNAME

echo "Removing image..."
docker rmi $APPIMG
docker build -t $APPIMG:$APPVER .
docker run --name $CNTRNAME -p $PORTNUM:8080 -d --restart unless-stopped  $APPIMG:$APPVER
