# lambda-invoke
Testing invoking a lambda function from code.

This assumes you have your AWS credentials (access key id and secret key) already figured out and stored in `~/.aws/config` and
`~/.aws/credentials`.

Upload the lambda function:
```
brew install terraform
terraform init
terraform plan -out plan
terraform apply plan
```
Then invoke it from node code:
```
npm install
node index.js
```
