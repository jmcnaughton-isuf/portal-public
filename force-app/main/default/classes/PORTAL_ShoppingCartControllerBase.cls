/*
 * Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
 *                     https://www.ucinnovation.com
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

 /**
  * Class contains logic for shopping cart and payment
  *
  * @author  Phillip Nguyen
  * @version 1.0
  * @since   1.0
  */
global without sharing virtual class PORTAL_ShoppingCartControllerBase {
    public static final String EMAIL_KEY = 'email';
    public static final String NAME_KEY = 'name';
    public static final String ID_KEY = 'Id';
    public static final String AMOUNT_KEY = 'amount';
    public static final String COOKIE_ID = 'cookieId';
    public static final String VALID_KEY = 'valid';
    public static final Boolean TRUE_KEY = true;
    public static final String EMPTY_VALUE = '';
    public static final String SESSION_ID = 'sessionId';
    public static final String START_TIME = 'startTime';
    public static final String END_TIME = 'endTime';

    public static final String CURRENT_STATUS = 'currentStatus';
    public static final String NEXT_STATUS = 'nextStatus';
    public static final String IN_SHOPPING_CART_STATUS = 'In Shopping Cart';
    
    public static final String ID_TO_DESIGNATION_MAP = 'idToDesignationMap';
    public static final String RTV2_CAMPAIGN_API_NAME = 'ucinn_ascendv2__Campaign__c';
    public static final String APPEAL_CONST = 'appeal';
    
    public static final String EVENT_NAME = 'eventName';
    public static final String EVENT_ID = 'eventId';
    public static final String FULL_NAME = 'fullName';
    public static final String PRIMARY_PARTICIPATION = 'primaryParticipation';
    public static final String PRIMARY_PARTICIPATION_NAME = 'primaryParticipationFullName';
    public static final String PRIMARY_PARTICIPATION_EMAIL = 'primaryParticipationEmail';
    public static final String SEND_CONFIRMATION_EMAIL = 'sendConfirmationEmail';
    public static final String EMAIL_TEMPLATE_DEVELOPER_NAME = 'developerName';
    public static final String EMAIL_RECIPIENT_LIST = 'emailRecipientList';
    public static final String EVENT_START_DATE_TIME = 'eventStartDateTime';
    public static final String EVENT_END_DATE_TIME = 'eventEndDateTime';
    public static final String EVENT_TIME_ZONE = 'eventTimeZone';
    public static final String EXPIRATION_DATE = 'expirationDate';
    public static final String PARTICIPATION_LIST = 'participationList';

    public static final String UNFORMATTED_EVENT_DATE = 'unformattedDateString';
    public static final String TIME_ZONE = 'timeZone';

    public static final String TICKET_TYPE = 'ticketType';
    public static final String NUMBER_OF_TICKETS = 'numberOfTickets';
    public static final String PRICE_PER_TICKET = 'pricePerTicket';
    public static final String TICKET_LIST = 'ticketList';
    public static final String TICKET_COST = 'ticketCost';

    public static final String REGISTRANT_INFORMATION = 'registrantInformation';
    public static final String FIRST_NAME = 'firstName';
    public static final String LAST_NAME = 'lastName';
    public static final String CHARGE_ID = 'chargeId';
    public static final String CHARGED_AMOUNT = 'chargedAmount';
    public static final String PAYMENT_METHOD = 'paymentMethod';
    public static final String STRIPE_KEY = 'Stripe';

    public static final String ADDRESS_LINE_1 = 'addressLine1';
    public static final String ADDRESS_LINE_2 = 'addressLine2';
    public static final String ADDRESS_CITY = 'addressCity';
    public static final String ADDRESS_STATE = 'addressState';
    public static final String ADDRESS_COUNTRY = 'addressCountry';
    public static final String ADDRESS_POSTAL_CODE = 'addressPostalCode';

    public static final String PRIMARY_PARTICIPANT_ADDRESS_LINE_1 = 'primaryParticipantAddressLine1';
    public static final String PRIMARY_PARTICIPANT_ADDRESS_LINE_2 = 'primaryParticipantAddressLine2';
    public static final String PRIMARY_PARTICIPANT_ADDRESS_CITY = 'primaryParticipantAddressCity';
    public static final String PRIMARY_PARTICIPANT_ADDRESS_STATE = 'primaryParticipantAddressState';
    public static final String PRIMARY_PARTICIPANT_ADDRESS_COUNTRY = 'primaryParticipantAddressCountry';
    public static final String PRIMARY_PARTICIPANT_ADDRESS_POSTAL_CODE = 'primaryParticipantAddressPostalCode';

    public static final String MULITPLE_CONFIRMATION_EMAILS_MDT = 'Is_Multiple_Event_Confirmation_Emails';

    public static final Integer EXPIRATION_BUFFER_INCREMENT_IN_SECONDS = 10;

    // email template merge fields
    public static final String MERGE_FIELD_FULL_NAME = 'ucinn_portal_Participation__c.Full_Name__c';
    public static final String MERGE_FIELD_EVENT_DETAILS = 'EventDetails';
    public static final String MERGE_FIELD_REPLACEMENT = 'mergeFieldToReplacementValue';
    public static final String MERGE_FIELD_ORIGINAL_TEXT = 'originalText';
    public static final String MERGE_FIELD_INCLUDE_ICS = 'includeICS';

    // email paramaters
    public static final String USER_ID = 'userId';
    public static final String EMAIL_SENDER_NAME = 'PORTAL TEST';
    public static final String SUPPORT_EMAIL = 'sendsupport@help.com';
    public static final String PRIMARY_EMAIL_TEMPLATE = 'Portal_Event_Confirmation';
    public static final String GUEST_EMAIL_TEMPLATE = 'Portal_Event_Guest_Confirmation';
    public static final String EMAIL_TO_SEND_LIST = 'emailList';

    public static final String ERROR_DELETE_PARTICIPATIONS = 'There was an issue removing your registration. Please contact an administrator.';
    public static final String ERROR_PAYMENT_AMOUNT = 'There was an issue with your payment amount.';
    public static final String ERROR_PAYMENT_VENDOR = 'There was an issue processing your information. Please contact an administrator.';
    public static final String ERROR_EXPIRATION_TIME_INVALID = 'There was an issue with your tickets. Please contact an administrator';
    public static final String ERROR_INVALID_STATUS = 'There was an issue with your registration. Please contact an administrator';
    public static final String ERROR_EXPIRED_TICKETS = 'Your tickets have expired. You may return to the event registration page and try again.';

    // EXCLUDE
    public static final List<String> REGISTRATION_STATUS_EXCLUDE_LIST = new List<String>{PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_COMPLETED,
                                                                                    PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_AWAITING_GATEWAY_CONFIRMATION};
    public static final List<String> TICKET_STATUS_EXCLUDE_LIST = new List<String>{PORTAL_CONST_Events.TICKET_STATUS_PAID,
                                                                              PORTAL_CONST_Events.TICKET_STATUS_AWAITING_GATEWAY_CONFIRMATION}; 

    public static final String ORGANIZATION_NAME_DEVELOPER_NAME = 'Organization_Name';
    public static final String FILE_EXTENSION_ICS = '.ics';
    public static final String FILE_CONTENT_TYPE_ICS = 'text/calendar';
    public static final String QR_CODE_GENERATOR_LINK = 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=';

    private PORTAL_PaymentHubControllerBase paymentHubController = null;

    /**
     * Get the payment hub controller base instance. Instantiate if necessary
     * 
     * @author Jacob Huang
     * @since 1.13
     * 
     * @param paymentMethod     String: Payment vendor that was used  
     *  
     * @return payment hub controller base instance
     */
    private PORTAL_PaymentHubControllerBase getPaymentHubControllerBase(String paymentMethod) {
        if (this.paymentHubController == null && String.isNotBlank(paymentMethod)) {
            this.paymentHubController = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController(paymentMethod);
            this.paymentHubController.setPaymentInterface(paymentMethod);
        }

        return this.paymentHubController;
    }

    /**
     * Get all participation's information in registration session that have tickets that are not paid
     *
     * @author                              Phillip Nguyen
     *
     * @param cookieId                      The registration session cookie Id
     * @param currentStatus                 The status of registration session (i.e 'In Shopping Cart', 'Pending Payment')
     * @return                              Mapped participation information: List of participations, expiration date, primary participation bio information
     *
     * @since                               1.0
     */
    public virtual Map<String, Object> getParticipationsMapInSession(Map<String, Object> params){
        Map<String, Object> returnMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return returnMap;
        }

        String cookieId = (String) params.get(COOKIE_ID);
        String registrationSessionStatus = (String) params.get(CURRENT_STATUS);

        if (String.isBlank(cookieId) || String.isBlank(registrationSessionStatus)) {
            return returnMap;
        }

        List<ucinn_portal_Participation__c> validParticipationsInSession = getParticipationsInSession(cookieId, registrationSessionStatus);

        if (validParticipationsInSession == null || validParticipationsInSession.isEmpty()) {
            return returnMap;
        }

        // acquire registration session for id and expiration date
        ucinn_portal_Registration_Session__c currentRegistrationSession = getRegistrationSessionFromParticipations(validParticipationsInSession);
        returnMap.put(EXPIRATION_DATE, currentRegistrationSession?.Expiration_Date_Time__c);
        returnMap.put(SESSION_ID, currentRegistrationSession?.Id);

        Map<String, Object> primaryParticipationMap = new Map<String, Object>();
        ucinn_portal_Participation__c firstParticipationRecord = validParticipationsInSession.get(0);

        // If primary participation is empty, then first participation record is primary participation
        if (String.isBlank(firstParticipationRecord.Primary_Participation__c)) {
            primaryParticipationMap = createParticipationBioInformationMapping(firstParticipationRecord);
        } else {
            primaryParticipationMap = createParticipationBioInformationMapping(firstParticipationRecord.Primary_Participation__r);
        }

        returnMap.put(PRIMARY_PARTICIPATION, primaryParticipationMap);

        List<Map<String, Object>> participationMapList = new List<Map<String,Object>>();
        for (ucinn_portal_Participation__c eachParticipation : validParticipationsInSession) {
            Map<String, Object> eachParticipationMap = createParticipationMapping(eachParticipation);
            participationMapList.add(eachParticipationMap);
        }

        returnMap.put(PARTICIPATION_LIST, participationMapList);

        return returnMap;
    }

    /**
     * Checks if there are valid tickets in shopping cart
     *
     * @author                              Phillip Nguyen
     * @since                               1.0
     *
     * @param cookieId                     Registration Session cookie Id
     * @return                              Map that contains if tickets are valid and expirate date/time of tickets
     */
    public virtual Map<String, Object> checkForTicketsInShoppingCart(Map<String, Object> params) {
        Map<String,Object> returnMap = new Map<String,Object>();

        if (params == null || params.isEmpty()) {
            return returnMap;
        }

        String cookieId = (String) params.get(COOKIE_ID);

        if (String.isBlank(cookieId)) {
            return returnMap;
        }

        List<ucinn_portal_Ticket__c> ticketsInShoppingCart = [SELECT Id, Expiration_Date_Time__c
                                                             FROM ucinn_portal_Ticket__c
                                                             WHERE Is_Valid_Ticket__c = :TRUE_KEY
                                                             AND Registration_Session__r.Session_Id__c = :cookieId
                                                             AND Registration_Session__r.Status__c = :IN_SHOPPING_CART_STATUS
                                                             AND Registration_Session__r.Is_Valid_Session__c = :TRUE_KEY];

        if (ticketsInShoppingCart != null && !ticketsInShoppingCart.isEmpty()) {
            returnMap.put(VALID_KEY, TRUE_KEY);
            returnMap.put(EXPIRATION_DATE, ticketsInShoppingCart.get(0).Expiration_Date_Time__c);
        }

        return returnMap;
    }

    /**
     * Changes registration status and extends timer in shopping cart and payment page
     *
     * @author                          Phillip Nguyen
     *
     * @param cookieId                 The registration session cookie Id
     * @param currentStatus             The current registration status for querying current registration
     * @param nextStatus                The status that current registration will be set TouchHandledException
     *
     * @since                           1.0
     */
    public virtual void modifyRegistrationStatusAndExtendExpirationDate(Map<String, Object> params){
        if (params == null || params.isEmpty()) {
            return;
        }

        String cookieId = (String) params.get(COOKIE_ID);
        String currentSessionStatus = (String) params.get(CURRENT_STATUS);
        String nextSessionStatus = (String) params.get(NEXT_STATUS);

        if (String.isBlank(cookieId) || String.isBlank(currentSessionStatus) || String.isBlank(nextSessionStatus)) {
            return;
        }

        String expirationTimeCMT = PORTAL_CONST_Events.ORG_SETTING_EVENT_PAYMENT_EXPIRATION_TIME_IN_MINUTES;

        if (nextSessionStatus == PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART) {
            expirationTimeCMT = PORTAL_CONST_Events.ORG_SETTING_SHOPPING_CART_EXPIRATION_TIME_IN_MINUTES;
        }

        List<ucinn_portal_Registration_Session__c> registrationSessionList = [SELECT Expiration_Date_Time__c, Is_Valid_Session__c, Status__c
                                                                             FROM ucinn_portal_Registration_Session__c
                                                                             WHERE Session_Id__c = :cookieId
                                                                             AND Status__c = :currentSessionStatus
                                                                             AND Is_Valid_Session__c = true
                                                                             ORDER BY CreatedDate DESC];

        if (registrationSessionList == null || registrationSessionList.isEmpty()) {
            return;
        }

        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{expirationTimeCMT}
        });


        Integer expirationTimeInMinutes = PORTAL_CONST_Events.DEFAULT_SESSION_EXPIRATION_TIME;

        try{
            if (orgSettingList != null && !orgSettingList.isEmpty()) {
                expirationTimeInMinutes = Integer.valueOf(orgSettingList.get(0).Value__c);
            }
        } catch(Exception e) {
            throw generateErrorMessage(ERROR_EXPIRATION_TIME_INVALID);
        }

        // reset expiration timer
        registrationSessionList.get(0).Expiration_Date_Time__c = DateTime.now().addMinutes(expirationTimeInMinutes);
        registrationSessionList.get(0).Is_In_Payment_Page__c = false;

        // nextSessionStatus should never be 'completed' or 'Awaiting' since the function only sets status to 'In Shopping Cart' or 'Pending Payment'
        if (nextSessionStatus != PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_COMPLETED && nextSessionStatus != PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_AWAITING_GATEWAY_CONFIRMATION) {
            registrationSessionList.get(0).Status__c = nextSessionStatus;
        } else {
            throw generateErrorMessage(ERROR_INVALID_STATUS);
        }

        update registrationSessionList;
    }

    /**
     * When exiting payment page, if primary participant is registered: delete tickets, registration, participations
     * if primary participant is not registered: extend session by 15 min and set status to 'In Shopping Cart'
     *
     * @author                              Phillip Nguyen
     * @since                               1.0
     *
     * @param cookieId                     Registration Session cookie Id
     */
    public virtual void handlePaymentPageExit(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return;
        }

        String cookieId = (String) params.get(COOKIE_ID);
        String currentSessionStatus = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT;

        if (String.isBlank(cookieId)) {
            return;
        }

        List<ucinn_portal_Participation__c> participationList = getParticipationsInSession(cookieId, currentSessionStatus);

        if (participationList == null || participationList.isEmpty()) {
            return;
        }

        String primaryParticipationStatus = getPrimaryParticipantStatus(participationList);

        if (primaryParticipationStatus == PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED) {
            // query for tickets and delete session and tickets
            List<ucinn_portal_Ticket__c> ticketsInSession = new List<ucinn_portal_Ticket__c>();
            List<ucinn_portal_Participation__c> participationListToDelete = new List<ucinn_portal_Participation__c>();

            for (ucinn_portal_Participation__c eachParticipation : participationList) {
                if (eachParticipation.Status__c == PORTAL_CONST_Events.PARTICIPATION_STATUS_PAYMENT_PENDING) {
                    participationListToDelete.add(eachParticipation);
                }

                if (eachParticipation.ucinn_portal_Tickets_Participation__r == null || eachParticipation.ucinn_portal_Tickets_Participation__r.isEmpty()) {
                    continue;
                }

                for (ucinn_portal_Ticket__c eachTicket : eachParticipation.ucinn_portal_Tickets_Participation__r) {
                    ticketsInSession.add(eachTicket);
                }
            }

            String currentModificationSessionId = (String) ticketsInSession.get(0).Registration_Session__c;
            delete ticketsinSession;
            Database.delete(currentModificationSessionId);
            participationListToDelete.addAll(getRegisteredParticipationsWithNoTickets(participationList));
            delete participationListToDelete;
        } else {  // extend time
            modifyRegistrationStatusAndExtendExpirationDate(new Map<String, Object>{COOKIE_ID => cookieId,
                                                                                    CURRENT_STATUS => currentSessionStatus,
                                                                                    NEXT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART});
        }
    }

    /**
     * Delete all participations in an Event Listing
     *
     * @author                          Phillip Nguyen
     * @param primaryParticipation      Event's Primary Participation Id
     *
     * @since                           1.0
     */
    public virtual void deleteRegistrationForEvent(Map<String, Object> params){
        if (params == null || params.isEmpty()) {
            throw generateErrorMessage(ERROR_DELETE_PARTICIPATIONS);
        }

        String primaryParticipationId = (String) params.get(PRIMARY_PARTICIPATION);

        if (String.isBlank(primaryParticipationId)) {
            throw generateErrorMessage(ERROR_DELETE_PARTICIPATIONS);
        }

        List<ucinn_portal_Participation__c> participationList = [SELECT Id FROM ucinn_portal_Participation__c
                                                                WHERE (Id = :primaryParticipationId
                                                                OR Primary_Participation__c = :primaryParticipationId)];

        if (participationList != null && !participationList.isEmpty()) {
            delete participationList;
        }
    }

    /**
     * Determines if we need to charge user's credit card
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param   cookieId        Registration session cookie Id
     * @param   sessionStatus   Registration session status
     * @param   paymentAmount   Amount registrant is paying is displayed correctly
     *
     * @return                  Boolean value, true means we charge credit card, false means we do not charge credit card
     */
    public virtual Boolean isChargeCreditCard(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            throw generateErrorMessage(ERROR_PAYMENT_VENDOR);
        }

        String cookieId = (String) params.get(COOKIE_ID);
        String sessionStatus = (String) params.get(CURRENT_STATUS);
        Decimal paymentAmount = (Decimal) params.get(AMOUNT_KEY);


        if (String.isBlank(cookieId) || String.isBlank(sessionStatus) || paymentAmount == null) {
            throw generateErrorMessage(ERROR_PAYMENT_VENDOR);
        }

        validatePaymentAmount(cookieId, sessionStatus, paymentAmount);  // if no error that means payment amount is currently valid
        addExpirationBufferToSession(cookieId, sessionStatus);

        return (paymentAmount > 0);  // charge the users credit card if their payment amount is not zero
    }

    /**
     * Recaptcha check, validate payment amount, make one time payment w payment processor and rtv2 if tickets cost money.
     * Then 2 cases:
     *      Create receipt object for session (if paid tickets), set participation to registered, set registration session status to completed
     *      Or just set registration status to awaiting gateway confirmation (Stripe payment element case, wait webhook to do the steps above)
     * Finish by sending emails to main registrant and guests
     *
     * @author                                  Phillip Nguyen
     * @since                                   1.0
     * 
     * @param cookieId                          Registration Session cookie Id
     * @param developerName                     Developer Name for email template used for primary registrant
     * @param paymentId:                        Optional string: The external id or payment token for the payment taken from the billing external gateway
     * @param amount                            Amount paid in dollars
     * @param paymentMethod                     Payment vendor that was used
     * @param registrantInformation             Primary Registrants information
     * @param recaptchaToken:                   The recaptcha client side token for this transaction submission
     * @param externalGatewayName               Optional string: Spreedly gateway name
     * @param additionalPaymentDataMap          Optional map: contains other info used by various payment processors
     * @param pageName                          Optional string: page section setting page name to use for populating rtv2 billing info fields and static/default fields 
     */
    public virtual void eventPaymentCheckout(Map<String, Object> params){
        if (params == null || params.isEmpty()) {
            throw generateErrorMessage(ERROR_PAYMENT_VENDOR);
        }

        String cookieId = (String) params.get(COOKIE_ID);
        String emailTemplateDeveloperName = (String) params.get(EMAIL_TEMPLATE_DEVELOPER_NAME);
        String paymentId = ((String) params.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY))?.replaceAll('"', ''); //can be blank if charge is 0
        Decimal payAmount =  Decimal.valueOf(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY))); //this can be zero
        String paymentMethod = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY);
        String recaptchaToken = (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN);

        // skip Recaptcha for paid tickets using Stripe Payment Element bc the user's token was already verified in frontend
        if (payAmount == 0 || (paymentMethod != PORTAL_CONST_OnlineGiving.STRIPE_PAYMENT_ELEMENT_METHOD_NAME
                && paymentMethod != PORTAL_CONST_OnlineGiving.TOUCHNET_METHOD_NAME)) {
            PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
            recaptchaController.verifyRecaptcha('PORTAL_ShoppingCartControllerBase.eventPaymentCheckout', recaptchaToken);
        }

        Map<Object, Object> registrantInformation = (Map<Object, Object>) params.get(REGISTRANT_INFORMATION);

        // Default value for email template developer name if design attribute is empty
        if (String.isBlank(emailTemplateDeveloperName)) {
            emailTemplateDeveloperName = PORTAL_CONST_Events.DEFAULT_EMAIL_TEMPLATE_DEVELOPER_NAME;
        }

        if (String.isBlank(cookieId) || String.isBlank(emailTemplateDeveloperName) || String.isBlank(paymentMethod)
            || payAmount == null || registrantInformation == null || registrantInformation.isEmpty()) {
                throw generateErrorMessage(ERROR_PAYMENT_VENDOR);
        }

        //validation check for payment amount, function takes payAmount in dollars
        validatePaymentAmount(cookieId, PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT, payAmount);

        PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper paymentResponseWrapper = null;
        if(payAmount > 0) {
            //either a charge has already been made and needs validation in external service (stripe) or we create a payment right here
            params.put(PORTAL_CONST_OnlineGiving.CONTACT_KEY, PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()}));
            paymentResponseWrapper = this.getPaymentHubControllerBase(paymentMethod).processOneTimePayment(params);
        }

        String registrantFirstName = (String) registrantInformation.get(FIRST_NAME);
        String registrantLastName = (String) registrantInformation.get(LAST_NAME);
        String registrantEmail = (String) registrantInformation.get(EMAIL_KEY);

        if (String.isBlank(registrantFirstName) || String.isBlank(registrantLastName) || String.isBlank(registrantEmail)) {
            throw generateErrorMessage(ERROR_PAYMENT_VENDOR);
        }

        // it is possible the timer expires immediately after the payment processor transaction
        // and before these upcoming queries (which look for non-expired registration sessions)
        addExpirationBufferToSession(cookieId, PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT);

        List<ucinn_portal_Participation__c> participationList = getParticipationsInSession(cookieId, PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT);

        if (participationList == null || participationList.isEmpty()) {
            throw generateErrorMessage(ERROR_PAYMENT_VENDOR);
        }

        // create receipt, rtv2 objects if payment was made using anything except Stripe Payment Element
        ucinn_portal_Receipt__c registrantReceipt = null;
        if (payAmount > 0 && String.isNotBlank(paymentResponseWrapper?.transactionId) && paymentMethod != PORTAL_CONST_OnlineGiving.STRIPE_PAYMENT_ELEMENT_METHOD_NAME) {
            registrantReceipt = this.generateReceiptObject(registrantFirstName, registrantLastName, registrantEmail, paymentResponseWrapper.transactionId, payAmount, paymentMethod);
            this.createReviewTransactionWithGatewayInfo(params, paymentResponseWrapper);
        }

        String sessionNewStatus = (payAmount > 0 && paymentMethod == PORTAL_CONST_OnlineGiving.STRIPE_PAYMENT_ELEMENT_METHOD_NAME) ? 
                                   PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_AWAITING_GATEWAY_CONFIRMATION : 
                                   PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_COMPLETED;

        // insert receipt and attach id to registration session, update registration session status
        updateRegistrationSessionRecord(cookieId, null, registrantReceipt, PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT, sessionNewStatus);

        // set participations to registered
        setParticipationsToRegistered(participationList);
        update participationList;

        sendEmailsToUsers(participationList, emailTemplateDeveloperName, registrantFirstName, registrantLastName, registrantEmail, registrantInformation);
    }

    /**
     * Checks if the registration session is already on the payment page. If not, sets the registration
     * session to be on the payment page.
     *
     * @author Aaron Wong
     *
     * @param cookieId      The cookie Id of the registration session.
     * @return              Whether or not the registration session is already on the payment page.
     * @since               1.0
     */
    public virtual Boolean handleUniquePaymentSession(Map<String, Object> params) {
        String cookieId = (String)params?.get(COOKIE_ID);

        if (String.isBlank(cookieId)) {
            return true;
        }

        List<ucinn_portal_Registration_Session__c> sessionList = [SELECT Id, Is_In_Payment_Page__c
                                                                  FROM ucinn_portal_Registration_Session__c
                                                                  WHERE Session_Id__c = :cookieId
                                                                  AND Status__c = :PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT
                                                                  AND Is_Valid_Session__c = true
                                                                  ORDER BY CreatedDate DESC];

        if (sessionList == null || sessionList.isEmpty()) {
            return true;
        }

        ucinn_portal_Registration_Session__c currentSession = sessionList.get(0);

        if (currentSession.Is_In_Payment_Page__c != true) {
            currentSession.Is_In_Payment_Page__c = true;
            update currentSession;
            return true;
        }

        return false;
    }

    /**
     * Gets event confirmation details for the given session.
     *
     * @author Aaron Wong
     *
     * @param sessionId     The Id of the registration session.
     * @return              The event confirmation details.
     * @since               1.0
     */
    public virtual List<ucinn_portal_Listing__c> getEventConfirmationDetails(Map<String, Object> params) {
        String sessionId = (String)params?.get(SESSION_ID);

        if (String.isBlank(sessionId)) {
            return new List<ucinn_portal_Listing__c>();
        }

        List<ucinn_portal_Participation__c> participationListInSession = [SELECT Id, Listing__c
                                                                          FROM ucinn_portal_Participation__c
                                                                          WHERE Id IN (SELECT Participation__c
                                                                                      FROM ucinn_portal_Ticket__c
                                                                                      WHERE Registration_Session__c = :sessionId
                                                                                      AND (Status__c = :PORTAL_CONST_Events.TICKET_STATUS_PAID OR Status__c = :PORTAL_CONST_Events.TICKET_STATUS_AWAITING_GATEWAY_CONFIRMATION))
                                                                          AND Status__c = :PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED];

        Set<String> listingIdSet = new Set<String>();

        for (ucinn_portal_Participation__c eachParticipation : participationListInSession) {
            listingIdSet.add(eachParticipation.Listing__c);
        }

        List<ucinn_portal_Listing__c> listingList = [SELECT Id, Name, Event_Actual_Start_Date_Time__c, Event_Actual_End_Date_Time__c, Time_Zone__c
                                                     FROM ucinn_portal_Listing__c
                                                     WHERE Id IN :listingIdSet];

        return listingList;
    }

    /**
     * After receiving the payment method id from something like the Stripe webhook, create the receipt and update the registration session status
     * in a failure case, delete tickets and participations if all its tickets are deleted
     * 
     * @author Jacob Huang
     * @since 1.3
     * 
     * @param firstName             String: first name of purchaser
     * @param lastName              String: last name of purchaser
     * @param email                 String: email of purchaser
     * @param paymentId             String: payment identifier in payment gateway
     * @param amount                Decimal: amount charged by payment gateway 
     * @param sessionId             String: registration session id associated with the payment
     * @param manualReviewReason    String: error string, indication of failure
     */
    public virtual void completeEventPaymentCheckout(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return;
        }

        if ((Boolean)params.get(PORTAL_StripeWebhookBase.IS_FAILURE) == true) {
            completeEventCheckoutForFailure(params);
        } else {
            completeEventCheckoutForSuccess(params);
        }
    }

    /**
     * Create receipt, create rtv2, and update registration session status
     * 
     * @author Jacob Huang
     * @since 1.3
     * 
     * @param registrantInformation Map<String, Object>: map of purchaser info with firstName, lastName, email, addressLine1, addressLine2, city, state, country, postalCode
     * @param paymentId             String: payment identifier in payment gateway
     * @param amount                Decimal: amount charged by payment gateway 
     * @param sessionId             String: registration session id associated with the payment
     * @param paymentOrigin         String: payment origin set during frontend initialization
     * @param contactId             String: contact id of portal user who's making the payment
     */
    private void completeEventCheckoutForSuccess(Map<String, Object> params) {
        Map<String, Object> registrantInformation = (Map<String, Object>)params.get(REGISTRANT_INFORMATION);
        String firstName = (String)registrantInformation?.get(FIRST_NAME);
        String lastName = (String)registrantInformation?.get(LAST_NAME);
        String email = (String)registrantInformation?.get(EMAIL_KEY);
        String paymentId = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY);
        Decimal amount = (Decimal)params.get(AMOUNT_KEY);
        String sessionId = (String)params.get(SESSION_ID);
        String paymentMethod = PORTAL_CONST_OnlineGiving.STRIPE_PAYMENT_ELEMENT_METHOD_NAME;

        ucinn_portal_Receipt__c registrantReceipt = this.generateReceiptObject(firstName, lastName, email, paymentId, amount, paymentMethod);
        // Stripe Payment Element processOneTimePayment does not actually make a callout
        this.createReviewTransactionWithGatewayInfo(params, this.getPaymentHubControllerBase(paymentMethod).processOneTimePayment(params));
        this.updateRegistrationSessionRecord(null, sessionId, registrantReceipt, PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_AWAITING_GATEWAY_CONFIRMATION, PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_COMPLETED);
    }

    /**
     * Delete registration session, tickets in the registration session, and related participations if all its tickets are deleted
     * 
     * @author Jacob Huang
     * @since 1.3
     * 
     * @param sessionId             String: registration session id associated with the payment
     */
    private void completeEventCheckoutForFailure(Map<String, Object> params) {
        String sessionId = (String)params.get(SESSION_ID);

        List<ucinn_portal_Registration_Session__c> registrationSessionList = [SELECT Id, (SELECT Id, Participation__c FROM ucinn_portal_Tickets_Reg_Session__r)
                                                                              FROM ucinn_portal_Registration_Session__c
                                                                              WHERE Id = :sessionId 
                                                                                    AND Status__c = :PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_AWAITING_GATEWAY_CONFIRMATION
                                                                                    AND Is_Valid_Session__c = true];

        // possible if the webhook gets sent multiple times by accident
        if (registrationSessionList == null || registrationSessionList.isEmpty()) {
            return;
        }

        ucinn_portal_Registration_Session__c registrationSessionToDelete = registrationSessionList.get(0);

        Set<Id> participationIdSet = new Set<Id>();
        for (ucinn_portal_Ticket__c eachTicket : registrationSessionToDelete.ucinn_portal_Tickets_Reg_Session__r) {
            participationIdSet.add(eachTicket.Participation__c);
        }

        // delete all tickets from the session
        delete registrationSessionToDelete.ucinn_portal_Tickets_Reg_Session__r;
        delete registrationSessionToDelete;

        // delete only participations that have no more tickets
        List<ucinn_portal_Participation__c> participationsForDeletedTicketsList = [SELECT Id, (SELECT Id FROM ucinn_portal_Tickets_Participation__r)
                                                                                   FROM ucinn_portal_Participation__c
                                                                                   WHERE Id IN :participationIdSet];

        List<ucinn_portal_Participation__c> participationsToDelete = new List<ucinn_portal_Participation__c>();
        for (ucinn_portal_Participation__c eachParticipation : participationsForDeletedTicketsList) {
            if (eachParticipation.ucinn_portal_Tickets_Participation__r.isEmpty()) {
               participationsToDelete.add(eachParticipation);
            }
        }

        delete participationsToDelete;
    }

    /**
     * Use the participation info and external payment gateway response wrapper to insert an rtv2
     * 
     * @author Jacob Huang
     * @since 1.13
     * 
     * @param params                    Map<String, Object>: params passed in from front end, some of which needed for rtv2 creation (listed below)
     * @param cookieId                      String: browser cookie that matches a registration session's Session_Id__c field
     * @param sessionId                     String: registration session id
     * @param pageName                      String: page section setting page name to use for populating rtv2 billing info fields and static/default fields 
     * @param registrantInformation         Map<String, Object>: billing information (first/last name, email, address)
     * @param additionalPaymentDataMap      Map<String, Object>: miscellaneous additional fields/values; however, it's only used for tender type, for this situation
     * @param paymentOrigin                 String: indicates whether this code is being called from Stripe Payment Element
     * @param cont                          Contact: current user contact record
     * @param contactId                     String: current user contact Id, Stripe Payment Element will pass contact Id instead of the actual contact
     * @param paymentMethod                 String: Payment vendor that was used, not necessary, only used for extra safety
     * 
     * @param paymentResponseWrapper    PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper: External gateway info
     */
    protected void createReviewTransactionWithGatewayInfo(Map<String, Object> params, PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper paymentResponseWrapper) {
        PORTAL_PaymentHubControllerBase paymentHubController = this.getPaymentHubControllerBase((String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY));

        String cookieId = (String)params?.get(COOKIE_ID);
        String sessionId = (String)params?.get(SESSION_ID);
        String paymentOrigin = (String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN);
        String expectedStatus = paymentOrigin == PORTAL_CONST_OnlineGiving.EVENTS_PAYMENT_ELEMENT ? PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_AWAITING_GATEWAY_CONFIRMATION : PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT;
        Map<String, Map<String, Object>> listingIdToGiftDataMap = this.getListingGiftDataMap(this.getPaidTicketsFromRegistrationSession(cookieId, sessionId, expectedStatus));

        Map<String, Object> commonReviewTranactionParams = this.getCommonReviewTransactionParams(params, paymentResponseWrapper.reviewTransactionFieldMap);

        Integer index = 1;
        // if there are multiple listings/multiple rtv2s, then CPU time may become an issue; DML limit of 150 should not be an issue
        for (String eachListingId : listingIdToGiftDataMap.keySet()) {  
            Map<String, Object> eachListingGiftDataMap = listingIdToGiftDataMap.get(eachListingId);
            Map<String, Object> reviewTransactionParams = new Map<String, Object>(commonReviewTranactionParams);

            Decimal amount = ((Decimal)eachListingGiftDataMap.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)).setScale(2, System.RoundingMode.CEILING);
            reviewTransactionParams.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, amount); 

            List<Map<String, Object>> designationList = ((Map<String, Map<String, Object>>)eachListingGiftDataMap.get(ID_TO_DESIGNATION_MAP)).values();
            reviewTransactionParams.put(PORTAL_CONST_OnlineGiving.DESIGNATIONS_KEY, designationList);
            reviewTransactionParams.put(PORTAL_MembershipControllerBase.MEMBERSHIP_BENEFIT_RECORDS, designationList);

            // Payment Hub accepts a param called appealCode, which is Campaign.ucinn_ascendv2__Motivation_Code__c
            // however, motivation code is a unique, non-required external id field, and in this situation, it may be blank  
            Map<String, Object> reviewTransactionFieldMap = (Map<String, Object>)reviewTransactionParams.get(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_FIELD_MAP);
            reviewTransactionFieldMap.put(RTV2_CAMPAIGN_API_NAME, eachListingGiftDataMap.get(APPEAL_CONST));

            // transactionId is copied onto rtv2's external system ID, which requires a unique value
            reviewTransactionParams.put(PORTAL_CONST_OnlineGiving.TRANSACTION_ID_KEY, index + '-' + paymentResponseWrapper.transactionId);

            paymentHubController.createReviewTransactionWithGatewayInfo(reviewTransactionParams);
            ++index;
        }
    }

    /**
     * Query for the paid tickets that belong to a particular registration session.
     * 
     * @author Jacob Huang
     * @since 1.13
     * 
     * @param cookieId          String: browser cookie that matches a registration session's Session_Id__c field
     * @param sessionId         String: registration session id
     * @param expectedStatus    String: registration session expected status
     *
     * @return list of ticket objects with fields neeeded for rtv2 creation
     */
    private List<ucinn_portal_Ticket__c> getPaidTicketsFromRegistrationSession(String cookieId, String sessionId, String expectedStatus) {
        List<ucinn_portal_Registration_Session__c> sessionList = [
            SELECT (SELECT Number_of_Tickets__c, Price_Per_Ticket__c,
                    Ticket_Type__r.Designation__c, Ticket_Type__r.Gift_Amount__c, 
                    Ticket_Type__r.Listing__r.Id, Ticket_Type__r.Listing__r.Campaign__c, Ticket_Type__r.Listing__r.Designation__c, Ticket_Type__r.Listing__r.Non_Gift_Designation__c 
	            FROM ucinn_portal_Tickets_Reg_Session__r
                WHERE Price_Per_Ticket__c > 0)
            FROM ucinn_portal_Registration_Session__c 
            WHERE (Id = :sessionId OR Session_Id__c = :cookieId) AND
                Is_Valid_Session__c = true AND
                Status__c = :expectedStatus
            ORDER BY CreatedDate DESC
        ];

        return !sessionList.isEmpty() ? sessionList[0].ucinn_portal_Tickets_Reg_Session__r : new List<ucinn_portal_Ticket__c>();
    }

    /**
     * Query for listing and ticket type field with gift information
     * 
     * @author Jacob Huang
     * @since 1.13
     * 
     * @param ticketList        List<ucinn_portal_Ticket__c>: list of tickets that the user is purchasing
     * 
     * @return A map of {Listing ID => {Campaign, Listing Payment Amount, {Designation ID => {Designation ID, Designation Payment Amount, Non Gift Amount}}}}
     */
    private Map<String, Map<String, Object>> getListingGiftDataMap(List<ucinn_portal_Ticket__c> ticketList) {
        Map<String, Map<String, Object>> listingIdToGiftDataMap = new Map<String, Map<String, Object>>();
        if (ticketList == null || ticketList.isEmpty()) {
            return listingIdToGiftDataMap;
        }

        for (ucinn_portal_Ticket__c eachTicket : ticketList) {
            Decimal paymentAmount = eachTicket.Number_of_Tickets__c * eachTicket.Price_Per_Ticket__c;
            // intrepret blank ticket type gift amount as 0, so then full price paid would be the non-gift amount
            Decimal giftAmount = eachTicket.Ticket_Type__r.Gift_Amount__c != null ? eachTicket.Ticket_Type__r.Gift_Amount__c : 0;
            // assign as much of the ticket price to the gift amount. Discounts will first reduce non-gift amount (explicitly) (to no less than 0), then reduce gift amount (implicitly)
            Decimal nonGiftAmount = eachTicket.Number_of_Tickets__c * Math.max(0, eachTicket.Price_Per_Ticket__c - giftAmount);
            String designationId = String.isNotBlank(eachTicket.Ticket_Type__r.Designation__c) ? eachTicket.Ticket_Type__r.Designation__c : eachTicket.Ticket_Type__r.Listing__r.Designation__c;

            Map<String, Object> listingDataMap = this.getListingDataMapWithUpdatedAmounts(listingIdToGiftDataMap, eachTicket.Ticket_Type__r.Listing__r, designationId, eachTicket.Ticket_Type__r.Listing__r.Non_Gift_Designation__c, paymentAmount, nonGiftAmount);
            listingIdToGiftDataMap.put(eachTicket.Ticket_Type__r.Listing__r.Id, listingDataMap);
       }

        return listingIdToGiftDataMap;
    }

    /**
     * Get the map for a particular listing with its appeal, running total amount, and running designation info map. 
     * Update the map using the amount argument.
     * 
     * @author Jacob Huang
     * @since 1.13
     * 
     * @param listingIdToGiftDataMap    Map<String, Map<String, Object>>: map that may or may not have gift data for the listing
     * @param listing                   ucinn_portal_Listing__c: Listing record that some ticket looks up to
     * @param designationId             String: Designation Id that some ticket or listing looks up to
     * @param nonGiftDesignationId      String: Non Gift Designation Id that listing looks up to
     * @param paymentAmount             Decimal: total amount paid from a single ticket record, add to existing listing and designation payment amounts
     * @param nonGiftAmount             Decimal: total non gift amount from a single ticket record, add to existing designation non gift amount or non gift designation's non gift amount
     * 
     * @return Map<String, Object> with information about a listing
     */
    private Map<String, Object> getListingDataMapWithUpdatedAmounts(Map<String, Map<String, Object>> listingIdToGiftDataMap, ucinn_portal_Listing__c listing, String designationId, String nonGiftDesignationId, Decimal paymentAmount, Decimal nonGiftAmount) {
        Map<String, Object> listingDataMap = listingIdToGiftDataMap?.get(listing?.Id);

        if (listingDataMap == null) {
            listingDataMap = new Map<String, Object>{
                APPEAL_CONST => listing?.Campaign__c,
                PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 0.0,
                ID_TO_DESIGNATION_MAP => new Map<String, Map<String, Object>>()
            };
        }

        // this value will eventually be put on rtv2.Total_Transaction_Amount__c
        Decimal updatedListingPaymentAmount = ((Decimal)listingDataMap.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)) + paymentAmount;
        listingDataMap.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, updatedListingPaymentAmount);

        Boolean isDesignationMatchingNonGiftDesignation = (nonGiftDesignationId == designationId);
        Decimal designationNonGiftAmount = (String.isBlank(nonGiftDesignationId) || isDesignationMatchingNonGiftDesignation == true) ? nonGiftAmount : 0;
        Decimal updatedPaymentAmount = (String.isBlank(nonGiftDesignationId) || isDesignationMatchingNonGiftDesignation == true) ? paymentAmount : paymentAmount - nonGiftAmount;

        Map<String, Map<String, Object>> idToDesignationMap = ((Map<String, Map<String, Object>>)listingDataMap.get(ID_TO_DESIGNATION_MAP));
        Map<String, Object> designationMap = this.getDesignationMapWithUpdatedAmounts(idToDesignationMap, designationId, updatedPaymentAmount, designationNonGiftAmount);
        idToDesignationMap.put(designationId, designationMap);

        if (String.isBlank(nonGiftDesignationId) || isDesignationMatchingNonGiftDesignation == true) {
            return listingDataMap;
        }

        designationMap = this.getDesignationMapWithUpdatedAmounts(idToDesignationMap, nonGiftDesignationId, nonGiftAmount, nonGiftAmount);
        idToDesignationMap.put(nonGiftDesignationId, designationMap);

        return listingDataMap;
    }

    /**
     * Get the map for a particular designation with its id, running total amount, and running non-gift amount. 
     * Update the map using the amount arguments.
     * 
     * @author Jacob Huang
     * @since 1.13
     * 
     * @param idToDesignationMap    Map<String, Map<String, Object>>: map that may or may not have gift data for the designation
     * @param designationId         String: Designation Id to get the info map for
     * @param paymentAmount         Decimal: total amount paid from a single ticket record, add to existing designation payment amount
     * @param nonGiftAmount         Decimal: total non gift amount from a single ticket record, add to existing designation non gift amount
     * 
     * @return Map<String, Object> with information about a designation
     */
    private Map<String, Object> getDesignationMapWithUpdatedAmounts(Map<String, Map<String, Object>> idToDesignationMap, String designationId, Decimal paymentAmount, Decimal nonGiftAmount) {
        Map<String, Object> designationMap = idToDesignationMap?.get(designationId);
        
        if (designationMap == null) {
            designationMap = new Map<String, Object> {
                ID_KEY => designationId,
                PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 0.0,
                PORTAL_MembershipControllerBase.BENEFIT_AMOUNT => 0.0 // this is non-gift amount, but re-using the constant from when membership non-gift amount was implemented
            };
        }

        // this value will eventually be put on rtv2.Payment_Amount_x_1__c
        Decimal updatedDesignationPaymentAmount = ((Decimal)designationMap.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)) + paymentAmount;
        designationMap.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, updatedDesignationPaymentAmount);

        // this value will eventually be put on rtv2.Non_Gift_Amount_x_1__c
        Decimal updatedNonGiftAmount = ((Decimal)designationMap.get(PORTAL_MembershipControllerBase.BENEFIT_AMOUNT)) + nonGiftAmount;
        designationMap.put(PORTAL_MembershipControllerBase.BENEFIT_AMOUNT, updatedNonGiftAmount);

        return designationMap;
    }

    /**
     * Get the param map for rtv2 creation with the shared/common values shared by all rtv2s in this transaction
     * 
     * @author Jacob Huang
     * @since 1.13
     * 
     * @param params                    Map<String, Object>: params passed in from front end, some of which needed for rtv2 creation (listed below)
     * @param additionalPaymentDataMap      Map<String, Object>: miscellaneous additional fields/values; however, it's only used for tender type, for this situation
     * @param paymentOrigin                 String: indicates whether this code is being called from Stripe Payment Element
     * @param cont                          Contact: current user contact record
     * @param contactId                     String: current user contact Id, Stripe Payment Element will pass contact Id instead of the actual contact
     * @param pageName                      String: page section setting page name to use for populating rtv2 billing info fields 
     * @param registrantInformation         Map<String, Object>: billing information (first/last name, email, address)
     * 
     * @param paymentResponseFieldMap   Map<String, Object>: External gateway info
     * 
     * @return param map with common values for rtv2 creation
     */
    private Map<String, Object> getCommonReviewTransactionParams(Map<String, Object> params, Map<String, Object> paymentResponseFieldMap) {
        Map<String, Object> reviewTransactionParams = new Map<String, Object>();

        reviewTransactionParams.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_OnlineGiving.GIFT);
        reviewTransactionParams.put(PORTAL_CONST_OnlineGiving.START_DATE_KEY, Date.today());

        reviewTransactionParams.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, params?.get(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS));
        reviewTransactionParams.put(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN, params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN));
        String pageName = (String)params?.get(PORTAL_PaymentHubControllerBase.PAGE_NAME);
        reviewTransactionParams.put(PORTAL_CONST_OnlineGiving.PAGE_SECTION_NAME, pageName);

        Contact userContact = (Contact)params?.get(PORTAL_CONST_OnlineGiving.CONTACT_KEY);
        if (String.isNotBlank((String)params?.get(PORTAL_StripeWebhookBase.CONTACT_ID))) {
            userContact = PORTAL_CommunityUtils.getContactInfoFromId((String)params.get(PORTAL_StripeWebhookBase.CONTACT_ID));
        }
        reviewTransactionParams.put(PORTAL_CONST_OnlineGiving.CONTACT_KEY, userContact);

        Map<String, Object> registrantInformation = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(params?.get(REGISTRANT_INFORMATION)));
        reviewTransactionParams.put(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_FIELD_MAP, this.getCommonReviewTransactionFieldMap(pageName, registrantInformation, paymentResponseFieldMap));        
        return reviewTransactionParams;
    }

    /**
     * Get the map of specific values that rtv2 fields need. These are the fields/values shared by all rtv2 records in this transaction.
     * This method will populate the rtv2 field map with the billing information fields using Page Section Setting because 
     * the Payment Hub billing info code is not very compatible with event code. 
     * 
     * @author Jacob Huang
     * @since 1.13
     * 
     * @param pageName                  String: page section setting page name to use for populating rtv2 billing info fields 
     * @param registrantInformation     Map<String, Object>: personal information map with the user's frontend input
     * @param paymentResponseFieldMap   Map<String, Object>: rtv2 fields/values that the payment processor requires
     * 
     * @return common review transaction fields/values in a map 
     */
    private Map<String, Object> getCommonReviewTransactionFieldMap(String pageName, Map<String, Object> registrantInformation, Map<String, Object> paymentResponseFieldMap) {
        Map<String, Object> reviewTransactionFieldMap = paymentResponseFieldMap != null ? paymentResponseFieldMap : new Map<String, Object>();
        List<Portal_Page_Section_Setting__mdt> sectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, '', '');

        for (Portal_Page_Section_Setting__mdt eachSection : sectionSettingList) {
            if (eachSection.Portal_Section_Field_Settings__r == null) {
                continue;
            }

            for (Portal_Section_Field_Setting__mdt eachField : eachSection.Portal_Section_Field_Settings__r) {
                if (String.isBlank(eachField.Staging_Record_Field_API_Name__c) || String.isBlank(eachField.Front_End_Field_Id__c) || String.isBlank((String)registrantInformation.get(eachField.Front_End_Field_Id__c))) {
                    continue;
                }

                reviewTransactionFieldMap.put(eachField.Staging_Record_Field_API_Name__c, registrantInformation.get(eachField.Front_End_Field_Id__c));
            }
        }

        return reviewTransactionFieldMap;
    }

    /**
     * Gets all participations in registration session that have tickets that are not paid
     *
     * @author                              Phillip Nguyen
     *
     * @param cookieId                     Registration Session cookie Id
     * @param currentStatus                 current registration session status
     *
     * @return                              List of participations records that contain unpaid tickets  //CHANGED
     *
     * @since                               1.0
     */
    private static List<ucinn_portal_Participation__c> getParticipationsInSession(String cookieId, String currentStatus) {
        List<ucinn_portal_Participation__c> validParticipationsInSession = new List<ucinn_portal_Participation__c>();

        if (String.isBlank(cookieId) || String.isBlank(currentStatus)) {
            return validParticipationsInSession;
        }

        String queryString = 'SELECT Id, Name, Is_Send_Confirmation_Email__c, Full_Name__c, Status__c, '
                                 + 'Primary_Participation__c, '
                                 + 'Primary_Participation__r.Status__c, '
                                 + 'Primary_Participation__r.Full_Name__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__Email_1__c, '
                                 + 'Primary_Participation__r.Contact__r.Email, '
                                 + 'Contact__r.Email, '
                                 + 'Listing__r.Id, Listing__r.Name, '
                                 + 'Listing__r.Has_Email_QR_Check_In__c, '
                                 + 'Listing__r.Email_Confirmation_Details__c, '
                                 + 'Listing__r.Event_Actual_Start_Date_Time__c, '
                                 + 'Listing__r.Event_Actual_End_Date_Time__c, '
                                 + 'Listing__r.Time_Zone__c, '
                                 + 'Listing__r.Location_Venue__c, '
                                 + 'Interim__r.ucinn_ascendv2__First_Name__c, '
                                 + 'Interim__r.ucinn_ascendv2__Last_Name__c, '
                                 + 'Interim__r.ucinn_ascendv2__Email_1__c, '
                                 + 'Interim__r.ucinn_ascendv2__Address_1_Line_1__c, '
                                 + 'Interim__r.ucinn_ascendv2__Address_1_Line_2__c, '
                                 + 'Interim__r.ucinn_ascendv2__City_1__c, '
                                 + 'Interim__r.ucinn_ascendv2__State_1__c, '
                                 + 'Interim__r.ucinn_ascendv2__Country_1__c, '
                                 + 'Interim__r.ucinn_ascendv2__Postal_Code_1__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__First_Name__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__Last_Name__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__Address_1_Line_1__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__Address_1_Line_2__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__City_1__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__State_1__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__Country_1__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__Postal_Code_1__c, '
                                 + 'Contact__r.FirstName, '
                                 + 'Contact__r.LastName, '
                                 + 'Contact__r.ucinn_ascendv2__Preferred_Address_Line_1__c, '
                                 + 'Contact__r.ucinn_ascendv2__Preferred_Address_Line_2__c, '
                                 + 'Contact__r.ucinn_ascendv2__Preferred_Address_City__c, '
                                 + 'Contact__r.ucinn_ascendv2__Preferred_Address_State__c, '
                                 + 'Contact__r.ucinn_ascendv2__Preferred_Address_Country__c, '
                                 + 'Contact__r.ucinn_ascendv2__Preferred_Address_Postal_Code__c, '
                                 + 'Primary_Participation__r.Contact__r.FirstName, '
                                 + 'Primary_Participation__r.Contact__r.LastName, '
                                 + 'Primary_Participation__r.Contact__r.ucinn_ascendv2__Preferred_Address_Line_1__c, '
                                 + 'Primary_Participation__r.Contact__r.ucinn_ascendv2__Preferred_Address_Line_2__c, '
                                 + 'Primary_Participation__r.Contact__r.ucinn_ascendv2__Preferred_Address_City__c, '
                                 + 'Primary_Participation__r.Contact__r.ucinn_ascendv2__Preferred_Address_State__c, '
                                 + 'Primary_Participation__r.Contact__r.ucinn_ascendv2__Preferred_Address_Country__c, '
                                 + 'Primary_Participation__r.Contact__r.ucinn_ascendv2__Preferred_Address_Postal_Code__c, '
                                 + '(SELECT Number_of_Tickets__c, Price_Per_Ticket__c, Ticket_Type__r.Name, '
                                 +  'Registration_Session__r.Status__c, Registration_Session__r.Expiration_Date_Time__c FROM ucinn_portal_Tickets_Participation__r '
                                 +  'WHERE Status__c NOT IN :TICKET_STATUS_EXCLUDE_LIST AND Is_Valid_Ticket__c = true) '
                                 + 'FROM ucinn_portal_Participation__c ';

            String whereClause = 'WHERE Id IN (SELECT Participation__c FROM ucinn_portal_Ticket__c WHERE Is_Valid_Ticket__c = true '
                                 + 'AND Registration_Session__r.Session_Id__c = :cookieId '
                                 + 'AND Registration_Session__r.Status__c = :currentStatus '
                                 + 'AND Registration_Session__r.Status__c NOT IN :REGISTRATION_STATUS_EXCLUDE_LIST) ';


            queryString = queryString + whereClause + ' ORDER BY Primary_Participation__c NULLS FIRST, CreatedDate ASC'; // CHANGED

            validParticipationsInSession = Database.query(queryString);

            return validParticipationsInSession;
    }

    /**
     * Gets a list of registered participations with no valid tickets from the given participation list.
     *
     * @author Aaron Wong
     *
     * @param participationList     List of participations to check if there are valid tickets.
     * @return                      List of registered participations with no valid tickets.
     * @since                       1.0
     */
    private static List<ucinn_portal_Participation__c> getRegisteredParticipationsWithNoTickets(List<ucinn_portal_Participation__c> participationList) {
        List<ucinn_portal_Participation__c> resultList = new List<ucinn_portal_Participation__c>();

        if (participationList == null || participationList.isEmpty()) {
            return resultList;
        }

        Set<String> participationIdSet = new Set<String>();

        for (ucinn_portal_Participation__c eachParticipation : participationList) {
            participationIdSet.add(eachParticipation.Id);
        }

        resultList = [SELECT Id
                      FROM ucinn_portal_Participation__c
                      WHERE Id IN :participationIdSet
                      AND Id NOT IN (SELECT Participation__c
                                     FROM ucinn_portal_Ticket__c
                                     WHERE Is_Valid_Ticket__c = true)
                      AND Status__c = :PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED];

        return resultList;
    }

    /**
     * Get current registration session from participations
     * participation list should only have 1 unique registration session since its tickets are unpaid
     *
     * @author                      Phillip Nguyen, Jacob Huang
     * @since                       1.3
     *
     * @param participationList     List of participations to find registration session for
     * @return                      returns registration session
     */
    private ucinn_portal_Registration_Session__c getRegistrationSessionFromParticipations(List<ucinn_portal_Participation__c> participationList) {
        for(ucinn_portal_Participation__c eachParticipation : participationList) {
            if (eachParticipation.ucinn_portal_Tickets_Participation__r == null) {
                continue;
            }

            for (ucinn_portal_Ticket__c eachTicket : eachParticipation.ucinn_portal_Tickets_Participation__r) {
                if (eachTicket.Registration_Session__r != null) {
                    return eachTicket.Registration_Session__r;
                }
            }
        }

        return null;
    }

    /**
     * Finds primary participation and returns their status
     *
     * @author                              Phillip Nguyen
     * @param participationList             List of participations
     *
     * @return                              primary participation's status
     * @since                               1.0
     */
    private String getPrimaryParticipantStatus(List<ucinn_portal_Participation__c> participationList) {
        String primaryParticipationStatus = '';

        if (participationList == null || participationList.isEmpty()) {
            return primaryParticipationStatus;
        }

        ucinn_portal_Participation__c firstParticipationRecord = participationList.get(0);

        // If primary participation is empty, then first participation record is primary participation
        if (String.isBlank(firstParticipationRecord.Primary_Participation__c)) {
            primaryParticipationStatus = firstParticipationRecord.Status__c;
        } else {
            primaryParticipationStatus=  firstParticipationRecord.Primary_Participation__r.Status__c;
        }

        return primaryParticipationStatus;
    }

    /**
     * Validates amount we are charging the user
     * a valid amount is zero or more and equal to the total cost of the tickets in the session
     *
     * @author                  Phillip Nguyen
     *
     * @param   cookieId        Registration session cookie Id
     * @param   sessionStatus   Registration session status
     * @param   paymentAmount   Amount registrant is paying is displayed correctly
     *
     * @since                   1.0
     */
    private virtual void validatePaymentAmount(String cookieId, String sessionStatus, Decimal paymentAmount){

        if (String.isBlank(cookieId) || String.isBlank(sessionStatus) || paymentAmount == null) {
            throw generateErrorMessage(ERROR_PAYMENT_VENDOR);
        }

        List<ucinn_portal_Participation__c> participationList = getParticipationsInSession(cookieId, sessionStatus);

        if (participationList == null || participationList.isEmpty()) {
            throw generateErrorMessage(ERROR_EXPIRED_TICKETS);
        }

        // calculate total ticket price
        Decimal totalAmount = 0.00;
        for (ucinn_portal_Participation__c eachParticipation : participationList) {
            if (eachParticipation.ucinn_portal_Tickets_Participation__r == null || eachParticipation.ucinn_portal_Tickets_Participation__r.isEmpty()) {
                continue;
            }

            for (ucinn_portal_Ticket__c eachTicket : eachParticipation.ucinn_portal_Tickets_Participation__r) {
                totalAmount += (eachTicket.Number_of_Tickets__c * eachTicket.Price_Per_Ticket__c);
            }
        }

        totalAmount = totalAmount.setScale(2, System.RoundingMode.CEILING);
        if (paymentAmount != totalAmount) {
            throw generateErrorMessage(ERROR_PAYMENT_AMOUNT);
        }

        return;  // if no errors then payment amount is valid
    }

    /**
     * Creates participantion information mapping
     *
     * @author                              Phillip Nguyen
     *
     * @param participationRecord           Participation record to grab information from
     *
     * @return                              Mapped bio information for participation
     */
    private Map<String, Object> createParticipationMapping(ucinn_portal_Participation__c participationRecord) {
        Map<String, Object> participationMap;

        if (participationRecord == null) {
            return participationMap;
        }

        participationMap = createParticipationBioInformationMapping(participationRecord);

        participationMap.put(ID_KEY, participationRecord.Id);
        participationMap.put(SEND_CONFIRMATION_EMAIL, participationRecord.Is_Send_Confirmation_Email__c);

        participationMap.put(EVENT_NAME, participationRecord.Listing__r.Name);
        participationMap.put(EVENT_ID, participationRecord.Listing__r.Id);
        participationMap.put(EVENT_START_DATE_TIME, participationRecord.Listing__r.Event_Actual_Start_Date_Time__c);
        participationMap.put(EVENT_END_DATE_TIME, participationRecord.Listing__r.Event_Actual_End_Date_Time__c);
        participationMap.put(EVENT_TIME_ZONE, participationRecord.Listing__r.Time_Zone__c);

        if (participationRecord.ucinn_portal_Tickets_Participation__r == null || participationRecord.ucinn_portal_Tickets_Participation__r.isEmpty()) {
            return participationMap;
        }

        List<Map<String, Object>> ticketListInEachParticipation = new List<Map<String, Object>>();

        Double totalTicketCostInParticipation = 0.0;
        for (ucinn_portal_Ticket__c eachTicketInParticipation : participationRecord.ucinn_portal_Tickets_Participation__r) {
            Map<String, Object> ticketMap = new Map<String, Object>();

            ticketMap.put(TICKET_TYPE, eachTicketInParticipation.Ticket_Type__r.Name);
            ticketMap.put(NUMBER_OF_TICKETS, eachTicketInParticipation.Number_of_Tickets__c);
            ticketMap.put(PRICE_PER_TICKET, eachTicketInParticipation.Price_Per_Ticket__c);

            totalTicketCostInParticipation += (eachTicketInParticipation.Price_Per_Ticket__c * eachTicketInParticipation.Number_of_Tickets__c);
            ticketListInEachParticipation.add(ticketMap);
        }

        participationMap.put(TICKET_LIST, ticketListInEachParticipation);
        participationMap.put(TICKET_COST, totalTicketCostInParticipation);

        return participationMap;
    }

    private Map<String, Object> createParticipationBioInformationMapping(ucinn_portal_Participation__c participationRecord) {
        Map<String, Object> bioInformationMap = new Map<String, Object>();

        bioInformationMap.put(FULL_NAME, participationRecord.Full_Name__c);

        if (participationRecord.Interim__r != null) {
            bioInformationMap.put(FIRST_NAME, participationRecord.Interim__r.ucinn_ascendv2__First_Name__c);
            bioInformationMap.put(LAST_NAME, participationRecord.Interim__r.ucinn_ascendv2__Last_Name__c);
            if (String.isNotBlank(participationRecord.Interim__r.ucinn_ascendv2__Email_1__c)) {
                bioInformationMap.put(EMAIL_KEY, participationRecord.Interim__r.ucinn_ascendv2__Email_1__c);
            } else {
                bioInformationMap.put(EMAIL_KEY, EMPTY_VALUE);
            }

            if (String.isNotBlank(participationRecord.Interim__r.ucinn_ascendv2__Address_1_Line_1__c)) {
                bioInformationMap.put(ADDRESS_LINE_1, participationRecord.Interim__r.ucinn_ascendv2__Address_1_Line_1__c);
            } else {
                bioInformationMap.put(ADDRESS_LINE_1, EMPTY_VALUE);
            }

            if (String.isNotBlank(participationRecord.Interim__r.ucinn_ascendv2__Address_1_Line_2__c)) {
                bioInformationMap.put(ADDRESS_LINE_2, participationRecord.Interim__r.ucinn_ascendv2__Address_1_Line_2__c);
            } else {
                bioInformationMap.put(ADDRESS_LINE_2, EMPTY_VALUE);
            }

            if (String.isNotBlank(participationRecord.Interim__r.ucinn_ascendv2__City_1__c)) {
                bioInformationMap.put(ADDRESS_CITY, participationRecord.Interim__r.ucinn_ascendv2__City_1__c);
            } else {
                bioInformationMap.put(ADDRESS_CITY, EMPTY_VALUE);
            }

            if (String.isNotBlank(participationRecord.Interim__r.ucinn_ascendv2__State_1__c)) {
                bioInformationMap.put(ADDRESS_STATE, participationRecord.Interim__r.ucinn_ascendv2__State_1__c);
            } else {
                bioInformationMap.put(ADDRESS_STATE, EMPTY_VALUE);
            }

            if (String.isNotBlank(participationRecord.Interim__r.ucinn_ascendv2__Country_1__c)) {
                bioInformationMap.put(ADDRESS_COUNTRY, participationRecord.Interim__r.ucinn_ascendv2__Country_1__c);
            } else {
                bioInformationMap.put(ADDRESS_COUNTRY, EMPTY_VALUE);
            }

            if (String.isNotBlank(participationRecord.Interim__r.ucinn_ascendv2__Postal_Code_1__c)) {
                bioInformationMap.put(ADDRESS_POSTAL_CODE, participationRecord.Interim__r.ucinn_ascendv2__Postal_Code_1__c);
            } else {
                bioInformationMap.put(ADDRESS_POSTAL_CODE, EMPTY_VALUE);
            }
        } else if (participationRecord.Contact__r != null) {
            bioInformationMap.put(FIRST_NAME, participationRecord.Contact__r.FirstName);
            bioInformationMap.put(LAST_NAME, participationRecord.Contact__r.LastName);
            if (String.isNotBlank(participationRecord.Contact__r.Email )) {
                bioInformationMap.put(EMAIL_KEY, participationRecord.Contact__r.Email );
            } else {
                bioInformationMap.put(EMAIL_KEY, EMPTY_VALUE);
            }

            if (String.isNotBlank(participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_Line_1__c)) {
                bioInformationMap.put(ADDRESS_LINE_1, participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_Line_1__c);
            } else {
                bioInformationMap.put(ADDRESS_LINE_1, EMPTY_VALUE);
            }

            if (String.isNotBlank(participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_Line_2__c)) {
                bioInformationMap.put(ADDRESS_LINE_2, participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_Line_2__c);
            } else {
                bioInformationMap.put(ADDRESS_LINE_2, EMPTY_VALUE);
            }

            if (String.isNotBlank(participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_City__c)) {
                bioInformationMap.put(ADDRESS_CITY, participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_City__c);
            } else {
                bioInformationMap.put(ADDRESS_CITY, EMPTY_VALUE);
            }

            if (String.isNotBlank(participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_State__c)) {
                bioInformationMap.put(ADDRESS_STATE, participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_State__c);
            } else {
                bioInformationMap.put(ADDRESS_STATE, EMPTY_VALUE);
            }

            if (String.isNotBlank(participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_Country__c)) {
                bioInformationMap.put(ADDRESS_COUNTRY, participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_Country__c);
            } else {
                bioInformationMap.put(ADDRESS_COUNTRY, EMPTY_VALUE);
            }

            if (String.isNotBlank(participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_Postal_Code__c)) {
                bioInformationMap.put(ADDRESS_POSTAL_CODE, participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_Postal_Code__c);
            } else {
                bioInformationMap.put(ADDRESS_POSTAL_CODE, EMPTY_VALUE);
            }
        }
        return bioInformationMap;
    }

    /**
     * Create mapping for event to primary participant ID
     *
     * @author                      Phillip Nguyen
     * @param participationList     Participation List to find and set primary participation
     * @return                      Return mapping of event to primary participant ID
     * @since                       1.0
     */
    private Map<String, String> createEventToPrimaryParticipationMapping(List<ucinn_portal_Participation__c> participationList) {
        Map<String, String> eventListingIdToPrimaryParticipationId = new Map<String, String>();

        if (participationList == null || participationList.isEmpty()) {
            return eventListingIdToPrimaryParticipationId;
        }

        // Create map of event ids to primary participations where each event has one primary participation
        for (ucinn_portal_Participation__c eachParticipation : participationList) {
            if (eachParticipation.Primary_Participation__c != null) {
                eventListingIdToPrimaryParticipationId.put(eachParticipation.Listing__r.Id, eachParticipation.Primary_Participation__c);
            } else if (!eventListingIdToPrimaryParticipationId.containsKey(eachParticipation.Listing__r.Id)) {
                eventListingIdToPrimaryParticipationId.put(eachParticipation.Listing__r.Id, eachParticipation.Id);
            }
        }

        return eventListingIdToPrimaryParticipationId;
    }

    /**
     * Set all participation status to registered when checking out
     *
     * @author                      Phillip Nguyen
     * @param participationList     participation list to change status
     * @since                       1.0
     */
    private void setParticipationsToRegistered(List<ucinn_portal_Participation__c> participationList) {
        if (participationList != null && !participationList.isEmpty()) {
            for (ucinn_portal_Participation__c eachParticipation : participationList) {
                eachParticipation.Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED;
            }
        }
    }

    /**
     * Create Event to Participation Mapping Structure for emails
     *
     * @author                      Phillip Nguyen
     * @param participationList     Participation List to create Event -> Participation mapping from
     * @return                      Event to Participation Map
     * @since                       1.0
     */
    private Map<String, List<ucinn_portal_Participation__c>> createEventListingToParticipationListMap(List<ucinn_portal_Participation__c> participationList) {
        Map<String, List<ucinn_portal_Participation__c>> eventListingToParticipationListMap = new Map<String, List<ucinn_portal_Participation__c>>();

        if (participationList == null || participationList.isEmpty()) {
            return eventListingToParticipationListMap;
        }

        // if listing is in map, then append participation to participation list for that event
        // if no listing, then create participation list for that event and add event => list to map
        for (ucinn_portal_Participation__c eachParticipation : participationList) {
            if (eventListingToParticipationListMap.containsKey(eachParticipation.Listing__r.Id)) {
                eventListingToParticipationListMap.get(eachParticipation.Listing__r.Id).add(eachParticipation);
            } else {
                List<ucinn_portal_Participation__c> participationListForOneEvent = new List<ucinn_portal_Participation__c>();

                participationListForOneEvent.add(eachParticipation);

                eventListingToParticipationListMap.put(eachParticipation.Listing__r.Id, participationListForOneEvent);
            }
        }

        return eventListingToParticipationListMap;
    }

    /**
     * Create EmeailRecipient List from participation list
     *
     * @author                      Phillip Nguyen
     * @param participationList     Participation List to create email recipients from
     * @return                      Return email recipient object list with all participation information
     * @since                       1.0
     */
    private List<PORTAL_CommunityUtils.EmailRecipient> createEmailRecipientList(List<ucinn_portal_Participation__c> participationList) {
        List<PORTAL_CommunityUtils.EmailRecipient> emailList = new List<PORTAL_CommunityUtils.EmailRecipient>();

        if (participationList == null || participationList.isEmpty()) {
            return emailList;
        }

        for (ucinn_portal_Participation__c eachParticipation : participationList) {

            if (eachParticipation.Is_Send_Confirmation_Email__c != true) {
                continue;
            }

            List<String> participationFullName = eachParticipation.Full_Name__c.split(' ');
            String firstName = participationFullName.get(0);
            String lastName = participationFullName.get(1);
            String email = '';

            if (eachParticipation.Interim__r.ucinn_ascendv2__Email_1__c != null) {
                email = eachParticipation.Interim__r.ucinn_ascendv2__Email_1__c;
            } else if (eachParticipation.Contact__r.Email != null) {
                email = eachParticipation.Contact__r.Email;
            } else {
                continue;
            }

            PORTAL_CommunityUtils.EmailRecipient emailRecipient = new PORTAL_CommunityUtils.EmailRecipient(firstName,
                                                                                                            lastName,
                                                                                                            email);

            emailList.add(emailRecipient);

        }

        return emailList;
    }

    /**
     * Generates email body for primary registrant
     *
     * @author                                              Phillip Nguyen
     * @param sendMultipleConfirmationEmails                Custom metadata setting to decide if we send multiple emails for events
     * @param eventListingToParticipationListMap            Event to participation map to create email body structure
     * @param eventListingIdtoPrimaryParticipationIdMap     Event to primary participation map used to generate modify event link information
     * @param communityName                                 Name of community
     * @return                                              A map of email body strings to the listing Id(s) included in that email body
     * @since                                               1.0
     */
    private Map<String, List<String>> generateMainEmailBody(Boolean sendMultipleConfirmationEmails,
                                                            Map<String, List<ucinn_portal_Participation__c>> eventListingToParticipationListMap,
                                                            Map<String, String> eventListingIdtoPrimaryParticipationIdMap, 
                                                            String communityName) {
                                                    
        Map<String, List<String>> emailBodiesToListingIdList = new Map<String, List<String>>();

        if (String.isBlank(communityName) || eventListingIdtoPrimaryParticipationIdMap == null || eventListingIdtoPrimaryParticipationIdMap.isEmpty()
                || eventListingToParticipationListMap == null || eventListingToParticipationListMap.isEmpty()) {
            return emailBodiesToListingIdList;
        }

        String emailBody = '';
        List<String> listingIdList = new List<String>();

        for (String eachEventId : eventListingToParticipationListMap.keySet()) {

            List<ucinn_portal_Participation__c> participationListForEvent = eventListingToParticipationListMap.get(eachEventId);
            listingIdList.add(eachEventId);

            String eventName = participationListForEvent.get(0).Listing__r.Name;
            String eventConfirmationDetails = participationListForEvent.get(0).Listing__r.Email_Confirmation_Details__c;
            String communityNameWithoutSuffix = PORTAL_CommunityUtils.getPortalURL();

            String formattedDateString = createFormattedDateString(participationListForEvent.get(0).Listing__r.Event_Actual_Start_Date_Time__c, participationListForEvent.get(0).Listing__r.Time_Zone__c);

            emailBody = emailBody + '<br/>' + eventName + '<br/>' + formattedDateString + '<br/>';

            // attach the registrants and guest names and tickets to this participation section
            for (ucinn_portal_Participation__c eachParticipationRecord : participationListForEvent) {

                if (eachParticipationRecord.ucinn_portal_Tickets_Participation__r == null || eachParticipationRecord.ucinn_portal_Tickets_Participation__r.isEmpty()) {
                    emailBody = emailBody + '&emsp;' + eachParticipationRecord.Full_Name__c + '<br/>';
                    continue;
                }

                emailBody = emailBody + '&emsp;' + eachParticipationRecord.Full_Name__c + ': <br/>';

                for (ucinn_portal_Ticket__c eachTicketInParticipationRecord : eachParticipationRecord.ucinn_portal_Tickets_Participation__r) {
                    emailBody = emailBody + '&emsp;&emsp;' + eachTicketInParticipationRecord.Ticket_Type__r.Name + ': '
                                                           + eachTicketInParticipationRecord.Number_of_Tickets__c + '<br/>';
                    if (eachParticipationRecord.Listing__r.Has_Email_QR_Check_In__c == true) {
                        emailBody = emailBody + '<br/>&emsp;&emsp;QR Check-In Code:<br/>';
                        emailBody = emailBody + '&emsp;&emsp;' + '<img src="' + this.getCheckInQRCode(eachParticipationRecord.Id, communityName) + '" alt="QR Code"/><br/>';
                    }
                }
            }

            emailBody = emailBody + '<br/><br/> ';

            if (String.isNotBlank(eventConfirmationDetails)) {
                // rich text fields automatically append to the url, communityName includes everything before /s/
                emailBody += eventConfirmationDetails.replace('src="/', 'src="' + communityNameWithoutSuffix + '/') + '<br/><br/>';
            }

            // add link to modify registration
            String primaryParticipationId = eventListingIdtoPrimaryParticipationIdMap.get(eachEventId);

            if (String.isNotBlank(primaryParticipationId)) {
                emailBody = emailBody + 'Modify your event registration: ' + communityName
                                        + '/s/event-registration?recordId=' + eachEventId
                                        + '&participationId=' + primaryParticipationId + '<br/><br/>';

            }

            // if setting on, then we need to return a list of email bodies
            if (sendMultipleConfirmationEmails == true) {
                emailBodiesToListingIdList.put(emailBody, listingIdList);
                emailBody = '';
                listingIdList = new List<String>();
            }
        }

        // if setting off, we can just return one email body
        if (sendMultipleConfirmationEmails == false) {
            emailBodiesToListingIdList.put(emailBody, listingIdList);
        }

        return emailBodiesToListingIdList;
    }

    /**
     * Generate guest participation email body
     *
     * @author                  Phillip Nguyen
     * @param participation     Guest participation information to generate email body information
     * @param communityName     Name of community
     * @return                  Guest email body
     * @since                   1.0
     */
    private String generateGuestEmailBody(ucinn_portal_Participation__c participation, ucinn_portal_Listing__c listingRecord, String communityName) {
        String emailBody = '';

        if (participation == null || listingRecord == null || String.isBlank(communityName)) {
            return emailBody;
        }

        String eventName = listingRecord.Name;
        String eventConfirmationDetails = listingRecord.Email_Confirmation_Details__c;
        String communityNameWithoutSuffix = PORTAL_CommunityUtils.getPortalURL();

        String formattedDateString = createFormattedDateString(listingRecord.Event_Actual_Start_Date_Time__c, listingRecord.Time_Zone__c);

        emailBody = emailBody + '<br/>' + eventName + '<br/>' + formattedDateString + '<br/>';


        emailBody = '<br/><br/>' + participation.Listing__r.Name + '<br/> ';
        for (ucinn_portal_Ticket__c eachTicket : participation.ucinn_portal_Tickets_Participation__r) {
            emailBody = emailBody + '&emsp;&emsp;' + eachTicket.Ticket_Type__r.Name + ': ' + eachTicket.Number_of_Tickets__c + '<br/>';
        }

        if (participation.Listing__r.Has_Email_QR_Check_In__c == true) {
            emailBody += '<br/>QR Check-In Code:<br/>';
            emailBody += '<img src="' + this.getCheckInQRCode(participation.Id, communityName) + '" alt="QR Code"/><br/>';
        }

        if (String.isNotBlank(eventConfirmationDetails)) {
            emailBody += '<br/>' + eventConfirmationDetails.replace('src="/', 'src="' + communityNameWithoutSuffix + '/') + '<br/><br/>';
        }

        return emailBody;
    }

    /**
     * Generates receipt object to link to registration session
     *
     * @author                  Phillip Nguyen
     * @param firstName         Primary Registrant first name
     * @param lastName          Primary Registrant last name
     * @param email             Primary Registrant email
     * @param transactionId     Id that can identify transaction in external payment service
     * @param chargedAmount     Payment charged amount in cents
     * @param paymentMethod     Payment method used by Primary Registrant
     *
     * @return                  Receipt object custom object
     * @since                   1.0
     */
    private ucinn_portal_Receipt__c generateReceiptObject(String firstName, String lastName, String email, String transactionId, Decimal chargedAmount, String paymentMethod) {
        ucinn_portal_Receipt__c registrantReceipt = new ucinn_portal_Receipt__c();

        if (chargedAmount == null || chargedAmount <= 0) {
            return null;
        }

        registrantReceipt.First_Name__c = firstName;
        registrantReceipt.Last_Name__c = lastName;
        registrantReceipt.Email__c = email;
        registrantReceipt.Charge_Id__c = transactionId;
        registrantReceipt.Charged_Amount__c = chargedAmount;

        return registrantReceipt;
    }

    /**
     * Generates user friendly custom error message and a stack trace for developers
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param errorMessage      User friendly error message to display on front end
     * @return                  AuraHandledException containing custom error message and stack trace
     */
    private AuraHandledException generateErrorMessage(String errorMessage) {
        return PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => errorMessage});
    }

    /**
     * Converts Date String into formatted date string for events
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param unformattedDate   Unformatted Date String
     * @param timeZone          Time Zone to parse
     *
     * @return                  Formatted Date String with Time Zone
     */
    private String createFormattedDateString(String unformattedDate, String timeZone) {
        String formattedDateString = '';

        if (String.isBlank(unformattedDate)) {
            return formattedDateString;
        }

        formattedDateString = DateTime.valueOfGMT(unformattedDate).format('MMMM dd, yyyy hh:mm aa', 'GMT');

        if (String.isBlank(timeZone)) {
            return formattedDateString;
        }

        List<String> timeZoneParts = timeZone.split(' ');

        for (String eachPart : timeZoneParts) {
            if (!eachPart.startsWith('(')) {
                formattedDateString = formattedDateString + ' ' + eachPart;
                continue;
            }

            if (!eachPart.contains('GMT')) {
                break;
            }
        }

        return formattedDateString;
    }

    /**
     * Sends out emails to registrant and their guests
     *
     * @author                              Phillip Nguyen
     * @since                               1.0
     *
     * @param participationList             List of participations to build email structure and find primary participation Id
     * @param emailTemplateDeveloperName    Developer name of Email Template to use
     * @param registrantFirstName           First name of registrant that was entered on the front end
     * @param registrantLastName            Last name of registrant that was entered on the front end
     * @param registrantEmail               Email of registrant that was entered on the front end
     * @param registrantInformation         Information of registrant that was entered on the front end (Email, Bio Information)
     */
    public void sendEmailsToUsers(List<ucinn_portal_Participation__c> participationList,
                                  String emailTemplateDeveloperName,
                                  String registrantFirstName,
                                  String registrantLastName,
                                  String registrantEmail,
                                  Map<Object, Object> registrantInformation) {

        if (participationList == null || participationList.isEmpty() || String.isBlank(emailTemplateDeveloperName)
            || String.isBlank(registrantFirstName) || String.isBlank(registrantLastName) || String.isBlank(registrantEmail)
            || registrantInformation == null || registrantInformation.isEmpty()) {
                return;
        }

        // determine if we are sending a confimation email per event
        Boolean sendMultipleConfirmationEmailsValue = false;

        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{MULITPLE_CONFIRMATION_EMAILS_MDT}
        });


        if (orgSettingList != null && !orgSettingList.isEmpty()) {
            try{
                sendMultipleConfirmationEmailsValue = Boolean.valueOf(orgSettingList.get(0).Value__c);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        // create event listings => primary participation Id so we can generate url for modify registration
        Map<String, String> eventListingIdtoPrimaryParticipationIdMap = createEventToPrimaryParticipationMapping(participationList);

        // create event listings => list of participations mapping so we can generate the email structure
        Map<String, List<ucinn_portal_Participation__c>> eventListingToParticipationListMap = createEventListingToParticipationListMap(participationList);

        List<PORTAL_CommunityUtils.EmailRecipient> emailRecipientList = new List<PORTAL_CommunityUtils.EmailRecipient>();

        // get email templates for primary registrant and guests
        Map<String, Object> emailTemplateParams = new Map<String, Object>();
        emailTemplateParams.put(EMAIL_TEMPLATE_DEVELOPER_NAME, emailTemplateDeveloperName);

        EmailTemplate confirmationEmailTemplate = PORTAL_CommunityUtils.getEmailTemplate(emailTemplateParams);

        if (confirmationEmailTemplate == null) {
            return;
        }

        emailTemplateParams.put(EMAIL_TEMPLATE_DEVELOPER_NAME, GUEST_EMAIL_TEMPLATE);

        EmailTemplate guestEmailTemplate = PORTAL_CommunityUtils.getEmailTemplate(emailTemplateParams);

        if (guestEmailTemplate == null) {
            return;
        }

        // create primary registrant email recipient
        PORTAL_CommunityUtils.EmailRecipient primaryRegistrantEmailRecipient = new PORTAL_CommunityUtils.EmailRecipient(registrantFirstName,
                                                                                                                        registrantLastName,
                                                                                                                        registrantEmail);

        emailRecipientList.add(primaryRegistrantEmailRecipient);

        // create all users to email
        emailRecipientList.addAll(createEmailRecipientList(participationList));
        emailTemplateParams.put(EMAIL_RECIPIENT_LIST, emailRecipientList);
        Map<String, User> emailToUsersMap = PORTAL_CommunityUtils.getUsersToEmail(emailTemplateParams);

        // create list of emails to send out
        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();

        Map<String, Messaging.EmailFileAttachment> eventIdToICSFileMap = createICSFileAttachmentList(eventListingToParticipationListMap);

        String communityName = PORTAL_CommunityUtils.getPortalURLWithNetworkId();

        if (String.isBlank(communityName)) {
            return;
        }

        if (communityName.endsWith('/')) {
            communityName = communityName.removeEnd('/');
        }

        Map<String, List<String>> eventEmailBodyToListingIdList = generateMainEmailBody(sendMultipleConfirmationEmailsValue, eventListingToParticipationListMap, eventListingIdtoPrimaryParticipationIdMap, communityName);

        String registrantFullName = registrantFirstName + ' ' + registrantLastName;
        // create email(s) for main registrant
        for (String eachEventEmailBody : eventEmailBodyToListingIdList.keySet()) {
            String emailBody = '';
            String emailBodyTemplate = confirmationEmailTemplate.Body;

            // prioritize HTML Template over Raw Text
            if (confirmationEmailTemplate.HtmlValue != null) {
                emailBodyTemplate = confirmationEmailTemplate.HtmlValue;
            }

            Messaging.SingleEmailMessage emailRecord = createEmailRecord(registrantFullName, 
                                                                        emailToUsersMap,
                                                                        (String)registrantInformation.get(EMAIL_KEY),
                                                                        confirmationEmailTemplate,
                                                                        eachEventEmailBody,
                                                                        eventEmailBodyToListingIdList.get(eachEventEmailBody),
                                                                        eventIdToICSFileMap);

            if (emailRecord == null) {
                continue;
            }

            emailMessageList.add(emailRecord);
        }

        // create email for guests
        for (ucinn_portal_Participation__c eachParticipation : participationList) {
            String email = '';
            String emailBody = '';
            String guestEmailTemplateBody = guestEmailTemplate.body;

            if (guestEmailTemplate.HtmlValue != null) {
                guestEmailTemplateBody = guestEmailTemplate.HtmlValue;
            }

            if (eachParticipation.Is_Send_Confirmation_Email__c != true) {  // null counts as false
                continue;
            }

            if (eachParticipation.Interim__r.ucinn_ascendv2__Email_1__c != null) {
                email = eachParticipation.Interim__r.ucinn_ascendv2__Email_1__c;
            } else if (eachParticipation.Contact__r.Email != null) {
                email = eachParticipation.Contact__r.Email;
            } else {
                continue;
            }

            emailBody = generateGuestEmailBody(eachParticipation, eachParticipation.Listing__r, communityName);

            Messaging.SingleEmailMessage emailRecord = createEmailRecord(eachParticipation.Full_Name__c,
                                                                        emailToUsersMap,
                                                                        email,
                                                                        guestEmailTemplate,
                                                                        emailBody,
                                                                        new List<String>{ eachParticipation.Listing__c },
                                                                        eventIdToICSFileMap);

            if (emailRecord == null) {
                continue;
            }

            emailMessageList.add(emailRecord);
        }

        PORTAL_CommunityUtils.sendEmails(new Map<String, Object>{EMAIL_TO_SEND_LIST => emailMessageList});
    }

    /**
     * Creates single email message to send to users
     * @author                          Phillip Nguyen
     * @since                           1.0
     *
     * @param registrantName            Name of registrant to put in email
     * @param emailToUsersMap           Mapping to find user corresponding to their email
     * @param userEmail                 User's email we are sending email to
     * @param emailTemplate             Email template to use
     * @param subject                   Subject of email
     * @param emailBody                 Body of email
     * @param listingIdList             List of event Id(s) that will be in this email record
     * @param listingIdToICSFileMap     A map from listing Id's to their corresponding ICS file
     *
     * @return                          Single email message
     */
    private Messaging.SingleEmailMessage createEmailRecord(String registrantName, Map<String, User> emailToUsersMap, String userEmail, EmailTemplate emailTemplate, String emailBody, List<String> listingIdList, Map<String, Messaging.EmailFileAttachment> listingIdToICSFileMap) {
        if (emailToUsersMap == null || emailToUsersMap.isEmpty() || !emailToUsersMap.containsKey(userEmail)
            || String.isBlank(userEmail) || String.isBlank(registrantName)) {
            return null;
        }

        // if there are events and ICS file has merge field to include ics, create their ics files
        List<Messaging.EmailFileAttachment> attachmentList = new List<Messaging.EmailFileAttachment>();
        String emailTemplateBody = String.isNotBlank(emailTemplate.HtmlValue) ? emailTemplate.HtmlValue : emailTemplate.Body;
        if (listingIdList != null && !listingIdList.isEmpty() && String.isNotBlank(emailTemplateBody) && emailTemplateBody.contains(MERGE_FIELD_INCLUDE_ICS) && listingIdToICSFileMap != null && !listingIdToICSFileMap.isEmpty()) {
            for (String eachEventId: listingIdList) {
                if (listingIdToICSFileMap.get(eachEventId) == null) {
                    continue;
                }

                attachmentList.add(listingIdToICSFileMap.get(eachEventId));
            }
        }

        Map<String, String> mergeFieldToReplacementValue = new Map<String, String>();
        mergeFieldToReplacementValue.put(MERGE_FIELD_FULL_NAME, registrantName);
        mergeFieldToReplacementValue.put(MERGE_FIELD_EVENT_DETAILS, emailBody);
        mergeFieldToReplacementValue.put(MERGE_FIELD_INCLUDE_ICS, '');

        Messaging.SingleEmailMessage emailRecord = PORTAL_CommunityUtils.createEmailRecord(new Map<String,Object>{USER_ID => emailToUsersMap.get(userEmail).Id,
                                                                                PORTAL_CommunityUtils.SENDER_DISPLAY_NAME => EMAIL_SENDER_NAME,
                                                                                PORTAL_CommunityUtils.EMAIL_ATTACHMENTS => attachmentList,
                                                                                PORTAL_CommunityUtils.EMAIL_TEMPLATE_RECORD => emailTemplate,
                                                                                PORTAL_CommunityUtils.MERGE_FIELD_VALUE_MAP => mergeFieldToReplacementValue
                                                                            });

        return emailRecord;
    }

    /**
     * 
     * @author                                      Sean Tang
     * @since                                       1.1
     *
     * @param eventListingToParticipationListMap    A map from event listing Id to participation list with primary listing records
     * @return                                      A map from event Id's to their corresponding ICS file attachments
     */
    private Map<String, Messaging.EmailFileAttachment> createICSFileAttachmentList(Map<String, List<ucinn_portal_Participation__c>> eventListingToParticipationListMap) {
        Map<String, Messaging.EmailFileAttachment> eventIdToICSFileMap = new Map<String, Messaging.EmailFileAttachment>();

        if (eventListingToParticipationListMap == null || eventListingToParticipationListMap.isEmpty()) {
            return eventIdToICSFileMap;
        }

        for (String eachEventId : eventListingToParticipationListMap.keySet()) {
            ucinn_portal_Listing__c eachListing = eventListingToParticipationListMap.get(eachEventId)?.get(0)?.Listing__r;

            eventIdToICSFileMap.put(eachEventId, createICSFileAttachment(eachListing));
        }

        return eventIdToICSFileMap;
    }


    /**
     * Creates ics file and return as an email attachment file
     * @author                          Sean Tang
     * @since                           1.1
     *
     * @param event                     The event to create the ICS file for
     * @return                          An Email file attachment with an ICS file created according to the event passed in
     */
    private Messaging.EmailFileAttachment createICSFileAttachment(ucinn_portal_Listing__c event) {
        if (event == null) {
            return null;
        }

        String eventName = (String) event.Name;
        String eventOrganizer = getOrganizationName();
        String communityEmail = getCommunityEmail();
        String eventLocation = getICSLocation(event);
        String eventTimeZone = getICSTimezoneString((String) event.Time_Zone__c);
        String eventStartTime = getICSFormattedDate(event.Event_Actual_Start_Date_Time__c);
        String eventEndTime = getICSFormattedDate(event.Event_Actual_End_Date_Time__c);

        String fileName = eventName + FILE_EXTENSION_ICS;
        String fileContent = 'BEGIN:VCALENDAR' +
                                '\nVERSION:2.0' +
                                '\nBEGIN:VEVENT' +
                                    '\nSUMMARY:' + eventName +
                                    '\nDTSTART' + eventTimeZone + ':' + eventStartTime +
                                    '\nDTEND' + eventTimeZone + ':' + eventEndTime +
                                    '\nLOCATION:' + eventLocation +
                                    '\nORGANIZER;CN=' + eventOrganizer + ':mailto:' + communityEmail +
                                '\nEND:VEVENT' +
                             '\nEND:VCALENDAR\n';

        Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
        emailAttachment.setFileName(fileName);
        emailAttachment.setBody(Blob.valueOf(fileContent));
        emailAttachment.setContentType(FILE_CONTENT_TYPE_ICS);

        return emailAttachment;
    }

    /**
     * Return the organization name
     * 
     * @author                          Sean Tang
     * @since                           1.1
     * 
     * @return                          organization name as a string
     */
    private String getOrganizationName() {
        return PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => ORGANIZATION_NAME_DEVELOPER_NAME});
    }

    /**
     * Return the community's sending email address from the current network
     * 
     * @author                          Sean Tang
     * @since                           1.1
     * 
     * @return                          sending email address as a string
     */
    private String getCommunityEmail() {
        List<Network> currentNetworks = [SELECT Id, EmailSenderAddress FROM Network WHERE Id =: Network.getNetworkId()];

        if (currentNetworks == null || currentNetworks.isEmpty()) {
            return '';
        }

        return (String) currentNetworks.get(0).EmailSenderAddress;
    }

    /**
     * Return the location information for ICS file
     * 
     * @author                          Sean Tang
     * @since                           1.1
     * 
     * @return                          location information as a string
     */
    private String getICSLocation(ucinn_portal_Listing__c listingRecord) {
        return (String.isNotBlank(listingRecord.Location_Venue__c)) ? listingRecord.Location_Venue__c : '';
    }

    /**
     * gets a date string for the ICS file
     * @author                          Sean Tang
     * @since                           1.1
     *
     * @param inputDateString           a date string in the format of 'yyyy-mm-dd hh:mm:ss'
     * @return                          a date string in the ICS file format of yyyymmddThhmmssZ
     */
    private String getICSFormattedDate(String inputDateString) {
        if (String.isBlank(inputDateString)) {
            return '';
        }

        return String.join(inputDateString.split(' '), 'T').replaceAll('[^\\w]', '');
    }

    /**
     * gets the timezone information for the ICS file
     * @author                          Sean Tang
     * @since                           1.1
     *
     * @param inputTimezoneString       a timezone string
     * @return                          the necessary timezone information for an ics file as a string
     */
    private String getICSTimezoneString(String inputTimezoneString) {
        String timezoneName = inputTimezoneString?.substringAfterLast(' (')?.substringBeforeLast(')');

        if (String.isBlank(timezoneName)) {
            return '';
        }

        // For special case of (South Australia) Australia/Adelaide time
        if (timezoneName.startsWith('(')) {
            timezoneName = timezoneName.substringAfterLast(' ');
        }

        return ';TZID=' + timezoneName;
    }

    /**
     * Gets a formatted event from the listing record.
     *
     * @author Aaron Wong
     *
     * @param listingRecord     The listing record to format.
     * @return                  Event with formatted date string/
     * @since                   1.0
     */
    private Map<String, Object> getFormattedEvent(ucinn_portal_Listing__c listingRecord) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (listingRecord == null) {
            return resultMap;
        }

        resultMap.put(NAME_KEY, listingRecord.Name);
        resultMap.put(START_TIME, createFormattedDateString(listingRecord.Event_Actual_Start_Date_Time__c, listingRecord.Time_Zone__c));
        resultMap.put(END_TIME, createFormattedDateString(listingRecord.Event_Actual_End_Date_Time__c, listingRecord.Time_Zone__c));

        return resultMap;
    }

    /**
     * Adds expiration time buffer to the session for payment processing.
     *
     * @author Aaron Wong
     *
     * @param cookieId          The cookie Id of the session.
     * @param sessionStatus     The status of the session.
     * @since                   1.0
     */
    private void addExpirationBufferToSession(String cookieId, String sessionStatus) {
        List<ucinn_portal_Registration_Session__c> sessionList = [SELECT Id, Expiration_Date_Time__c
                                                                  FROM ucinn_portal_Registration_Session__c
                                                                  WHERE Session_Id__c = :cookieId
                                                                  AND Status__c = :sessionStatus
                                                                  ORDER BY CreatedDate DESC];

        if (sessionList == null || sessionList.isEmpty()) {
            return;
        }

        sessionList.get(0).Expiration_Date_Time__c = sessionList.get(0).Expiration_Date_Time__c.addSeconds(EXPIRATION_BUFFER_INCREMENT_IN_SECONDS);

        update sessionList.get(0);
    }

    /**
     * Get registration session with an expected status, update the session status, insert the receipt, and set the receipt id on the session
     * 
     * @author Jacob Huang
     * @since 1.3
     * 
     * @param cookieId                  String: browser cookie that matches a registration session's Session_Id__c field, used for query
     * @param sessionId                 String: registration session id, used for query
     * @param registrantReceipt         ucinn_portal_Receipt__c: optional uninserted receipt record
     * @param sessionCurrentStatus      String: current registration session Status__c to query for
     * @param sessionNewStatus          String: value to update the registration session Status__c to
     */
    private void updateRegistrationSessionRecord(String cookieId, String sessionId, ucinn_portal_Receipt__c registrantReceipt, String sessionCurrentStatus, String sessionNewStatus) {
        List<ucinn_portal_Registration_Session__c> currentRegistrationSessionList = [SELECT Status__c FROM ucinn_portal_Registration_Session__c
                                                                                    WHERE (Id = :sessionId OR Session_Id__c = :cookieId) 
                                                                                        AND Status__c = :sessionCurrentStatus
                                                                                        AND Is_Valid_Session__c = true
                                                                                    ORDER BY CreatedDate DESC];

        if (currentRegistrationSessionList == null || currentRegistrationSessionList.isEmpty()) {
            return;
        }

        currentRegistrationSessionList.get(0).Status__c = sessionNewStatus;
        if (registrantReceipt != null) {
            insert registrantReceipt;
            currentRegistrationSessionList.get(0).Receipt__c = registrantReceipt.Id;
        }

        update currentRegistrationSessionList;
    }

    /**
     * Gets QR Code by generating a string with qr code generator + portal url with listing id and participation id 
     * as url params
     * 
     * @author  Phillip Nguyen
     * @since   1.12
     * @param   participationId     Participant's Id
     * @param   communityName       Name of community
     * 
     * @return  QR code as a string to be used as the src for an img tag
     */
    public virtual String getCheckInQRCode(String participationId, String communityName) {
        String returnString = '';

        if (String.isBlank(participationId) || String.isBlank(communityName)) {
            return returnString;
        }

        returnString = QR_CODE_GENERATOR_LINK;
        returnString += communityName + '/s/event-check-in?participationId=' + participationId;

        return returnString;
    }
}