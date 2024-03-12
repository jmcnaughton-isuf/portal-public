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
 * Case trigger base class
 *
 * @author      Daniel Mardirousi
 * @version 1.0
 * @since   1.0
 */
public without sharing class PORTAL_TRIG_Case {

    public static void run(Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUnDelete, List<SObject> triggerNewList, List<SObject> triggerOldList) {
        List<Case> approvedMembershipCases = new List<Case>();
        List<Case> deniedMembershipCases = new List<Case>();

        if (isAfter) {
            List<Case> newCases = (List<Case>) triggerNewList;
            List<Case> oldCases = (List<Case>) triggerOldList;
            if (isUpdate) {
                for (Integer index = 0; index < newCases.size(); index++) {
                    Case oldCase = oldCases.get(index);
                    Case newCase = newCases.get(index);
                    if (newCase.Type == 'Zone Membership' && newCase.Status == 'Approved' && newCase.Status != oldCase.Status) {
                        approvedMembershipCases.add(newCase);
                    }
                    else if (newCase.Type == 'Zone Membership' && newCase.Status == 'Denied' && newCase.Status != oldCase.Status) {
                        deniedMembershipCases.add(newCase);
                    }

                }

                updateMembershipCasses(approvedMembershipCases, 'Active');
                updateMembershipCasses(deniedMembershipCases, 'Denied');

            }
            if (isInsert) {
            }
        }
    }

    /**
     * On case update, update the related zone memberships
     *
     * @param   newCases                                list of new cases provided by the trigger
     * @param   newStatus                               The status to give the pending related zone memeberships
     */
    private static void updateMembershipCasses(List<Case> newCases, String newStatus) {
        if (newCases.isEmpty()) {
            return;
        }

        Set<Id> caseIds = new Set<Id>();

        for (Case currentCase : newCases) {
            caseIds.add((Id)currentCase.get('Id'));
        }

        List<ucinn_portal_Zone_Membership__c> membershipsToUpdate = [SELECT Id, Is_On_Newsletter__c, Status__c FROM ucinn_portal_Zone_Membership__c WHERE Case__c IN :caseIds];

        for (ucinn_portal_Zone_Membership__c currentMembership : membershipsToUpdate) {
            if (currentMembership.Status__c == 'Pending') {
                currentMembership.Status__c = newStatus;
            }
        }

        update membershipsToUpdate;
    }

}