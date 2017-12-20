# lambda-invoke
Testing invoking a lambda function from code

This assumes you have your AWS credentials (access key id and secret key) already figured out and stored in `~/.aws/config` and
`~/.aws/credentials`.

```
brew install terraform
terraform init
terraform plan -out plan
terraform apply plan
```
