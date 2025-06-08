# Tech Eazy AWS DevOps Automation - Alwin Roy

## 🔧 Project Overview

This project automates the following:
- Spin up AWS EC2
- Install Java and app dependencies
- Clone and deploy Java app
- Make app available on port 80
- Shut down after set time

## 🚀 Usage

### 1. Clone this Repo

```bash
git clone https://github.com/alwinroy25/tech_eazy_alwinroy25_aws_devops.git
cd tech_eazy_alwinroy25_aws_devops
```

### 2. Setup AWS CLI with IAM credentials

```bash
aws configure
```

### 3. Run the Automation

```bash
bash setup.sh Dev
```

Or for Prod:

```bash
bash setup.sh Prod
```

## 📁 Directory Structure

```
.
├── setup.sh
├── config/
│   ├── dev_config
│   └── prod_config
├── resources/
│   └── Techeazy.postman_collection.json
├── app/
│   └── techeazy-devops/
```

## 🧪 Testing

Import `resources/Techeazy.postman_collection.json` into Postman and test the `GET /` endpoint.

## 🔐 Security

> **Note:** AWS credentials are **NOT** stored in this repo. They're loaded from the environment via AWS CLI config.
