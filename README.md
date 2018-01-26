# App Service Linux - Built in runtime Docker images

This repo contains all docker images for App Service on Linux Built in runtime for PHP , Ruby , Node JS and .NET core. 	

## Contribution guide

Please follow the guidelines to be compliant . If any docker image is out of compliance , it will be **blacklisted** from this repo and eventually removed. 

## Files, folders and naming conventions
1. Create a new folder for a new docker image and include a version folder . Such as 
```
+my-image
	         \  version-number
		       \Dockerfile and other files 
		
```
 
 *Note:  If you are updating an existing image  , create a new version folder within your image folder.*
  
2.Include a README.md within version folder to describe :
		a. Any changes with deployment of use of the image 
		b. Include comments if the image is not backward compatible and how user can manually upgrade to new version 


+ [**Best practices**](/contribution-guide/best-practices.md). Best practices for improving the quality of your docker image
+ [**Git tutorial**](/contribution-guide/git-tutorial.md). Step by step to get you started with Git.
+ [**Useful Tools**](/contribution-guide/useful-tools.md). Useful resources and tools for docker image development

## Submission workflow 
The submission process 6 step process as shown below. The time taken to approve or reject a PR can vary as this is community driven. 

![Submission workflow for docker images](images/submission-flow.PNG?raw=true)

## Deploying Samples
You can deploy these directly from the Azure portal. 

1. Login to [Azure portal](https://portal.azure.com)
2. Search for "Web App" 
3. Select Linux OS 


*Note: The first request can take longer to complete since the docker image needs to be pulled and run on the container for the first request. This can occur when you scale up your application or the instance gets recycled.*


