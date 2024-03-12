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
 * Schduler class for adding constitutes to a zone membership based on proximity of their active addresses.
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
 */
// system.schedule('Zone membership', '0 0 2 ? * * *', new PORTAL_BATCH_ScheduleAddZoneMemberships()); //system method to schedule apex class
public virtual class PORTAL_BATCH_ScheduleAddZoneMemberships implements Schedulable{
    public virtual void execute(SchedulableContext ctx){
        Database.executeBatch(new PORTAL_BATCH_AddZoneMemberships());
    }
}