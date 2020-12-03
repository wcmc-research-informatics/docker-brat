This is a docker package adopted from https://github.com/cassj/brat-docker deploying an instance of [brat](http://brat.nlplab.org/). 
WARNING: This package is intended to install brat on a local secured machine. THIS PACKAGE COMES WITH NO WARRANTIES, USE AT YOUR OWN RISK. 
Do not place sensitive or medical data into brat while running it on public network. 
This package is tested under mac and linux machines, and not tested on Windows machines. 

# Pre-requisite: Docker
If Docker is not already installed on your machine, install it following this link:https://docs.docker.com/engine/install/

# Load annotation data into a folder of you choice
Create a folder on your local machine and load your annotation data into that folder,  Eg. /Users/abc/Desktop/bratdata. 
Edit brat/client-data/annotation.conf file based on your annotation guidelines, and copy to the folder you just created.  
Also create empty files with the extension ".ann" for each annotation text file and should be placed in the same folder as the text file.
Examples: temp.txt, temp.ann, temp2.txt, temp2.ann
You may have subdirectories for data documents. However for each document both .txt and .ann files should be in the same directory. 

# Building the Docker image for the first time
Build an image from Dockerfile by issuing the build command specifying image <name>:<tag>:  
docker build -t <image_name> .
Example:  
docker build -t brat-img . --no-cache

Run the image as a container  
docker run -d --privileged -p <host_port>:<container_port> -v <host_data_dir_you_created>:<container_data_dir> -e BRAT_USERNAME=<admin_username> -e BRAT_PASSWORD=<admin_password> -e BRAT_EMAIL=<admin_email> --name <container_name> <images_name>

Example:   
docker run -d --privileged -p 80:80 -v /Users/abc/Desktop/bratdata:/bratdata -e BRAT_USERNAME=john -e BRAT_PASSWORD=xyz -e BRAT_EMAIL=djohn@example.com --name myBrat brat-img

If everything goes well, go to the address http://localhost:90 on a browser and you should be able to start annotating your documents. Note, that for performing annotation you need to be logged into the tool through the login button on top right.  
Without login, you only get to view documents.

# Additional docker commands
-- To list all images  
docker images

-- To list all containers   
docker ps

- To start a stopped container  
docker start <Container ID or name>

-- To stop a running container  
docker stop <Container ID or name>

Executing on an running container, say to go to a bash terminal  
docker exec -it <Container ID> bash

### Additional users

To add multiple users to the server use `users.json` to list your users and their passwords like so:

```javascript
{
    "user1": "password",
    "user2": "password",
    ...
}
```

## Note
You may stop and start a given container without losing any annotation data.  

