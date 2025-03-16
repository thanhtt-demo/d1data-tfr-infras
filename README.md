# D1Data Infrastructure as Code

This repository contains Terraform and Terragrunt configurations for managing D1Data cloud infrastructure in AWS using a DRY (Don't Repeat Yourself) approach.

## Project Structure

```
d1data-tfr-infras/
├── _envcommon/                 # Common module configurations
│   ├── ec2-instance.hcl        # Common EC2 instance configuration
│   ├── key-pair.hcl            # Common key pair configuration
│   ├── s3-bucket.hcl           # Common S3 bucket configuration
│   ├── s3-tables.hcl           # Common S3 tables configuration
│   ├── security-group.hcl      # Common security group configuration
│   └── vpc.hcl                 # Common VPC configuration
├── modules/                    # Custom Terraform modules
│   └── s3tables/               # S3 tables module
├── non-prod/                   # Non-production environment
│   ├── dev/                    # Development environment
│   │   ├── ap-southeast-1/     # Singapore region
│   │   │   ├── ec2/           # EC2 resources
│   │   │   ├── s3/            # S3 resources
│   │   │   └── vpc/           # VPC configuration
│   │   └── env.hcl            # Dev environment variables
│   ├── account.hcl            # Non-prod account variables
│   └── ...
├── common.hcl                 # Common variables for all environments
└── root.hcl                   # Root Terragrunt configuration
```

## Prerequisites

- Terraform >= 1.10.5
- Terragrunt >= 0.70.2
- AWS CLI configured with appropriate credentials
- S3 bucket for remote state storage
- DynamoDB table for state locking

## Configuration Files

The project uses several configuration files to maintain environment variables:

- **root.hcl**: Base configuration for all environments
- **common.hcl**: Common variables across all environments
- **account.hcl**: Account-specific variables
- **region.hcl**: Region-specific variables
- **env.hcl**: Environment-specific variables

## Feature Flags

The infrastructure supports selective deployment using feature flags. To enable or disable specific components:

1. In a component's terragrunt.hcl file, add:
   ```hcl
   locals {
     enabled = true  # or false to disable
   }

   skip = !local.enabled
   ```

2. Run Terragrunt as usual - disabled components will be skipped

## Usage

### Basic Commands

```bash
# Navigate to the desired component directory
cd non-prod/dev/ap-southeast-1/vpc

# Initialize Terragrunt and the underlying Terraform configuration
terragrunt init

# Preview changes
terragrunt plan

# Apply changes
terragrunt apply

# Destroy resources
terragrunt destroy
```

### Managing Multiple Components

```bash
# Apply all components in an environment
cd non-prod/dev/ap-southeast-1
terragrunt run-all apply

# Apply specific components
terragrunt run-all apply --terragrunt-include-dir="*/vpc" --terragrunt-include-dir="*/ec2/*"

# Destroy all components
terragrunt run-all destroy
```

## State Management

State files are stored remotely in AWS S3 with the following configuration:

- **Bucket**: `d1data-remote-state`
- **Key**: Based on relative path within the repository
- **Region**: Defined in the region.hcl file
- **DynamoDB Table**: `d1data-terraform-locks` (for state locking)
- **Encryption**: Enabled

## Line Ending Handling

When working in a mixed-environment team (Windows, macOS, Linux), you might see Git warnings about CRLF/LF line endings. This is normal and helps maintain consistency across operating systems.

To standardize line endings, add a `.gitattributes` file to the repository:

```
# Set default behavior to automatically normalize line endings
* text=auto

# Explicitly declare text files
*.tf text
*.hcl text
*.md text
*.sh text eol=lf
```

## Troubleshooting

### Common Issues

1. **AccessControlListNotSupported Error**:
   - Modern S3 buckets use Object Ownership with "Bucket owner enforced" and don't support ACLs
   - Solution: Remove ACL settings and use `object_ownership = "BucketOwnerEnforced"`

2. **Invalid Lifecycle Rule Configuration**:
   - AWS Provider has updated the expected format for S3 lifecycle rules
   - Solution: Follow the updated format with proper filter configuration

3. **Missing HCL Files**:
   - Ensure all required .hcl files exist in the expected parent folders
   - Check for common.hcl, account.hcl, region.hcl, and env.hcl

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
