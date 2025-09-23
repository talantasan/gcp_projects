# GCLOUD Commands

## 1. gcloud login  
```
gcloud auth login
gcloud auth application-default login
```
## 2. gcloud projects
```
gcloud projects list
gcloud projects create $PROJECT_NAME
gcloud projects delete $PROJECT_NAME
```

## 3. gcloud config
```
gcloud config list
gcloud config set proejct $PROJECT_ID
```
## 4. gcloud compute instances
```
gcloud compute regions list
gcloud compute instances list
 gcloud compute instances delete talant-vm-1 --zone us-east1-b

 gcloud compute instance-templates list
```
## 5. gcloud storage AND gsutil
```
 gcloud storage buckets create gs://talant-1-471921 --project talant-1-471921
 
 gcloud storage buckets

 gcloud storage buckets list

 gcloud storage buckets list --format "json(name)"

 gcloud storate cp [FILE_NAME] gs://[BUCKET_NAME]

 gsutil mb gs://[BUCKET_NAME]

 gsutil cp [FILE_NAME] gs://[BUCKET_NAME]
```

## 6. Enable google apis
```
gcloud services enable \
iap.googleapis.com \
networkmanagement.googleapis.com
``` 

## 7. SSH into VM machine
```
gcloud compute ssh mynet-us-vm \
--zone=us-east1-c \
--tunnel-through-iap 
```

