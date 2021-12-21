Step 1: Create a Base Container
Let’s get started by creating a running container. So that we don’t get bogged down in the details of any particular container, we can use nginx.

The Docker create command will create a new container for us from the command line:


Here we have requested a new container named nginx_base with port 80 exposed to localhost. We are using nginx:alpine as a base image for the container.

If we don’t have the nginx:alpine image in our local docker image repository, it will download automatically. 

Step 2: Inspect Images

Step 3: Inspect Containers
Note here that the container is not running, so we won’t see it in the container list unless we use the -a flag (-a is for all).

Step 4: Start the Container
Let’s start the container and see what happens.

Now we visit http://localhost with our browser. We will see the default “Welcome to nginx!” page. We are now running an nginx container.

Step 5: Modify the Running Container
So if we wanted to modify this running container so that it behaves in a specific way, there are a variety of ways to do that.

In order to keep things as simple as possible, we are just going to copy a new index.html file onto the server. You could do practically anything you wanted here.

Let’s create a new index.html file and copy it onto the running container. Using an editor on your machine, create an index.html file in the same directory that you have been running Docker commands from.

Then paste the following HTML into it:

<html>
<head>
<title>Hi Mom</title>
</head>
<body>
<h1>Hi Mom!</h1>
</body>
Then save the file and return to the command line. We will use the docker cp command to copy this file onto the running container.


Now reload your browser or revisit http://localhost. You will see the message “Hi Mom!” in place of the default nginx welcome page.


Step 6: Create an Image From a Container
So at this point, we’ve updated the contents of a running container and as long as we keep that container around, we don’t need to do anything.

However, we want to know how to save this container as an image so we can make other containers based on this one. The Docker commands to do this are quite simple.

To save a Docker container, we just need to use the docker commit command like this:


Now look at the docker images list:


You can see there is a new image there. It does not have a repository or tag, but it exists. This is an image created from the running container. Let’s tag it so it will be easier to find later.

Step 7: Tag the Image
Using docker tag, we can name the image we just created. We need the image ID for the command, so given that the image ID listed above is f7a677e35ee8, our command will be:


And if we look at the index of images again, we can see that the <None>s were replaced:


We can actually use complicated tags here with version numbers and all the other fixings of a tag command, but for our example, we’ll just create an image with a meaningful name.

Step 8: Create Images With Tags
We can also tag the image as it is created by adding another argument to the end of the command like this:


This command effectively commits and tags at the same time, which is helpful but not required.

Step 9: Delete the Original Container
Earlier we started a Docker container. We can see that it is still running using the docker ps command.


Let’s stop the Docker container that is currently running and delete it.


If we list all of the Docker containers, we should have none:


Now, let’s create a new container based on the image we just created and start it.


Note that docker run is the equivalent of executing docker create followed by docker start; we are just saving a step here.

The -d option tells Docker to run the container detached so we get our command prompt back.

Step 10: Look at Running Containers
If we look at the running containers now, we will see we have one called hi_mom:


Now we can go look at http://localhost.


As we can see, the index.html page now shows the “Hi Mom!” message just like we wanted.

Stop the container hi_mom before moving on to the next section.


Step 11: Consider Our Options
There are a few optional things we can do using the commit command that will change information about our images.

For example, we might want to record who the author of our image is or capture a commit message telling us about the state of the image.

These are all controlled through optional parameters to the commit command.

Let’s go back to our original running container. We are going to use a slightly different command here to make cleanup easier:


This command will run the image nginx:alpine with the name nginx_base; the creation of the image will be included in the command execution.

The –rm will cause the container to be deleted when it is shut down. The -d tells the command line client to run in detached mode. This will allow us to run other commands from the same terminal.

So if you visit http://localhost now, you should see the default nginx welcome page.


We went through changing things about the running container above, so I won’t repeat that work here; instead, we want to look at the various options around the commit sub-command.

Option A: Set Authorship
Let’s start by setting the authorship of the image. If you inspect the docker image hi_mom_nginx above, you will discover that its author field is blank.

We will use the docker inspect command to get the details of the image and grep out the author line.


So if we use the author option on the docker commit command, we can set the value of the author field.


And we can check the authorship of that image:


Let’s delete that image and try some other options:


Option B: Create Commit Messages
Let’s say you want a commit message to remind yourself what the image is about or what the state of the container was at the time the image was made.

There is a –message option you can use to include that information.

Execute this command:


Using the image name, we can look at the history of the Docker image to see our message. Here we are using the docker history command to show the change history of the image we created:


Notice that we see the entire history here, and the first entry is from our commit of the running container. The first line listed shows our commit message in the rightmost column.

Let’s remove this image and check out the other options:


Option C: Commit Without Pause
When you use the commit command, the container will be paused.

For our little play container this is unimportant, but you might be doing something like capturing an image of a production system where pausing isn’t an option.

You can add the –pause=false flag to the commit command, and the image will be created from the container without the pause.


If you don’t pause the container, you run the risk of corrupting your data.

For example, if the container is in the midst of a write operation, the data being written could be corrupted or come out incomplete. That is why, by default, the container gets paused before the image is created.

Let’s remove this image and check out the other options:


Option D: Change Configuration
The last option I want to discuss is the -c or –change flag. This option allows you to set the configuration of the image.

You can change any of the following settings of the image during the commit process:

CMD
ENTRYPOINT
ENV
EXPOSE
LABEL
ONBUILD
USER
VOLUME
WORKDIR
Nginx’s original docker file contains the following settings:

CMD [“nginx”, “-g”, “daemon off;”]
ENV NGINX_VERSION 1.15.3
EXPOSE 80
So we will just play with one of those for a moment. The NGINX_VERSION and EXPOSE could cause issues with container startup, so we will mess with the command line (CMD) executed by the container.

Nginx allows us to pass the -T command line argument that will dump its configuration to standard out. Let’s make an image with an alternate CMD value as follows:


Now stop the nginx_base container with this command:


And start a new container from the image we just created:


The configuration for the nginx process will be dumped to standard out when you execute this command. 
