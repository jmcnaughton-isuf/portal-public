public without sharing class PORTAL_UTIL_Directory {
    public static final String ALL_CONST = 'All';

    /**
     * Gets a list of Search Criteria Metadata used for searching.
     *
     * @author Aaron Wong
     * @result List of Search Criteria Metadata.
     * @since  1.0
     */
    public static List<Portal_Directory_Search_Criteria__mdt> getSearchCriteriaMetadataList() {
        List<Portal_Directory_Search_Criteria__mdt> searchCriteriaMetadataList = [SELECT id, MasterLabel, DeveloperName, Default_Value__c, Display_Order__c, Directory_Location__c, Field_Logic__c, Search_Criteria_Name__c, Search_Input_Type__c,
                                                                                         Portal_Directory_Search_Category__r.Category_Name__C, Portal_Directory_Search_Category__r.Object_API_Name__c, Portal_Directory_Search_Category__r.Type__c,
                                                                                         Portal_Directory_Search_Category__r.Contact_Id_API_Name__c, Geolocation_Address_Input__c, Cache_API_Name__c,
                                                                                         (SELECT Field_Api_Name__c, Is_Negate_Logic__c, Operation__c, Order_Number__c, Static_Value__c FROM Portal_Directory_Search_Query_Fields__r)
                                                                                  FROM Portal_Directory_Search_Criteria__mdt
                                                                                  ORDER BY MasterLabel];

        return searchCriteriaMetadataList;
    }

    /**
     * Filters the given Search Criteria by the given zone.
     *
     * @author Aaron Wong
     * @param searchCriteriaList    List of search criteria to filter.
     * @param zone                  Zone to filter by.
     * @result                      Filtered list of search criteria.
     * @since                       1.0
     */
    public static List<Portal_Directory_Search_Criteria__mdt> filterSearchCriteriaByZone(List<Portal_Directory_Search_Criteria__mdt> searchCriteriaList,
                                                                                         String zone) {
        if (searchCriteriaList == null || searchCriteriaList.isEmpty() || String.isBlank(zone)) {
            return searchCriteriaList;
        }

        List<Portal_Directory_Search_Criteria__mdt> resultList = new List<Portal_Directory_Search_Criteria__mdt>();

        // Filter searchSettingList for all search Settings with the correct zone or specified as All
        for (Portal_Directory_Search_Criteria__mdt eachSearchCriteria : searchCriteriaList) {
            if (String.isBlank(eachSearchCriteria.Directory_Location__c)) {
                continue;
            }

            List<String> directoryLocationList = eachSearchCriteria.Directory_Location__c.split(';');

            if (directoryLocationList.contains(zone) || directoryLocationList.contains(ALL_CONST)) {
                resultList.add(eachSearchCriteria);
            }
        }

        return resultList;
    }

    /**
     * Send direct message to the constituent.
     *
     * @param: toContactId    The constituent to send a message to.
     * @param: subject        The subject of the message.
     * @param: body            The body of the message.
     * @since:                 1.0
     */
    public static void sendDirectMessage(String toContactId, String subject, String body) {
        List<ucinn_portal_Directory_Setting__c> receipientSettings = [SELECT Is_Receiving_Messages__c FROM ucinn_portal_Directory_Setting__c WHERE Contact__c = :toContactId];
        if (receipientSettings.size() > 0 && !receipientSettings.get(0).Is_Receiving_Messages__c) {
            //TODO: use PORTAL_CommunityUtils
            throw new AuraHandledException('This person does not want to be contacted.');
        }

        User currentUser = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        if (currentUser.ContactId != null) {
            List<ucinn_portal_Directory_Setting__c> userSettings = [SELECT Is_Receiving_Messages__c FROM ucinn_portal_Directory_Setting__c WHERE Contact__c = :currentUser.ContactId];
            if (userSettings.size() > 0  && !userSettings.get(0).Is_Receiving_Messages__c) {
                //TODO: use PORTAL_CommunityUtils
                throw new AuraHandledException('You have opted out of messaging. Please change your directory settings if you want to send a message.');
            }
        }

        User toUsr = [SELECT Id, ContactId FROM User WHERE ContactId = :toContactId];

        // Define the FeedItemInput object to pass to postFeedElement
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();

        // If you have problems with this variable talk to Ken :)
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = body;

        ConnectApi.TextSegmentInput textSegment;
        ConnectApi.MarkupBeginSegmentInput markupBeginSegment;
        ConnectApi.MarkupEndSegmentInput markupEndSegment;

        List<ConnectApi.MessageSegmentInput> messageSegments = new List<ConnectApi.MessageSegmentInput>();

        markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
        markupBeginSegment.markupType = ConnectApi.MarkupType.Paragraph;
        //messageSegments.add(markupBeginSegment);

        textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = body;
        messageSegments.add(textSegment);

        markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
        markupEndSegment.markupType = ConnectApi.MarkupType.Paragraph;
        //messageSegments.add(markupEndSegment);

        // The MessageBodyInput object holds the text in the post
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = messageSegments;

        feedItemInput.body = messageBodyInput;

        // The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
        // For this feed item, we define a direct message capability to hold the member(s) and the subject.

        List<String> memberIds = new List<String>();
        memberIds.add(toUsr.Id);

        ConnectApi.DirectMessageCapabilityInput dmInput = new ConnectApi.DirectMessageCapabilityInput();
        dmInput.subject = subject;
        dmInput.membersToAdd = memberIds;

        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
        feedElementCapabilitiesInput.directMessage = dmInput;

        feedItemInput.capabilities = feedElementCapabilitiesInput;

        if (!Test.isRunningTest()) {
            // Post the feed item.
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
        }
    }
}