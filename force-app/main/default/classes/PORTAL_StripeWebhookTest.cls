@isTest
public class PORTAL_StripeWebhookTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual String getInvoiceResponseBody () {
            return '{"id":"evt_1HBwikI20XIvtWbhyfMRXIg7","object":"event","api_version":"2020-03-02","created":1596434426,"data":{"object":{"id":"in_1HBvmaI20XIvtWbhXYabgewF","object":"invoice","account_country":"US","account_name":"MorehouseCollege","amount_due":25000,"amount_paid":25000,"amount_remaining":0,"application_fee_amount":null,"attempt_count":1,"attempted":true,"auto_advance":false,"billing_reason":"subscription_cycle","charge":"ch_1HBwijI20XIvtWbhIpJ0MVLG","collection_method":"charge_automatically","created":1596430820,"currency":"usd","custom_fields":null,"customer":"cus_HTUiRkdzji5Msh","customer_address":{"city": "Springfield","country": null,"line1": "743 Evergreen Terrace","line2": "","postal_code": "90001","state": "CA"},"customer_email":"test@ucinnovation.com","customer_name":null,"customer_phone":null,"customer_shipping":null,"customer_tax_exempt":"none","customer_tax_ids":[],"default_payment_method":null,"default_source":null,"default_tax_rates":[],"description":null,"discount":null,"discounts":[],"due_date":null,"ending_balance":0,"footer":null,"hosted_invoice_url":"https://pay.stripe.com/invoice/acct_1Ge4gMI20XIvtWbh/invst_HlSiArkwX35SrRAXJxrz5p76KWbHpze","invoice_pdf":"https://pay.stripe.com/invoice/acct_1Ge4gMI20XIvtWbh/invst_HlSiArkwX35SrRAXJxrz5p76KWbHpze/pdf","lines":{"object":"list","data":[{"id":"il_1HBvmaI20XIvtWbhXg8VQ5Tl","object":"line_item","amount":25000,"currency":"usd","description":"1×TestProduct(at$250.00/month)","discount_amounts":[],"discountable":true,"discounts":[],"livemode":false,"metadata":{"order_id": "614b446a685734435f54772e","amount_1": "17.0","fund_id_1": "29001-424-5303-80","fund_id": "29001-424-5303-80","appeal_code": "FY21-UOD-PrimaryForm","source": "Scalefunder","line_items": "68.00,29001-424-5303-80","sf_recurring_amount": "17.00","sf_recurring_frequency": "monthly","sf_recurring_duration": "4"},"period":{"end":1599109200,"start":1596430800},"plan":{"id":"price_1GuXicI20XIvtWbhkTbe5fLn","object":"plan","active":false,"aggregate_usage":null,"amount":25000,"amount_decimal":"25000","billing_scheme":"per_unit","created":1592286742,"currency":"usd","interval":"month","interval_count":1,"livemode":false,"metadata":{},"nickname":null,"product":"prod_HQqotDs4NdIGNl","tiers":null,"tiers_mode":null,"transform_usage":null,"trial_period_days":null,"usage_type":"licensed"},"price":{"id":"price_1GuXicI20XIvtWbhkTbe5fLn","object":"price","active":false,"billing_scheme":"per_unit","created":1592286742,"currency":"usd","livemode":false,"lookup_key":null,"metadata":{},"nickname":null,"product":"prod_HQqotDs4NdIGNl","recurring":{"aggregate_usage":null,"interval":"month","interval_count":1,"trial_period_days":null,"usage_type":"licensed"},"tiers_mode":null,"transform_quantity":null,"type":"recurring","unit_amount":25000,"unit_amount_decimal":"25000"},"proration":false,"quantity":1,"subscription":"sub_HTUizTWdiP9tUG","subscription_item":"si_HTUiL1SJjmzsgZ","tax_amounts":[],"tax_rates":[],"type":"subscription"}],"has_more":false,"total_count":1,"url":"/v1/invoices/in_1HBvmaI20XIvtWbhXYabgewF/lines"},"livemode":false,"metadata":{},"next_payment_attempt":null,"number":"E2FD687F-0003","paid":true,"payment_intent":"pi_1HBwijI20XIvtWbhroRxMKU4","period_end":1596430800,"period_start":1593752400,"post_payment_credit_notes_amount":0,"pre_payment_credit_notes_amount":0,"receipt_number":null,"starting_balance":0,"statement_descriptor":null,"status":"paid","status_transitions":{"finalized_at":1596434425,"marked_uncollectible_at":null,"paid_at":1596434425,"voided_at":null},"subscription":"sub_HTUizTWdiP9tUG","subtotal":25000,"tax":null,"tax_percent":null,"total":25000,"total_discount_amounts":[],"total_tax_amounts":[],"transfer_data":null,"webhooks_delivered_at":1596430822}},"livemode":false,"pending_webhooks":1,"request":{"id":null,"idempotency_key":null},"type":"invoice.payment_succeeded"}}';
        }

        public virtual String getInvoiceResponseBodyWithOpportunity () {
            return '{"id":"evt_1HBwikI20XIvtWbhyfMRXIg7","object":"event","api_version":"2020-03-02","created":1596434426,"data":{"object":{"id":"in_1HBvmaI20XIvtWbhXYabgewF","object":"invoice","account_country":"US","account_name":"MorehouseCollege","amount_due":25000,"amount_paid":25000,"amount_remaining":0,"application_fee_amount":null,"attempt_count":1,"attempted":true,"auto_advance":false,"billing_reason":"subscription_cycle","charge":"ch_1HBwijI20XIvtWbhIpJ0MVLG","collection_method":"charge_automatically","created":1596430820,"currency":"usd","custom_fields":null,"customer":"cus_HTUiRkdzji5Msh","customer_address":{"city": "Springfield","country": null,"line1": "743 Evergreen Terrace","line2": "","postal_code": "90001","state": "CA"},"customer_email":"test@ucinnovation.com","customer_name":null,"customer_phone":null,"customer_shipping":null,"customer_tax_exempt":"none","customer_tax_ids":[],"default_payment_method":null,"default_source":null,"default_tax_rates":[],"description":null,"discount":null,"discounts":[],"due_date":null,"ending_balance":0,"footer":null,"hosted_invoice_url":"https://pay.stripe.com/invoice/acct_1Ge4gMI20XIvtWbh/invst_HlSiArkwX35SrRAXJxrz5p76KWbHpze","invoice_pdf":"https://pay.stripe.com/invoice/acct_1Ge4gMI20XIvtWbh/invst_HlSiArkwX35SrRAXJxrz5p76KWbHpze/pdf","lines":{"object":"list","data":[{"id":"il_1HBvmaI20XIvtWbhXg8VQ5Tl","object":"line_item","amount":25000,"currency":"usd","description":"1×TestProduct(at$250.00/month)","discount_amounts":[],"discountable":true,"discounts":[],"livemode":false,"metadata":{"order_id": "614b446a685734435f54772e","amount_1": "17.0","fund_id_1": "29001-424-5303-80","fund_id": "29001-424-5303-80","appeal_code": "FY21-UOD-PrimaryForm","source": "Scalefunder","line_items": "68.00,29001-424-5303-80","sf_recurring_amount": "17.00","sf_recurring_frequency": "monthly","sf_recurring_duration": "4"},"period":{"end":1599109200,"start":1596430800},"plan":{"id":"price_1GuXicI20XIvtWbhkTbe5fLn","object":"plan","active":false,"aggregate_usage":null,"amount":25000,"amount_decimal":"25000","billing_scheme":"per_unit","created":1592286742,"currency":"usd","interval":"month","interval_count":1,"livemode":false,"metadata":{},"nickname":null,"product":"prod_HQqotDs4NdIGNl","tiers":null,"tiers_mode":null,"transform_usage":null,"trial_period_days":null,"usage_type":"licensed"},"price":{"id":"price_1GuXicI20XIvtWbhkTbe5fLn","object":"price","active":false,"billing_scheme":"per_unit","created":1592286742,"currency":"usd","livemode":false,"lookup_key":null,"metadata":{},"nickname":null,"product":"prod_HQqotDs4NdIGNl","recurring":{"aggregate_usage":null,"interval":"month","interval_count":1,"trial_period_days":null,"usage_type":"licensed"},"tiers_mode":null,"transform_quantity":null,"type":"recurring","unit_amount":25000,"unit_amount_decimal":"25000"},"proration":false,"quantity":1,"subscription":"sub_test","subscription_item":"si_HTUiL1SJjmzsgZ","tax_amounts":[],"tax_rates":[],"type":"subscription"}],"has_more":false,"total_count":1,"url":"/v1/invoices/in_1HBvmaI20XIvtWbhXYabgewF/lines"},"livemode":false,"metadata":{},"next_payment_attempt":null,"number":"E2FD687F-0003","paid":true,"payment_intent":"pi_1HBwijI20XIvtWbhroRxMKU4","period_end":1596430800,"period_start":1593752400,"post_payment_credit_notes_amount":0,"pre_payment_credit_notes_amount":0,"receipt_number":null,"starting_balance":0,"statement_descriptor":null,"status":"paid","status_transitions":{"finalized_at":1596434425,"marked_uncollectible_at":null,"paid_at":1596434425,"voided_at":null},"subscription":"sub_test","subtotal":25000,"tax":null,"tax_percent":null,"total":25000,"total_discount_amounts":[],"total_tax_amounts":[],"transfer_data":null,"webhooks_delivered_at":1596430822}},"livemode":false,"pending_webhooks":1,"request":{"id":null,"idempotency_key":null},"type":"invoice.payment_succeeded"}}';
        }

        public virtual String getInvoiceResponseBodyWithRT () {
            return '{"id":"evt_1HBwikI20XIvtWbhyfMRXIg7","object":"event","api_version":"2020-03-02","created":1596434426,"data":{"object":{"id":"in_1HBvmaI20XIvtWbhXYabgewF","object":"invoice","account_country":"US","account_name":"MorehouseCollege","amount_due":25000,"amount_paid":25000,"amount_remaining":0,"application_fee_amount":null,"attempt_count":1,"attempted":true,"auto_advance":false,"billing_reason":"subscription_cycle","charge":"ch_1HBwijI20XIvtWbhIpJ0MVLG","collection_method":"charge_automatically","created":1596430820,"currency":"usd","custom_fields":null,"customer":"cus_HTUiRkdzji5Msh","customer_address":{"city": "Springfield","country": null,"line1": "743 Evergreen Terrace","line2": "","postal_code": "90001","state": "CA"},"customer_email":"test@ucinnovation.com","customer_name":null,"customer_phone":null,"customer_shipping":null,"customer_tax_exempt":"none","customer_tax_ids":[],"default_payment_method":null,"default_source":null,"default_tax_rates":[],"description":null,"discount":null,"discounts":[],"due_date":null,"ending_balance":0,"footer":null,"hosted_invoice_url":"https://pay.stripe.com/invoice/acct_1Ge4gMI20XIvtWbh/invst_HlSiArkwX35SrRAXJxrz5p76KWbHpze","invoice_pdf":"https://pay.stripe.com/invoice/acct_1Ge4gMI20XIvtWbh/invst_HlSiArkwX35SrRAXJxrz5p76KWbHpze/pdf","lines":{"object":"list","data":[{"id":"il_1HBvmaI20XIvtWbhXg8VQ5Tl","object":"line_item","amount":25000,"currency":"usd","description":"1×TestProduct(at$250.00/month)","discount_amounts":[],"discountable":true,"discounts":[],"livemode":false,"metadata":{"order_id": "614b446a685734435f54772e","amount_1": "17.0","fund_id_1": "29001-424-5303-80","fund_id": "29001-424-5303-80","appeal_code": "FY21-UOD-PrimaryForm","source": "Scalefunder","line_items": "68.00,29001-424-5303-80","sf_recurring_amount": "17.00","sf_recurring_frequency": "monthly","sf_recurring_duration": "4"},"period":{"end":1599109200,"start":1596430800},"plan":{"id":"price_1GuXicI20XIvtWbhkTbe5fLn","object":"plan","active":false,"aggregate_usage":null,"amount":25000,"amount_decimal":"25000","billing_scheme":"per_unit","created":1592286742,"currency":"usd","interval":"month","interval_count":1,"livemode":false,"metadata":{},"nickname":null,"product":"prod_HQqotDs4NdIGNl","tiers":null,"tiers_mode":null,"transform_usage":null,"trial_period_days":null,"usage_type":"licensed"},"price":{"id":"price_1GuXicI20XIvtWbhkTbe5fLn","object":"price","active":false,"billing_scheme":"per_unit","created":1592286742,"currency":"usd","livemode":false,"lookup_key":null,"metadata":{},"nickname":null,"product":"prod_HQqotDs4NdIGNl","recurring":{"aggregate_usage":null,"interval":"month","interval_count":1,"trial_period_days":null,"usage_type":"licensed"},"tiers_mode":null,"transform_quantity":null,"type":"recurring","unit_amount":25000,"unit_amount_decimal":"25000"},"proration":false,"quantity":1,"subscription":"ManualReviewTest","subscription_item":"si_HTUiL1SJjmzsgZ","tax_amounts":[],"tax_rates":[],"type":"subscription"}],"has_more":false,"total_count":1,"url":"/v1/invoices/in_1HBvmaI20XIvtWbhXYabgewF/lines"},"livemode":false,"metadata":{},"next_payment_attempt":null,"number":"E2FD687F-0003","paid":true,"payment_intent":"pi_1HBwijI20XIvtWbhroRxMKU4","period_end":1596430800,"period_start":1593752400,"post_payment_credit_notes_amount":0,"pre_payment_credit_notes_amount":0,"receipt_number":null,"starting_balance":0,"statement_descriptor":null,"status":"paid","status_transitions":{"finalized_at":1596434425,"marked_uncollectible_at":null,"paid_at":1596434425,"voided_at":null},"subscription":"ManualReviewTest","subtotal":25000,"tax":null,"tax_percent":null,"total":25000,"total_discount_amounts":[],"total_tax_amounts":[],"transfer_data":null,"webhooks_delivered_at":1596430822}},"livemode":false,"pending_webhooks":1,"request":{"id":null,"idempotency_key":null},"type":"invoice.payment_succeeded"}}';
        }

        public virtual String getSubDeletedResponseBody () {
            return '{  "id": "evt_1HPBEcI20XIvtWbhK4zPy65z",  "object": "event",  "api_version": "2020-03-02",  "created": 1599588482,  "data": { "object": { "id": "sub_test", "object": "subscription", "application_fee_percent": null, "billing_cycle_anchor": 1599627600, "billing_thresholds": null, "cancel_at": null, "cancel_at_period_end": false, "canceled_at": 1599588482, "collection_method": "charge_automatically", "created": 1599588433, "current_period_end": 1599627600, "current_period_start": 1599588433, "customer": "cus_Hz9Wn3kKH1xpOa", "days_until_due": null, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "discount": null, "ended_at": 1599588482, "latest_invoice": null, "livemode": false, "metadata": { }, "next_pending_invoice_item_invoice": null, "pause_collection": null, "pending_invoice_item_interval": null, "pending_setup_intent": null, "pending_update": null, "quantity": 1, "schedule": null, "start_date": 1599588433, "status": "canceled", "tax_percent": null, "transfer_data": null, "trial_end": null, "trial_start": null }  },  "livemode": false,  "pending_webhooks": 1,  "request": { "id": "req_jwbN9k4Io3gDkB", "idempotency_key": null  },  "type": "customer.subscription.deleted"}';
        }

        public virtual String getSubDeletedResponseBodyNoOppo () {
            return '{  "id": "evt_1HPBEcI20XIvtWbhK4zPy65z",  "object": "event",  "api_version": "2020-03-02",  "created": 1599588482,  "data": { "object": { "id": "ManualReviewTest", "object": "subscription", "application_fee_percent": null, "billing_cycle_anchor": 1599627600, "billing_thresholds": null, "cancel_at": null, "cancel_at_period_end": false, "canceled_at": 1599588482, "collection_method": "charge_automatically", "created": 1599588433, "current_period_end": 1599627600, "current_period_start": 1599588433, "customer": "cus_Hz9Wn3kKH1xpOa", "days_until_due": null, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "discount": null, "ended_at": 1599588482, "latest_invoice": null, "livemode": false, "metadata": { }, "next_pending_invoice_item_invoice": null, "pause_collection": null, "pending_invoice_item_interval": null, "pending_setup_intent": null, "pending_update": null, "quantity": 1, "schedule": null, "start_date": 1599588433, "status": "canceled", "tax_percent": null, "transfer_data": null, "trial_end": null, "trial_start": null }  },  "livemode": false,  "pending_webhooks": 1,  "request": { "id": "req_jwbN9k4Io3gDkB", "idempotency_key": null  },  "type": "customer.subscription.deleted"}';
        }


        public virtual String getSubUnpaidResponseBody () {
            return '{  "id": "evt_1HPBEcI20XIvtWbhK4zPy65z",  "object": "event",  "api_version": "2020-03-02",  "created": 1599588482,  "data": { "object": { "id": "sub_test", "object": "subscription", "application_fee_percent": null, "billing_cycle_anchor": 1599627600, "billing_thresholds": null, "cancel_at": null, "cancel_at_period_end": false, "canceled_at": 1599588482, "collection_method": "charge_automatically", "created": 1599588433, "current_period_end": 1599627600, "current_period_start": 1599588433, "customer": "cus_Hz9Wn3kKH1xpOa", "days_until_due": null, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "discount": null, "ended_at": 1599588482, "latest_invoice": null, "livemode": false, "metadata": { }, "next_pending_invoice_item_invoice": null, "pause_collection": null, "pending_invoice_item_interval": null, "pending_setup_intent": null, "pending_update": null, "quantity": 1, "schedule": null, "start_date": 1599588433, "status": "unpaid", "tax_percent": null, "transfer_data": null, "trial_end": null, "trial_start": null }  },  "livemode": false,  "pending_webhooks": 1,  "request": { "id": "req_jwbN9k4Io3gDkB", "idempotency_key": null  },  "type": "customer.subscription.updated"}';
        }

        public virtual String getSubUnpaidResponseBodyNoOppo () {
            return '{  "id": "evt_1HPBEcI20XIvtWbhK4zPy65z",  "object": "event",  "api_version": "2020-03-02",  "created": 1599588482,  "data": { "object": { "id": "ManualReviewTest", "object": "subscription", "application_fee_percent": null, "billing_cycle_anchor": 1599627600, "billing_thresholds": null, "cancel_at": null, "cancel_at_period_end": false, "canceled_at": 1599588482, "collection_method": "charge_automatically", "created": 1599588433, "current_period_end": 1599627600, "current_period_start": 1599588433, "customer": "cus_Hz9Wn3kKH1xpOa", "days_until_due": null, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "discount": null, "ended_at": 1599588482, "latest_invoice": null, "livemode": false, "metadata": { }, "next_pending_invoice_item_invoice": null, "pause_collection": null, "pending_invoice_item_interval": null, "pending_setup_intent": null, "pending_update": null, "quantity": 1, "schedule": null, "start_date": 1599588433, "status": "unpaid", "tax_percent": null, "transfer_data": null, "trial_end": null, "trial_start": null }  },  "livemode": false,  "pending_webhooks": 1,  "request": { "id": "req_jwbN9k4Io3gDkB", "idempotency_key": null  },  "type": "customer.subscription.updated"}';
        }

        public virtual String getSubIncompleteResponseBody () {
            return '{  "id": "evt_1HPBEcI20XIvtWbhK4zPy65z",  "object": "event",  "api_version": "2020-03-02",  "created": 1599588482,  "data": { "object": { "id": "sub_test", "object": "subscription", "application_fee_percent": null, "billing_cycle_anchor": 1599627600, "billing_thresholds": null, "cancel_at": null, "cancel_at_period_end": false, "canceled_at": 1599588482, "collection_method": "charge_automatically", "created": 1599588433, "current_period_end": 1599627600, "current_period_start": 1599588433, "customer": "cus_Hz9Wn3kKH1xpOa", "days_until_due": null, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "discount": null, "ended_at": 1599588482, "latest_invoice": null, "livemode": false, "metadata": { }, "next_pending_invoice_item_invoice": null, "pause_collection": null, "pending_invoice_item_interval": null, "pending_setup_intent": null, "pending_update": null, "quantity": 1, "schedule": null, "start_date": 1599588433, "status": "incomplete", "tax_percent": null, "transfer_data": null, "trial_end": null, "trial_start": null }  },  "livemode": false,  "pending_webhooks": 1,  "request": { "id": "req_jwbN9k4Io3gDkB", "idempotency_key": null  },  "type": "customer.subscription.updated"}';
        }

        public virtual String getSubIncompleteResponseBodyNoOppo () {
            return '{  "id": "evt_1HPBEcI20XIvtWbhK4zPy65z",  "object": "event",  "api_version": "2020-03-02",  "created": 1599588482,  "data": { "object": { "id": "ManualReviewTest", "object": "subscription", "application_fee_percent": null, "billing_cycle_anchor": 1599627600, "billing_thresholds": null, "cancel_at": null, "cancel_at_period_end": false, "canceled_at": 1599588482, "collection_method": "charge_automatically", "created": 1599588433, "current_period_end": 1599627600, "current_period_start": 1599588433, "customer": "cus_Hz9Wn3kKH1xpOa", "days_until_due": null, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "discount": null, "ended_at": 1599588482, "latest_invoice": null, "livemode": false, "metadata": { }, "next_pending_invoice_item_invoice": null, "pause_collection": null, "pending_invoice_item_interval": null, "pending_setup_intent": null, "pending_update": null, "quantity": 1, "schedule": null, "start_date": 1599588433, "status": "incomplete", "tax_percent": null, "transfer_data": null, "trial_end": null, "trial_start": null }  },  "livemode": false,  "pending_webhooks": 1,  "request": { "id": "req_jwbN9k4Io3gDkB", "idempotency_key": null  },  "type": "customer.subscription.updated"}';
        }

        public virtual String getSubIncompleteExpiredResponseBody () {
            return '{  "id": "evt_1HPBEcI20XIvtWbhK4zPy65z",  "object": "event",  "api_version": "2020-03-02",  "created": 1599588482,  "data": { "object": { "id": "sub_test", "object": "subscription", "application_fee_percent": null, "billing_cycle_anchor": 1599627600, "billing_thresholds": null, "cancel_at": null, "cancel_at_period_end": false, "canceled_at": 1599588482, "collection_method": "charge_automatically", "created": 1599588433, "current_period_end": 1599627600, "current_period_start": 1599588433, "customer": "cus_Hz9Wn3kKH1xpOa", "days_until_due": null, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "discount": null, "ended_at": 1599588482, "latest_invoice": null, "livemode": false, "metadata": { }, "next_pending_invoice_item_invoice": null, "pause_collection": null, "pending_invoice_item_interval": null, "pending_setup_intent": null, "pending_update": null, "quantity": 1, "schedule": null, "start_date": 1599588433, "status": "incomplete_expired", "tax_percent": null, "transfer_data": null, "trial_end": null, "trial_start": null }  },  "livemode": false,  "pending_webhooks": 1,  "request": { "id": "req_jwbN9k4Io3gDkB", "idempotency_key": null  },  "type": "customer.subscription.updated"}';
        }

        public virtual String getSubIncompleteExpiredResponseBodyNoOppo () {
            return '{  "id": "evt_1HPBEcI20XIvtWbhK4zPy65z",  "object": "event",  "api_version": "2020-03-02",  "created": 1599588482,  "data": { "object": { "id": "ManualReviewTest", "object": "subscription", "application_fee_percent": null, "billing_cycle_anchor": 1599627600, "billing_thresholds": null, "cancel_at": null, "cancel_at_period_end": false, "canceled_at": 1599588482, "collection_method": "charge_automatically", "created": 1599588433, "current_period_end": 1599627600, "current_period_start": 1599588433, "customer": "cus_Hz9Wn3kKH1xpOa", "days_until_due": null, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "discount": null, "ended_at": 1599588482, "latest_invoice": null, "livemode": false, "metadata": { }, "next_pending_invoice_item_invoice": null, "pause_collection": null, "pending_invoice_item_interval": null, "pending_setup_intent": null, "pending_update": null, "quantity": 1, "schedule": null, "start_date": 1599588433, "status": "incomplete_expired", "tax_percent": null, "transfer_data": null, "trial_end": null, "trial_start": null }  },  "livemode": false,  "pending_webhooks": 1,  "request": { "id": "req_jwbN9k4Io3gDkB", "idempotency_key": null  },  "type": "customer.subscription.updated"}';
        }

        public virtual String getSubPastDueResponseBody () {
            return '{  "id": "evt_1HPBEcI20XIvtWbhK4zPy65z",  "object": "event",  "api_version": "2020-03-02",  "created": 1599588482,  "data": { "object": { "id": "sub_test", "object": "subscription", "application_fee_percent": null, "billing_cycle_anchor": 1599627600, "billing_thresholds": null, "cancel_at": null, "cancel_at_period_end": false, "canceled_at": 1599588482, "collection_method": "charge_automatically", "created": 1599588433, "current_period_end": 1599627600, "current_period_start": 1599588433, "customer": "cus_Hz9Wn3kKH1xpOa", "days_until_due": null, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "discount": null, "ended_at": 1599588482, "latest_invoice": null, "livemode": false, "metadata": { }, "next_pending_invoice_item_invoice": null, "pause_collection": null, "pending_invoice_item_interval": null, "pending_setup_intent": null, "pending_update": null, "quantity": 1, "schedule": null, "start_date": 1599588433, "status": "past_due", "tax_percent": null, "transfer_data": null, "trial_end": null, "trial_start": null }  },  "livemode": false,  "pending_webhooks": 1,  "request": { "id": "req_jwbN9k4Io3gDkB", "idempotency_key": null  },  "type": "customer.subscription.updated"}';
        }

        public virtual String getSubPastDueResponseBodyNoOppo () {
            return '{  "id": "evt_1HPBEcI20XIvtWbhK4zPy65z",  "object": "event",  "api_version": "2020-03-02",  "created": 1599588482,  "data": { "object": { "id": "ManualReviewTest", "object": "subscription", "application_fee_percent": null, "billing_cycle_anchor": 1599627600, "billing_thresholds": null, "cancel_at": null, "cancel_at_period_end": false, "canceled_at": 1599588482, "collection_method": "charge_automatically", "created": 1599588433, "current_period_end": 1599627600, "current_period_start": 1599588433, "customer": "cus_Hz9Wn3kKH1xpOa", "days_until_due": null, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "discount": null, "ended_at": 1599588482, "latest_invoice": null, "livemode": false, "metadata": { }, "next_pending_invoice_item_invoice": null, "pause_collection": null, "pending_invoice_item_interval": null, "pending_setup_intent": null, "pending_update": null, "quantity": 1, "schedule": null, "start_date": 1599588433, "status": "past_due", "tax_percent": null, "transfer_data": null, "trial_end": null, "trial_start": null }  },  "livemode": false,  "pending_webhooks": 1,  "request": { "id": "req_jwbN9k4Io3gDkB", "idempotency_key": null  },  "type": "customer.subscription.updated"}';
        }

        public virtual String getSubActiveResponseBody () {
            return '{  "id": "evt_1HPBEcI20XIvtWbhK4zPy65z",  "object": "event",  "api_version": "2020-03-02",  "created": 1599588482,  "data": { "object": { "id": "sub_test", "object": "subscription", "application_fee_percent": null, "billing_cycle_anchor": 1599627600, "billing_thresholds": null, "cancel_at": null, "cancel_at_period_end": false, "canceled_at": 1599588482, "collection_method": "charge_automatically", "created": 1599588433, "current_period_end": 1599627600, "current_period_start": 1599588433, "customer": "cus_Hz9Wn3kKH1xpOa", "days_until_due": null, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "discount": null, "ended_at": 1599588482, "latest_invoice": null, "livemode": false, "metadata": { }, "next_pending_invoice_item_invoice": null, "pause_collection": null, "pending_invoice_item_interval": null, "pending_setup_intent": null, "pending_update": null, "quantity": 1, "schedule": null, "start_date": 1599588433, "status": "active", "tax_percent": null, "transfer_data": null, "trial_end": null, "trial_start": null }  },  "livemode": false,  "pending_webhooks": 1,  "request": { "id": "req_jwbN9k4Io3gDkB", "idempotency_key": null  },  "type": "customer.subscription.updated"}';
        }

        public virtual String getSubActiveResponseBodyNoOppo () {
            return '{  "id": "evt_1HPBEcI20XIvtWbhK4zPy65z",  "object": "event",  "api_version": "2020-03-02",  "created": 1599588482,  "data": { "object": { "id": "ManualReviewTest", "object": "subscription", "application_fee_percent": null, "billing_cycle_anchor": 1599627600, "billing_thresholds": null, "cancel_at": null, "cancel_at_period_end": false, "canceled_at": 1599588482, "collection_method": "charge_automatically", "created": 1599588433, "current_period_end": 1599627600, "current_period_start": 1599588433, "customer": "cus_Hz9Wn3kKH1xpOa", "days_until_due": null, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "discount": null, "ended_at": 1599588482, "latest_invoice": null, "livemode": false, "metadata": { }, "next_pending_invoice_item_invoice": null, "pause_collection": null, "pending_invoice_item_interval": null, "pending_setup_intent": null, "pending_update": null, "quantity": 1, "schedule": null, "start_date": 1599588433, "status": "active", "tax_percent": null, "transfer_data": null, "trial_end": null, "trial_start": null }  },  "livemode": false,  "pending_webhooks": 1,  "request": { "id": "req_jwbN9k4Io3gDkB", "idempotency_key": null  },  "type": "customer.subscription.updated"}';
        }

        public virtual String getPaymentIntentSucceededResponseBody () {
            return '{"id":"evt_3NGHc1KvkFcJ4a191mbVNRW1","object":"event","api_version":"2016-07-06","created":1686126134,"data":{"object":{"id":"pi_3NGHc1KvkFcJ4a1911bYYjVz","object":"payment_intent","allowed_source_types":["card","cashapp","us_bank_account"],"amount":10000,"amount_capturable":0,"amount_details":{"tip":{}},"amount_received":10000,"application":null,"application_fee_amount":null,"automatic_payment_methods":null,"canceled_at":null,"cancellation_reason":null,"capture_method":"automatic","charges":{"object":"list","data":[{"id":"py_3NGHc1KvkFcJ4a1913DyYyiF","object":"charge","amount":10000,"amount_captured":10000,"amount_refunded":0,"application":null,"application_fee":null,"application_fee_amount":null,"balance_transaction":"txn_3NGHc1KvkFcJ4a191JV1pwkU","billing_details":{"address":{"city":null,"country":null,"line1":null,"line2":null,"postal_code":null,"state":null},"email":"tshinto@ucinnovation.com","name":"Todd Shinto","phone":null},"calculated_statement_descriptor":null,"captured":true,"created":1686126062,"currency":"usd","customer":"cus_O1jE6w3ttZPBw8","description":"Invoice 51231E5F-0003","destination":null,"dispute":null,"disputed":false,"failure_balance_transaction":null,"failure_code":null,"failure_message":null,"fraud_details":{},"invoice":"in_1NGGNWKvkFcJ4a19mNBYDQdZ","livemode":false,"metadata":{},"on_behalf_of":null,"order":null,"outcome":{"network_status":"approved_by_network","reason":null,"risk_level":"not_assessed","seller_message":"Payment complete.","type":"authorized"},"paid":true,"payment_intent":"pi_3NGHc1KvkFcJ4a1911bYYjVz","payment_method":"pm_1NFfltKvkFcJ4a19eg1ysyrU","payment_method_details":{"type":"us_bank_account","us_bank_account":{"account_holder_type":"individual","account_type":"checking","bank_name":"STRIPE TEST BANK","fingerprint":"LIoZVRhRlDsf7zMj","last4":"6789","routing_number":"110000000"}},"receipt_email":null,"receipt_number":null,"receipt_url":"https://pay.stripe.com/receipts/invoices/CAcaFwoVYWNjdF8xOUd0d1dLdmtGY0o0YTE5KLX8gKQGMga9MHgZQCk6LBYWfHEkaSJxPw444Djw8XVIK4r1qQO2mN-etT-UHP9taxsJJagKJGKLVqfh?s=ap","refunded":false,"refunds":{"object":"list","data":[],"has_more":false,"total_count":0,"url":"/v1/charges/py_3NGHc1KvkFcJ4a1913DyYyiF/refunds"},"review":null,"shipping":null,"source":null,"source_transfer":null,"statement_descriptor":null,"statement_descriptor_suffix":null,"status":"succeeded","transfer_data":null,"transfer_group":null}],"has_more":false,"total_count":1,"url":"/v1/charges?payment_intent=pi_3NGHc1KvkFcJ4a1911bYYjVz"},"client_secret":"pi_3NGHc1KvkFcJ4a1911bYYjVz_secret_zE3V1oHuIvmy5QUVu7H8pg3xv","confirmation_method":"automatic","created":1686126061,"currency":"usd","customer":"cus_O1jE6w3ttZPBw8","description":"Invoice 51231E5F-0003","invoice":"in_1NGGNWKvkFcJ4a19mNBYDQdZ","last_payment_error":null,"latest_charge":"py_3NGHc1KvkFcJ4a1913DyYyiF","livemode":false,"metadata":{},"next_action":null,"next_source_action":null,"on_behalf_of":null,"payment_method":"pm_1NFfltKvkFcJ4a19eg1ysyrU","payment_method_options":{"card":{"installments":null,"mandate_options":null,"network":null,"request_three_d_secure":"automatic"},"cashapp":{},"us_bank_account":{"setup_future_usage":"none","verification_method":"automatic"}},"payment_method_types":["card","cashapp","us_bank_account"],"processing":null,"receipt_email":null,"review":null,"setup_future_usage":null,"shipping":null,"source":null,"statement_descriptor":null,"statement_descriptor_suffix":null,"status":"succeeded","transfer_data":null,"transfer_group":null}},"livemode":false,"pending_webhooks":9,"request":null,"type":"payment_intent.succeeded"}';
        }


        public virtual void setupData() {
            System.runAs(thisUser) {
                Campaign appeal = new Campaign();
                appeal.ucinn_ascendv2__Motivation_Code__c = '123appeal';
                appeal.Name = 'testappeal';
                appeal = (Campaign)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => appeal});
                insert appeal;

                // Create designation
                ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
                designation.Name = 'testdesig';
                designation.ucinn_ascendv2__Acknowledgement_Description__c = 'Test Designation';
                designation.ucinn_ascendv2__External_System_ID__c = '123desig';
                designation = (ucinn_ascendv2__Designation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => designation});
                insert designation;

                Account acc = new Account();
                acc.Name = 'testAccount';
                acc = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acc});
                insert acc;

                Contact con = new Contact();
                con.LastName = 'Last';
                con.AccountId = acc.Id;
                con.Email = 'test@test.com';
                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                Id rgRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Recurring_Gift').getRecordTypeId();
                Opportunity opp = new Opportunity();
                opp.Name = 'RG';
                opp.StageName = 'Funded';
                opp.Amount = 1000;
                opp.ucinn_ascendv2__Contact__c = con.Id;
                opp.ucinn_ascendv2__Designation__c = designation.Id;
                opp.AccountId = acc.Id;
                opp.CampaignId = appeal.Id;
                opp.RecordTypeId = rgRecordTypeId;
                opp.ucinn_ascendv2__External_Payment_Gateway_ID__c = 'sub_test';
                opp.ucinn_ascendv2__Subscription_ID__c = 'sub_test';
                opp.ucinn_ascendv2__Tender_Type_for_Gifts__c = 'Cash';
                opp.ucinn_ascendv2__External_System_Id__c = 'sub_test';
                opp.CloseDate = Date.today();
                opp.ucinn_ascendv2__Frequency__c = 'Annual';
                opp = (Opportunity)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => opp});
                insert opp;

                ucinn_ascendv2__Designation_Detail__c detail = new ucinn_ascendv2__Designation_Detail__c();
                detail.ucinn_ascendv2__Designation__c = designation.Id;
                detail.ucinn_ascendv2__Opportunity__c = opp.Id;
                detail = (ucinn_ascendv2__Designation_Detail__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => detail});
                insert detail;


                ucinn_ascendv2__Review_Transaction_v2__c newRT = new ucinn_ascendv2__Review_Transaction_v2__c();
                newRt.ucinn_ascendv2__First_Name__c = 'First';
                newRt.ucinn_ascendv2__Last_Name__c = 'Lasttest';
                newRt.ucinn_ascendv2__Email_1__c = 'test@test.com';
                newRt.ucinn_ascendv2__Email_1_Type__c = 'Personal';
                newRt.ucinn_ascendv2__Status__c = 'Manual Review';
                newRt.ucinn_ascendv2__Transaction_Date__c = Date.today();
                newRt.ucinn_ascendv2__Opportunity_Type__c = 'Recurring';
                newRt.ucinn_ascendv2__Tender_Type_1__c = 'Credit Card';
                newRt.ucinn_ascendv2__Campaign_External_ID__c = appeal.Id;
                newRt.ucinn_ascendv2__External_System_ID__c = 'GNRL-ManualReviewTest';
                newRt.ucinn_ascendv2__Subscription_ID__c = 'ManualReviewTest';
                newRt.ucinn_ascendv2__External_Payment_Gateway_ID__c = 'ManualReviewTest';
                newRt.ucinn_ascendv2__Transaction_Type__c = 'Recurring Gift';
                newRt.ucinn_ascendv2__Designation_1__c = designation.Id;
                newRt.ucinn_ascendv2__Installment_Amount_1_1__c = 1000;
                newRt.ucinn_ascendv2__Installment_Frequency_1__c = 'Monthly';
                newRt.ucinn_ascendv2__Installment_Date_1_1__c = Date.today();
                newRT = (ucinn_ascendv2__Review_Transaction_v2__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newRT});
                insert newRT;
            }
        }


        public virtual void testInvoiceWebhook() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getInvoiceResponseBody());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }


        public virtual void testInvoiceWebhookWithOpportunity() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getInvoiceResponseBodyWithOpportunity());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }


        public virtual void testInvoiceWebhookWithRT() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getInvoiceResponseBodyWithRT());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }


        public virtual void testRealData(){
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf('{ "id": "evt_1KU5uKKvkFcJ4a196Lc8EE7I", "object": "event", "api_version": "2016-07-06", "created": 1645088652, "data": { "object": { "id": "in_1KU4v0KvkFcJ4a19DmRFysFN", "object": "invoice", "account_country": "US", "account_name": "UC Innovation - Test", "account_tax_ids": null, "amount_due": 1250, "amount_paid": 1250, "amount_remaining": 0, "application_fee": null, "attempt_count": 1, "attempted": true, "auto_advance": false, "automatic_tax": { "enabled": false, "status": null}, "billing": "charge_automatically", "billing_reason": "subscription_cycle", "charge": "ch_3KU5uIKvkFcJ4a190FNjFka9", "closed": true, "collection_method": "charge_automatically", "created": 1645084850, "currency": "usd", "custom_fields": null, "customer": "cus_LAHBgU3CPUX9Tf", "customer_address": { "city": null, "country": null, "line1": null, "line2": null, "postal_code": "aaddress[line1]=aaddress[city]=aemail=test@test.comname=Test Tester", "state": null }, "customer_email": null, "customer_name": null, "customer_phone": null, "customer_shipping": null, "customer_tax_exempt": "none", "customer_tax_ids": [ ], "date": 1645084850, "default_payment_method": null, "default_source": null, "default_tax_rates": [ ], "description": null, "discount": null, "discounts": [ ], "due_date": null, "ending_balance": 0, "finalized_at": 1645088650, "footer": null, "forgiven": false, "hosted_invoice_url": "https://invoice.stripe.com/i/acct_19GtwWKvkFcJ4a19/test_YWNjdF8xOUd0d1dLdmtGY0o0YTE5LF9MQVBrYUlwVFVtaGdzOE1PNlpXVmFza3RzQWtNYTFCLDM1NjI5NDUy02008hn8QgEd?s=ap", "invoice_pdf": "https://pay.stripe.com/invoice/acct_19GtwWKvkFcJ4a19/test_YWNjdF8xOUd0d1dLdmtGY0o0YTE5LF9MQVBrYUlwVFVtaGdzOE1PNlpXVmFza3RzQWtNYTFCLDM1NjI5NDUy02008hn8QgEd/pdf?s=ap", "last_finalization_error": null, "lines": { "object": "list", "data": [ { "id": "sub_1KTwckKvkFcJ4a19BhGjbs87", "object": "line_item", "amount": 1250, "currency": "usd", "description": null, "discount_amounts": [ ], "discountable": true, "discounts": [ ], "livemode": false, "metadata": { }, "period": { "end": 1645689600, "start": 1645084800 }, "plan": { "id": "price_1KTwciKvkFcJ4a198Tgh2aqL", "object": "plan", "active": true, "aggregate_usage": null, "amount": 1250, "amount_decimal": "1250", "billing_scheme": "per_unit", "created": 1645052964, "currency": "usd", "interval": "week", "interval_count": 1, "livemode": false, "metadata": { }, "name": "subscription", "nickname": null, "product": "prod_LAHBysG8EbzqQ8", "statement_descriptor": null, "tiers": null, "tiers_mode": null, "transform_usage": null, "trial_period_days": null, "usage_type": "licensed" }, "price": { "id": "price_1KTwciKvkFcJ4a198Tgh2aqL", "object": "price", "active": true, "billing_scheme": "per_unit", "created": 1645052964, "currency": "usd", "livemode": false, "lookup_key": null, "metadata": { }, "nickname": null, "product": "prod_LAHBysG8EbzqQ8", "recurring": { "aggregate_usage": null, "interval": "week", "interval_count": 1, "trial_period_days": null, "usage_type": "licensed" }, "tax_behavior": "unspecified", "tiers_mode": null, "transform_quantity": null, "type": "recurring", "unit_amount": 1250, "unit_amount_decimal": "1250" }, "proration": false, "quantity": 1, "subscription": null, "subscription_item": "si_LAHBokN5OIdNfe", "tax_amounts": [ ], "tax_rates": [ ], "type": "subscription", "unique_id": "il_1KU4v0KvkFcJ4a19gUbCAtA6", "unique_line_item_id": "sli_16a3e5KvkFcJ4a19208e437f" } ], "has_more": false, "total_count": 1, "url": "/v1/invoices/in_1KU4v0KvkFcJ4a19DmRFysFN/lines" }, "livemode": false, "metadata": { }, "next_payment_attempt": null, "number": "1936A94B-0001", "on_behalf_of": null, "paid": true, "paid_out_of_band": false, "payment_intent": "pi_3KU5uIKvkFcJ4a190Jd9Y7OP", "payment_settings": { "payment_method_options": null, "payment_method_types": null }, "period_end": 1645084800, "period_start": 1645052965, "post_payment_credit_notes_amount": 0, "pre_payment_credit_notes_amount": 0, "quote": null, "receipt_number": null, "starting_balance": 0, "statement_descriptor": null, "status": "paid", "status_transitions": { "finalized_at": 1645088650, "marked_uncollectible_at": null, "paid_at": 1645088650, "voided_at": null }, "subscription": "sub_1KTwckKvkFcJ4a19BhGjbs87", "subtotal": 1250, "tax": null, "tax_percent": null, "total": 1250, "total_discount_amounts": [ ], "total_tax_amounts": [ ], "transfer_data": null, "webhooks_delivered_at": 1645084850 } }, "livemode": false, "pending_webhooks": 2, "request": null, "type": "invoice.payment_succeeded" }');
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }



        public virtual void testSubDeletedWebhook() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getSubDeletedResponseBody());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }


        public virtual void testSubDeletedWebhookNoOpportunity() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getSubDeletedResponseBodyNoOppo());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }



        public virtual void testSubIncompleteWebhook() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getSubIncompleteResponseBody());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }


        public virtual void testSubIncompleteWebhookNoOpportunity() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getSubIncompleteResponseBodyNoOppo());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }



        public virtual void testSubIncompleteExpiredWebhook() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getSubIncompleteExpiredResponseBody());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }


        public virtual void testSubIncompleteExpiredWebhookNoOpportunity() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getSubIncompleteExpiredResponseBodyNoOppo());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }



        public virtual void testSubUnpaidWebhook() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getSubUnpaidResponseBody());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }


        public virtual void testSubUnpaidWebhookNoOpportunity() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getSubUnpaidResponseBodyNoOppo());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }



        public virtual void testSubPastDueWebhook() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getSubPastDueResponseBody());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }


        public virtual void testSubPastDueWebhookNoOpportunity() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getSubPastDueResponseBodyNoOppo());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }



        public virtual void testSubActiveWebhook() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getSubActiveResponseBody());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }


        public virtual void testSubActiveWebhookNoOpportunity() {
            Test.startTest();
            RestRequest req = new RestRequest();
            req.requestURI = '/services/apexrest/portal/webhook';
            req.httpMethod = 'POST';
            req.addHeader('Stripe-Signature', 't=1234,v1=fmfwe');
            req.requestBody = Blob.valueOf(getSubActiveResponseBodyNoOppo());
            RestContext.request = req;
            PORTAL_StripeWebhook.receivePost();
            Test.stopTest();
        }

        public virtual void testPaymentIntentSucceeded() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded', '', PORTAL_StripePaymentGateway.PAYMENT_METHOD_ENDPOINT + '/pm_1NFfltKvkFcJ4a19eg1ysyrU');
            Test.setMock(HttpCalloutMock.class, mockcallouts);
            
            Test.startTest();
            PORTAL_StripeWebhook.finishReceivingPost(getPaymentIntentSucceededResponseBody());
            Test.stopTest();
        }

        // public virtual void testUpdateSubscriptionStatus() {
        //     Campaign appeal = new Campaign();
        //     appeal.ucinn_ascendv2__Motivation_Code__c = '123appeal';
        //     appeal.Name = 'testappeal';
        //     appeal = (Campaign)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => appeal});
        //     insert appeal;
    
        //     // Create designation
        //     ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
        //     designation.Name = 'testdesig';
        //     designation.ucinn_ascendv2__Acknowledgement_Description__c = 'Test Designation';
        //     designation.ucinn_ascendv2__External_System_ID__c = '123desig';
        //     designation = (ucinn_ascendv2__Designation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => designation});
        //     insert designation;
            
        //     Account acc = new Account();
        //     acc.Name = 'testAccount';
        //     acc = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acc});
        //     insert acc;
            
        //     Contact con = new Contact();
        //     con.LastName = 'Last';
        //     con.AccountId = acc.Id;
        //     con.Email = 'test@test.com';
        //     con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
        //     insert con;
            
        //     Id rgRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Recurring_Gift').getRecordTypeId();
        //     Opportunity opp = new Opportunity();
        //     opp.Name = 'RG';
        //     opp.StageName = 'Funded';
        //     opp.Amount = 1000;
        //       opp.ucinn_ascendv2__Contact__c = con.Id;
        //     opp.ucinn_ascendv2__Designation__c = designation.Id;
        //     opp.AccountId = acc.Id;
        //     opp.CampaignId = appeal.Id;
        //     opp.RecordTypeId = rgRecordTypeId;
        //     opp.ucinn_ascendv2__External_Payment_Gateway_ID__c = 'sub_test';
        //     opp.ucinn_ascendv2__Subscription_ID__c = 'sub_test';
        //     opp.ucinn_ascendv2__Tender_Type_for_Gifts__c = 'Cash';
        //     opp.ucinn_ascendv2__External_System_Id__c = 'sub_test';
        //     opp.CloseDate = Date.today();
        //     opp.ucinn_ascendv2__Frequency__c = 'Annual';
        //     opp = (Opportunity)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => opp});
        //     insert opp;
    
        //     ucinn_ascendv2__Designation_Detail__c detail = new ucinn_ascendv2__Designation_Detail__c();
        //     detail.ucinn_ascendv2__Designation__c = designation.Id;
        //     detail.ucinn_ascendv2__Opportunity__c = opp.Id;
        //     detail = (ucinn_ascendv2__Designation_Detail__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => detail});
        //     insert detail;
            
            
        //     ucinn_ascendv2__Review_Transaction_v2__c newRT = new ucinn_ascendv2__Review_Transaction_v2__c();
        //     newRt.ucinn_ascendv2__First_Name__c = 'First';
        //     newRt.ucinn_ascendv2__Last_Name__c = 'Lasttest';
        //     newRt.ucinn_ascendv2__Email_1__c = 'test@test.com';
        //     newRt.ucinn_ascendv2__Email_1_Type__c = 'Personal';
        //     newRt.ucinn_ascendv2__Status__c = 'Manual Review';
        //     newRt.ucinn_ascendv2__Transaction_Date__c = Date.today();
        //     newRt.ucinn_ascendv2__Opportunity_Type__c = 'Recurring';
        //     newRt.ucinn_ascendv2__Tender_Type_1__c = 'Credit Card';
        //     newRt.ucinn_ascendv2__Campaign_External_ID__c = appeal.Id;
        //     newRt.ucinn_ascendv2__External_System_ID__c = 'GNRL-ManualReviewTest';
        //     newRt.ucinn_ascendv2__Subscription_ID__c = 'sub_test';
        //     newRt.ucinn_ascendv2__External_Payment_Gateway_ID__c = 'ManualReviewTest';
        //     newRt.ucinn_ascendv2__Transaction_Type__c = 'Recurring Gift';
        //     newRt.ucinn_ascendv2__Designation_1__c = designation.Id;
        //     newRt.ucinn_ascendv2__Installment_Amount_1_1__c = 1000;
        //     newRt.ucinn_ascendv2__Installment_Frequency_1__c = 'Monthly';
        //     newRt.ucinn_ascendv2__Installment_Date_1_1__c = Date.today();
        //     newRT = (ucinn_ascendv2__Review_Transaction_v2__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newRT});
        //     insert newRT;

        //     Map<String, Object> fieldMap = new Map<String, Object>{PORTAL_StripeWebhookBase.SUBSCRIPTION_ID_KEY => opp.ucinn_ascendv2__Subscription_ID__c,
        //                                                         PORTAL_StripeWebhookBase.STATUS_KEY => 'Incomplete'};

        //     Test.startTest();
            
        //     PORTAL_StripeWebhookBase.updateSubscriptionStatus(fieldMap);

        //     Test.stopTest();
        // }

        public virtual void testCreatePaymentForOpportunitiesAndReviewTransaction() {
            Campaign appeal = new Campaign();
            appeal.ucinn_ascendv2__Motivation_Code__c = '123appeal';
            appeal.Name = 'testappeal';
            appeal = (Campaign)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => appeal});
            insert appeal;
    
            // Create designation
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'testdesig';
            designation.ucinn_ascendv2__Acknowledgement_Description__c = 'Test Designation';
            designation.ucinn_ascendv2__External_System_ID__c = '123desig';
            designation = (ucinn_ascendv2__Designation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => designation});
            insert designation;
            
            Account acc = new Account();
            acc.Name = 'testAccount';
            acc = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acc});
            insert acc;
            
            Contact con = new Contact();
            con.LastName = 'Last';
            con.AccountId = acc.Id;
            con.Email = 'test@test.com';
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;
            
            Id rgRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Recurring_Gift').getRecordTypeId();
            Opportunity opp = new Opportunity();
            opp.Name = 'RG';
            opp.StageName = 'Funded';
            opp.Amount = 1000;
            opp.ucinn_ascendv2__Contact__c = con.Id;
            opp.ucinn_ascendv2__Designation__c = designation.Id;
            opp.AccountId = acc.Id;
            opp.CampaignId = appeal.Id;
            opp.RecordTypeId = rgRecordTypeId;
            opp.ucinn_ascendv2__External_Payment_Gateway_ID__c = 'sub_test';
            opp.ucinn_ascendv2__Subscription_ID__c = 'sub_test';
            opp.ucinn_ascendv2__Tender_Type_for_Gifts__c = 'Cash';
            opp.ucinn_ascendv2__External_System_Id__c = 'sub_test';
            opp.CloseDate = Date.today();
            opp.ucinn_ascendv2__Frequency__c = 'Annual';
            opp = (Opportunity)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => opp});
            insert opp;

    
            ucinn_ascendv2__Designation_Detail__c detail = new ucinn_ascendv2__Designation_Detail__c();
            detail.ucinn_ascendv2__Designation__c = designation.Id;
            detail.ucinn_ascendv2__Opportunity__c = opp.Id;
            detail = (ucinn_ascendv2__Designation_Detail__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => detail});
            insert detail;
            
            
            ucinn_ascendv2__Review_Transaction_v2__c newRT = new ucinn_ascendv2__Review_Transaction_v2__c();
            newRt.ucinn_ascendv2__First_Name__c = 'First';
            newRt.ucinn_ascendv2__Last_Name__c = 'Lasttest';
            newRt.ucinn_ascendv2__Email_1__c = 'test@test.com';
            newRt.ucinn_ascendv2__Email_1_Type__c = 'Personal';
            newRt.ucinn_ascendv2__Status__c = 'Manual Review';
            newRt.ucinn_ascendv2__Transaction_Date__c = Date.today();
            newRt.ucinn_ascendv2__Opportunity_Type__c = 'Recurring';
            newRt.ucinn_ascendv2__Tender_Type_1__c = 'Credit Card';
            newRt.ucinn_ascendv2__Campaign_External_ID__c = appeal.Id;
            newRt.ucinn_ascendv2__External_System_ID__c = 'GNRL-ManualReviewTest';
            newRt.ucinn_ascendv2__Subscription_ID__c = 'sub_test';
            newRt.ucinn_ascendv2__External_Payment_Gateway_ID__c = 'ManualReviewTest';
            newRt.ucinn_ascendv2__Transaction_Type__c = 'Recurring Gift';
            newRt.ucinn_ascendv2__Designation_1__c = designation.Id;
            newRt.ucinn_ascendv2__Installment_Amount_1_1__c = 1000;
            newRt.ucinn_ascendv2__Installment_Frequency_1__c = 'Monthly';
            newRt.ucinn_ascendv2__Installment_Date_1_1__c = Date.today();
            newRT = (ucinn_ascendv2__Review_Transaction_v2__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newRT});
            insert newRT;

            ucinn_ascendv2__Review_Transaction_v2__c alternativeRT = new ucinn_ascendv2__Review_Transaction_v2__c();
            alternativeRt.ucinn_ascendv2__First_Name__c = 'First';
            alternativeRt.ucinn_ascendv2__Last_Name__c = 'Lasttest';
            alternativeRt.ucinn_ascendv2__Email_1__c = 'test@test.com';
            alternativeRt.ucinn_ascendv2__Email_1_Type__c = 'Personal';
            alternativeRt.ucinn_ascendv2__Status__c = 'Manual Review';
            alternativeRt.ucinn_ascendv2__Transaction_Date__c = Date.today();
            alternativeRt.ucinn_ascendv2__Opportunity_Type__c = 'Recurring';
            alternativeRt.ucinn_ascendv2__Tender_Type_1__c = 'Credit Card';
            alternativeRt.ucinn_ascendv2__Campaign_External_ID__c = appeal.Id;
            alternativeRt.ucinn_ascendv2__External_System_ID__c = 'GNRL-ManualReviewTest';
            alternativeRt.ucinn_ascendv2__Subscription_ID__c = 'sub_test_alternative';
            alternativeRt.ucinn_ascendv2__External_Payment_Gateway_ID__c = 'ManualReviewTest';
            alternativeRt.ucinn_ascendv2__Transaction_Type__c = 'pledge';
            alternativeRt.ucinn_ascendv2__Designation_1__c = designation.Id;
            alternativeRt.ucinn_ascendv2__Installment_Amount_1_1__c = 1000;
            alternativeRt.ucinn_ascendv2__Installment_Frequency_1__c = 'Monthly';
            alternativeRt.ucinn_ascendv2__Installment_Date_1_1__c = Date.today();
            alternativeRT = (ucinn_ascendv2__Review_Transaction_v2__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => alternativeRT});
            insert alternativeRT;

            Map<String, Object> fieldMap = new Map<String, Object>{'created' => 1, 'amount_paid' => 1, 'charge' => 'TestId'};

            Test.startTest();

            PORTAL_StripeWebhookBase.createPaymentForOpportunities(fieldMap, opp.ucinn_ascendv2__Subscription_ID__c, 'TestPrefix');

            opp.AccountId = null;
            update opp;

            PORTAL_StripeWebhookBase.createPaymentForOpportunities(fieldMap, opp.ucinn_ascendv2__Subscription_ID__c, 'TestPrefix');

            
            PORTAL_StripeWebhookBase.createPaymentForReviewTransaction(fieldMap, newRT.ucinn_ascendv2__Subscription_ID__c, 'TestPrefix');
            PORTAL_StripeWebhookBase.createPaymentForReviewTransaction(fieldMap, alternativeRT.ucinn_ascendv2__Subscription_ID__c, 'TestPrefix');


            Test.stopTest();
        }

        public virtual void testCreateDesignationToAmountMapForRecurringGift() {
            List<ucinn_ascendv2__Designation__c> designations = new List<ucinn_ascendv2__Designation__c>{
                new ucinn_ascendv2__Designation__c(Name = 'One'),
                new ucinn_ascendv2__Designation__c(Name = 'Two'),
                new ucinn_ascendv2__Designation__c(Name = 'Three')
            };
            insert designations;

            List<ucinn_ascendv2__Designation_Detail__c> designationDetails = new List<ucinn_ascendv2__Designation_Detail__c>{
                new ucinn_ascendv2__Designation_Detail__c(ucinn_ascendv2__Amount__c = 20, ucinn_ascendv2__Designation__c = designations[0].Id),
                new ucinn_ascendv2__Designation_Detail__c(ucinn_ascendv2__Amount__c = 30, ucinn_ascendv2__Designation__c = designations[1].Id),
                new ucinn_ascendv2__Designation_Detail__c(ucinn_ascendv2__Amount__c = 40, ucinn_ascendv2__Designation__c = designations[2].Id)
            };
            
            Test.startTest();

            Map<Id, Decimal> designationToAmount = PORTAL_StripeWebhookBase.createDesignationToAmountMapForRecurringGift(null, 100);
            System.assertEquals(true, designationToAmount.isEmpty());

            designationToAmount = PORTAL_StripeWebhookBase.createDesignationToAmountMapForRecurringGift(designationDetails, null);
            System.assertEquals(0, designationToAmount.get(designations[0].Id));
            System.assertEquals(0, designationToAmount.get(designations[1].Id));
            System.assertEquals(0, designationToAmount.get(designations[2].Id));

            designationToAmount = PORTAL_StripeWebhookBase.createDesignationToAmountMapForRecurringGift(designationDetails, 90);
            System.assertEquals(20, designationToAmount.get(designations[0].Id));
            System.assertEquals(30, designationToAmount.get(designations[1].Id));
            System.assertEquals(40, designationToAmount.get(designations[2].Id));

            designationToAmount = PORTAL_StripeWebhookBase.createDesignationToAmountMapForRecurringGift(designationDetails, 30);
            System.assertEquals(20, designationToAmount.get(designations[0].Id));
            System.assertEquals(10, designationToAmount.get(designations[1].Id));
            System.assertEquals(0, designationToAmount.get(designations[2].Id));
            
            designationToAmount = PORTAL_StripeWebhookBase.createDesignationToAmountMapForRecurringGift(designationDetails, 120);
            System.assertEquals(50, designationToAmount.get(designations[0].Id));
            System.assertEquals(30, designationToAmount.get(designations[1].Id));
            System.assertEquals(40, designationToAmount.get(designations[2].Id));

            Test.stopTest();
        }

        public virtual void testCreateOrUpdateRecords() {
            Map<String, Object> params = new Map<String, Object>{
                PORTAL_StripeWebhookBase.EVENT_TYPE => PORTAL_StripeWebhookBase.PAYMENT_INTENT_SUCCEEDED,
                PORTAL_StripeWebhookBase.METADATA_PARAMS => new Map<String, Object>() 
            };

            Test.startTest();
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN, PORTAL_CONST_OnlineGiving.MEMBERSHIP_PAYMENT_ELEMENT);
            PORTAL_StripeWebhookBase.createOrUpdateRecords(params, null);
            
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN, PORTAL_CONST_OnlineGiving.EVENTS_PAYMENT_ELEMENT);
            PORTAL_StripeWebhookBase.createOrUpdateRecords(params, null);

            try {
                params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN, PORTAL_CONST_OnlineGiving.ONLINE_GIVING_PAYMENT_ELEMENT);
                // create rtv2 method fails, but that's fine bc we only want to test up until that metohd is called
                PORTAL_StripeWebhookBase.createOrUpdateRecords(params, null);
                System.assert(false);
            } catch (AuraHandledException e) { }

            Test.stopTest();
        }
    }


    @isTest
    static void testInvoiceWebhook() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testInvoiceWebhook();
    }

    @isTest
    static void testInvoiceWebhookWithOpportunity() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testInvoiceWebhookWithOpportunity();
    }

    @isTest
    static void testInvoiceWebhookWithRT() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testInvoiceWebhookWithRT();
    }

    @isTest
    static void testRealData(){
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testRealData();
    }


    @isTest
    static void testSubDeletedWebhook() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testSubDeletedWebhook();
    }

    @isTest
    static void testSubDeletedWebhookNoOpportunity() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testSubDeletedWebhookNoOpportunity();
    }


    @isTest
    static void testSubIncompleteWebhook() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testSubIncompleteWebhook();
    }

    @isTest
    static void testSubIncompleteWebhookNoOpportunity() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testSubIncompleteWebhookNoOpportunity();
    }


    @isTest
    static void testSubIncompleteExpiredWebhook() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testSubIncompleteExpiredWebhook();
    }

    @isTest
    static void testSubIncompleteExpiredWebhookNoOpportunity() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testSubIncompleteExpiredWebhookNoOpportunity();
    }


    @isTest
    static void testSubUnpaidWebhook() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testSubUnpaidWebhook();
    }

    @isTest
    static void testSubUnpaidWebhookNoOpportunity() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testSubUnpaidWebhookNoOpportunity();
    }


    @isTest
    static void testSubPastDueWebhook() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testSubPastDueWebhook();
    }

    @isTest
    static void testSubPastDueWebhookNoOpportunity() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testSubPastDueWebhookNoOpportunity();
    }


    @isTest
    static void testSubActiveWebhook() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testSubActiveWebhook();
    }

    @isTest
    static void testSubActiveWebhookNoOpportunity() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testSubActiveWebhookNoOpportunity();
    }
    
    // @isTest
    // static void testUpdateSubscriptionStatus() {
    //     PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testUpdateSubscriptionStatus();
    // }
    
    @isTest
    static void testCreatePaymentForOpportunitiesAndReviewTransaction() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testCreatePaymentForOpportunitiesAndReviewTransaction();
    }

    @isTest
    static void testCreateDesignationToAmountMapForRecurringGift() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testCreateDesignationToAmountMapForRecurringGift();
    }

    /**
     * test create or update records method
     * @author Jacob Huang
     * @since 1.3
     */
    @isTest
    static void testCreateOrUpdateRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testCreateOrUpdateRecords();
    }    
    
    /**
     * test payment intent succeeded 
     * @author Todd Shinto
     * @since 1.4
     */
    @isTest
    static void testStripePaymentIntentSucceeded() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripeWebhookTestClass().testPaymentIntentSucceeded();
    }
}