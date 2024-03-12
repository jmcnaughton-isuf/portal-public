public inherited sharing class PORTAL_GooglePayController {
    private static final String MERCHANT_NAME_DEVELOPER_NAME = 'Merchant_Name';
    private static final String GOOGLE_PAY_MERCHANT_ID_DEVELOPER_NAME = 'Google_Pay_Merchant_Id';

    public String lexOrigin {
        get {
            return PORTAL_CommunityUtils.constructOrigin();
        }
        set;
    }

    public String merchantName {
        get {
            return PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{
                PORTAL_Utils.DEVELOPER_NAME => MERCHANT_NAME_DEVELOPER_NAME
            });
        }
        set;
    }

    public String merchantId {
        get {
            return PORTAL_Utils.getSecureMetadata(GOOGLE_PAY_MERCHANT_ID_DEVELOPER_NAME);
        }
        set;
    }
}