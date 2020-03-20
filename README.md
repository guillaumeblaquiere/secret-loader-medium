# Secret loader Medium
This project is in relation with [the medium article](https://medium.com/google-cloud/secret-manager-improve-cloud-run-security-without-changing-the-code-634f60c541e6)
that explain how to preload secret in Cloud Run without changing the application code 

The process run a script before running the app. It works only on environment variable.
In serverless environment, only Cloud Run is compliant. (and App Engine Flexible, because it's compliant with container)

# Test the secret-loader
The test is performed with Cloud Run.

## Create a secret
Create a secret into secret manager

```
echo "my super secret" | gcloud beta secrets create --data-file=- --replication-policy=automatic my-secret
```

## Create a service account
You have to allow Cloud Run service account to access to secret manager

Create the service account
```
gcloud iam service-accounts create cr-access-secret
```

Either allow full access to secret manager and can access to all secrets
```
gcloud projects add-iam-policy-binding \
--member=serviceAccount:cr-access-secret@<PROJECT_ID>.iam.gserviceaccount.com \
--role=roles/secretmanager.secretAccessor <PROJECT_ID>
```

Or allow the access to a specific secret
```
gcloud beta secrets add-iam-policy-binding  \
--member=serviceAccount:cr-access-secret@<PROJECT_ID>.iam.gserviceaccount.com \
--role=roles/secretmanager.secretAccessor my-secret
```

## Build the test container
The test container only print the environment variable when you call the root URL. 
2 versions exists

Build the script version based on gcloud SDK 
```
gcloud builds submit -t gcr.io/<PROJECT_ID>/secret-loader
```
The file [`start.sh`](https://github.com/guillaumeblaquiere/secret-loader-medium/blob/master/start-gcloud.sh)
contains a bash script and use `gcloud` command for loading the secret. The [`Dockerfile`](https://github.com/guillaumeblaquiere/secret-loader-medium/blob/master/Dockerfile.gcloud)
file is used during the build. The latest layer is the gcloud SDK container. It's a big image (700Mb)

## Deploy the container
The container must be deployed with the previously created service account and with the secret in parameter

```
gcloud run deploy --image=gcr.io/<PROJECT_ID>/secret-loader --platform=managed  \
--region=us-central1 --allow-unauthenticated \
--service-account=cr-access-secret@<PROJECT_ID>.iam.gserviceaccount.com \
--set-env-vars=super_secret=secret:/my-secret#1 secret-loader
```

## Test the secret loader transformation
Perform a simple curl on the URL and check the environment variable `super_secret` value returned

```
curl https://secret-loader.<project-hash>-uc.a.run.app
```


# License

This library is licensed under Apache 2.0. Full license text is available in
[LICENSE](https://github.com/guillaumeblaquiere/secret-loader-medium/tree/master/LICENSE).
