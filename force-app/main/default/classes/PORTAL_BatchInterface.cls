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
/*
* Required functions for all portal batches
*
* @author Daniel Mardirousi
* @version 1.0
* @since 1.0
*/
global interface PORTAL_BatchInterface {
    Database.QueryLocator batchStart(Database.BatchableContext BC);

    void batchExecute(Database.BatchableContext BC, List<SObject> sobjectList);

    void batchFinish(Database.BatchableContext BC);
}