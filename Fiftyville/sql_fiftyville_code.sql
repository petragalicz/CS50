-- starting with the crime report:
SELECT *
FROM crime_scene_reports
WHERE YEAR = 2020
  AND MONTH = 7
  AND DAY = 28
  AND street = "Chamberlin Street";

-- description: Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse.
--Interviews were conducted today with three witnesses who were present at the time — each of their interview transcripts mentions the courthouse.


-- reading the interviews regarding the crime
SELECT *
FROM interviews
WHERE YEAR = 2020
  AND MONTH = 7
  AND DAY = 28
  AND transcript LIKE "%courthouse%";

--1st interview: look for cars that left the parking lot within ten minutes of the theft
--2nd interview:I was walking by the ATM on Fifer Street and saw the thief there withdrawing some money.
--3rd interview: As the thief was leaving the courthouse, they called someone who talked to them for less than a minute. In the call,
-- I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
--The thief then asked the person on the other end of the phone to purchase the flight ticket.

-- looking at the courthouse_security_logs from 10:15 to 10:25
SELECT license_plates
FROM courthouse_security_logs
WHERE YEAR = 2020
  AND MONTH = 7
  AND DAY = 28
  AND HOUR = 10
  AND MINUTE > 14
  AND MINUTE < 26;

--possible license plates:
/*5P2BI95
94KL13X
6P58WS2
4328GD8
G412CB7
L93JTIZ
322W7JE
0NTHK55
*/

-- looking at ATM withdrawals on the day of the theft on Fifer street
SELECT account_number
FROM atm_transactions
WHERE YEAR = 2020
  AND MONTH = 7
  AND DAY = 28
  AND atm_location = "Fifer Street"
  AND transaction_type = "withdraw";

-- possible account numbers:
/*28500762
28296815
76054385
49610011
16153065
25506511
81061156
26013199*/


-- looking at ATM withdrawals joining with the people table
SELECT passport_number
FROM atm_transactions
JOIN bank_accounts ON atm_transactions.account_number = bank_accounts.account_number
JOIN people ON bank_accounts.person_id = people.id
WHERE atm_transactions.year = 2020
  AND atm_transactions.month = 7
  AND atm_transactions.day = 28
  AND atm_transactions.atm_location = "Fifer Street"
  AND atm_transactions.transaction_type = "withdraw";

--looking at the phone_calls made that day lasting less than a minute:
SELECT *
FROM phone_calls
WHERE YEAR = 2020
  AND MONTH = 7
  AND DAY = 28
  AND duration < 61;

/*id | caller | receiver | year | month | day | duration
221 | (130) 555-0289 | (996) 555-8899 | 2020 | 7 | 28 | 51
224 | (499) 555-9472 | (892) 555-8872 | 2020 | 7 | 28 | 36
233 | (367) 555-5533 | (375) 555-8161 | 2020 | 7 | 28 | 45
234 | (609) 555-5876 | (389) 555-5198 | 2020 | 7 | 28 | 60
251 | (499) 555-9472 | (717) 555-1342 | 2020 | 7 | 28 | 50
254 | (286) 555-6063 | (676) 555-6554 | 2020 | 7 | 28 | 43
255 | (770) 555-1861 | (725) 555-3243 | 2020 | 7 | 28 | 49
261 | (031) 555-6622 | (910) 555-3251 | 2020 | 7 | 28 | 38
279 | (826) 555-1652 | (066) 555-9701 | 2020 | 7 | 28 | 55
281 | (338) 555-6650 | (704) 555-2131 | 2020 | 7 | 28 | 54*/

--looking at which flight they took and where (the earliest flight on the next day)
SELECT airports.city
FROM
  (SELECT *
   FROM flights
   JOIN airports ON flights.origin_airport_id = airports.id
   WHERE YEAR = 2020
     AND MONTH = 7
     AND DAY = 29
     AND city = "Fiftyville"
   ORDER BY HOUR,
            MINUTE
   LIMIT 1) AS inner_query
JOIN airports ON inner_query.destination_airport_id = airports.id;


--passengers on the plane comparing it with list of people from courthouse_security_logs, ATM, and call logs:
SELECT *
FROM
  (SELECT passport_number
   FROM
     (SELECT flights.id
      FROM flights
      JOIN airports ON flights.origin_airport_id = airports.id
      WHERE YEAR = 2020
        AND MONTH = 7
        AND DAY = 29
        AND city = "Fiftyville"
      ORDER BY HOUR,
               MINUTE
      LIMIT 1) AS inner_query
   JOIN passengers ON inner_query.id = passengers.flight_id) AS outer_query
JOIN people ON outer_query.passport_number = people.passport_number
WHERE people.license_plate IN
    (SELECT license_plate
     FROM courthouse_security_logs
     WHERE YEAR = 2020
       AND MONTH = 7
       AND DAY = 28
       AND HOUR = 10
       AND MINUTE > 14
       AND MINUTE < 26)
  AND phone_number IN
    (SELECT caller
     FROM phone_calls
     WHERE YEAR = 2020
       AND MONTH = 7
       AND DAY = 28
       AND duration < 61)
  AND outer_query.passport_number IN
    (SELECT passport_number
     FROM atm_transactions
     JOIN bank_accounts ON atm_transactions.account_number = bank_accounts.account_number
     JOIN people ON bank_accounts.person_id = people.id
     WHERE atm_transactions.year = 2020
       AND atm_transactions.month = 7
       AND atm_transactions.day = 28
       AND atm_transactions.atm_location = "Fifer Street"
       AND atm_transactions.transaction_type = "withdraw");

-- lookig again at the phone log to see who Ernest talked to:
SELECT people.name
FROM
  (SELECT *
   FROM phone_calls
   JOIN people ON phone_calls.caller = people.phone_number
   WHERE YEAR = 2020
     AND MONTH = 7
     AND DAY = 28
     AND duration < 61
     AND people.name = "Ernest") AS inner_query
JOIN people ON inner_query.receiver = people.phone_number;
