# Building the gathee base image

## Prerequisites

1. Ensure the following;
- You have a [google cloud account](https://console.cloud.google.com/).
- You have a [google cloud project](https://cloud.google.com/resource-manager/docs/creating-managing-projects).
- You have enabled the Compute Engine API.
- You have installed packer as instructed [here](https://www.packer.io/downloads.html) and that it's executable from your terminal.

2. Clone the repository as follows;

 ```
 git clone https://github.com/xcixor/gathee-deployment.git
 cd base-image
 ```

3. Setup the service account;
  Instructions to create a service account can be found [here](https://cloud.google.com/iam/docs/creating-managing-service-accounts). The role that the account will be able to perform is the most crucial part of setting up the account. The minimum capabilities that the account should have are Compute Image User, Compute Instance Admin and Service Account Actor. Download the Service Account JSON key to your machine after giving the Service Account its roles.

  Once you have gotten the key, change the name of the file [account.json.example](../account/account.json.example) to account.json. This file is located under the *account* directory. Delete the contents in the file and paste your JSON key here.

4. Setup Environment Variables
   Firstly, change the name of the [variables.json.example](./variables.json.example) file to variables.json. This file contains a key value pair of the id of your google cloud platform project. The id is a unique identifier for the project and notifies packer the project that you are building a custom image for.

   Next, provide values for each of the keys shown in the table below. A description of the value needed has been given:

   | **Key**           | **Value Description**|
   |-------------------|----------------------|
   | project_id        | Provide the google project id where you are hosting your application on|

5. Validate and build the base image.

```
packer validate --var-file variables.json packer.json
packer build --var-file variables.json packer.json
```

6. Visit GCP console to confirm that your image has been created.

  On the menu page under Compute Engine click on Images.
  ![Images-GCE-Menu](../../docs/images/images-gce.png)

  You should be able to see the image pelly-base-image on the list of images.
  ![Pelly-Base-Image](../../docs/images/dashboard.png)