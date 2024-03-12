@isTest
public with sharing class PORTAL_TouchNetPaymentGatewayTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetTouchNetSettings() {
            Test.startTest();
            PORTAL_TouchNetPaymentGateway controller = new PORTAL_TouchNetPaymentGateway();
            Map<String, Object> returnMap = controller.getTouchNetSettings();
            System.assert(returnMap != null);
            Test.stopTest();
        }

        public virtual void testGetReviewTransactionTenderType() {
            Test.startTest();
            PORTAL_TouchNetPaymentGateway controller = new PORTAL_TouchNetPaymentGateway();
            String returnString = controller.getReviewTransactionTenderType(new Map<Object, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY => 'ACH'});
            System.assert(returnString == PORTAL_CONST_OnlineGiving.ACH_CONST);

            returnString = controller.getReviewTransactionTenderType(new Map<Object, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY => 'Credit'});
            System.assert(returnString == PORTAL_CONST_OnlineGiving.CREDIT_CARD);
            Test.stopTest();
        }

        public virtual void testGenerateTicket() {
            Test.startTest();
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
            mockcallouts.addRequest(200,'succeeded',
                                    '<?xml version="1.0" encoding="utf-8"?>' +
                                    '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
                                        '<soap:Body>' + 
                                            '<c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.191">' +
                                                '<c:generateSecureLinkTicketResponse>' +
                                                    '<c:ticket>' + 'testTicket123' + '</c:ticket>' +
                                                '</c:generateSecureLinkTicketResponse>' +
                                            '</c:replyMessage>' +
                                        '</soap:Body>' +
                                    '</soap:Envelope>',
                                    'https://test.secure.touchnet.net:8703/C30006test_tlink/services/TPGSecureLink');

            PORTAL_TouchNetPaymentGateway controller = new PORTAL_TouchNetPaymentGateway();
            String returnString = controller.generateSecureLinkTicket(null);
            System.assert(String.isBlank(returnString));

            List<Object> nameValuePairs = new List<Object>();
            nameValuePairs.add(new Map<String, Object>{'name' => 'SUCCESS', 'value' => 'test'});

            returnString = controller.generateSecureLinkTicket(new Map<String, Object>{PORTAL_TouchNetPaymentGateway.TICKET_NAME => 'testTicket',
                                                                                       PORTAL_TouchNetPaymentGateway.NAME_VALUE_PAIRS => nameValuePairs});
            //System.assert(String.isBlank(returnString));
            // TODO assert
            Test.stopTest();
        }

        public virtual void testOneTimeGift() {
            Test.startTest();
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
            mockcallouts.addRequest(200,'succeeded',
                                    '<?xml version="1.0" encoding="utf-8"?>' +
                                    '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
                                        '<soap:Body>' + 
                                            '<c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.191">' +
                                                '<c:upay>portaltest</c:upay>' +
                                            '</c:replyMessage>' +
                                        '</soap:Body>' +
                                    '</soap:Envelope>',
                                    'https://test.secure.touchnet.net:8703/C30006test_tlink/services/TPGSecureLink');

            PORTAL_TouchNetPaymentGateway controller = new PORTAL_TouchNetPaymentGateway();
            try {
                controller.createOneTimePayment(null);
            } catch(Exception error) {
                System.debug(error);
            }

            PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper response = controller.createOneTimePayment(new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY => 'testIdKeyTouchNet'});
            // TODO assert
            Test.stopTest();
        }

        public virtual void testAutomaticPayments() {
            Test.startTest();
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
            mockcallouts.addRequest(200,'succeeded',
                                    '<?xml version="1.0" encoding="utf-8"?>' +
                                    '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
                                        '<soap:Body>' + 
                                            '<c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.191">' +
                                                '<c:upay>portaltest</c:upay>' +
                                            '</c:replyMessage>' +
                                        '</soap:Body>' +
                                    '</soap:Envelope>',
                                    'https://test.secure.touchnet.net:8703/C30006test_tlink/services/TPGSecureLink');

            PORTAL_TouchNetPaymentGateway controller = new PORTAL_TouchNetPaymentGateway();
            try {
                controller.createSubscription(null);
            } catch(Exception error) {
                System.debug(error);
            }

            try {
                String response = controller.createSubscription(new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY => 'testIdKeyTouchNet',
                                                                        PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 0,
                                                                        PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY => new ucinn_ascendv2__Review_Transaction_v2__c()});
            } catch (Exception error) {
                System.debug(error);
            }

            String response = controller.createSubscription(new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY => 'testIdKeyTouchNet',
                                                                                    PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 50.00,
                                                                                    PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY => new ucinn_ascendv2__Review_Transaction_v2__c()});
            // TODO assert
            System.assert(String.isNotBlank(response));

            controller.createSubscription(new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY => 'testIdKeyTouchNet',
                                                                        PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 50.00,
                                                                        PORTAL_CONST_OnlineGiving.START_DATE_KEY => Date.today().addDays(1),
                                                                        PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY => new ucinn_ascendv2__Review_Transaction_v2__c()});

            controller.createSubscription(new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY => 'testIdKeyTouchNet',
                                                                        PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 50.00,
                                                                        PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY => new ucinn_ascendv2__Review_Transaction_v2__c(),
                                                                        PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY => PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE,
                                                                        PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY => 6});
            Test.stopTest();
        }

        public virtual void testCreateWalletPaymentMethod() {
            Test.startTest();
            PORTAL_TouchNetPaymentGateway controller = new PORTAL_TouchNetPaymentGateway();
            String returnString = controller.createWalletPaymentMethod(null, null);
            System.assert(String.isBlank(returnString));
            Test.stopTest();
        }

        public virtual void testGetPublicAPIKey() {
            Test.startTest();
            PORTAL_TouchNetPaymentGateway controller = new PORTAL_TouchNetPaymentGateway();
            String returnString = controller.getPublicAPIKey(null);
            System.assert(String.isBlank(returnString));
            Test.stopTest();
        }

        public virtual void testUpdateSubscriptionCreditCard() {
            Test.startTest();
            PORTAL_TouchNetPaymentGateway controller = new PORTAL_TouchNetPaymentGateway();
            String returnString = controller.updateSubscriptionCreditCard(null);
            System.assert(String.isBlank(returnString));
            Test.stopTest();
        }

        public virtual void testGetCreditCardIdToLastFourDigitsMap() {
            Test.startTest();
            PORTAL_TouchNetPaymentGateway controller = new PORTAL_TouchNetPaymentGateway();
            Map<String, String> returnMap = controller.getCreditCardIdToLastFourDigitsMap(null);
            System.assert(returnMap == null);
            Test.stopTest();
        }

        public virtual void testCancelSubscription() {
            Test.startTest();
            PORTAL_TouchNetPaymentGateway controller = new PORTAL_TouchNetPaymentGateway();
            controller.cancelSubscription(null);
            Test.stopTest();
        }
    }

    public static testMethod void testGetTouchNetSettings() {
        PORTAL_TestClassFactory.getTestClassFactory().getTouchNetPaymentGatewayTestClass().testGetTouchNetSettings();
    }

    public static testMethod void testGetReviewTransactionTenderType() {
        PORTAL_TestClassFactory.getTestClassFactory().getTouchNetPaymentGatewayTestClass().testGetReviewTransactionTenderType();
    }

    public static testMethod void testGenerateTicket() {
        PORTAL_TestClassFactory.getTestClassFactory().getTouchNetPaymentGatewayTestClass().testGenerateTicket();
    }

    public static testMethod void testOneTimeGift() {
        PORTAL_TestClassFactory.getTestClassFactory().getTouchNetPaymentGatewayTestClass().testOneTimeGift();
    }

    public static testMethod void testAutomaticPayments() {
        PORTAL_TestClassFactory.getTestClassFactory().getTouchNetPaymentGatewayTestClass().testAutomaticPayments();
    }

    public static testMethod void testCreateWalletPaymentMethod() {
        PORTAL_TestClassFactory.getTestClassFactory().getTouchNetPaymentGatewayTestClass().testCreateWalletPaymentMethod();
    }

    public static testMethod void testGetPublicAPIKey() {
        PORTAL_TestClassFactory.getTestClassFactory().getTouchNetPaymentGatewayTestClass().testGetPublicAPIKey();
    }

    public static testMethod void testUpdateSubscriptionCreditCard() {
        PORTAL_TestClassFactory.getTestClassFactory().getTouchNetPaymentGatewayTestClass().testUpdateSubscriptionCreditCard();
    }

    public static testMethod void testGetCreditCardIdToLastFourDigitsMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getTouchNetPaymentGatewayTestClass().testGetCreditCardIdToLastFourDigitsMap();
    }

    public static testMethod void testCancelSubscription() {
        PORTAL_TestClassFactory.getTestClassFactory().getTouchNetPaymentGatewayTestClass().testCancelSubscription();
    }
}