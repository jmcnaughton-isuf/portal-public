/*
 * Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
 *                     http://www.ucinnovation.com
 *
 * This source code is licensed, not sold, and is subject to a written
 * license agreement.  Among other things, no portion of this source
 * code may be copied, transmitted, disclosed, displayed, distributed,
 * translated, used as the basis for a derivative work, or used, in
 * whole or in part, for any program or purpose other than its intended
 * use in compliance with the license agreement as part of UC Innovation's
 * software.  This source code and certain of the algorithms contained
 * within it are confidential trade secrets of UC Innovation, Inc.
 * and may not be used as the basis for any other
 * software, hardware, product or service.
 */

@isTest
public class PORTAL_CommunityUtilsTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact con;
        public User communityUser;
        public Account acct;
        public Id profileId;
        public ucinn_portal_Custom_Form_Field__c formFieldPicklist;
        public ucinn_portal_Custom_Form_Field__c formFieldMultiPicklist;
        public ucinn_portal_Custom_Form_Field__c formFieldCheckbox;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupUserData() {
            System.runAs(thisUser) {

                profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com',
                                ucinn_portal_Is_Display_On_Portal__c = true);
                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                communityUser = new User(alias = 'comUser',
                                        email = 'testCommunityUsermig123@test.com',
                                        emailencodingkey='UTF-8',
                                        lastname = 'Batman',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        IsActive = true,
                                        ContactId = con.Id,
                                        timezonesidkey='America/Los_Angeles',
                                        username = System.now().millisecond() + 'testCommunityUsermig123@test.com');
                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;

                System.debug('communityUser: ' + communityUser.Id);
                System.debug('communityUser.ContactId: ' + communityUser.ContactId);
            }
        }

        public virtual void setupFormField() {
            ucinn_portal_Registration_Template__c newTemplate = new ucinn_portal_Registration_Template__c();
            newTemplate = (ucinn_portal_Registration_Template__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newTemplate});
            insert newTemplate;

            ucinn_portal_Registration_Page__c newPage = new ucinn_portal_Registration_Page__c(Name = 'Test Page', Order_Number__c = 1, Registration_Template__c = newTemplate.Id);
            newPage = (ucinn_portal_Registration_Page__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newPage});
            insert newPage;

            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
            ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c(Name = 'Test Event',
                                                                            Header_Content__c = 'This is a Test.',
                                                                            RecordTypeId = recordTypeId,
                                                                            Status__c = 'Published',
                                                                            Registration_Template__c = newTemplate.Id);
            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            ucinn_portal_Ticket_Type__c newTicketType = new ucinn_portal_Ticket_Type__c(Listing__c = newListing.Id, Price__c = 5);
            newTicketType = (ucinn_portal_Ticket_Type__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newTicketType});
            insert newTicketType;


            formFieldPicklist = new ucinn_portal_Custom_Form_Field__c(Field_Label__c = 'test',
                                                                     Is_Required__c = false,
                                                                     Field_Type__c = 'Picklist',
                                                                     Field_Order__c = 1,
                                                                     Available_Values__c = 'test1;test2;test3',
                                                                     Registration_Template__c = newTemplate.Id,
                                                                     Ticket_Type__c = newTicketType.Id,
                                                                     Registration_Page__c = newPage.Id);

            formFieldMultiPicklist = new ucinn_portal_Custom_Form_Field__c(Field_Label__c = 'test2',
                                                                      Is_Required__c = false,
                                                                      Field_Type__c = 'Multi-Picklist',
                                                                      Field_Order__c = 2,
                                                                      Default_Value__c = 'test1;test2;test3',
                                                                      Registration_Template__c = newTemplate.Id,
                                                                      Ticket_Type__c = newTicketType.Id,
                                                                      Registration_Page__c = newPage.Id);

            formFieldCheckbox = new ucinn_portal_Custom_Form_Field__c(Field_Label__c = 'test3',
                                                                      Is_Required__c = false,
                                                                      Field_Type__c = 'Checkbox',
                                                                      Field_Order__c = 3,
                                                                      Registration_Template__c = newTemplate.Id,
                                                                      Ticket_Type__c = newTicketType.Id,
                                                                      Registration_Page__c = newPage.Id);

            formFieldPicklist = (ucinn_portal_Custom_Form_Field__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => formFieldPicklist});
            formFieldMultiPicklist = (ucinn_portal_Custom_Form_Field__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => formFieldMultiPicklist});
            formFieldCheckbox = (ucinn_portal_Custom_Form_Field__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => formFieldCheckbox});

            insert formFieldPicklist;
            insert formFieldMultiPicklist;
            insert formFieldCheckbox;
        }


        public virtual void testUserContactInfo() {
            setupUserData();

            PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => communityUser.Id});
            PORTAL_CommunityUtils.getLoggedInUserInfo(communityUser.Id);
        }

        public virtual void testHasNetworkId() {
            PORTAL_CommunityUtils.testHasNetworkId = true;

            PORTAL_CommunityUtils.testHasUrlPathPrefix = true;
            PORTAL_CommunityUtils.testHasNetwork = true;
            PORTAL_CommunityUtils.getBaseUrl();
            PORTAL_CommunityUtils.getCommunityPrefixName();

            PORTAL_CommunityUtils.testHasUrlPathPrefix = true;
            PORTAL_CommunityUtils.testHasNetwork = false;
            PORTAL_CommunityUtils.getBaseUrl();

            PORTAL_CommunityUtils.testHasUrlPathPrefix = false;
            PORTAL_CommunityUtils.testHasNetwork = true;
            PORTAL_CommunityUtils.getBaseUrl();

            PORTAL_CommunityUtils.testHasUrlPathPrefix = false;
            PORTAL_CommunityUtils.testHasNetwork = false;
            PORTAL_CommunityUtils.getBaseUrl();
        }

        public virtual void testHasNoNetworkId() {
            PORTAL_CommunityUtils.testHasNetworkId = false;
            PORTAL_CommunityUtils.getBaseUrl();
            PORTAL_CommunityUtils.getCommunityPrefixName();
        }

        public virtual void testGetPicklists() {
            Test.startTest();
           // PORTAL_CommunityUtils.SERVER_getPicklists(new Map<String, List<String>>{'Contact' => new List<String>{'ucinn_ascendv2__Gender__c'}});

            URL request = URL.getCurrentRequestUrl();
            String urlString = request.toExternalForm();
            String host = request.getHost();
            String endpointURL = urlString.substringBefore(host) + host;
            Id recordTypeId = Schema.SObjectType.ucinn_ascendv2__Degree_Information__c.getRecordTypeInfosByDeveloperName().get('Non_School_Degree_Information').getRecordTypeId();
            endpointURL += '/services/data/v41.0';
            endpointURL += '/ui-api/object-info/' +  'ucinn_ascendv2__Degree_Information__c' + '/picklist-values/' + String.valueOf(recordTypeId) +'/' + 'ucinn_ascendv2__Degree__c';

            PORTAL_HttpMockCallout mockCallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockCallouts);

            mockCallouts.addRequest('{"value":[{"value":"test", "label":"test"}]}', endpointURL);
            PORTAL_CommunityUtils.SERVER_getPicklistByRecordType('ucinn_ascendv2__Degree_Information__c', String.valueOf(recordTypeId), 'ucinn_ascendv2__Degree__c');

            mockCallouts.deleteAllRequests();

            mockCallouts.addRequest('{"values":[{"value":"test", "label":"test"}]}', endpointURL);
            PORTAL_CommunityUtils.SERVER_getPicklistByRecordType('ucinn_ascendv2__Degree_Information__c', String.valueOf(recordTypeId), 'ucinn_ascendv2__Degree__c');

            //PORTAL_CommunityUtils.SERVER_getPicklistEntries(new Map<String, List<String>>{'Contact' => new List<String>{'ucinn_ascendv2__Gender__c'}});
            Test.stopTest();
        }

        public virtual void testGetUserProfile() {
            setupUserData();
            System.runAs(communityUser) {
                String profileName = PORTAL_CommunityUtils.SERVER_getUserProfile();
                System.assertEquals(profileName, 'ascend Customer Community User');
            }
        }

        // @isTest
        // public static void testGetUserAccessLevel() {
        //     setupUserData();
        //     PORTAL_CommunityUtils.SERVER_getUserAccessLevel(new List<String>{'Submit_Events__c'}, 'All');

        //     Zone__c zone = new Zone__c();
        //     zone.Name = 'Alumni Club';
        //     zone.Is_Display_on_Portal__c = true;
        //     insert zone;

        //     Zone_Access_Level__c accessLevel = new Zone_Access_Level__c();
        //     accessLevel.Name = 'Volunteer';
        //     accessLevel.Submit_Events__c = true;
        //     insert accessLevel;

        //     Zone_Membership__c membership = new Zone_Membership__c();
        //     membership.Zone__c = zone.Id;
        //     membership.Constituent__c = con.Id;
        //     membership.Zone_Access_Level__c = accessLevel.Id;
        //     insert membership;

        //     System.runAs(communityUser) {
        //         PORTAL_CommunityUtils.SERVER_getUserAccessLevel(new List<String>{'Submit_Events__c'}, '');
        //         PORTAL_CommunityUtils.SERVER_getUserAccessLevel(new List<String>{'Submit_Events__c'}, 'Alumni Club');
        //     }
        // }

        public virtual void testHashObjectFields() {

            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                                    ucinn_ascendv2__Address_Line_2__c = '#110',
                                                                                    ucinn_ascendv2__Address_Line_3__c = '',
                                                                                    ucinn_ascendv2__City__c = 'Irvine',
                                                                                    ucinn_ascendv2__Country__c = 'United States',
                                                                                    ucinn_ascendv2__State__c = 'CA',
                                                                                    ucinn_ascendv2__Postal_Code__c = '92602');

            //hash the address to get the external id for this address
            String hashCode = PORTAL_CommunityUtils.hashObjectFields(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_SOBJECT_TYPE => ((SObject) Type.forName('ucinn_ascendv2__Address__c').newInstance()).getSObjectType(), PORTAL_CommunityUtils.PARAM_SOBJECT_RECORD => address});
        }

        public virtual void testGetPortalURL() {
            PORTAL_CommunityUtils.getPortalURL();
        }

        public virtual void testGetPortalURLWithNetworkId() {
            PORTAL_CommunityUtils.getPortalURLWithNetworkId();
        }

        public virtual void testInfixToPostfix() {

            PORTAL_CommunityUtils.infixToPostfix(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_LOGIC_STRING => '1 BAD 2'});
            PORTAL_CommunityUtils.infixToPostfix(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_LOGIC_STRING => '1 AND 2 OR 3'});
            PORTAL_CommunityUtils.infixToPostfix(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_LOGIC_STRING => '1 2 3 4'});
            PORTAL_CommunityUtils.infixToPostfix(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_LOGIC_STRING => 'AND AND AND AND'});
        }

        // @isTest
        // public static void testTimeFunctions() {
        //     Listing__c listing1 = new Listing__c(Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
        //     listing1.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/New_York)';
        //     listing1.Actual_Start_Date_Time__c = '2019-02-04 12:00:00';
        //     listing1.Actual_End_Date_Time__c = '2019-02-04 15:00:00';

        //     Listing__c listing2 = new Listing__c(Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
        //     listing2.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/New_York)';
        //     listing2.Actual_Start_Date_Time__c = '2019-02-05 12:00:00';
        //     listing2.Actual_End_Date_Time__c = '2019-02-09 15:00:00';

        //     PORTAL_CommunityUtils.validateAndUpdateDateTimeFields(listing2, listing1, 'Start_Date_Time__c', 'Actual_Start_Date_Time__c', listing1.Time_Zone__c, listing2.Time_Zone__c);

        //     Listing__c listing3 = new Listing__c(Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
        //     listing3.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/New_York)';
        //     listing3.Start_Date_Time__c = DateTime.now();
        //     listing3.End_Date_Time__c = DateTime.now().addDays(1);

        //     Listing__c listing4 = new Listing__c(Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
        //     listing4.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/New_York)';
        //     listing4.Start_Date_Time__c = DateTime.now().addDays(10);
        //     listing4.End_Date_Time__c = DateTime.now().addDays(12);

        //     PORTAL_CommunityUtils.validateAndUpdateDateTimeFields(listing4, listing3, 'Start_Date_Time__c', 'Actual_Start_Date_Time__c', listing3.Time_Zone__c, listing4.Time_Zone__c);

        //     Listing__c listing5 = new Listing__c(Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
        //     listing5.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/New_York)';
        //     listing5.Actual_Start_Date_Time__c = '2019-02-04 12:00:00';
        //     listing5.Actual_End_Date_Time__c = '2019-02-04 15:00:00';

        //     Listing__c listing6 = new Listing__c(Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
        //     listing6.Time_Zone__c = '(GMT–05:00) Central Daylight Time (America/Chicago)';
        //     listing6.Actual_Start_Date_Time__c = '2019-02-04 12:00:00';
        //     listing6.Actual_End_Date_Time__c = '2019-02-04 15:00:00';

        //     PORTAL_CommunityUtils.validateAndUpdateDateTimeFields(listing6, listing5, 'Start_Date_Time__c', 'Actual_Start_Date_Time__c', listing6.Time_Zone__c, listing5.Time_Zone__c);

        // }

        public virtual void testEvaluateExpression() {

            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2',  PORTAL_CommunityUtils.PARAM_OPERATOR => '<'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2',  PORTAL_CommunityUtils.PARAM_OPERATOR => '<='}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2',  PORTAL_CommunityUtils.PARAM_OPERATOR => '>'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2',  PORTAL_CommunityUtils.PARAM_OPERATOR => '>='}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2',  PORTAL_CommunityUtils.PARAM_OPERATOR => '!='}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2',  PORTAL_CommunityUtils.PARAM_OPERATOR => '='}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2',  PORTAL_CommunityUtils.PARAM_OPERATOR => 'LIKE'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '1;2;3',  PORTAL_CommunityUtils.PARAM_OPERATOR => 'IN'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2',  PORTAL_CommunityUtils.PARAM_OPERATOR => 'NOT IN'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1;2;3;', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '1;2;3;4',  PORTAL_CommunityUtils.PARAM_OPERATOR => 'INCLUDES'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2',  PORTAL_CommunityUtils.PARAM_OPERATOR => 'EXCLUDES'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_OPERATOR => 'INCLUDES'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_OPERATOR => 'EXCLUDES'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => null, PORTAL_CommunityUtils.PARAM_OPERATOR => 'BLANK'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => null, PORTAL_CommunityUtils.PARAM_OPERATOR => 'NOTBLANK'}), false);

            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2',  PORTAL_CommunityUtils.PARAM_OPERATOR => '<', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'String'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2',  PORTAL_CommunityUtils.PARAM_OPERATOR => '<', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'FAKE TYPE'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '1', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2',  PORTAL_CommunityUtils.PARAM_OPERATOR => 'FAKE OPERATOR', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'String'}), false);
        }

        public virtual void testEvaluateNumericExpression() {
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '100.1',  PORTAL_CommunityUtils.PARAM_OPERATOR => '=',    PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '100.10',   PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Number'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '100.1',  PORTAL_CommunityUtils.PARAM_OPERATOR => '!=',   PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '100.101',  PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Number'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '100',    PORTAL_CommunityUtils.PARAM_OPERATOR => '>',    PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '90',       PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Number'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '100.1',  PORTAL_CommunityUtils.PARAM_OPERATOR => '>=',   PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '100.10',   PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Number'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '90',     PORTAL_CommunityUtils.PARAM_OPERATOR => '<',    PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '101',      PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Number'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '90.0',   PORTAL_CommunityUtils.PARAM_OPERATOR => '<=',   PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '90',       PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Number'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => null,     PORTAL_CommunityUtils.PARAM_OPERATOR => 'BLANK',        PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Number'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => null,     PORTAL_CommunityUtils.PARAM_OPERATOR => 'NOTBLANK',     PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Number'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '100',    PORTAL_CommunityUtils.PARAM_OPERATOR => 'FAKE OPERATOR', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '100', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Number'}), false);
        }
        
        public virtual void testEvaluateBooleanExpression() {
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => 'true', PORTAL_CommunityUtils.PARAM_OPERATOR => '=', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => 'TRUE', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Boolean'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => 'true', PORTAL_CommunityUtils.PARAM_OPERATOR => '!=', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => 'True', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Boolean'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => null, PORTAL_CommunityUtils.PARAM_OPERATOR => 'BLANK', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Boolean'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => null, PORTAL_CommunityUtils.PARAM_OPERATOR => 'NOTBLANK', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Boolean'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => 'true', PORTAL_CommunityUtils.PARAM_OPERATOR => 'FAKE OPERATOR', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => 'true', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Boolean'}), false);
        }

        public virtual void testEvaluateDateExpression() {
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2023-01-01', PORTAL_CommunityUtils.PARAM_OPERATOR => '=',  PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Date'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2023-01-01', PORTAL_CommunityUtils.PARAM_OPERATOR => '!=', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Date'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2023-12-31', PORTAL_CommunityUtils.PARAM_OPERATOR => '>',  PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Date'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2023-01-01', PORTAL_CommunityUtils.PARAM_OPERATOR => '>=', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Date'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2020-01-01', PORTAL_CommunityUtils.PARAM_OPERATOR => '<',  PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Date'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2023-01-02', PORTAL_CommunityUtils.PARAM_OPERATOR => '<=', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Date'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => null, PORTAL_CommunityUtils.PARAM_OPERATOR => 'BLANK', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Date'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => null, PORTAL_CommunityUtils.PARAM_OPERATOR => 'NOTBLANK', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Date'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2023-01-01', PORTAL_CommunityUtils.PARAM_OPERATOR => 'FAKE OPERATOR', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Date'}), false);
        }

        public virtual void testEvaluateDatetimeExpression() {
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERATOR => '=',  PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Datetime'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERATOR => '!=', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Datetime'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2023-12-31 00:00:00', PORTAL_CommunityUtils.PARAM_OPERATOR => '>',  PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Datetime'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERATOR => '>=', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Datetime'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2020-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERATOR => '<',  PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Datetime'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2023-01-02 00:00:00', PORTAL_CommunityUtils.PARAM_OPERATOR => '<=', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Datetime'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => null, PORTAL_CommunityUtils.PARAM_OPERATOR => 'BLANK', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Datetime'}), true);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => null, PORTAL_CommunityUtils.PARAM_OPERATOR => 'NOTBLANK', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Datetime'}), false);
            System.assertEquals(PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERATOR => 'FAKE OPERATOR', PORTAL_CommunityUtils.PARAM_SECOND_VALUE => '2023-01-01 00:00:00', PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => 'Datetime'}), false);
        }

        // @isTest
        // public static void testsendSingleEmail() {
        //     setupUserData();
        //     communityUser.email = 'dmardirousi@ucinnovation.com';
        //     PORTAL_CommunityUtils.sendSingleEmail(new List<Id>{communityUser.Id}, 'test', 'test', 'test', 'test');
        // }

        public virtual void userIsLoggedInConstituentTest() {
            setupUserData();


            Contact con2 = new Contact(LastName = 'Test_Contact 2',
                              AccountId = acct.Id,
                              Email = 'testCommunityUsermig12345@test.com',
                              ucinn_portal_Is_Display_On_Portal__c = true);
            con2 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con2});
            insert con2;

            User communityUser2 = new User(alias = 'comUser',
                                     email = 'testCommunityUsermig12345@test.com',
                                     emailencodingkey='UTF-8',
                                     lastname = 'Batman',
                                     languagelocalekey='en_US',
                                     localesidkey='en_US',
                                     profileid = profileId,
                                     IsActive = true,
                                     ContactId = con2.Id,
                                     timezonesidkey='America/Los_Angeles',
                                     username = 'testCommunityUsermig12312@test.com',
                                     CommunityNickname = 'Batman22');
            communityUser2 = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser2});
            insert communityUser2;

            PORTAL_CommunityUtils.userIsLoggedInConstituent(null);

            System.runAs(communityUser) {
                PORTAL_CommunityUtils.userIsLoggedInConstituent(communityUser.Id);
                PORTAL_CommunityUtils.userIsLoggedInConstituent(communityUser2.Id);
            }
        }

        public virtual void SERVER_getPicklistEntriesTest() {
            Map<String, List<String>> picklists = new Map<String, List<String>>{'ucinn_ascendv2__Giving_Society__c' => new List<String>{'ucinn_portal_Type__c'}};

            PORTAL_CommunityUtils.SERVER_getPicklistEntries(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_PICKLISTS => picklists}
             ).get('ucinn_ascendv2__Giving_Society__c');
        }

        private virtual void generateSingleLineAddressTest() {
            PORTAL_CommunityUtils.generateSingleLineAddress(null);
            PORTAL_CommunityUtils.generateSingleLineAddress(new Map<String, Object>{'test' => 'test'});
            PORTAL_CommunityUtils.generateSingleLineAddress(new Map<String, Object>{'city' => 'city'});
            PORTAL_CommunityUtils.generateSingleLineAddress(new Map<String, Object>{'state' => 'state'});
            PORTAL_CommunityUtils.generateSingleLineAddress(new Map<String, Object>{'postalCode' => 'postalCode'});
            PORTAL_CommunityUtils.generateSingleLineAddress(new Map<String, Object>{'country' => 'country'});
            PORTAL_CommunityUtils.generateSingleLineAddress(new Map<String, Object>{'city' => 'city',
                                                                                    'state' => 'state'});
            PORTAL_CommunityUtils.generateSingleLineAddress(new Map<String, Object>{'city' => 'city',
                                                                                    'postalCode' => '12345',
                                                                                    'state' => 'state'});
            PORTAL_CommunityUtils.generateSingleLineAddress(new Map<String, Object>{'city' => 'city',
                                                                                    'postalCode' => '12345',
                                                                                    'country' => 'USA',
                                                                                    'state' => 'state'});
        }
        public virtual void testGetEmailTemplate() {
            System.assertEquals(PORTAL_CommunityUtils.getEmailTemplate(null), null);
            System.assertEquals(PORTAL_CommunityUtils.getEmailTemplate(new Map<String, Object>{PORTAL_CommunityUtils.DEVELOPER_NAME => 'Test Email Template Name'}), null);
        }

        public virtual void testSendEmails() {
            PORTAL_CommunityUtils.sendEmails(null);
            PORTAL_CommunityUtils.sendEmails(new Map<String, Object>{PORTAL_CommunityUtils.EMAIL_TO_SEND_LIST => null});
        }

        public virtual void testReplaceMergeFields() {
            System.assertEquals('', PORTAL_CommunityUtils.replaceMergeFields(new Map<String, Object>{PORTAL_CommunityUtils.MERGE_FIELD_ORIGINAL_TEXT => ''}));
            System.assertEquals('', PORTAL_CommunityUtils.replaceMergeFields(null));
        }

        public virtual void testCreateEmailRecord() {
            System.assertEquals(null, PORTAL_CommunityUtils.createEmailRecord(null));
            System.assertEquals(null, PORTAL_CommunityUtils.createEmailRecord(new Map<String, Object>{PORTAL_CommunityUtils.USER_ID => ''}));
            System.assertNotEquals(null, PORTAL_CommunityUtils.createEmailRecord(new Map<String, Object>{PORTAL_CommunityUtils.USER_ID => '000000000000000000'}));
        }

        public virtual void testParseCustomFormFieldList() {
            setupFormField();
            Test.startTest();
            System.assertEquals(new List<Map<String, Object>>(), PORTAL_CommunityUtils.parseCustomFormFieldList(null));

            List<Map<String, Object>> parsedFormField1 = PORTAL_CommunityUtils.parseCustomFormFieldList(new List<ucinn_portal_Custom_Form_Field__c>{formFieldPicklist, formFieldMultiPicklist, formFieldCheckbox});
            List<Map<String, Object>> picklistValues = (List<Map<String, Object>>) parsedFormField1[0].get('picklistValues');
            System.assertEquals(picklistValues.isEmpty(), false);

            List<String> multiPicklistValues = (List<String>) parsedFormField1[1].get('multiPicklistDefaultValues');
            System.assertEquals(multiPicklistValues.isEmpty(), false);

            System.assertEquals(parsedFormField1[2].get('defaultValue'), false);

            formFieldCheckbox.Default_Value__c = 'true';
            update formFieldCheckbox;

            List<Map<String, Object>> parsedFormField2 = PORTAL_CommunityUtils.parseCustomFormFieldList(new List<ucinn_portal_Custom_Form_Field__c>{formFieldCheckbox});
            System.assertEquals(parsedFormField2[0].get('defaultValue'), true);
            Test.stopTest();

        }

        public virtual void testGenerateSingleLineAddress() {
            PORTAL_CommunityUtils.generateSingleLineAddress(new Map<String,Object>{PORTAL_CommunityUtils.STREET_KEY => 'Test Street', PORTAL_CommunityUtils.POSTAL_CODE => '92882'});
        }

        public virtual void testGetUserFromEmail() {
            setupUserData();
            User testUser = PORTAL_CommunityUtils.getUserFromEmail('testCommunityUsermig123@test.com');

            System.assertEquals(testUser.Email.toLowerCase(), 'testcommunityusermig123@test.com');
        }
    }

    static testMethod void testUserContactInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testUserContactInfo();
    }

    static testMethod void testHasNetworkId() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testHasNetworkId();
    }

    static testMethod void testHasNoNetworkId() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testHasNoNetworkId();
    }

    @isTest
    public static void testGetPicklists() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testGetPicklists();
    }

    @isTest
    public static void testGetUserProfile() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testGetUserProfile();
    }

    // @isTest
    // public static void testGetUserAccessLevel() {
    //     setupUserData();
    //     PORTAL_CommunityUtils.SERVER_getUserAccessLevel(new List<String>{'Submit_Events__c'}, 'All');

    //     Zone__c zone = new Zone__c();
    //     zone.Name = 'Alumni Club';
    //     zone.Is_Display_on_Portal__c = true;
    //     insert zone;

    //     Zone_Access_Level__c accessLevel = new Zone_Access_Level__c();
    //     accessLevel.Name = 'Volunteer';
    //     accessLevel.Submit_Events__c = true;
    //     insert accessLevel;

    //     Zone_Membership__c membership = new Zone_Membership__c();
    //     membership.Zone__c = zone.Id;
    //     membership.Constituent__c = con.Id;
    //     membership.Zone_Access_Level__c = accessLevel.Id;
    //     insert membership;

    //     System.runAs(communityUser) {
    //         PORTAL_CommunityUtils.SERVER_getUserAccessLevel(new List<String>{'Submit_Events__c'}, '');
    //         PORTAL_CommunityUtils.SERVER_getUserAccessLevel(new List<String>{'Submit_Events__c'}, 'Alumni Club');
    //     }
    // }

    @isTest
    public static void testHashObjectFields() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testHashObjectFields();
    }

    @isTest
    public static void testGetPortalURL() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testGetPortalURL();
    }

    @isTest
    public static void testGetPortalURLWithNetworkId() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testGetPortalURLWithNetworkId();
    }

    @isTest
    public static void testInfixToPostfix() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testInfixToPostfix();
    }

    // @isTest
    // public static void testTimeFunctions() {
    //     Listing__c listing1 = new Listing__c(Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
    //     listing1.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/New_York)';
    //     listing1.Actual_Start_Date_Time__c = '2019-02-04 12:00:00';
    //     listing1.Actual_End_Date_Time__c = '2019-02-04 15:00:00';

    //     Listing__c listing2 = new Listing__c(Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
    //     listing2.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/New_York)';
    //     listing2.Actual_Start_Date_Time__c = '2019-02-05 12:00:00';
    //     listing2.Actual_End_Date_Time__c = '2019-02-09 15:00:00';

    //     PORTAL_CommunityUtils.validateAndUpdateDateTimeFields(listing2, listing1, 'Start_Date_Time__c', 'Actual_Start_Date_Time__c', listing1.Time_Zone__c, listing2.Time_Zone__c);

    //     Listing__c listing3 = new Listing__c(Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
    //     listing3.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/New_York)';
    //     listing3.Start_Date_Time__c = DateTime.now();
    //     listing3.End_Date_Time__c = DateTime.now().addDays(1);

    //     Listing__c listing4 = new Listing__c(Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
    //     listing4.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/New_York)';
    //     listing4.Start_Date_Time__c = DateTime.now().addDays(10);
    //     listing4.End_Date_Time__c = DateTime.now().addDays(12);

    //     PORTAL_CommunityUtils.validateAndUpdateDateTimeFields(listing4, listing3, 'Start_Date_Time__c', 'Actual_Start_Date_Time__c', listing3.Time_Zone__c, listing4.Time_Zone__c);

    //     Listing__c listing5 = new Listing__c(Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
    //     listing5.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/New_York)';
    //     listing5.Actual_Start_Date_Time__c = '2019-02-04 12:00:00';
    //     listing5.Actual_End_Date_Time__c = '2019-02-04 15:00:00';

    //     Listing__c listing6 = new Listing__c(Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
    //     listing6.Time_Zone__c = '(GMT–05:00) Central Daylight Time (America/Chicago)';
    //     listing6.Actual_Start_Date_Time__c = '2019-02-04 12:00:00';
    //     listing6.Actual_End_Date_Time__c = '2019-02-04 15:00:00';

    //     PORTAL_CommunityUtils.validateAndUpdateDateTimeFields(listing6, listing5, 'Start_Date_Time__c', 'Actual_Start_Date_Time__c', listing6.Time_Zone__c, listing5.Time_Zone__c);

    // }

    @isTest
    public static void testEvaluateExpression() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testEvaluateExpression();
    }

    /**
     * test evaluate numeric expression
     * @author Jacob Huang
     * @since 1.1
     */
    @isTest
    public static void testEvaluateNumericExpression() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testEvaluateNumericExpression();
    }

    /**
     * test evaluate Boolean expression
     * @author Jacob Huang
     * @since 1.1
     */
    @isTest
    public static void testEvaluateBooleanExpression() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testEvaluateBooleanExpression();
    }

    /**
     * test evaluate date expression
     * @author Jacob Huang
     * @since 1.1
     */
    @isTest
    public static void testEvaluateDateExpression() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testEvaluateDateExpression();
    }

    /**
     * test evaluate date expression
     * @author Jacob Huang
     * @since 1.1
     */
    @isTest
    public static void testEvaluateDatetimeExpression() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testEvaluateDatetimeExpression();
    }

    // @isTest
    // public static void testsendSingleEmail() {
    //     setupUserData();
    //     communityUser.email = 'dmardirousi@ucinnovation.com';
    //     PORTAL_CommunityUtils.sendSingleEmail(new List<Id>{communityUser.Id}, 'test', 'test', 'test', 'test');
    // }

    @isTest
    public static void userIsLoggedInConstituentTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().userIsLoggedInConstituentTest();
    }

    @isTest
    public static void SERVER_getPicklistEntriesTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().SERVER_getPicklistEntriesTest();
    }

    @isTest
    private static void generateSingleLineAddressTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().generateSingleLineAddressTest();
    }
    static testMethod void testGetEmailTemplate() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testGetEmailTemplate();
    }

    static testMethod void testSendEmails() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testSendEmails();
    }

    static testMethod void testReplaceMergeFields() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testReplaceMergeFields();
    }

    static testMethod void testCreateEmailRecord() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testCreateEmailRecord();
    }

    static testMethod void testParseCustomFormFieldList() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testParseCustomFormFieldList();
    }

    static testMethod void testGenerateSingleLineAddress() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testGenerateSingleLineAddress();
    }

    /**
     * test get user from email
     * @author Todd Shinto
     * @since 1.11
     */
    static testMethod void testGetUserFromEmail() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUtilsTestClass().testGetUserFromEmail();
    }
}