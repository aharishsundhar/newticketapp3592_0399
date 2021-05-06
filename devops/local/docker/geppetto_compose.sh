#!bin/bash

DESKTOPCODE='../../../application/client/desktop/newticketapp3592'

COMPOSEPATH='../../../../devops/local/docker/'

ENVPATH='../../.env'


while getopts :cdrs option
do
    case "$option" in
    c)  
         echo "Creating new docker images and containers"
         cd $DESKTOPCODE
         docker build -t newticketapp3592ui-0399 .
         docker run --name newticketapp3592ui-0399 --restart=unless-stopped -d -p 5055:5000 newticketapp3592ui-0399
         sleep 15
         echo "UI build is done..."

         cd $COMPOSEPATH
         docker-compose up -d --build
         echo "uploading the mongo script..."
         sleep 50
         docker cp mongo.js mongo-0399:/data/db/
         docker exec -ti mongo-0399 mongo -u admin -p 'password' --authenticationDatabase 'admin' newticketapp3592_0399 /data/db/mongo.js
         sleep 10
         echo "Process completed"
         echo " Your application is deployed here the link, http://localhost:5055 "
         ;;
    d)
         echo "Now Deleting all containers and images"
         docker-compose down -v --rmi all 
         docker rm -f newticketapp3592ui-0399
         docker rmi newticketapp3592ui-0399
         echo "Process completed"
         ;;
    r)
         echo "Now Re-starting the stopped containers"
         docker-compose start
         docker restart newticketapp3592ui-0399
         sleep 35
         echo "Process completed"
         ;;
    s)
         echo "Now stopping the running containers"
         docker-compose stop
         docker stop newticketapp3592ui-0399
         echo "Process completed"
         ;;
    *)
        echo "Hmm, an invalid option was received. the valid option are."
        echo "Flag c - To Create new containers and images."
        echo "Flag d - To Delete all the containers and images."
        echo "Flag r - To Restart the stopped containers."
        echo "Flag s - To Stop the running containers."
        echo "Here's the usage statement:"
        echo ""
        echo "bash geppetto_compose.sh -c (or) bash geppetto_compose.sh -d (or) bash geppetto_compose.sh -r (or) bash geppetto_compose.sh -s"
       
       ;;
        esac
done

echo ""
echo "These are the usage options for help."
echo "Flag c - To Create new containers and images."
echo "Flag d - To Delete all the containers and images."
echo "Flag r - To Restart the stopped containers."
echo "Flag s - To Stop the running containers."
echo "Here's the usage statement:"
echo ""
echo "bash geppetto_compose.sh -c (or) bash geppetto_compose.sh -d (or) bash geppetto_compose.sh -r (or) bash geppetto_compose.sh -s"
