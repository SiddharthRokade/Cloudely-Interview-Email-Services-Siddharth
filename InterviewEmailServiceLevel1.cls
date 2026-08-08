public with sharing class InterviewEmailServiceLevel1 {
  public class Request {

        @InvocableVariable(required=true)
        public Id interviewId;

    }

    @InvocableMethod(label='Send Interview Email')
    public static void sendInterviewEmail(List<Request> requests) {

        if (requests == null || requests.isEmpty()) {
            return;
        }

        Id interviewId = requests[0].interviewId;

        // Get Interview Record
        Interview__c interview = [
            SELECT Id,
                   Candidate_Name_CPO__c,
                   Interview_Date_CPO__c
            FROM Interview__c
            WHERE Id = :interviewId
            LIMIT 1
        ];

        // Get Candidate Record
        Candidate__c candidate = [
            SELECT Id,
                   Name,
                   First_Name__c,
                   Last_Name__c,
                   Email__c,
                   Interview_Date__c,
                   Level1_Interviewer__c,
                   Level_2_Interviewer__c,
                   Primary_Skill__c,
                   Total_Experience__c,
                   Relevant_Experience__c
            FROM Candidate__c
            WHERE Id = :interview.Candidate_Name_CPO__c
            LIMIT 1
        ];

        // Get Level 1 Interviewer
        User level1Interviewer;

        if (candidate.Level1_Interviewer__c != null) {
            level1Interviewer = [
                SELECT Id, Name, Email
                FROM User
                WHERE Id = :candidate.Level1_Interviewer__c
                LIMIT 1
            ];
        }

        // Get Level 2 Interviewer
        User level2Interviewer;

        if (candidate.Level_2_Interviewer__c != null) {
            level2Interviewer = [
                SELECT Id, Name, Email
                FROM User
                WHERE Id = :candidate.Level_2_Interviewer__c
                LIMIT 1
            ];
        }

        // Get Resume File
        List<ContentDocumentLink> fileLinks = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :candidate.Id
            LIMIT 1
        ];

        if (fileLinks.isEmpty()) {
            System.debug('No Resume Found');
            return;
        }

        ContentVersion resume = [
            SELECT Id,
                   Title,
                   VersionData,
                   FileExtension
            FROM ContentVersion
            WHERE ContentDocumentId = :fileLinks[0].ContentDocumentId
            AND IsLatest = TRUE
            LIMIT 1
        ];
        // Generate Lightning Record Links
String baseUrl = URL.getOrgDomainUrl().toExternalForm();

String candidateLink =
    baseUrl + '/lightning/r/Candidate__c/' + candidate.Id + '/view';

String interviewLink =
    baseUrl + '/lightning/r/Interview__c/' + interview.Id + '/view';

        // Debug
        System.debug('Interview Record: ' + interview);
        System.debug('Candidate Record: ' + candidate);

        System.debug('Level 1 Interviewer: ' + level1Interviewer);
        System.debug('Level 2 Interviewer: ' + level2Interviewer);

        System.debug('Resume Title: ' + resume.Title);
        System.debug('Resume Extension: ' + resume.FileExtension);

        if (level1Interviewer != null) {
            System.debug('Level 1 Email: ' + level1Interviewer.Email);
        }

        if (level2Interviewer != null) {
            System.debug('Level 2 Email: ' + level2Interviewer.Email);
        }
                // Prepare Email Recipients
        List<String> interviewerEmails = new List<String>();

        if (level1Interviewer != null && level1Interviewer.Email != null) {
            interviewerEmails.add(level1Interviewer.Email);
        }

        if (level2Interviewer != null && level2Interviewer.Email != null) {
            interviewerEmails.add(level2Interviewer.Email);
        }


        // Check if Interviewers exist
        if (interviewerEmails.isEmpty()) {
            System.debug('No interviewer email found');
            return;
        }


      // Create Email
Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

// Send only to Level 1 Interviewer
email.setToAddresses(
    new List<String>{ level1Interviewer.Email }
);

// Subject
email.setSubject(
    'Interview Scheduled - ' +
    candidate.First_Name__c + ' ' +
    candidate.Last_Name__c
);

// HTML Body
String htmlBody =

'Hello ' + level1Interviewer.Name + ',<br/><br/>' +

'You have been assigned as the <b>Level 1 Interviewer</b> for the following candidate.<br/><br/>' +

'<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;">' +

'<tr>' +
'<td><b>Candidate Name</b></td>' +
'<td>' + candidate.First_Name__c + ' ' + candidate.Last_Name__c + '</td>' +
'</tr>' +

'<tr>' +
'<td><b>Email</b></td>' +
'<td>' + candidate.Email__c + '</td>' +
'</tr>' +

'<tr>' +
'<td><b>Primary Skill</b></td>' +
'<td>' + candidate.Primary_Skill__c + '</td>' +
'</tr>' +

'<tr>' +
'<td><b>Total Experience</b></td>' +
'<td>' + String.valueOf(candidate.Total_Experience__c) + '</td>' +
'</tr>' +

'<tr>' +
'<td><b>Relevant Experience</b></td>' +
'<td>' + String.valueOf(candidate.Relevant_Experience__c) + '</td>' +
'</tr>' +

'<tr>' +
'<td><b>Interview Date</b></td>' +
'<td>' + String.valueOf(interview.Interview_Date_CPO__c) + '</td>' +
'</tr>' +

'</table><br/><br/>' +

'<b>Salesforce Records</b><br/><br/>' +

'<a href="' + candidateLink + '">Open Candidate Record</a><br/><br/>' +

'<a href="' + interviewLink + '">Open Interview Record</a><br/><br/>' +

'The candidate resume has been attached with this email.<br/><br/>' +

'Regards,<br/>' +
'<b>Cloudely People Operations Team</b>';

email.setHtmlBody(htmlBody);

// Attach Resume
Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();

attachment.setFileName(
    resume.Title + '.' + resume.FileExtension
);

attachment.setBody(
    resume.VersionData
);

email.setFileAttachments(
    new Messaging.EmailFileAttachment[]{
        attachment
    }
);

// Send Email
Messaging.sendEmail(
    new Messaging.SingleEmailMessage[]{
        email
    }
);

System.debug('Level 1 Interview Email Sent Successfully');