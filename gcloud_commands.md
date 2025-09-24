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

## 8. Create vpc network with custom mode
```
gcloud compute networks create privatenet --subnet-mode=custom


gcloud compute networks list --format="json(name)"
```

## 9. Create/list subnet 
```
gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=us-east1 --range=172.16.0.0/24


gcloud compute networks subnets create privatesubnet-notus --network=privatenet --region=asia-southeast1 --range=172.20.0.0/20

gcloud compute networks subnets list --sort-by=NETWORK

gcloud compute networks subnets list --network NETWORK_NAME


```

## 10. Create/list firewall rules
```
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0


gcloud compute firewall-rules list --sort-by=NETWORK --format=json
```

## 11. Create/List vm instance in a network and subnet
```
gcloud compute instances create privatenet-us-vm --zone=us-east1-c --machine-type=e2-micro --subnet=privatesubnet-us --image-family=debian-12 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=privatenet-us-vm
```

