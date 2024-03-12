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
 * Wrapper class for form data to be passed to an LWC
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public virtual inherited sharing class PORTAL_FormWrapper {
    @AuraEnabled
    public String heading {get; set;}
    @AuraEnabled
    public String formId {get; set;}
    @AuraEnabled
    public List<PORTAL_FormWrapper> subSectionList {get; set;}
    @AuraEnabled
    public List<PORTAL_FormRowWrapper> formRowList {get; set;}  //List of form field lists
    @AuraEnabled
    public Boolean isMultipleRecordForm {get; set;}    // Whether or not to allow adding and deleting of records.
    @AuraEnabled
    public Boolean isDisplay {get; set;}
}