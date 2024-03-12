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
 * Functions all geolocation service API's need to handle
 *
 * @author          Daniel Mardirousi
 * @version         1.0
 * @since           1.0
 */
global interface PORTAL_GeolocationApiInterface {

        /**
         * geolocate a single address and return the most likly result.
         *
         * @param       address                 Address to geolocate
         * @param       additonalUrlParams      Map of URL paramters names to URL paramter values to include.
         * @return                              Map of geolocation for the given address.
         * @version                             1.0
         * @since                               1.0
         */
        Map<String, Object> geolocateSingleLineAddress(String address, Map<String, String> additonalUrlParams);

       /**
         * geolocate a single address and return the most likly result.
         *
         * @param       address                 Address to geolocate
         * @return                              Map of geolocation for the given address.
         * @version                             1.0
         * @since                               1.0
         */
        Map<String, Object> geolocateSingleLineAddress(String address);
}