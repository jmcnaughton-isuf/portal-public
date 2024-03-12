public inherited sharing class PORTAL_CONST_Events {
    public static final Integer DEFAULT_SESSION_EXPIRATION_TIME = 15;
    public static final Integer DEFAULT_WATILIST_EXPIRATION_TIME_IN_HOURS = 24;
    public static final String DEFAULT_EMAIL_TEMPLATE_DEVELOPER_NAME = 'Portal_Event_Confirmation';

    public static final String TICKET_STATUS_PAID = 'Paid';
    public static final String TICKET_STATUS_AWAITING_GATEWAY_CONFIRMATION = 'Awaiting Gateway Confirmation';

    public static final String TICKET_DISCOUNT_TYPE_FREE = 'Free';
    public static final String TICKET_DISCOUNT_TYPE_PRICE = 'Price';
    public static final String TICKET_DISCOUNT_TYPE_PERCENTAGE = 'Percentage';

    public static final String TICKET_TYPE_API_NAME = 'Ticket_Type__c';

    public static final String REGISTRATION_SESSION_STATUS_COMPLETED = 'Completed';
    public static final String REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART = 'In Shopping Cart';
    public static final String REGISTRATION_SESSION_STATUS_PENDING_PAYMENT = 'Pending Payment';
    public static final String REGISTRATION_SESSION_STATUS_AWAITING_GATEWAY_CONFIRMATION = 'Awaiting Gateway Confirmation';

    public static final String PARTICIPATION_STATUS_REGISTERED = 'Registered';
    public static final String PARTICIPATION_STATUS_PAYMENT_PENDING = 'Payment Pending';
    public static final String PARTICIPATION_STATUS_CANCELLED = 'Cancelled';

    public static final String ORG_SETTING_IS_GUEST_REGISTRATION_MODIFIABLE = 'Is_Event_Guest_Registration_Modifiable';
    public static final String ORG_SETTING_SHOPPING_CART_EXPIRATION_TIME_IN_MINUTES = 'Shopping_Cart_Expiration_Time_in_Minutes';
    public static final String ORG_SETTING_EVENT_PAYMENT_EXPIRATION_TIME_IN_MINUTES = 'Event_Payment_Expiration_Time_in_Minutes';
    public static final String ORG_SETTING_EVENT_REGISTRATION_URL = 'Event_Registration_Url';
    public static final String ORG_SETTING_EVENT_SENDER_DISPLAY_NAME = 'Event_Sender_Display_Name';
    public static final String ORG_SETTING_WAITLIST_EXPIRATION = 'Waitlist_Expiration_Time_in_Hours';

    public static final String EMAIL_TEMPLATE_PORTAL_EVENT_WAITLIST_REGISTRATION = 'Portal_Event_Waitlist_Registration';
    public static final String EMAIL_TEMPLATE_PORTAL_EVENT_WAITLIST_AVAILABLE = 'Portal_Event_Waitlist_Available';
    public static final String EMAIL_TEMPLATE_EVENT_WAITLIST_EXPIRATION = 'Event_Waitlist_Expiration';

    public static final String EMAIL_SENDER_DISPLAY_NAME = 'UC Innovation Events';
}