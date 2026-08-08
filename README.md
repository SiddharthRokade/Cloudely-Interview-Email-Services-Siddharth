# Cloudely Interview Email Services - Siddharth

This repository contains two Invocable Apex classes developed as part of a Salesforce Interview Management System during the Cloudely internship.

## InterviewEmailServiceLevel1

Handles automated interview notification emails for Level 1 interviewers.

### Functionality

- Retrieves Interview and Candidate information using SOQL.
- Retrieves the Level 1 interviewer email address.
- Retrieves the candidate's latest resume from Salesforce Files.
- Uses ContentDocumentLink and ContentVersion for resume retrieval.
- Generates interview notification emails containing candidate details and interview date.
- Attaches the candidate's resume to the email.
- Uses Messaging.SingleEmailMessage to send the notification email.
- Integrates with Record-Triggered Flow using Invocable Apex.

## InterviewEmailServiceLevel2

Handles automated interview notification emails for Level 2 interviewers.

### Functionality

- Retrieves Interview and Candidate information using SOQL.
- Retrieves the Level 2 interviewer email address.
- Retrieves the candidate's latest resume from Salesforce Files.
- Uses ContentDocumentLink and ContentVersion for resume retrieval.
- Generates interview notification emails containing candidate details and interview date.
- Attaches the candidate's resume to the email.
- Uses Messaging.SingleEmailMessage to send the notification email.
- Integrates with Record-Triggered Flow using Invocable Apex.

## Technologies Used

- Salesforce Apex
- Invocable Apex
- SOQL
- Record-Triggered Flow
- Salesforce Files
- ContentDocumentLink
- ContentVersion
- Messaging.SingleEmailMessage

## Project Context

These classes were developed as part of a larger Salesforce Interview Management System during the Cloudely internship.

This repository contains only the Apex components related to the interview email notification functionality.

## Author

Siddharth Rokade
