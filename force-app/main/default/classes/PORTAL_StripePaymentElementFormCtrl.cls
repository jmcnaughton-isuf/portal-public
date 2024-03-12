public with sharing class PORTAL_StripePaymentElementFormCtrl {

    public String lexOrigin {
        get {
            return PORTAL_CommunityUtils.constructOrigin();
        }
        set;
    }
}