# Go to GitHub and create a `private` repository `phonebook` then clone to your local

```bash (pwd : /home/ec2-user)
git clone git clone https://****TOKEN*****@github.com/USER/phonebook.git
```

- In the `phonebook-app.py` application --->>> you can change developer names

- In the `templates/*.html` files  --->>> you can change names

# copy-paste `templates` directory and `phonebook-app.py` into local repository (phonebook), push the changes then check your remote repository

```bash (pwd : /home/ec2-user)
cd phonebook
git add .
git commit -m "first commit"
git push
```

# Normally how can we run application written in `python`? With terraform we prepare configuration files in order to create infrastructure for our application, in this infrastructure there will be `ec2-instances` that will be running behind the `Application Load Balancer`. We need to clone our remote repo into these instances and then execute python command to run the application. How can we automate these transactions? -->> We prepare a `userdata`.

```bash (pwd : /home/ec2-user)
ls phonebook    #   - phonebook-app.py      - templates
python3 /home/ec2-user/phonebook/phonebook-app.py
```


### for accessing your AWS account  (3 ways : 1. execute `aws configure` command , 2. writing you credentials in `provider` , 3. Using `Policy-Role`). If you have already installed terraform on your local PC and installed AWS CLI and made `aws configure`, you have a `.aws` directory that includes your credentials, so you do not need to do anything extra.

- `Hard-coding` credentials (credentials in `provider`) into any Terraform configuration is `NOT` recommended, and risks secret leakage should this file ever be committed to a public version control system. 
- Using AWS credentials in EC2 instance (executing `aws configure` command using AWS CLI) is not recommended.

```go   (NOT RECOMMENDED)
provider "aws" {
  region = "us-east-1"
  //  access_key = ""
  //  secret_key = ""

}
```
```bash (NOT RECOMMENDED)
aws configure
```

- `RECOMMENDED` Create a role in IAM management console. Secure way to make API calls is to create a role and assume it. It gives temporary credentials for access your account and makes API calls.
    - Go to the IAM service, click "roles" in the navigation panel on the left then click "create role". 
    - Under the use cases, Select `EC2`, click "Next Permission" button.
    - In the search box write EC2 and select `AdministratorAccess`  then click "Next: Tags" and "Next: Reviews".
    - Name it `terraform`.
    - Attach this role to your EC2 instance. (Actions - Security - Modify)


# Connect to web-server in order to connect you database and to check the data in the database

- Connect to one of the instance `Web Server of Phonebook App` (ec2-instance you created using terraform) with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

- install mysql into one of the `Web Server of Phonebook App` (ec2-instance you created using terraform) and execute commands below in order to connect your database and check the data

```bash (pwd : home/ec2-user)
sudo dnf install mysql
mysql -u admin -p -h phonebook-app-db.cpzb4jp3x0uy.us-east-1.rds.amazonaws.com  # copy-paste RDS endpoint

SHOW DATABASES;
use phonebook;
SHOW TABLES;
SELECT * FROM phonebook;
```

# graph
- Go to the terminal and run `terraform graph`. It creates a visual graph of Terraform resources. The output of "terraform graph" command is in the DOT format, which can easily be converted to an image by making use of dot provided by GraphViz.

- Copy the output and paste it to the `https://dreampuf.github.io/GraphvizOnline`. Then display it. If you want to display this output in your local, you can download graphviz (`sudo yum install graphviz`) and take a `graph.svg` with the command `terraform graph | dot -Tsvg > graph.svg`.

```bash
terraform graph

sudo yum install graphviz
terraform graph | dot -Tsvg > graph.svg
```