public inherited sharing class PORTAL_StripeCreditCardFormController {
    public static final String STRIPE_DISABLED_WALLET_TYPES = 'Stripe_Disabled_Wallet_Types';

    public String lexOrigin {
        get {
            return PORTAL_CommunityUtils.constructOrigin();
        }
        set;
    }

    public String disableWallets {
        get {
            String disabledWalletTypes = PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => STRIPE_DISABLED_WALLET_TYPES});

            return String.isNotBlank(disabledWalletTypes) ? disabledWalletTypes : '[]';
        }
        set;
    }
}