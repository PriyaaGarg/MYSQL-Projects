use fraud_detection;
select * from transactions Limit 100;

#Confirmed Fraud Transactions
SELECT * FROM transactions
WHERE isFraud = 1;

#Suspected Fraud Transactions
SELECT * FROM transactions
WHERE isFlaggedFraud = 1;

#Extracting the Large Value Transactions
SELECT * FROM transactions
WHERE amount>200000;

#Extracting the Large Cash-Out Transactions
SELECT * FROM transactions
WHERE (type = 'CASH_OUT' AND amount>150000);

#Single Originator But Multiple Beneficiaries
SELECT nameOrig, count(DISTINCT nameDest) AS distinct_destination
FROM transactions
GROUP BY nameOrig
HAVING distinct_destination>1;

#Multiple Originator But Same Beneficiary
SELECT nameDest, count(DISTINCT nameOrig) AS distinct_originator
FROM transactions
GROUP BY nameDest
HAVING distinct_originator>1
ORDER BY distinct_originator DESC;

#Multiple Transactions Between Same Parties
SELECT nameOrig, nameDest, COUNT(*) as same_parties
FROM transactions
GROUP BY nameOrig, nameDest
HAVING same_parties>1;

#Time Based Fraud Detection
SELECT step, COUNT(*) AS total_transactions,
SUM(isFraud) AS fraud_count
FROM transactions
GROUP BY step
ORDER BY fraud_count DESC;

#Duplicate Transactions
SELECT nameOrig, amount, COUNT(*) as duplicate_transactions
FROM transactions
GROUP BY nameOrig, amount
HAVING duplicate_transactions>1;

#Data Mismatch
SELECT * 
FROM transactions
WHERE oldbalanceOrg - newbalanceOrig != amount;

SELECT * 
FROM transactions
WHERE newbalanceDest - oldBalanceDest != amount;


