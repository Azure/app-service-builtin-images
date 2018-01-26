## Best practices

These docker images listed are to be used with Web App for Containers , check out things you should know about [Web App for Containers](https://blogs.msdn.microsoft.com/waws/2017/09/08/things-you-should-know-web-apps-and-linux/)Follow the best practices as listed below :

1. Follow the best practices for writing a docker image as listed [here](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/). Note that , Web app for containers has a few limitations that are not supported : 

- Do not use VOLUME , USER instructions
- Do not use ```chown``` statements
- You can use only ONE port in additional to using the port for SSH i.e 2222

2. Include [SSH support](https://docs.microsoft.com/en-us/azure/app-service/containers/app-service-linux-ssh-support) in your docker image to allow users using the image to debug issues. 
3. Learn how to use the custom image on [Web App for Containers](https://docs.microsoft.com/en-us/azure/app-service/containers/quickstart-custom-docker-image). Since the platform is different than local Docker engine hosted machine , it is a good practice to test your build your image in Azure using web app for containers. 

