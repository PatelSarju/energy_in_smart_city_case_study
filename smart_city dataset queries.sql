/* 1. Total and average daily energy consumption by zone */
SELECT Zone, ROUND(SUM(EnergyConsumed_kWh),2) AS TotalEnergyConsumption, ROUND(AVG(EnergyConsumed_kWh),2) AS AverageEnergyConsumption FROM smartcityenergy 
GROUP BY DAY(new_Date), Zone
ORDER BY DAY(new_Date) ASC, TotalEnergyConsumption DESC;


/* 2. Identify top 5 highest energy-consuming consumers by type */
SELECT MeterID, ConsumerType, ROUND(SUM(EnergyConsumed_kWh),2) AS TotalConsumingEnergy FROM smartcityenergy
GROUP BY ConsumerType, MeterID
ORDER BY TotalConsumingEnergy DESC LIMIT 5;


/* 3. Monthly trend of consumption across zones */
SELECT Zone, MONTH(new_Date) AS Month, ROUND(SUM(EnergyConsumed_kWh),2) AS TotalConsumingEnergy FROM smartcityenergy
GROUP BY Zone,MONTH(new_Date)
ORDER BY Month ASC;


/* 4. Calculate average cost per zone (EnergyConsumed x TarrifRate). */
SELECT Zone, ROUND(AVG(EnergyConsumed_kWh * TariffRate),2) AS AverageCost FROM smartcityenergy
GROUP BY Zone
ORDER BY AverageCost DESC;


/* 5. List meters with highest number of faults or outages. */
-- List meters with highest number of outages
SELECT MeterID, SUM(OutageMinutes) AS TotalOutageMinutes FROM smartcityenergy
GROUP BY MeterID
ORDER BY TotalOutageMinutes DESC LIMIT 5;

-- List meters with highest number of faults
SELECT MeterID, COUNT(MeterStatus) AS TotalFaults FROM smartcityenergy
WHERE MeterStatus="Faulty"
GROUP BY MeterID
ORDER BY COUNT(MeterStatus) DESC LIMIT 5;


/* 6. Determine zones with lowest energy efficiency (high usage + frequent outages). */
SELECT Zone, ROUND(SUM(EnergyConsumed_kWh),2) AS TotalUsage, SUM(OutageMinutes) AS TotalOutageMinutes FROM smartcityenergy
GROUP BY Zone
ORDER BY TotalUsage, TotalOutageMinutes DESC;


/* 7. Detect patterns of peak usage during weekdays Vs weekends. */
SELECT
    CASE
        WHEN WEEKDAY(new_Date) = 5 OR WEEKDAY(new_Date) = 6 THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type, 
    ROUND(SUM(PeakUsage_kWh),2) TotalPeakUsage
    FROM smartcityenergy
    GROUP BY day_type;