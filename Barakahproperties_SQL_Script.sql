Schema -

CREATE TABLE buildings (
bldg_id VARCHAR(10) PRIMARY KEY,
building_name VARCHAR(100) NOT NULL,
"location" VARCHAR(100) NOT NULL,
"type" VARCHAR(50) NOT NULL CHECK ("type" IN('Residential', 'Commercial', 'Mixed')),
total_units INT
	);

CREATE TABLE units (
unit_id VARCHAR(10) PRIMARY KEY,
building_id VARCHAR(10) REFERENCES buildings(building_id) NOT NULL,
unit_type VARCHAR(100) NOT NULL,
"floor" INT NOT NULL,
area_sqft INT NOT NULL CHECK(area_sqft NOT IN(0))
	);

CREATE TABLE rental_targets (
target_id VARCHAR(10) PRIMARY KEY,
unit_id VARCHAR(10) REFERENCES units(unit_id) NOT NULL,
"month" INT NOT NULL CHECK("month" IN(1,2,3,4,5,6,7,8,9,10,11,12)),
"year" INT NOT NULL CHECK("year" IN(2024)),
target_rent_aed INT NOT NULL CHECK(target_rent_aed NOT IN(0))
	);

CREATE TABLE rental_actuals (
actual_id VARCHAR(10) PRIMARY KEY,
unit_id VARCHAR(10) REFERENCES units(unit_id) NOT NULL,
"month" INT NOT NULL CHECK("month" IN(1,2,3,4,5,6,7,8,9,10,11,12)),
"year" INT NOT NULL CHECK("year" IN(2024)),
actual_rent_aed INT NOT NULL,
payment_status VARCHAR(20) NOT NULL CHECK(payment_status IN('Paid','Late','Arrears','Vacant')),
days_late INT NOT NULL
	);

CREATE TABLE 
	maintenance_costs (
cost_id VARCHAR(10) PRIMARY KEY,
building_id VARCHAR(10) REFERENCES buildings(building_id) NOT NULL,
"month" INT NOT NULL CHECK("month" IN(1,2,3,4,5,6,7,8,9,10,11,12)),
"year" INT NOT NULL CHECK("year" IN(2024)),
category VARCHAR NOT NULL CHECK(category IN('AC Maintenance','Plumbing','Cleaning','Electrical','Security','Landscaping')), 
budgeted_cost INT NOT NULL,
actual_cost INT NOT NULL
	);	


---- Which buildings are under-collecting vs target, and by how much in AED and %? ----

SELECT
	b.building_id,
	b.building_name,
	ra.year,
	SUM(ra.actual_rent_aed) AS total_rent_actual,
	SUm(rt.target_rent_aed) AS total_rent_target,
	SUM(ra.actual_rent_aed-rt.target_rent_aed) AS variance,
	ROUND((SUM(ra.actual_rent_aed-rt.target_rent_aed)*100.0)/NULLIF(SUM(rt.target_rent_aed),0),2) AS variance_pct
FROM rental_actuals AS ra
	JOIN rental_targets AS rt
		ON ra.unit_id = rt.unit_id AND ra.month = rt.month AND ra.year = rt.year
			JOIN units AS u
				ON ra.unit_id = u.unit_id
					JOIN buildings AS b
						ON b.building_id = u.building_id
GROUP BY 
	b.building_id, b.building_name, ra.year
ORDER BY
	variance ASC;


---- What is the unit status breakdown (Paid, Late, Arrears, Vacant) per building for Q4 2024 (months 10, 11, 12)? ----

SELECT 
	b.building_id, 
	b.building_name,
	b.location,
	COUNT(DISTINCT(ra.unit_id)) AS total_unit_count,
	SUM(CASE WHEN ra.payment_status = 'Paid' THEN 1 ELSE 0 END) AS paid_count,
	SUM(CASE WHEN ra.payment_status = 'Late' THEN 1 ELSE 0 END) AS late_count,
	SUM(CASE WHEN ra.payment_status = 'Arrears' THEN 1 ELSE 0 END) AS arrear_count,
	SUM(CASE WHEN ra.payment_status = 'Vacant' THEN 1 ELSE 0 END) AS vacant_count,
	COUNT(ra.payment_status) AS total_count
FROM rental_actuals AS ra
	JOIN units AS u
		ON ra.unit_id = u.unit_id
			JOIN buildings AS b
				ON u.building_id = b.building_id
WHERE ra.month IN (10,11,12) AND "year" = 2024				
GROUP BY
	b.building_id
ORDER BY
	B.building_id;

---- Which 10 units have the highest cumulative rent shortfall for the full year 2024, and what is the primary reason ? Vacancy or underpayment? ----

SELECT 
	b.building_id,
	b.building_name,
	ra.unit_id,
	u.unit_type,
	ra.year,
	SUM(ra.actual_rent_aed) AS annual_rent_actual,
	SUM(rt.target_rent_aed) AS annual_rent_target,
	(SUM(ra.actual_rent_aed) - SUM(rt.target_rent_aed)) AS annual_variance,
	SUM(CASE WHEN ra.payment_status = 'Arrears' THEN 1 ELSE 0 END) AS arrears_count,
    SUM(CASE WHEN ra.payment_status = 'Vacant' THEN 1 ELSE 0 END) AS vacancy_count
FROM rental_actuals AS ra
	JOIN rental_targets AS rt
	ON ra.unit_id = rt.unit_id AND ra.month = rt.month AND ra.year = rt.year
		JOIN units AS u
		ON ra.unit_id = u.unit_id
			JOIN buildings AS b
			ON u.building_id = b.building_id
WHERE ra.year = 2024			
GROUP BY
	b.building_id, b.building_name, u.unit_type, ra.unit_id, ra.year
ORDER BY
	annual_variance
LIMIT
	10;


---- Where are we over budget on maintenance AC, plumbing, cleaning, etc.? ----

SELECT 
	b.building_id,
	b.building_name,
	category,
	SUM(actual_cost) AS annual_actual_cost,
	SUM(budgeted_cost) AS annual_budgeted_cost,
	(SUM(actual_cost) - SUM(budgeted_cost)) AS annual_variance,
	ROUND((SUM(actual_cost) - SUM(budgeted_cost))*100.0/NULLIF(SUM(budgeted_cost),0),2) AS annual_variance_pct
	FROM maintenance_costs AS m
	JOIN buildings AS b 
	ON m.building_id = b.building_id
GROUP BY 
	category,b.building_id, b.building_name
HAVING
	ROUND((SUM(actual_cost) - SUM(budgeted_cost))*100.0/NULLIF(SUM(budgeted_cost),0),2) > 0
ORDER BY	
	annual_variance_pct DESC;
	
SELECT *
	FROM maintenance_costs;		

SELECT *
	FROM units;	

SELECT *
	FROM buildings;

---- What is the collection efficiency rate per building per quarter? ----

WITH quarterly AS (
SELECT
	ra.unit_id,
	CASE
		WHEN ra.month IN (1,2,3) THEN 'Q1'
		WHEN ra.month IN (4,5,6) THEN 'Q2'
		WHEN ra.month IN (7,8,9) THEN 'Q3'
		WHEN ra.month IN (10,11,12) THEN 'Q4'
	ELSE 'N/A'
	END AS quarter,
	ra.year,
	SUM(ra.actual_rent_aed) AS quarterly_actual_rent,
	SUM(rt.target_rent_aed) AS quarterly_target_rent,
	SUM(ra.actual_rent_aed) - SUM(rt.target_rent_aed) AS variance
FROM rental_actuals AS ra
JOIN rental_targets AS rt
	ON ra.unit_id = rt .unit_id AND ra.month = rt.month AND ra.year = rt.year
GROUP BY
	ra.unit_id, quarter, ra.year
)

SELECT
	b.building_id,
	b.building_name,
	q.quarter,
	q.year,
	SUM(q.quarterly_actual_rent) AS quarterly_actual_rent,
	SUM(q.quarterly_target_rent) AS quarterly_target_rent,
	SUM(q.variance) AS variance,
	ROUND(SUM(q.quarterly_actual_rent)*100.0/NULLIF(SUM(q.quarterly_target_rent),0),2) AS collection_pct
FROM buildings AS b
JOIN units AS u
ON b.building_id = u.building_id
	JOIN quarterly AS q
	ON q.unit_id = u.unit_id
GROUP BY
	b.building_id, b.building_name, q.quarter, q.year
ORDER BY
	b.building_id, collection_pct DESC;

---- What is the The Net Position (P&L) ----

WITH actual_m_cost AS (
SELECT
	b.building_id,
	b.building_name,
	SUM(m.actual_cost) AS actual_cost
FROM maintenance_costs AS m
JOIN buildings AS b
ON m.building_id = b.building_id
WHERE m.year = 2024
GROUP BY b.building_id, b.building_name
),
actual_rent AS (
SELECT
	u.building_id,
	b.building_name,
	SUM(ra.actual_rent_aed) AS actual_rent_received
FROM rental_actuals AS ra
JOIN units AS u
ON ra.unit_id = u.unit_id
	JOIN buildings AS b
	ON b.building_id = u.building_id
WHERE ra.year = 2024
GROUP BY u.building_id, b.building_name
)
SELECT
	actual_rent.building_id,
	actual_rent.building_name,
	actual_rent.actual_rent_received,
	actual_m_cost.actual_cost,
	(actual_rent.actual_rent_received) - (actual_m_cost.actual_cost) AS profit_n_loss
FROM actual_rent
JOIN actual_m_cost
USING(building_id)
ORDER BY profit_n_loss DESC;

---- Performance Tier Classification ----

SELECT 
	b.building_id,
	b.building_name,
	SUM(ra.actual_rent_aed) AS annual_actual_rent,
	SUM(rt.target_rent_aed) AS annual_target_rent,
	(SUM(ra.actual_rent_aed) - SUM(rt.target_rent_aed)) AS variance,
	ROUND((SUM(ra.actual_rent_aed)*100.0/NULLIF(SUM(rt.target_rent_aed),0)),2) AS variance_pct,
	CASE
		WHEN variance_pct > 98 THEN 'Top Performer'
    	WHEN variance_pct >= 95 THEN 'On Track'
    	WHEN variance_pct >= 90 THEN 'At Risk'
    	ELSE 'Underperforming'
	END AS tier_classification	
FROM rental_actuals AS ra
JOIN rental_targets AS rt
ON ra.unit_id = rt.unit_id AND ra.month = rt.month AND ra.year = rt.year
	JOIN units AS u
	ON ra.unit_id = u.unit_id
		JOIN buildings AS b
		ON u.building_id = b.building_id
WHERE ra.year = 2024		
GROUP BY b.building_id, b.building_name
ORDER BY variance_pct DESC;
