# Energy Efficiency Retrofit Financing System

A comprehensive Clarity smart contract system for managing building energy efficiency retrofits, financing, and performance tracking.

## System Overview

This system provides a complete solution for energy efficiency retrofit financing, covering the entire lifecycle from initial audit to final verification and payment processing.

### Core Components

1. **Property Management** (`property-registry.clar`)
    - Property registration and ownership tracking
    - Building characteristics and baseline energy data
    - Property value assessments and updates

2. **Energy Audit System** (`energy-audit.clar`)
    - Professional energy audits and recommendations
    - Improvement project specifications and cost estimates
    - Audit validation and approval workflows

3. **Financing Platform** (`financing-system.clar`)
    - Loan origination and approval processes
    - Payment scheduling and processing
    - Interest calculations and fee management

4. **Energy Verification** (`energy-verification.clar`)
    - Post-retrofit energy consumption monitoring
    - Savings calculation and verification
    - Performance milestone tracking

5. **Contractor Management** (`contractor-tracking.clar`)
    - Contractor registration and certification
    - Work quality tracking and ratings
    - Payment processing and dispute resolution

## Key Features

- **Transparent Financing**: All loan terms, payments, and balances are recorded on-chain
- **Performance-Based Payments**: Contractor payments tied to verified energy savings
- **Quality Assurance**: Built-in contractor rating and performance tracking
- **Property Value Tracking**: Monitor impact of retrofits on property values
- **Audit Trail**: Complete history of all transactions and improvements

## Contract Architecture

### Data Flow
1. Property owner registers building in `property-registry`
2. Energy audit conducted and recorded in `energy-audit`
3. Financing arranged through `financing-system`
4. Contractor selected and tracked in `contractor-tracking`
5. Energy savings verified in `energy-verification`
6. Payments processed based on verified performance

### Security Features
- Multi-signature requirements for large transactions
- Time-locked payments for contractor work
- Escrow system for dispute resolution
- Role-based access control for different user types

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Node.js and npm for testing
- Basic understanding of Clarity smart contracts

### Installation
\`\`\`bash
npm install
clarinet check
clarinet test
\`\`\`

### Testing
\`\`\`bash
npm test
\`\`\`

## Contract Interactions

### For Property Owners
- Register property and baseline energy data
- Request energy audits
- Apply for retrofit financing
- Monitor energy savings and payments

### For Contractors
- Register and maintain certifications
- Submit bids for retrofit projects
- Track work progress and quality ratings
- Receive performance-based payments

### For Auditors
- Conduct and submit energy audits
- Validate improvement recommendations
- Verify post-retrofit energy savings

### For Lenders
- Review and approve financing applications
- Monitor loan performance and payments
- Access risk assessment data

## Error Codes

- `ERR-NOT-AUTHORIZED (u100)`: Caller lacks required permissions
- `ERR-INVALID-INPUT (u101)`: Invalid input parameters
- `ERR-NOT-FOUND (u102)`: Requested resource not found
- `ERR-ALREADY-EXISTS (u103)`: Resource already exists
- `ERR-INSUFFICIENT-FUNDS (u104)`: Insufficient balance for operation
- `ERR-INVALID-STATE (u105)`: Operation not valid in current state
- `ERR-EXPIRED (u106)`: Time-sensitive operation has expired
- `ERR-QUALITY-THRESHOLD (u107)`: Work quality below minimum threshold

## License

MIT License - see LICENSE file for details
