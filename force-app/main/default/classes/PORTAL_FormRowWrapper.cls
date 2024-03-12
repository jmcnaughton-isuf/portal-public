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
 * Wrapper class for form rows to be passed to an LWC.
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public inherited sharing class PORTAL_FormRowWrapper {
    @AuraEnabled
    public List<PORTAL_FormFieldWrapper> formFieldList {get; set;}

    public PORTAL_FormRowWrapper() {
        this.formFieldList = new List<PORTAL_FormFieldWrapper>();
    }

    public PORTAL_FormRowWrapper(List<PORTAL_FormFieldWrapper> formFieldList) {
        this.formFieldList = formFieldList;
    }
}