/*
 * Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
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
 * Subclass of Address Wrapper that adds fields specific to autocomplete
 * 
 * @author          Jacob Huang
 * @version         1.0
 * @since           1.0
 */
public inherited sharing class PORTAL_AutocompleteAddressWrapper extends PORTAL_AddressWrapper {
    public static final String NUMBER_OF_SIMILAR_ENTRIES = 'numberOfSimilarEntries';
    public static final String LABEL_CONST = 'label';
    public static final String ID_CONST = 'id';

    @AuraEnabled
    public Integer numberOfSimilarEntries {get; set;}   // number of addresses with the same streetLine 1 and 2
    @AuraEnabled
    public String label {get; set;}                     // address formatted for human readability 
    @AuraEnabled
    public String id {get; set;}                        // unique identifier for the address    

    /**
     * Default constructor, does not set any fields
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    public PORTAL_AutocompleteAddressWrapper() {
        super();
    }

    /**
     * Constructor, uses a map to set field values
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param objectRecord      Map<Object, Object>: map with field values used populate the address wrapper
     */
    public PORTAL_AutocompleteAddressWrapper(Object objectRecord) {
        super(objectRecord);

        if (objectRecord == null) {
            return;
        }
        Map<Object, Object> objectMap = (Map<Object, Object>) objectRecord;
        
        this.numberOfSimilarEntries = (Integer) objectMap.get(NUMBER_OF_SIMILAR_ENTRIES);
        this.label = (String) objectMap.get(LABEL_CONST);
        this.id = (String) objectMap.get(ID_CONST);
    }
}