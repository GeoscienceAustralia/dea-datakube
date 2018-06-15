S3_BUCKET=$1


aws s3api create-bucket --bucket $S3_BUCKET --region ap-southeast-2 --create-bucket-configuration LocationConstraint=ap-southeast-2
aws s3api put-bucket-versioning --bucket $S3_BUCKET --versioning-configuration Status=Enabled
export KOPS_STATE_STORE=s3://$S3_BUCKET
kops create cluster --zones=ap-southeast-2a,ap-southeast-2b,ap-southeast-2c $S3_BUCKET.k8s.local --yes

