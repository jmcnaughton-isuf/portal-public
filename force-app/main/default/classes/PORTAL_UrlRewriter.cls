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
 * Url Rewriter class for the portal. To be used on a community with no community prefix.
 * 
 * @author Aaron Wong
 * @since  1.0
 */
global class PORTAL_UrlRewriter implements Site.UrlRewriter {
    public static final String APPLE_DOMAIN_ASSOCIATION_TXT_PATH = '/.well-known/apple-developer-merchantid-domain-association.txt';
    public static final String APPLE_DOMAIN_ASSOCIATION_PATH = '/.well-known/apple-developer-merchantid-domain-association';
    public static final String APPLE_DOMAIN_RESOURCE_READER_PATH = '/PORTAL_AppleDomainAssociationReader';

    /**
     * Maps a user-friendly URL to a Salesforce URL.
     * 
     * @author Aaron Wong
     * 
     * @param myFriendlyUrl     Page reference that the user is attempting to go to.
     * @return                  Page reference that is displayed to the user.
     */
    global PageReference mapRequestUrl(PageReference myFriendlyUrl) {
        String url = myFriendlyUrl.getUrl();

        if (url == APPLE_DOMAIN_ASSOCIATION_PATH || url == APPLE_DOMAIN_ASSOCIATION_TXT_PATH){
            return new PageReference(APPLE_DOMAIN_RESOURCE_READER_PATH);
        }

        return myFriendlyUrl;
    }

    /**
     * Maps a list of Salesforce URLs to a list of user-friendly URLs
     * 
     * @author Aaron Wong
     * 
     * @param mySalesforceUrls      List of Salesforce Urls.  
     * @return                      List of user-friendly Urls. 
     */
    global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls) {
        List<PageReference> myFriendlyUrls = new List<PageReference>();

        for (PageReference mySalesforceUrl : mySalesforceUrls) {
            //Get the URL of the page
            String url = mySalesforceUrl.getUrl();

            if (url.startsWith(APPLE_DOMAIN_RESOURCE_READER_PATH)){
                myFriendlyUrls.add(new PageReference(APPLE_DOMAIN_ASSOCIATION_PATH));
                myFriendlyUrls.add(new PageReference(APPLE_DOMAIN_ASSOCIATION_TXT_PATH));
            } else {
                myFriendlyUrls.add(mySalesforceUrl);
            }
        }

        return myFriendlyUrls;
    }

}