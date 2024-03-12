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
 * Handles logic revolving around Recipients
 *
 * @author Aaron Wong
 * @version 1.0
 * @since 1.0
 */
public inherited sharing class PORTAL_UTIL_Recipients {
    public static final String CONTACT_CONST = 'Contact';
    public static final String CONTACT_ID = 'contactId';
    public static final String TICKET_TYPE_ID_SET = 'ticketTypeIdSet';
    public static final String RECIPIENT_ID_SET = 'recipientIdSet';
    public static final String AND_CONST = 'AND';
    public static final String OR_CONST = 'OR';

    public static final String RECIPIENT_FILTER_API_NAME = 'ucinn_portal_Recipient_Filter__c';
    public static final String RECIPIENT_FILTER_FIELD_API_NAME = 'ucinn_portal_Recipient_Filter_Field__c';
    public static final String HAS_MULTIPLE_FIELDS_API_NAME = 'Has_Multiple_Fields__c';
    public static final string OBJECT_API_NAME_FIELD = 'Object_API_Name__c';
    public static final String FIELD_API_NAME_FIELD = 'Field_API_Name__c';
    public static final String FIELD_VALUE_API_NAME = 'Field_Value__c';
    public static final String FIELD_TYPE_API_NAME  = 'Field_Type__c';
    public static final String OPERATOR_API_NAME = 'Operator__c';
    public static final String CONTACT_RELATIONSHIP_API_NAME_FIELD = 'Contact_Relationship_API_Name__c';
    public static final String RECIPIENT_FILTER_RELATIONSHIP_NAME = 'Recipient_Filter__r';

    public static final String OBJECT_API_NAME = 'objectApiName';
    public static final String FIELD_API_NAME = 'fieldApiName';
    public static final String FIELD_VALUE = 'fieldValue';
    public static final String FIELD_TYPE = 'fieldType';
    public static final String OPERATOR_CONST = 'operator';

    public static final Map<String, String> RECIPIENT_FILTER_API_NAME_MAP = new Map<String, String>{OBJECT_API_NAME => OBJECT_API_NAME_FIELD,
                                                                                                    FIELD_API_NAME => FIELD_API_NAME_FIELD,
                                                                                                    FIELD_VALUE => FIELD_VALUE_API_NAME,
                                                                                                    FIELD_TYPE => FIELD_TYPE_API_NAME,
                                                                                                    OPERATOR_CONST => OPERATOR_API_NAME};
    public static final Map<String, String> RECIPIENT_FILTER_FIELD_API_NAME_MAP = new Map<String, String>{OBJECT_API_NAME => OBJECT_API_NAME_FIELD,
                                                                                                          FIELD_API_NAME => FIELD_API_NAME_FIELD,
                                                                                                          FIELD_VALUE => FIELD_VALUE_API_NAME,
                                                                                                          FIELD_TYPE => FIELD_TYPE_API_NAME,
                                                                                                          OPERATOR_CONST => OPERATOR_API_NAME};
    public static final Map<String, Map<String, String>> OBJECT_API_NAME_TO_FIELD_API_NAME_MAP = new Map<String, Map<String, String>>{RECIPIENT_FILTER_API_NAME => RECIPIENT_FILTER_API_NAME_MAP,
                                                                                                                                      RECIPIENT_FILTER_FIELD_API_NAME => RECIPIENT_FILTER_FIELD_API_NAME_MAP};

    /**
     * Method that checks all recipients against the constituent attributes
     *
     * @param constituentId:            The id of the constituent to use to query for the attributes
     * @param ticketTypeIdSet:          Set of ticket type Ids to check recipients for
     * @param recipientIdSet:           Set of recipient IDs to use 
     * 
     * @return:                         The set of content filter ids that the user has matches against
     */
    public static Set<String> getContentFiltersThatMatchConstituentAttributes(Map<String, Object> params) {
        Set<String> resultSet = new Set<String>();

        if (params == null || params.isEmpty() || String.isBlank((String)params.get(CONTACT_ID))) {
            return resultSet;
        }

        String constituentId = (String)params.get(CONTACT_ID);
        Set<String> ticketTypeIdSet = (Set<String>)params.get(TICKET_TYPE_ID_SET);
        Set<String> recipientIdSet = (Set<String>)params.get(RECIPIENT_ID_SET);

        List<ucinn_portal_Recipient__c> recipientList = getRecipientList(new Map<String, Object>{
            TICKET_TYPE_ID_SET => ticketTypeIdSet,
            RECIPIENT_ID_SET => recipientIdSet
        });

        if (recipientList == null || recipientList.isEmpty()) {
            return resultSet;
        }

        if (recipientIdSet == null) {
            recipientIdSet = new Set<String>();
            for (ucinn_portal_Recipient__c eachRecipient : recipientList) {
                recipientIdSet.add(eachRecipient.Id);
            }
        }

        // Map can be empty or null
        Map<String, List<ucinn_portal_Recipient_Filter_Field__c>> filterIdToFilterFieldMap = getFilterIdToFilterFieldMap(recipientIdSet);

        String contactQueryString = generateContactQueryString(recipientList, filterIdToFilterFieldMap, constituentId);

        if (String.isBlank(contactQueryString)) {
            return resultSet;
        }

        List<Contact> contactList = Database.query(contactQueryString);

        if (contactList == null || contactList.isEmpty()) {
            return resultSet;
        }

        resultSet = getMatchingRecipientIds(recipientList, filterIdToFilterFieldMap, contactList.get(0));

        return resultSet;
    }

    /**
     * Gets a list of Recipient records based on the criteria.
     *
     * @author Aaron Wong
     *
     * @param ticketTypeIdSet       Set of ticket type Ids.
     * @param recipientIdSet        Set of recipient IDs to query
     * 
     * @return                      List of Recipient records.
     * @since                       1.0
     */
    public static List<ucinn_portal_Recipient__c> getRecipientList(Map<String, Object> params) {
        List<ucinn_portal_Recipient__c> resultList = new List<ucinn_portal_Recipient__c>();

        Set<String> ticketTypeIdSet = null;
        Set<String> recipientIdSet = null;

        if (params != null && !params.isEmpty()) {
            ticketTypeIdSet = (Set<String>)params.get(TICKET_TYPE_ID_SET);
            recipientIdSet = (Set<String>)params.get(RECIPIENT_ID_SET);
        }

        String contentFilterQueryString = 'SELECT ';
        String contentFilterFields = ' Filter_Logic__c, (SELECT Field_API_Name__c, Field_Value__c, Object_API_Name__c, Field_Type__c, '
                                                            + ' Operator__c, Order_Number__c, Field_Logic__c, Has_Multiple_Fields__c, '
                                                            + ' Contact_Relationship_API_Name__c '
                                                            + ' FROM ucinn_portal_Recipient_Filters_Recipient__r) ';
        String whereClause = '';

        if (ticketTypeIdSet != null) {
            whereClause = ' WHERE id IN (SELECT Recipient__c FROM ucinn_portal_Ticket_Discount__c WHERE Ticket_Type__c IN :ticketTypeIdSet) ';
        } else if (recipientIdSet != null) {
            whereClause = ' WHERE Id IN :recipientIdSet';
        }

        contentFilterQueryString = contentFilterQueryString + contentFilterFields + ' FROM ucinn_portal_Recipient__c ' + whereClause;

        resultList = Database.query(contentFilterQueryString);

        return resultList;
    }

    /**
     * Gets a map of Recipient filter Id to Recipient Filter Fields
     *
     * @author Aaron Wong
     *
     * @param recipientIdSet        Set of recipient Ids
     * @return                      Map of Id to Recipient Filter Fields.
     * @since                       1.0
     */
     private static Map<String, List<ucinn_portal_Recipient_Filter_Field__c>> getFilterIdToFilterFieldMap(Set<String> recipientIdSet) {
         Map<String, List<ucinn_portal_Recipient_Filter_Field__c>> resultMap = new Map<String, List<ucinn_portal_Recipient_Filter_Field__c>>();

         if (recipientIdSet == null || recipientIdSet.isEmpty()) {
             return resultMap;
         }

        List<ucinn_portal_Recipient_Filter_Field__c> filterFieldList = [SELECT id, Field_API_Name__c, Field_Value__c, Operator__c, Object_API_Name__c, Field_Type__c,
                                                                                  Order_Number__c, Recipient_Filter__c, Recipient_Filter__r.Contact_Relationship_API_Name__c
                                                                        FROM ucinn_portal_Recipient_Filter_Field__c
                                                                        WHERE Recipient_Filter__r.Recipient__c IN :recipientIdSet];

        for (ucinn_portal_Recipient_Filter_Field__c eachFilterField : filterFieldList) {
            if (resultMap.containsKey(eachFilterField.Recipient_Filter__c)) {
                resultMap.get(eachFilterField.Recipient_Filter__c).add(eachFilterField);
            } else {
                resultMap.put(eachFilterField.Recipient_Filter__c, new List<ucinn_portal_Recipient_Filter_Field__c>{eachFilterField});
            }
        }

        return resultMap;
     }

    /**
     * Generates contact query string containing fields used by the Recipient filters.
     *
     * @author Aaron wong
     *
     * @param recipientList                 List of Recipient records.
     * @param filterIdToFilterFieldMap      Map of Recipient Filter Ids to lists of Recipient Filter Fields.
     * @param constituentId                 The Id of the constituent to get.
     * @return                              Contact query string.
     * @since                               1.0
     */
    private static String generateContactQueryString(List<ucinn_portal_Recipient__c> recipientList,
                                                      Map<String, List<ucinn_portal_Recipient_Filter_Field__c>> filterIdToFilterFieldMap,
                                                      String constituentId) {
        if (recipientList == null || recipientList.isEmpty() || String.isBlank(constituentId)) {
            return '';
        }

        //map that keeps track of the fields to query for for each related object and for the contact itself
        Map<String, Set<String>> relationshipNameToFieldsToQueryMap = getFieldsToQueryMap(recipientList, filterIdToFilterFieldMap);

        //generates the query string and queries for the contact
        String resultString = 'SELECT Id';

        List<String> nestedQueryStringList = new List<String>();

        for (String sObjectAPIName : relationshipNameToFieldsToQueryMap.keySet()) {
            if (sObjectAPIName == CONTACT_CONST) {
                resultString = resultString + ',' + String.join(new List<String>(relationshipNameToFieldsToQueryMap.get(sObjectAPIName)), ', ');
            } else {
                String nestedQueryString = '(SELECT ' + String.join(new List<String>(relationshipNameToFieldsToQueryMap.get(sObjectAPIName)), ', ') + ' FROM ' +
                                           sObjectAPIName + ')';
                nestedQueryStringList.add(nestedQueryString);
            }
        }

        if (nestedQueryStringList.size() > 0) {
            resultString = resultString + ', ' + String.join(nestedQueryStringList, ', ');
        }

        resultString = resultString + ' FROM Contact WHERE Id = \'' + constituentId + '\'';

        return resultString;
    }

    /**
     * Gets the matching recipient Ids for the contact given.
     *
     * @author Aaron Wong
     *
     * @param recipientList                 List of Recipient records.
     * @param filterIdToFilterFieldMap      Map of Recipient Filter Ids to lists of Recipient Filter Fields.
     * @param contactRecord                 The contact to check against.
     * @return                              Set of recipient Ids that match the constituent.
     * @since                               1.0
     */
    private static Set<String> getMatchingRecipientIds(List<ucinn_portal_Recipient__c> recipientList,
                                                       Map<String, List<ucinn_portal_Recipient_Filter_Field__c>> filterIdToFilterFieldMap,
                                                       Contact contactRecord) {
        Set<String> resultSet = new Set<String>();

        if (recipientList == null || recipientList.isEmpty() || contactRecord == null) {
            return resultSet;
        }

        //for each of the content filters, go through the filter criteria and check each one against the constituent
        for (ucinn_portal_Recipient__c eachRecipient : recipientList) {
            //generate a map of the filter criteria order to filter criteria for easy look up since the logic can be in any order
            Map<String, ucinn_portal_Recipient_Filter__c> orderToFilterCriteriaMap = new Map<String, ucinn_portal_Recipient_Filter__c>();
            if (eachRecipient.ucinn_portal_Recipient_Filters_Recipient__r == null || eachRecipient.ucinn_portal_Recipient_Filters_Recipient__r.size() <= 0) {
                continue;
            }

            for (ucinn_portal_Recipient_Filter__c eachFilterCriteria : eachRecipient.ucinn_portal_Recipient_Filters_Recipient__r) {
                if (String.isNotBlank(eachFilterCriteria.Order_Number__c)) {
                    orderToFilterCriteriaMap.put(eachFilterCriteria.Order_Number__c, eachFilterCriteria);
                }
            }

            String filterLogic = eachRecipient.Filter_Logic__c;

            if (String.isBlank(filterLogic)) {
                filterLogic = '';

                for (ucinn_portal_Recipient_Filter__c eachRecipientFilter : eachRecipient.ucinn_portal_Recipient_Filters_Recipient__r) {
                    if (String.isBlank(eachRecipientFilter.Order_Number__c)) {
                        continue;
                    }

                    if (String.isNotBlank(filterLogic)) {
                        filterLogic = filterLogic + ' AND ';
                    }

                    filterLogic = filterLogic + eachRecipientFilter.Order_Number__c;
                }
            }

            if (evaluateFilterLogic(contactRecord, filterLogic, RECIPIENT_FILTER_API_NAME, orderToFilterCriteriaMap, filterIdToFilterFieldMap) == true) {
                resultSet.add(eachRecipient.Id);
            }
        }

        return resultSet;
    }

    /**
     * Gets the fields to query on Contact.
     *
     * @author Ashley Tran
     *
     * @param recipientList                 List of recipient records.
     * @param filterIdToFilterFieldMap      Map of Recipient Filter Ids to Recipient Filter Fields.
     * @return                              Map of relationship name to fields to query.
     * @since                               1.0
     */
    private static Map<String, Set<String>> getFieldsToQueryMap(List<ucinn_portal_Recipient__c> recipientList,
                                                                Map<String, List<ucinn_portal_Recipient_Filter_Field__c>> filterIdToFilterFieldMap) {
        Map<String, Set<String>> resultMap = new Map<String, Set<String>>();

        if (recipientList == null || recipientList.isEmpty()) {
            return resultMap;
        }

        //grabs all of the fields that should be queried for
        for (ucinn_portal_Recipient__c eachRecipient : recipientList) {
            if (eachRecipient.ucinn_portal_Recipient_Filters_Recipient__r != null) {
                for (ucinn_portal_Recipient_Filter__c eachRecipientFilter : eachRecipient.ucinn_portal_Recipient_Filters_Recipient__r) {
                    String objectRelationshipName = eachRecipientFilter.Object_API_Name__c;

                    if (objectRelationshipName == CONTACT_CONST && eachRecipientFilter.Field_API_Name__c == 'Id') {
                        continue;
                    }

                    if (objectRelationshipName != CONTACT_CONST) {
                        objectRelationshipName = eachRecipientFilter.Contact_Relationship_API_Name__c;
                    }

                    if (!String.isBlank(objectRelationshipName) && String.isNotBlank(eachRecipientFilter.Field_API_Name__c)) {
                        if (resultMap.containsKey(objectRelationshipName)) {
                            resultMap.get(objectRelationshipName).add(eachRecipientFilter.Field_API_Name__c);
                        } else {
                            resultMap.put(objectRelationshipName, new Set<String>{eachRecipientFilter.Field_API_Name__c});
                        }
                    }

                    if (eachRecipientFilter.Has_Multiple_Fields__c == true && filterIdToFilterFieldMap.containsKey(eachRecipientFilter.Id)) {
                        List<ucinn_portal_Recipient_Filter_Field__c> filterFieldList = filterIdToFilterFieldMap.get(eachRecipientFilter.Id);

                        for (ucinn_portal_Recipient_Filter_Field__c eachFilterField : filterFieldList) {
                            if (String.isNotBlank(eachFilterField.Field_API_Name__c)) {
                                if (resultMap.containsKey(objectRelationshipName)) {
                                    resultMap.get(objectRelationshipName).add(eachFilterField.Field_Api_Name__c);
                                } else {
                                    resultMap.put(objectRelationshipName, new Set<String>{eachFilterField.Field_Api_Name__c});
                                }
                            }
                        }
                    }
                }
            }
        }

        return resultMap;
    }

    /**
     * Evaluates Recipient filters with multiple fields
     *
     * @author Ashley Tran
     *
     * @param contactRecord                 The contact record.
     * @param filterCriteria                The filter criteria to filter by.
     * @param filterIdToFilterFieldMap      Map of Recipient Filter Ids to lists of Recipient Filter Fields.
     * @return                              If the contact matches the filter criteria.
     * @since                               1.0
     */
    public static Boolean evaluateFilterFieldCriteriaWithMultipleFields(Contact contactRecord,
                                                                        ucinn_portal_Recipient_Filter__c filterCriteria,
                                                                        Map<String, List<ucinn_portal_Recipient_Filter_Field__c>> filterIdToFilterFieldMap) {
        if (contactRecord == null || filterCriteria == null) {
            return false;
        }

        Map<String, ucinn_portal_Recipient_Filter_Field__c> orderToFilterFieldsMap = new Map<String, ucinn_portal_Recipient_Filter_Field__c>();
        if (!filterIdToFilterFieldMap.containsKey(filterCriteria.Id) || filterIdToFilterFieldMap.get(filterCriteria.Id).isEmpty()) {
            return false;
        } else {
            for (ucinn_portal_Recipient_Filter_Field__c eachFilterField : filterIdToFilterFieldMap.get(filterCriteria.Id)) {
                if (!String.isBlank(eachFilterField.Order_Number__c)) {
                    orderToFilterFieldsMap.put(eachFilterField.Order_Number__c, eachFilterField);
                }
            }
        }

        String fieldLogic = filterCriteria.Field_Logic__c;

        if (String.isBlank(fieldLogic)) {
            fieldLogic = '';

            for (ucinn_portal_Recipient_Filter_Field__c eachFilterField : filterIdToFilterFieldMap.get(filterCriteria.Id)) {
                if (String.isNotBlank(fieldLogic)) {
                    fieldLogic = fieldLogic + ' AND ';
                }

                fieldLogic = fieldLogic + eachFilterField.Order_Number__c;
            }
        }

        return evaluateFilterLogic(contactRecord, fieldLogic, RECIPIENT_FILTER_FIELD_API_NAME, orderToFilterFieldsMap, filterIdToFilterFieldMap);
    }

    /**
     * Evaluates the filter logic to determine if the Constituent passes the filter.
     *
     * @author Aaron Wong
     *
     * @param contactRecord                 The contact record to filter.
     * @param filterLogic                   The logic to filter by.
     * @param sObjectAPIName                The object api name of the criteria to evaluate.
     * @param orderToCriteriaMap            Map of order number to criteria to evaluate.
     * @param filterIdToFilterFieldMap      Map of filter Id to Filter Fields.
     * @return                              If the contact record passes the filter or not.
     * @since                               1.0
     */
    private static Boolean evaluateFilterLogic(Contact contactRecord,
                                               String filterLogic,
                                               String sObjectAPIName,
                                               Map<String, SObject> orderToCriteriaMap,
                                               Map<String, List<ucinn_portal_Recipient_Filter_Field__c>> filterIdToFilterFieldMap) {
        if (String.isBlank(filterLogic)) {
            return false;
        }
        //map that keeps track of the related records that have passed the criteria so far
        Map<String, Set<Id>> childObjectNameToIdsThatMatchCriteriaMap = new Map<String, Set<Id>>();
        //generates a list of string that tells you which order to evaluate the expression in (can be integers, OR, AND)
        List<String> postFixExpressions = PORTAL_CommunityUtils.infixToPostFix(new Map<String, Object> {PORTAL_CommunityUtils.PARAM_LOGIC_STRING => filterLogic});

        if (postFixExpressions == null || postFixExpressions.isEmpty()) {
            return false;
        }

        //if there is only on filter criteria and it is an integer, evaluate that single criteria against the constituent attribute
        //if the constituent matches, then add the filter id to the set of ids to return
        if (postFixExpressions.size() == 1) {
            if (postFixExpressions.get(0).isNumeric() && orderToCriteriaMap.containsKey(postFixExpressions.get(0))) {
                return evaluateCriteria(contactRecord,
                                        orderToCriteriaMap.get(postFixExpressions.get(0)),
                                        childObjectNameToIdsThatMatchCriteriaMap,
                                        filterIdToFilterFieldMap,
                                        sObjectAPIName,
                                        AND_CONST);
            }
        }
        //if there are multiple criteria then evaluate the criteria in the correct order
        List<Boolean> stack = new List<Boolean>();
        while (postFixExpressions.size() > 0) {
            //postfix is evaluated by first finding an operator and then evaluating the two previous criteria using the operator
            for (Integer postFixIndex = 0; postFixIndex < postFixExpressions.size(); postFixIndex++) {
                if (postFixExpressions.get(postFixIndex) == OR_CONST || postFixExpressions.get(postFixIndex) == AND_CONST) {
                    //if there is no criteria before the operator then clear everything and break
                    //must clear the postFixExpressions to stop the while loop
                    //must clear the stack to indicate a bad result
                    //must stop evaluating because you have bad filter logic
                    if (postFixIndex - 1 < 0) {
                        postFixExpressions.clear();
                        stack.clear();
                        break;
                    //if you have no criteria two indices before the operator then you must use the most recent
                    //evaluation result. if there is no result then this in an error because your logic is bad and
                    //looks something like '1 AND'
                    } else if (postFixIndex - 2 < 0 && stack.size() == 0) {
                        postFixExpressions.clear();
                        stack.clear();
                        break;
                    } else {
                        //you can evaluate your criteria
                        Integer indexOfFirstOperand = postFixIndex - 1;

                        //stops evaluating because your logic looks something like 'AND AND AND'
                        //which cannot be evaulated
                        if (!postFixExpressions.get(indexOfFirstOperand).isNumeric()) {
                            postFixExpressions.clear();
                            stack.clear();
                            break;
                        }

                        Integer indexOfSecondOperand = postFixIndex - 2;

                        //the second operand exists within the expression and should be evaulated
                        if (indexOfSecondOperand >= 0) {

                            //stops evaluating because your logic looks something like 'AND AND AND'
                            //which cannot be evaulated
                            if (!postFixExpressions.get(indexOfSecondOperand).isNumeric()) {
                                postFixExpressions.clear();
                                stack.clear();
                                break;
                            }
                            //evaluates the criteria and adds the result to the stack
                            Boolean evaluationOfFirstOperand = evaluateCriteria(contactRecord,
                                                                                orderToCriteriaMap.get(postFixExpressions.get(indexOfFirstOperand)),
                                                                                childObjectNameToIdsThatMatchCriteriaMap,
                                                                                filterIdToFilterFieldMap,
                                                                                sObjectAPIName,
                                                                                postFixExpressions.get(postFixIndex)) == true;
                            Boolean evaluationOfSecondOperand = evaluateCriteria(contactRecord,
                                                                                orderToCriteriaMap.get(postFixExpressions.get(indexOfSecondOperand)),
                                                                                childObjectNameToIdsThatMatchCriteriaMap,
                                                                                filterIdToFilterFieldMap,
                                                                                sObjectAPIName,
                                                                                postFixExpressions.get(postFixIndex)) == true;
                            if (postFixExpressions.get(postFixIndex) == OR_CONST) {
                                stack.add((evaluationOfFirstOperand || evaluationOfSecondOperand));
                            } else if (postFixExpressions.get(postFixIndex) == AND_CONST) {
                                stack.add((evaluationOfFirstOperand && evaluationOfSecondOperand));
                            }
                            //removes the criteria that was just evaluated from the list of expressions to evaluate
                            //breaks here to start the evaluation at the beginning after the removal of the old expressions
                            postFixExpressions.remove(postFixIndex);
                            postFixExpressions.remove(indexOfFirstOperand);
                            postFixExpressions.remove(indexOfSecondOperand);
                            break;
                        } else {
                            // 1 AND 2 AND 3 => 1 2 AND 3 AND
                            //evaulates the first criteria against the last result
                            Boolean evaluationOfFirstOperand = evaluateCriteria(contactRecord,
                                                                                orderToCriteriaMap.get(postFixExpressions.get(indexOfFirstOperand)),
                                                                                childObjectNameToIdsThatMatchCriteriaMap,
                                                                                filterIdToFilterFieldMap,
                                                                                sObjectAPIName,
                                                                                postFixExpressions.get(postFixIndex)) == true;
                            Boolean evaluationOfSecondOperand = stack.get(0);
                            stack.clear();
                            if (postFixExpressions.get(postFixIndex) == OR_CONST) {
                                stack.add((evaluationOfFirstOperand || evaluationOfSecondOperand));
                            } else if (postFixExpressions.get(postFixIndex) == AND_CONST) {
                                stack.add((evaluationOfFirstOperand && evaluationOfSecondOperand));
                            }
                            //removes the criteria that was just evaluated from the list of expressions to evaluate
                            //breaks here to start the evaluation at the beginning after the removal of the old expressions
                            postFixExpressions.remove(postFixIndex);
                            postFixExpressions.remove(indexOfFirstOperand);
                            break;
                        }
                    }
                //if you've reached the end of your expression but there was no operator
                //stop all evaluations
                } else if (postFixIndex == postFixExpressions.size() - 1) {
                    postFixExpressions.clear();
                    stack.clear();
                    break;
                }
            }
        }

        //if the evaluations succeeded and the result was true
        //add the filter id to the set of ids to return
        if (stack.size() == 1 && stack.get(0) == true) {
            return true;
        }
        return false;
    }

    /**
     * Evaluates filter fields for a constituent.
     *
     * @author Ashley Tran
     *
     * @param contactRecord                                 The contact record to evaluate.
     * @param criteriaRecord                                The filter field to evaluate.
     * @param childObjectNameToIdsThatMatchCriteriaMap      Map that keeps track of all child records that have passed the previous criteria
     * @param filterIdToFilterFieldMap                      Map of filter Id to Filter Fields.
     * @param sObjectAPIName                                The object api name of the criteria to evaluate.
     * @param operator                                      Operator to evaluate the filter field with.
     * @return                                              Whether or not the filter field passes for the contact record.
     * @since                                               1.0
     */
    private static Boolean evaluateCriteria(Contact contactRecord,
                                            SObject criteriaRecord,
                                            Map<String, Set<Id>> childObjectNameToIdsThatMatchCriteriaMap,
                                            Map<String, List<ucinn_portal_Recipient_Filter_Field__c>> filterIdToFilterFieldMap,
                                            String sObjectAPIName,
                                            String operator) {

        Map<String, String> FIELD_API_NAME_MAP = OBJECT_API_NAME_TO_FIELD_API_NAME_MAP.get(sObjectAPIName);

        if (FIELD_API_NAME_MAP == null || FIELD_API_NAME_MAP.isEmpty()) {
            return false;
        }

        //if we had no criteria return false
        if (contactRecord == null || criteriaRecord == null || String.isBlank(sObjectAPIName)) {
            return false;
        }

        if (sObjectAPIName == RECIPIENT_FILTER_API_NAME && (Boolean)criteriaRecord.get(HAS_MULTIPLE_FIELDS_API_NAME) == true) {
            return evaluateFilterFieldCriteriaWithMultipleFields(contactRecord, (ucinn_portal_Recipient_Filter__c)criteriaRecord, filterIdToFilterFieldMap);
        }

        if ((String)criteriaRecord.get(FIELD_API_NAME_MAP.get(OBJECT_API_NAME)) == CONTACT_CONST) {
            //gets the relationship value if evaluating a parent field and compares it against the value on the filter criteria
            if (((String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_API_NAME))).contains('.')) {
                List<String> fields = ((String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_API_NAME))).split('\\.');

                if (contactRecord.getSObject(fields.get(0)) == null) {
                    return false;
                } else {
                   return PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object> {
                                                                   PORTAL_CommunityUtils.PARAM_FIRST_VALUE => String.valueOf(contactRecord.getSObject(fields.get(0)).get(fields.get(1))),
                                                                   PORTAL_CommunityUtils.PARAM_SECOND_VALUE => (String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_VALUE)),
                                                                   PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => (String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_TYPE)),
                                                                   PORTAL_CommunityUtils.PARAM_OPERATOR => (String)criteriaRecord.get(FIELD_API_NAME_MAP.get(OPERATOR_CONST))});
                }
            //compares the constituent attribute against the value on the filter criteria
            } else {
                   return PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object> {
                                                                   PORTAL_CommunityUtils.PARAM_FIRST_VALUE => String.valueOf(contactRecord.get((String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_API_NAME)))),
                                                                   PORTAL_CommunityUtils.PARAM_SECOND_VALUE => (String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_VALUE)),
                                                                   PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => (String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_TYPE)),
                                                                   PORTAL_CommunityUtils.PARAM_OPERATOR => (String)criteriaRecord.get(FIELD_API_NAME_MAP.get(OPERATOR_CONST))});
            }
        //must evaluate child records differently
        } else {
            String contactRelationshipName = '';

            if (sObjectAPIName == RECIPIENT_FILTER_API_NAME) {
                contactRelationshipName = (String)criteriaRecord.get(CONTACT_RELATIONSHIP_API_NAME_FIELD);
            } else {
                contactRelationshipName = (String)(criteriaRecord.getSObject(RECIPIENT_FILTER_RELATIONSHIP_NAME).get(CONTACT_RELATIONSHIP_API_NAME_FIELD));
            }

            if (!String.isBlank(contactRelationshipName)) {
                 if (contactRecord.getSObjects(contactRelationshipName) != null) {
                    //creates a set of ids of child records that currently match this criteria
                    //ids are added to this set if the child record value matches the value on the filter criteria
                    Set<Id> idsThatMatchCriteria = new Set<Id>();

                    for (sObject childRecord : contactRecord.getSObjects(contactRelationshipName)) {
                        if (((String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_API_NAME))).contains('.')) {
                            List<String> fields = ((String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_API_NAME))).split('\\.');

                            if (childRecord.getSObject(fields.get(0)) != null) {
                                if (PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object> {
                                                                   PORTAL_CommunityUtils.PARAM_FIRST_VALUE => String.valueOf(childRecord.getSObject(fields.get(0)).get(fields.get(1))),
                                                                   PORTAL_CommunityUtils.PARAM_SECOND_VALUE => (String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_VALUE)),
                                                                   PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => (String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_TYPE)),
                                                                   PORTAL_CommunityUtils.PARAM_OPERATOR => (String)criteriaRecord.get(FIELD_API_NAME_MAP.get(OPERATOR_CONST))})) {
                                    idsThatMatchCriteria.add(childRecord.Id);
                                }
                            }
                        } else {
                            if (PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object> {
                                                                   PORTAL_CommunityUtils.PARAM_FIRST_VALUE => String.valueOf(childRecord.get((String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_API_NAME)))),
                                                                   PORTAL_CommunityUtils.PARAM_SECOND_VALUE => (String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_VALUE)),
                                                                   PORTAL_CommunityUtils.PARAM_OPERAND_TYPE => (String)criteriaRecord.get(FIELD_API_NAME_MAP.get(FIELD_TYPE)),
                                                                   PORTAL_CommunityUtils.PARAM_OPERATOR => (String)criteriaRecord.get(FIELD_API_NAME_MAP.get(OPERATOR_CONST))})) {
                                idsThatMatchCriteria.add(childRecord.Id);
                            }
                        }
                    }
                    //if there was an existing set of ids that were evaluated against existing criteria
                    //must do a set union or intersection depending on the operator
                    //evaluates based on the size of the ids
                    //else add the set of ids to the map of relationship name to ids that match
                    //this is necessary to make sure that child records are evaluated correctly
                    //for example if the filter logic that was evaulated before this one was 'Contact_Name__r.First_Name__c == 'Emily''
                    //then all records that had first name Emily was added to the set
                    //if the operator was AND and the criteria that we are evaluating right now is 'Contact_Name__r.Last_Name__c == 'Alumni''
                    //then we must make sure that Emily and Alumni are values on the same contact name
                    // record by making sure the id of the child record is in both sets (the previous evaluated set and the set we just created)
                    //if the operator was OR then we could have any contact name record that had either first name Emily or last name Alumni (they do
                    // not have to be on the same record) so the evaluation is true as long as the id is in either set
                    if (childObjectNameToIdsThatMatchCriteriaMap.containsKey(contactRelationshipName)) {
                        Set<Id> idsThatMatchAllCriteria = childObjectNameToIdsThatMatchCriteriaMap.get(contactRelationshipName);
                        if (operator == OR_CONST) {
                            idsThatMatchAllCriteria.addAll(idsThatMatchCriteria);
                        } else if (operator == AND_CONST) {
                            idsThatMatchAllCriteria.retainAll(idsThatMatchCriteria);
                        }
                        return idsThatMatchAllCriteria.size() > 0;
                    } else {
                        childObjectNameToIdsThatMatchCriteriaMap.put(contactRelationshipName, idsThatMatchCriteria);
                        return idsThatMatchCriteria.size() > 0;
                    }
                }

            }

            return false;
        }
    }
}