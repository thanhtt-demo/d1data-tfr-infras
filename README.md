# D1Data Infrastructure as Code

This repository contains Terraform and Terragrunt configurations for managing D1Data cloud infrastructure.

## Prerequisites

- Terraform >= 1.10.5
- Terragrunt >= 0.70.2
- AWS CLI configured with appropriate credentials

## Configuration

The project uses Terragrunt for maintaining DRY infrastructure code. Key configurations:

- Remote state stored in S3 bucket: `d1data-remote-state`
- State locking using DynamoDB table: `d1data-terraform-locks`
- AWS provider configuration generated automatically
- Environment-specific variables managed through HCL files

## Usage

1. Navigate to demo directory
2. Run terragrunt commands:

```bash
terragrunt init
terragrunt plan
terragrunt apply
```

## State Management

State files are stored remotely in AWS S3 with the following configuration:

- Bucket: `d1data-remote-state`
- Key: Based on relative path
- Region: Defined in region.hcl
- Encryption: Enabled

## License

Copyright 2024 D1Data

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
