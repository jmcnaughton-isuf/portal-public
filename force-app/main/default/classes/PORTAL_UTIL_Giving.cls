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
 * Utility class for giving/gift related logic
 * 
 * @author  Jacob Huang
 * @version 1.0
 */

public inherited sharing class PORTAL_UTIL_Giving {
    public static final Map<String, Decimal> frequencyStringToPeriodDecimalMap = new Map<String, Decimal> { 
                                                                                            'Weekly' => 1,              // once every 1 week
                                                                                            'Bi-Weekly' => 2,           // once every 2 weeks
                                                                                            'Quad-Weekly' => 4,         // once every 4 weeks
                                                                                            'Monthly' => 1,             // once every 1 month
                                                                                            'Semi-Monthly' => 0.5,      // Cybersource: twice a month on the 1st and 15th
                                                                                            'Quarterly' => 3,           // once every 3 months
                                                                                            'Semi-Annual' => 6,         // once every 6 months
                                                                                            'Annual' =>  12};           // once every 12 months

    public static final String INVALID_FREQUENCY = 'The frequency provided is invalid.';
    public static final String WEEKLY = 'Weekly';
    public static final String SEMI_MONTHLY = 'Semi-Monthly';

    /**
     * calculate the number of recurring payments at a given frequency 
     * 
     * @param startDate         start date
     * @param endDate           last date that a donor will give
     * @param frequency         key in frequencyStringToPeriodDecimalMap class variable
     * @return number of recurring payments for the specified duration, null if invalid dates
     */
    public static Integer getNumberOfPayments(Date startDate, Date endDate, String frequency) {
        if (startDate == null || endDate == null || endDate < startDate) {
            return null;
        }

        if (!frequencyStringToPeriodDecimalMap.keySet().contains(frequency)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => INVALID_FREQUENCY
            });
        }

        Decimal period = frequencyStringToPeriodDecimalMap.get(frequency);
        Integer timeUnitsBetween;
        Integer extraPayments;
        if (frequency.contains(WEEKLY)) {
            timeUnitsBetween = startDate.daysBetween(endDate) / 7;
            extraPayments = 1;
        }
        else if (frequency.equals(SEMI_MONTHLY)) { // twice a month on 1st and 15th
            Date adjustedStart = nextSemiMonthlyDate(startDate);
            Date adjustedEnd = previousSemiMonthlyDate(endDate);
            timeUnitsBetween = adjustedStart.monthsBetween(adjustedEnd);
            extraPayments = getSemiMonthlyExtraPayments(adjustedStart.day(), adjustedEnd.day());
        }
        else {
            timeUnitsBetween = startDate.monthsBetween(endDate);
            extraPayments = (startDate.addMonths(timeUnitsBetween) <= endDate) ? 1 : 0;
        }

        return (Integer) (timeUnitsBetween / period) + extraPayments;
    }

    /**
     * get the next date when a semi-monthly payment is due
     * 
     * @param initialDate         date on or before a semi-monthly payment date
     * @return next date when semi-monthly payment is due (day is 1 or 15)
     */
    private static Date nextSemiMonthlyDate(Date initialDate) {
        if (initialDate.day() > 1 && initialDate.day() <= 14) {
            return Date.newInstance(initialDate.year(), initialDate.month(), 15);
        }
        else if (initialDate.day() > 15) {
            // Apex automatically adds 1 to year if month argument is 13
            return Date.newInstance(initialDate.year(), initialDate.month() + 1, 1);
        }
        else {
            return initialDate;
        }
    }

    /**
     * get the previous date when a semi-monthly payment is due
     * 
     * @param initialDate         date on or after a semi-monthly payment date
     * @return previous date when semi-monthly payment is due (day is 1 or 15)
     */
    private static Date previousSemiMonthlyDate(Date initialDate) {
        Integer day = (initialDate.day() >= 15) ? 15 : 1;
        return Date.newInstance(initialDate.year(), initialDate.month(), day);
    }

    /**
     * get the number of additional semi-monthly payments that are needed due to
     * the day of the month the subscription begins and ends 
     * total payments = (months between start and end date * 2) + return value of this method
     * 
     * @param startDay          start day (1 or 15)
     * @param endDay            end day (1 or 15)
     * @return number of additional payments
     */
    private static Integer getSemiMonthlyExtraPayments(Integer startDay, Integer endDay) {
        if (startDay == endDay) {
            return 1;
        }
        else if (startDay == 1) {
            return 2;
        }
        else {
            return 0;
        }
    }
}