1. Build the docker image with 
```docker build --tag mipsx .```
2. Create a new copy of the armx directory contents
3. Start a new image with 
```docker run -i -t --privileged -v <PATH_TO_NEW_ARMX>:/armx mipsx<N>```
4. The end user should attach to  
```docker exec -it $(docker ps | awk '/mipsx<N>/ {print $1}') bash```