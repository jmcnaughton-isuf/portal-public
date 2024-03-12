/*
 * Batch used to get constituent id's that belong in a content filter.
 * Within postfix equation numbers represent Content_Recipients_Filter objects, strings represent id for cache of id's that are stored and used for intermediate operations.
 * The current batch uses the current Job Id as the Cache_Api_Name for the current cache. Each iteration of this batch will maintain its own cache and use that batches job Id
 * to retrieve any given cache.
 * Content Recipients record type is used to specifiy if something speical needs to occur
 * Error Code range: 400s
 *
 * @author      Ashley Tran
 * @since       1.0
 * @version     1.0
 */
global virtual without sharing class PORTAL_BATCH_NewsletterFilter implements Database.Batchable<sObject>, Database.AllowsCallouts{
    global List<String> postfix; // Postfix expression which contains filters and caches that need to be operated on.
    global String contentRecipientFilterId; // id of Content Recipients object
    global String newsletterId; // id of newsletter listing
    global String cacheId; // (When you first call to class set to NULL) stores the id of the cache to use in the execute method. Needed since we aren't using stateful.
    global String currentOperator; // (When you first call to class set to NULL) stores the operator to use in the execute method. Needed since we aren't using stateful.
    global String email; // If you are running a count recipients when it is finished it will email this email when done
    global Boolean countRecipients; // States if batch is being used to count recipients.
    global Boolean postProcessingFilters; // (Set to NULL on first call unless you are filter on the entire group) States if the batch is done and needs to do post processing filters.
    global String  filterRecordType;
    global Datetime deliveryTime;
    // used to get detailed errors from the batch to the user.

    global static final Id NEWSLETTER_FILTER_RECORD_TYPE_ID = Schema.SObjectType.ucinn_portal_Search_Filter_Cache__c.getRecordTypeInfosByDeveloperName().get('Newsletter_Filter').getRecordTypeId();
    global static final String ALL_CONTACTS_CACHE_NAME = '_All_Contacts_Cache_';
    global static final String NEWSLETTER_SERVICE_INDICATOR_METADATA_NAME = 'Newsletter_Service_Indicators';
    global static final String CONTACT_ID_FIELD = 'Contact_Id_Cache_';
    global static final Integer MAX_LENGTH = ucinn_portal_Search_Filter_Cache__c.Contact_Id_Cache_1__c.getDescribe().getLength() - 19;


    public class NewsletterFilterBatchException extends Exception {}

    /**
    * Constructor used to set all class variables
    *
    * @param postfix                    Postfix expression which contains filters and caches that need to be operated on.
    * @param contentRecipientFilterId   id of Content Recipients object we are using
    * @param newsletterId               id of the newsletter listing being sent
    * @param cacheId                    (Set to NULL on first call). Stores the id of the cache to be used in the execute method.
    * @param currentOperator            (Set to NLUL on first call). Stores the operator to be used in the execute method.
    * @param email                      If you are running a count recipients when it is finished it will email this email when done
    * @param countRecipients            States if batch is being used to count recipients.
    * @param postProcessingFilters      (Set to null on first run unless you are filtering on entire group set it to true). States if the batch is done and needs to do post processing filters.
    * @param deliveryTime               datetime for the email to be sent with some buffer (~5 min max past this time)
    * @since                            1.0
    */
    global PORTAL_BATCH_NewsletterFilter(List<String> postfix, String contentRecipientFilterId, String newsletterId, String cacheId, String operator, String email, Boolean countRecipients, Boolean postProcessingFilters, Datetime deliveryTime) {

        if (postfix == null || contentRecipientFilterId == null || newsletterId == null) {
            throw new NewsletterFilterBatchException('There was an unexpected error trying to start our newsletter batch. Error: 401');
        }

        this.postfix = postfix;
        this.contentRecipientFilterId = contentRecipientFilterId;
        this.newsletterId = newsletterId;
        this.cacheId = cacheId;
        this.currentOperator = operator;
        this.email = email;
        this.countRecipients = countRecipients;
        this.postProcessingFilters = postProcessingFilters;
        this.filterRecordType = contentRecipientsRecordTypeName(this.contentRecipientFilterId);
        this.deliveryTime = deliveryTime;
    }

    /**
    * Create query on either constituents or directory search filter cache.
    * Case 1: Both filters are numbers (1 OR 2) query will be on constituents and filters 1 and 2 will be subjoins
    * Case 2: One filter is a number and other is a cache (1 OR 7075B00001AbzU6QAJ) query will be on constituents with fitler 1 being subjoin and this.cacheId set to '7075B00001AbzU6QAJ'
    * Case 3: Both are caches (7075B00001AbzU6QAJ OR 7075B00001AbzU6QAk) query will be on directory search filter cache with the first cache '7075B00001AbzU6QAJ' and this.cacheId set to the second cache
    *
    * @param bc             content of the batch
    * @return               QueryLocator for the query constructore
    * @since                1.0
    */
    global virtual Database.QueryLocator start(Database.BatchableContext bc) {
        String queryString;

        try {

            String operand1;
            String operand2;
            String operator;

            queryString = 'SELECT Id, Email FROM Contact WHERE Email != null';

            if (postProcessingFilters == true) {
                String alumniClubFilter = getAlumniClubFilter();

                if (String.isNotBlank(alumniClubFilter)) {
                    queryString += ' AND ' +  getAlumniClubFilter();
                }
            }
            else if (postfix.size() == 1) { // case where just a single filter is provided. Occurs only when the starting filter is of size one.
                ucinn_portal_Recipient_Filter__c filter = getFilter(postfix[0], contentRecipientFilterId);
                queryString += ' AND ' + getSubJoinQuery(filter);
            }
            else if (postfix.size() > 2) {

                // grab first occurring operator and operand
                for (Integer currentIndex = 0; currentIndex < postfix.size(); currentIndex++) {

                    if (isOperator(postfix[currentIndex])) {
                        operator = postfix[currentIndex];
                        operand1 = postfix[currentIndex - 1];
                        operand2 = postfix[currentIndex - 2];
                        break;
                    }

                }

                queryString = generateQueryStringWithOperands(queryString, operator, operand1, operand2);
            }

            // new cache created and intermediate results for the current batch will be stored in it.
            ucinn_portal_Search_Filter_Cache__c cache = new ucinn_portal_Search_Filter_Cache__c();
            cache.Name = operand1 + ' ' + operator + ' ' + operand2;
            cache.Cache_API_Name__c = bc.getJobId();
            cache.RecordTypeId= NEWSLETTER_FILTER_RECORD_TYPE_ID;
            cache.Order_Number__c = 1;
            insert cache;

            System.debug(queryString);

            return Database.getQueryLocator(queryString);

        } catch (NewsletterFilterBatchException e) {
            System.debug(e.getStackTraceString());
            String body ='Error Message: ' + e.getMessage();
            sendExceptionEmail(body, bc.getJobId());
            return null;
        }
        catch (Exception e) {
            System.debug(e.getStackTraceString());
            String body ='Error Message: ' + 'There was an unexpected error that occured in the newsletter filter.\n' + e.getMessage();
            sendExceptionEmail(body, bc.getJobId());
            return null;
        }
    }

    /**
     * Combines two operands and an operand Ex : (1 OR 2) and stores the results in ucinn_portal_Search_Filter_Cache__c created in the start method
     *
     * @param bc                    context of the batch
     * @param records               Either a list of Contacts or ucinn_portal_Search_Filter_Cache__c
     * @sicne                       1.0
     */
    global virtual void execute(Database.BatchableContext bc, List<sObject> records) {
        ucinn_portal_Search_Filter_Cache__c intermediateResultsCache = getNextEmptyCache(bc.getJobId());

        Set<String> recordIdSet = new Set<String>();
        for (sObject eachContact : records) {
            recordIdSet.add(eachContact.Id);
        }

        if (String.isBlank(this.cacheId)) {
            intermediateResultsCache = addSetToCache(recordIdSet, intermediateResultsCache);
        } else { // one query is a cache
            intermediateResultsCache = identifyIdsToAddToSet(recordIdSet, intermediateResultsCache, this.cacheId, this.currentOperator);
        }

        upsert intermediateResultsCache;
    }

    /**
     * Remove what was operated on from the postfix eqation and set what is needed next.
     * If there is nothing left in the postfix equation either email the stated email of the counts from the batch if count recipients is true
     * or send the emails out.
     *
     * @param bc                    context of the batch
     * @since                       1.0
     */
    global virtual void finish(Database.BatchableContext bc) {

        AsyncApexJob jobs = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ExtendedStatus
            FROM AsyncApexJob
            WHERE Id = :BC.getJobId()
        ];

        // if the filter had any errors stop the batch
        if (jobs.NumberOfErrors > 0) {
            String body ='Error Message: ' + jobs.ExtendedStatus;
            sendExceptionEmail(body, bc.getJobId());
            return;
        }

        try {


            if (this.currentOperator == 'OR') {
                addFinalIdsToCache(bc);
            }

            if (postfix.size() == 1 || postProcessingFilters == true) {
                postfix.clear();
            }

            runNextBatch(bc.getJobId(), jobs.TotalJobItems);

            if (postfix.isEmpty()) { // Prefix size is zero
                if (this.postProcessingFilters != true && this.filterRecordType == 'Newsletter') { // apply the from filter
                    postfix.add('FROM'); // indicates we want to query FROM (this indicates you want to query form the who is from the club)
                    //Passing in the current cache as the cache id so its used for the next expression evaluation. Sending 'AND' to do an AND operation.
                    Database.executeBatch(new PORTAL_BATCH_NewsletterFilter(postfix, contentRecipientFilterId, newsletterId, bc.getJobId(), 'AND', email, countRecipients, true, deliveryTime), 2000);
                } else {
                    Integer numberOfRecipients = countResult(bc.getJobId());
                    ucinn_portal_Listing__c newsletter = [SELECT Id, Name FROM ucinn_portal_Listing__c WHERE id =:newsletterId];
                    newsletter.Number_of_Newsletter_Recipients__c = numberOfRecipients;

                    if (countRecipients == true) {
                        List<String> emails = new List<String>();
                        emails.add(this.email);
                        String body = 'Your Count Number of Recipients has been completed for your ' + filterRecordType + ' named: \'' + newsletter.Name +
                             '. You have ' +  numberOfRecipients + ' number of recipients.';
                        this.sendCompletionEmail(body);
                        String displayName = null;
                        delete [SELECT Id FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_API_Name__c = :this.cacheId];
                        update newsletter;
                    } else {
                        newsletter.Cache_API_Name__c = bc.getJobId();
                        update newsletter;
                        Database.executeBatch(new PORTAL_BATCH_NewsletterCampaign(newsletter.Id, deliveryTime, 1, 1), 1);
                    }
                }
            }
        } catch (Exception e) {
            System.debug(e.getStackTraceString());
            String body ='Error Message: ' + 'There was an unexpected error that occured in the newsletter filter.\nError Message:' + e.getMessage() + '\n\nStack Trace:' + e.getStackTraceString() + '  - ' + postfix;
            sendExceptionEmail(body, bc.getJobId());
        }
    }

    private void addFinalIdsToCache(Database.BatchableContext bc) {
        ucinn_portal_Search_Filter_Cache__c intermediateResultsCache = getNextEmptyCache(bc.getJobId());

        for (ucinn_portal_Search_Filter_Cache__c eachCacheRecord : [SELECT Cache_API_Name__c, Id, Order_Number__c, Contact_Id_Cache_1__c,
                                                                    Contact_Id_Cache_2__c, Contact_Id_Cache_3__c, Contact_Id_Cache_4__c, Contact_Id_Cache_5__c,
                                                                    Contact_Id_Cache_6__c,Contact_Id_Cache_7__c,Contact_Id_Cache_8__c,Contact_Id_Cache_9__c,
                                                                    Contact_Id_Cache_10__c, Contact_Id_Cache_11__c, Contact_Id_Cache_12__c
                                                                    FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_API_Name__c = :this.cacheId OR Cache_API_Name__c = :PORTAL_CONST_GLOBAL.DUMMY_CACHE_NAME ORDER BY Order_Number__c ASC]) {

            if (eachCacheRecord.Order_Number__c == -1) {
                continue;
            }

            Set<String> intermediateSet = new Set<String>();

            // loop through cache fields
            for (Integer fieldOrder = 1; fieldOrder <= 12; fieldOrder++) {
                String cacheFieldIds = (String)eachCacheRecord.get(getCacheFieldName(fieldOrder));
                if (String.isNotBlank(cacheFieldIds)) {
                    intermediateSet.addAll(cacheFieldIds.split(';'));  // split current cache field on cache record into a set (is current cache field)
                }

            }
            intermediateResultsCache =  addSetToCache(intermediateSet, intermediateResultsCache);

        }

        upsert intermediateResultsCache;

    }

    //--------------------------------------Private Helper Methods--------------------------------------//

    /**
     * Checks to see if item in postfix equation is an operator
     *
     * @param operator              String from the postfix equation
     * @return                      Boolean stating if the string is an operator or not
     * @since                       1.0
     */
    private static boolean isOperator(String operator) {
        operator = operator.toUpperCase();
        return (operator == 'AND' || operator == 'OR');
    }


    /**
     *  Get record type name form content recipients object
     *
     * @param   contentRecipientFilterId        Id of the filter
     * @return                  record name of providede filter
     * @since                   1.0
     */
    private String contentRecipientsRecordTypeName(String contentRecipientFilterId){
        return [SELECT RecordType.DeveloperName FROM ucinn_portal_Recipient__c WHERE Id =: contentRecipientFilterId]?.RecordType.DeveloperName;
    }

    /**
     * Grabs the filter used by the filter specified
     *
     * @param orderNumber           Specifies the field order from Needed from Content Recipients Filter
     * @param contentRecipientFilterId              Id of the Contact_Recipients
     * @return                      Content Recipients filter associated with fieldId and orderNumber
     * @since                       1.0
     */
    private ucinn_portal_Recipient_Filter__c getFilter(String orderNumber, String contentRecipientFilterId) {
        try {
            return [SELECT Object_API_Name__c, Field_API_Name__c, Operator__c, Field_Value__c , Order_Number__c,
                    Contact_Lookup_Field_API_Name__c
                    FROM ucinn_portal_Recipient_Filter__c
                    WHERE Recipient__c =: contentRecipientFilterId AND Order_Number__c =: orderNumber
                    LIMIT 1];
        } catch (System.QueryException e) {
            System.debug(e.getStackTraceString());
            throw new NewsletterFilterBatchException('There was an issue with your Newsletter_Recipients_Filters. Make sure you have all the filters you stated in your '+
                                                        'filter logic and that the fields and objects you stated are correctly spelled. Error Code: 405.');
        }
    }

    /**
     * Creates the sub queries given the information on the operand
     *
     * @param operand               Content Recipients Filter to create sub query off of
     * @return                      String version of query for content recipients filter
     * @since                       1.0
     */
    private  String getSubJoinQuery(ucinn_portal_Recipient_Filter__c filter) {
        String queryString =' ';
        if (String.isNotBlank(filter.Object_API_Name__c) && String.isNotBlank(filter.Field_API_Name__c) && String.isNotBlank(filter.Field_Value__c)) {
          try {
            DescribeSObjectResult filterObjectDescribeResult = ((SObject)(Type.forName(filter.Object_API_Name__c).newInstance())).getSObjectType().getDescribe();
            DisplayType fieldDisplayType = getDisplayTypeForFilter(filterObjectDescribeResult, filter.Field_API_Name__c, filter.Id);
            String fieldValue = getFieldValueForFilter(filter.Operator__c, filter.Field_Value__c, fieldDisplayType);
            // if the object we are querying on is Contact we just add it to the where clause.
            if (filter.Object_API_Name__c == 'Contact') {
                queryString +=  filter.Field_API_Name__c + ' ' + filter.Operator__c + ' '  + fieldValue +' ';
            } else {
                String contactIdField = filter.Contact_Lookup_Field_API_Name__c;

                if (String.isBlank(contactIdField)){
                    throw new NewsletterFilterBatchException ('There was no reference to Contact on that object. Error Code: 408.');
                }

                queryString += 'Id IN ( SELECT ' + contactIdField + ' FROM ' + filter.Object_API_Name__c +
                    ' WHERE ' + filter.Field_API_Name__c + ' ' + filter.Operator__c + ' ' + fieldValue +') ';

            }
          } catch (Exception e) {
              throw new NewsletterFilterBatchException('There was an error trying to create the query for the fitler ' + filter.Id);
          }

        }
        return queryString;
    }


    /**
     * Gets the last cache order from a cache
     *
     * @param cacheApiName              cache api name of the cache being searched for
     * @return                          Last Directory Search Filter Cache associated with cache
     * @since                           1.0
     */
    public ucinn_portal_Search_Filter_Cache__c getNextEmptyCache(String cacheApiName) {
        String cacheQuery =  'SELECT Contact_Id_Cache_1__c, Contact_Id_Cache_2__c, Contact_Id_Cache_3__c, Contact_Id_Cache_4__c, Contact_Id_Cache_5__c, Contact_Id_Cache_6__c,'
        + 'Contact_Id_Cache_7__c, Contact_Id_Cache_8__c, Contact_Id_Cache_9__c, Contact_Id_Cache_10__c, Contact_Id_Cache_11__c, Contact_Id_Cache_12__c, '
        + 'Order_Number__c, Cache_API_Name__c FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_API_Name__c= \'' + cacheApiName +'\' AND RecordTypeId= \''+ NEWSLETTER_FILTER_RECORD_TYPE_ID +'\'' + ' ORDER BY ORDER_Number__c DESC LIMIT 1';

        ucinn_portal_Search_Filter_Cache__c lastCacheRecord = Database.query(cacheQuery);

        Boolean createNewCache = true;
        // if field doesn't exist populate it with an empty one
        for (Integer fieldOrder = 1; fieldOrder <= 12; fieldOrder++) {
            String cacheFieldName = getCacheFieldName(fieldOrder);
            String cacheField = (String)lastCacheRecord.get(cacheFieldName);

            if (String.isBlank(cacheField)) {
                lastCacheRecord.put(cacheFieldName, '');
                createNewCache = false;
            }
        }

        if (createNewCache) {
            ucinn_portal_Search_Filter_Cache__c newCache = new ucinn_portal_Search_Filter_Cache__c();
            newCache.Name='Newsletter Cache';
            newCache.Cache_API_Name__c = cacheApiName;
            newCache.RecordTypeId= NEWSLETTER_FILTER_RECORD_TYPE_ID;
            newCache.Order_Number__c = (lastCacheRecord.Order_Number__c + 1);
            insert newCache;
            return newCache;
        }

        return lastCacheRecord;
    }

    /**
     * loop through the cache and get the next available cache field that has room to add more id's in.
     *
     * @param currentCache              Cache to search through
     * @param startIndex                Which field to start the search on
     * @return                          field order that has room, or -1 if there is no room
     * @since                           1.0
     */
    public static Integer getNextAvailableCacheField(ucinn_portal_Search_Filter_Cache__c currentCache, Integer startIndex) {
        Integer fieldOrder;

        for (fieldOrder = startIndex; fieldOrder <= 12; fieldOrder++) {
            String cacheFieldName = getCacheFieldName(fieldOrder);
            String cacheField = (String)currentCache.get(cacheFieldName);
            if (String.isBlank(cacheField)) {
                return fieldOrder;
            }
            // there is room to id's in current field
            if (cacheField.length() <= MAX_LENGTH - 19) {
                return fieldOrder;
            }
        }
        return -1;
    }

     /**
     * Method that gets the current zone for the newsletter
     *
     * @return                              Newsletter's portal zone
     * @since                               1.0
     */
    private String getZoneForNewsletter() {
        List<ucinn_portal_Listing__c> newsletterZones = [SELECT Portal_Zone__c  FROM ucinn_portal_Listing__c WHERE Id=:this.newsletterId];

        if (newsletterZones.isEmpty()) {
            throw new NewsletterFilterBatchException('There was an error with the newsletter filter. Error code:409.');
        }

        if (String.isBlank(newsletterZones.get(0).Portal_Zone__c)) {
            throw new NewsletterFilterBatchException('There was an error. Please add a portal zone to your newsletter. Error code:410.');
        }

        return newsletterZones.get(0).Portal_Zone__c;
    }

    /**
     * Generate query for those who should receive the newsletter based on zone membership or off of service indicator
     *
     * @return                          String query for all constituetnts with active zone membership that have Is_On_Newsletter__c set to true
     * @since                           1.0
     */
    private String getAlumniClubFilter() {

        String zone = getZoneForNewsletter();
        if (zone.toLowerCase() == PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME.toLowerCase()) { // if on ALL than don't filter on zone, filter on service indicator
            List<Portal_Organization_Setting__mdt> newsletterServiceIndicators = (List<Portal_Organization_Setting__mdt>) PORTAL_UTILS.getCustomMetadataRecordList(new Map<String, Object> {
                PORTAL_UTILS.FIELD_SET => new Set<String>{'Value__c'},
                PORTAL_UTILS.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
                PORTAL_UTILS.DEVELOPER_NAME_LIST => new List<String>{NEWSLETTER_SERVICE_INDICATOR_METADATA_NAME}
            });
            Set<String> serviceIndicatorSet = new Set<String>();
            for (Portal_Organization_Setting__mdt setting : newsletterServiceIndicators) {
                if (setting.DeveloperName == NEWSLETTER_SERVICE_INDICATOR_METADATA_NAME && String.isNotBlank(setting.Value__c)) {
                    List<String> serviceIndicatorValueList = setting.Value__c.split(';');
                    for (String eachServiceIndicatorValue : serviceIndicatorValueList) {
                        serviceIndicatorSet.add('\'' + eachServiceIndicatorValue + '\'');
                    }
                }
            }

            if (serviceIndicatorSet.isEmpty()) {
                return '';
            }

            return ' ID NOT IN ( SELECT ucinn_ascendv2__Contact__c FROM ucinn_ascendv2__Service_Indicator__c WHERE ' +
                ' ucinn_ascendv2__Is_Active__c = true AND (ucinn_ascendv2__Service_Indicator_Value__r.ucinn_ascendv2__Code__c IN (' +
                + String.join(new List<String> (serviceIndicatorSet), ',') + ')))';
        }
        String queryString = ' ID IN (SELECT Constituent__c FROM ucinn_portal_Zone_Membership__c WHERE Status__c = \'Active\' AND Is_On_Newsletter__c = true ';
        queryString += ' AND Zone__r.Name = ';
        queryString += '\'' + zone + '\')';
        return queryString;
    }

    /**
     * Adds the set of conact id's where it can find space in the cache.
     *
     * @param contactIds                        Set of contact ids to add to the cache
     * @param intermediateResultsCache          Cache to store contactIds in
     * @return                                  cache with the contactIds added to it
     * @since                                   1.0
     */
    @TestVisible
    private ucinn_portal_Search_Filter_Cache__c addSetToCache(Set<String> contactIds, ucinn_portal_Search_Filter_Cache__c intermediateResultsCache) {
        Integer fieldOrder = getNextAvailableCacheField(intermediateResultsCache, 1);
        if (fieldOrder == -1) {
            upsert intermediateResultsCache;
            intermediateResultsCache = new ucinn_portal_Search_Filter_Cache__c(Name='Newsletter Cache', Cache_API_Name__c=intermediateResultsCache.Cache_API_Name__c,RecordTypeId=NEWSLETTER_FILTER_RECORD_TYPE_ID, Order_Number__c= (intermediateResultsCache.Order_Number__c + 1));
            fieldOrder = 1;
        }
        String cacheFieldName = getCacheFieldName(fieldOrder);
        String cacheField = (String)intermediateResultsCache.get(cacheFieldName);
        if (String.isBlank(cacheField)) {
            cacheField = '';
        }
        Integer cacheLength = cacheField.length();

        for (String eachId: contactIds) {
            if (cacheLength + 19 >= MAX_LENGTH) {
                intermediateResultsCache.put(cacheFieldName, cacheField);
                if (fieldOrder == 12) {
                    upsert intermediateResultsCache;
                    intermediateResultsCache = new ucinn_portal_Search_Filter_Cache__c(Cache_API_Name__c=intermediateResultsCache.Cache_API_Name__c,RecordTypeId=NEWSLETTER_FILTER_RECORD_TYPE_ID, Order_Number__c= (intermediateResultsCache.Order_Number__c + 1));
                    fieldOrder = 1;
                    cacheField = '';
                    cacheFieldName = getCacheFieldName(fieldOrder);
                    cacheLength = 0;
                } else {
                    fieldOrder += 1;
                    cacheFieldName = getCacheFieldName(fieldOrder);
                    cacheField = (String)intermediateResultsCache.get(cacheFieldName);
                    if (String.isBlank(cacheField)) {
                        cacheField = '';
                    }
                    cacheLength = 0;
                }
            }
            cacheField += eachId + ';';
            cacheLength += 19;
        }

        intermediateResultsCache.put(cacheFieldName, cacheField);
        return intermediateResultsCache;
    }

    /**
     * Returns the number of id's in the entire cache
     *
     * @param cacheApiName                  Api name of the cache to count
     * @return                              Number of constituents in the cache
     * @since                               1.0
     */
    private Integer countResult(String cacheApiName) {
         Integer counter = 0;
        for (ucinn_portal_Search_Filter_Cache__c cacheRecord: [SELECT Cache_API_Name__c, Id, Order_Number__c, Contact_Id_Cache_1__c,
                                                            Contact_Id_Cache_2__c, Contact_Id_Cache_3__c, Contact_Id_Cache_4__c, Contact_Id_Cache_5__c,
                                                            Contact_Id_Cache_6__c,Contact_Id_Cache_7__c,Contact_Id_Cache_8__c,Contact_Id_Cache_9__c,
                                                            Contact_Id_Cache_10__c, Contact_Id_Cache_11__c, Contact_Id_Cache_12__c
                                                            FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_API_Name__c= :cacheApiName AND RecordTypeId = :NEWSLETTER_FILTER_RECORD_TYPE_ID ORDER BY Order_Number__c ASC]) {

            for (Integer fieldOrder = 1; fieldOrder <=12; fieldOrder++) {
                String cacheIds = (String)cacheRecord.get(getCacheFieldName(fieldOrder));
                if (String.isNotBlank(cacheIds)) {
                    counter += (cacheIds.length() / 19);
                }
            }
        }
        return counter;
    }


     /**
     * Method that gets the display type (data type) for a field
     *
     * @param filterObjectDescribeResult    the getDescribe() result for our desired sobject
     * @param filterFIeld                   the filter field we are trying to get the type for
     * @param filterId                      The id for our filter
     * @return                              The display type for our field
     * @since                               1.0
     */
    @TestVisible
    private DisplayType getDisplayTypeForFilter(DescribeSObjectResult filterObjectDescribeResult, String filterField, Id filterId) {
        if (filterField.containsIgnoreCase('__r')) {
            List<String> fieldList = filterField.split('\\.');
            if (fieldList.size() > 2) {
                throw new NewsletterFilterBatchException('The related query for filter with id ' + filterId + ' is nested too deep.');
            }
            String relationshipFieldName = fieldList.get(0).replace('__r', '__c');
            String fieldAPIName = fieldList.get(1);
            List<Schema.SObjectType> sobjectReferenceList = filterObjectDescribeResult.fields.getMap().get(relationshipFieldName).getDescribe().getReferenceTo();
            if (sobjectReferenceList.isEmpty()) {
                throw new NewsletterFilterBatchException ('There was an issue with finding the related object in the newsletter filter. Please check your spelling.'
                                            + '\nThe ucinn_portal_Recipient_Filter__c Id is: ' + filterId + '. Error Code: 406.');
            }
            String parentObjectAPIName = sobjectReferenceList.get(0).getDescribe().getName();
            DescribeSObjectResult relatedObjectDescribeResult = ((sObject)(Type.forName(parentObjectAPIName).newInstance())).getSObjectType().getDescribe();
            return relatedObjectDescribeResult.fields.getMap().get(fieldAPIName).getDescribe().getType();

        } else {
            return filterObjectDescribeResult.fields.getMap().get(filterField).getDescribe().getType();
        }
    }

     /**
     * returns the query string for the filter field
     *
     * @param operator                  The type of operation we are trying to query by
     * @param fieldValue                The field value that we are trying to filter the query by
     * @param fieldDisplayType          The data type for our field
     * @return                          The query representation of our field
     * @since                           1.0
     */
    @TestVisible
    private String getFieldValueForFilter(String operator, String fieldValue, DisplayType fieldDisplayType) {
        Set<String> operatorSet = new Set<String>{'INCLUDES', 'IN', 'NOT IN', 'EXCLUDES'};
          // Pre-processing of query based on operators. Field needs to be reformatted
        if (operator == 'LIKE') {
            return '\'%' + fieldValue + '%\'';
        }
        // Expecting a list seperated by semicolons. Ex: 1;2;3;4;5;6
        else if (operatorSet.contains(operator)) {
            List<String> splitFieldValues = fieldValue.split(';');
            Set<String> formattedFieldValues = new Set<String>();
            for (String value : splitFieldValues) {
                formattedFieldValues.add('\'' + value.trim() + '\'');
            }

            return '(' + String.join(new List<String>(formattedFieldValues), ',') + ')';
        } else {
            // add quotations to field types that need it (Ex: String)
            if (fieldDisplayType == Schema.DisplayType.CURRENCY || fieldDisplayType == Schema.DisplayType.DOUBLE || fieldDisplayType == Schema.DisplayType.BOOLEAN || fieldDisplayType == Schema.DisplayType.PERCENT) {
                return fieldValue;
            } else {
                return ' \''  + fieldValue +'\' ';
            }
        }
    }

     /**
     * Method that takes our current set of ids in the query and does
     * set methods to get the ids that match our filter
     *
     * @param recordIdSet                   The set of ids that we currently have from the btach execute
     * @param intermediateResultsCache      The current cache that is holding our data
     * @param cacheApiName                  The cache external id to get the ids that we are comparing against
     * @param operator                      The boolean logic operator to do the comparison
     * @since                               1.0
     */
    private ucinn_portal_Search_Filter_Cache__c identifyIdsToAddToSet(Set<String> recordIdSet, ucinn_portal_Search_Filter_Cache__c intermediateResultsCache, String cacheApiName, String operator) {
        Set<String> finalIdSet = new Set<String>(recordIdSet);
        Set<String> finalDuplicateIdSet = new Set<String>();
        for (ucinn_portal_Search_Filter_Cache__c eachCacheRecord : [SELECT Cache_API_Name__c, Id, Order_Number__c, Contact_Id_Cache_1__c,
                                                                    Contact_Id_Cache_2__c, Contact_Id_Cache_3__c, Contact_Id_Cache_4__c, Contact_Id_Cache_5__c,
                                                                    Contact_Id_Cache_6__c,Contact_Id_Cache_7__c,Contact_Id_Cache_8__c,Contact_Id_Cache_9__c,
                                                                    Contact_Id_Cache_10__c, Contact_Id_Cache_11__c, Contact_Id_Cache_12__c
                                                                    FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_API_Name__c = :cacheApiName OR Cache_API_Name__c = :PORTAL_CONST_GLOBAL.DUMMY_CACHE_NAME ORDER BY Order_Number__c ASC]) {

            if (eachCacheRecord.Order_Number__c == -1) {
                continue;
            }

            Set<String> intermediateSet = new Set<String>();

            // loop through cache fields
            for (Integer fieldOrder = 1; fieldOrder <= 12; fieldOrder++) {
                String cacheFieldIds = (String)eachCacheRecord.get(getCacheFieldName(fieldOrder));
                if (String.isNotBlank(cacheFieldIds)) {
                    intermediateSet.addAll(cacheFieldIds.split(';'));  // split current cache field on cache record into a set (is current cache field)
                }

            }

            if (operator == 'OR') {
                intermediateSet.retainAll(recordIdSet);
                finalDuplicateIdSet.addAll(intermediateSet);
            } else if (operator == 'AND') {
                intermediateSet.retainAll(recordIdSet);
                addSetToCache(intermediateSet, intermediateResultsCache);
            }
        }

        if (operator == 'OR') {
            finalIdSet.removeAll(finalDuplicateIdSet);
            return addSetToCache(finalIdSet, intermediateResultsCache);
        }
        return intermediateResultsCache;
    }

     /**
     * method that adjusts our postfix for the next iteration and calls the next batch if necessary
     *
     * @param jobId                         The job id for our current batch
     * @param totalItems                    The totla number of executes that ran for this batch
     * @since                               1.0
     */
    @TestVisible
    private void runNextBatch(Id jobId, Integer totalItems) {
        String operator;
        String operand1;
        String operand2;
        Integer currentIndex;

        // remove what was just operated on from the postfix expression and replace it with the cache number. Delete old caches
        for (currentIndex = 0; currentIndex < postfix.size(); currentIndex++) {
            if (isOperator(postfix[currentIndex])) {
                operator = postfix[currentIndex];
                postfix.remove(currentIndex);
                operand1 = postfix[currentIndex-1];

                if (!operand1.isNumeric() && operand1 != ALL_CONTACTS_CACHE_NAME) {
                    delete [SELECT Id FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_API_Name__c = :operand1];
                }

                postfix.remove(currentIndex - 1);
                operand2 = postfix[currentIndex-2];

                if (!operand2.isNumeric() && operand2 != ALL_CONTACTS_CACHE_NAME) {
                    delete [SELECT Id FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_API_Name__c = :operand2];
                }

                postfix.remove(currentIndex - 2);
                if (!postfix.isEmpty()) { // add current cache created into the postfix equation
                    postfix.add(currentIndex - 2, jobId); // adding id for cache in postfix equation
                }

                break;
            }
        }

        if (postfix.size() != 0) {
            if (totalItems == 0) {
                Integer currentBatchesCache = currentIndex - 2; // index of Cache_Api_Name of the cache for the current iteration of the batch

                if (this.currentOperator == 'OR') {

                    if (!operand1.isNumeric() && !operand2.isNumeric()) {
                        if (postfix[currentBatchesCache] != ALL_CONTACTS_CACHE_NAME) {
                            delete [SELECT Id FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_API_Name__c = :postfix[currentBatchesCache]];
                        }
                        postfix[currentBatchesCache] = operand2; // If both operands are caches, we query off the first one only so if the query is empty that means the first one is empty
                    }
                    else if ((operand1.isNumeric() && !operand2.isNumeric()) || !operand1.isNumeric() && operand2.isNumeric()){
                        // grab that one that is the cache and use that
                        String cacheToUse;
                        if (!operand1.isNumeric()) {
                            cacheToUse = operand1;
                        }
                        else if (!operand2.isNumeric()) {
                            cacheToUse = operand2;
                        }

                        if (postfix[currentBatchesCache] != ALL_CONTACTS_CACHE_NAME) {
                            delete [SELECT Id FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_API_Name__c = :postfix[currentBatchesCache]];
                        }
                        postfix[currentBatchesCache] = cacheToUse;
                    }
                }
            }

            String cacheId = null;
            String nextOperator = null;
            // grabbing nextOperator and cacheId
            for (Integer index = 0; index < postfix.size(); index++) {
                if (isOperator(postfix[index])) {
                    operator = postfix[index];
                    operand1 = postfix[index - 1];
                    operand2 = postfix[index - 2];
                    nextOperator = operator;

                    if (!operand2.isNumeric()) {
                        cacheId = operand2;
                    }
                    else if (!operand1.isNumeric()){
                        cacheId = operand1;
                    }
                    break;
                }
            }

            Database.executeBatch(new PORTAL_BATCH_NewsletterFilter(postfix, contentRecipientFilterId, newsletterId, cacheId, nextOperator, email, countRecipients, postProcessingFilters, deliveryTime), 2000);
        }
    }

     /**
     * Method that creates the current query string for our start method
     *
     * @param queryString                   The query string we want to modify
     * @param operator                      The boolean logic operator to join two subqueries
     * @param operand1                      The first boolean logic operand (can be the filter order number or a cache id)
     * @param operand2                      The second boolean logic operand (can be the filter order number or a cache id)
     * @return                              Query String for the start method
     * @since                               1.0
     */

    private String generateQueryStringWithOperands(String queryString, String operator, String operand1, String operand2) {
        // three casses for operands. Both are just subquerries, 1 is subquery 1 is cache, Both are cache
        if (String.isBlank(operand1) && String.isBlank(operand2)) {
            return queryString;
        }

        if (operand1.IsNumeric() && operand2.IsNumeric()) {

            ucinn_portal_Recipient_Filter__c firstFilter = getFilter(operand1, this.contentRecipientFilterId);
            queryString += ' AND (' + getSubJoinQuery(firstFilter);

            queryString += operator;

            ucinn_portal_Recipient_Filter__c secondFilter = getFilter(operand2, this.contentRecipientFilterId);
            queryString += getSubJoinQuery(secondFilter);
            queryString += ')';
        }
        else if (operand1.isNumeric()) { // operand2 is a cache
            ucinn_portal_Recipient_Filter__c filter = getFilter(operand1, this.contentRecipientFilterId);
            queryString += ' AND ' + getSubJoinQuery(filter);
            this.cacheId = operand2;
        }
        else if (operand2.isNumeric()) { // operand1 is a cache
            ucinn_portal_Recipient_Filter__c filter = getFilter(operand2, this.contentRecipientFilterId);
            queryString += ' AND ' + getSubJoinQuery(filter);
            this.cacheId = operand1;
        }
        return queryString;
    }

     /**
     * Method that sends out error emails in case of failure
     *
     * @param body                          The email body
     * @param jobId                         The current batch job id
     * @since                               1.0
     */
    private void sendExceptionEmail(String body, Id jobId) {
        String subjectLine = 'There was an error trying to send out the newletter';
        if (this.countRecipients == true) {
            subjectLine = 'There was an error counting your recipients';
        }
        if (String.isBlank(this.email)) {
            this.email = [SELECT Email FROM User WHERE Id = :UserInfo.getUserId()]?.Email;
        }
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject(subjectLine);
        mail.setHtmlBody(body);
        mail.setToAddresses(new String[]{email});
        mail.saveAsActivity = false;
        mailList.add(mail);
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(mailList);
        }
        System.abortJob(jobId);
    }

    private void sendCompletionEmail(String body) {
        String subjectLine = 'Count number of recipients has been completed';

        if (String.isBlank(this.email)) {
            this.email = [SELECT Email FROM User WHERE Id = :UserInfo.getUserId()]?.Email;
        }

        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject(subjectLine);
        mail.setHtmlBody(body);
        mail.setToAddresses(new String[]{email});
        mail.saveAsActivity = false;
        mailList.add(mail);
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(mailList);
        }
    }

    @TestVisible
    private static String getCacheFieldName(Integer fieldOrder) {
        return CONTACT_ID_FIELD + fieldOrder + '__c';
    }
}