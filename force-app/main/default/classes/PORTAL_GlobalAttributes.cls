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
 * Singleton class to support interim source url.
 * Class named Global Attributes to support scalability in the future if
 * we need to store more information in a singleton.
 * 
 * @author  Phillip Nguyen
 * @since   1.0
 * 
 */
public without sharing class PORTAL_GlobalAttributes {
    private static PORTAL_GlobalAttributes instance = null;
    private String pathURL = '';

    private PORTAL_GlobalAttributes() {}

    /**
     * Get singleton instance, instantiates it if it does not already exist.
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     */
    public static PORTAL_GlobalAttributes getInstance() {
        if (instance == null) {
            instance = new PORTAL_GlobalAttributes();
        }

        return instance;
    }

    /**
     * Set relative url
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param portalPathUrl     Path Url
     */
    public void setPathUrl(String portalPathUrl) {
        this.pathURL = portalPathUrl;
    }

    /**
     * get path/relative url
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     */
    public String getPathUrl() {
        return this.pathURL;
    }
}