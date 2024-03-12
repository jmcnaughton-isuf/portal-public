/*
 * Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
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

/**
 * Wrapper class for form field data to be passed to an LWC.
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public virtual inherited sharing class PORTAL_FormFieldWrapper implements Comparable {
    @AuraEnabled
    public String fieldId {get; set;}
    @AuraEnabled
    public String fieldType {get; set;}
    @AuraEnabled
    public String label {get; set;}
    @AuraEnabled
    public Object value {get; set;}
    @AuraEnabled
    public String tooltipText {get; set;}
    @AuraEnabled
    public String fieldDescription {get; set;}
    @AuraEnabled
    public Decimal orderNumber {get; set;}
    @AuraEnabled
    public Boolean isRequired {get; set;}
    @AuraEnabled
    public Boolean isDisabled {get; set;}
    @AuraEnabled
    public Boolean isDisplay {get; set;}
    @AuraEnabled
    public List<Map<String, Object>> lookupSettingList {get; set;}     // Used for lookup fields
    @AuraEnabled
    public List<Map<String, String>> picklistValues {get; set;}

    /**
     * Comparator function used to sort the form fields. (Nulls first)
     *
     * @author Aaron Wong
     *
     * @param compareTo     A PORTAL_FormFieldWrapper object to compare to.
     * @return              Greater than 1 if the current field is should appear later, less than 1 if the current
     *                      field should appear sooner.
     * @since               1.0
     */
    public virtual Integer compareTo(Object compareTo) {
        if (compareTo == null || ((PORTAL_FormFieldWrapper)compareTo).orderNumber == null) {
            return 1;
        } else if (this.orderNumber == null) {
            return -1;
        } else if (this.orderNumber > ((PORTAL_FormFieldWrapper)compareTo).orderNumber) {
            return 1;
        } else {
            return -1;
        }
    }
}