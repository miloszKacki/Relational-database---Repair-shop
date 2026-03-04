-- Show the invoice of client X billed for a repair from day Y
-- X = person with phone number 789654321 (Anna Kowalska)
-- Y = 2022-09-10

SELECT 
	Invoices.*,
	Jobs.return_date,
	Persons.phone_number
FROM Invoices
	INNER JOIN Persons
		ON Persons.phone_number = Invoices.persons_phone_number
	INNER JOIN Jobs
		ON Jobs.repair_id = Invoices.repair_id
WHERE
	Persons.phone_number = 365247819
	AND Jobs.return_date = '2022-09-10'

--Select a list of Mechanics:
	-- who worked during the last 12 months
	-- along with the ammounts of repairs done by them
	-- collective hours taken by those repairs
	-- and dates they were employed and maybe fired 

-- I added another 12 months - it querries better on example data

SELECT 
	Lately_working_mechanics.phone_number,
	COUNT(Jobs.return_date) as number_of_repairs,
	SUM(Jobs.work_hours) as sum_of_work_hours
FROM (
	SELECT 
	Mechanics.*,
	Jobs.return_date,
	Jobs.roll_in_date
	FROM Mechanics
		INNER JOIN Jobs
		ON Mechanics.phone_number = Jobs.mechanics_phone_number
	WHERE
		Jobs.return_date > '2023-01-13'
		OR Jobs.roll_in_date > '2023-01-13'
	) Lately_working_mechanics
	LEFT JOIN 
		Jobs
		ON Lately_working_mechanics.phone_number = Jobs.mechanics_phone_number
GROUP BY
	Lately_working_mechanics.phone_number
ORDER BY
	number_of_repairs
		DESC,
	sum_of_work_hours
		DESC



--Repair history of a car with registration_number KR82WA

SELECT 
	Jobs.roll_in_date,
	Jobs.return_date,
	Jobs.work_hours
FROM Cars
	INNER JOIN Jobs
		ON Jobs.repaired_registration_number = Cars.registration_number
WHERE
	Cars.registration_number = 'KR82WA'


--List of parts used to all repairs on a single car
--along with the part's types and dates of repairs they were used in

SELECT 
	Used_parts.serial_number,
	Part_Kinds.part_kind_type,
	Part_Kinds.manufacturer,
	Jobs.roll_in_date as repair_start_date,
	Jobs.return_date as repair_finish_date
FROM (
	SELECT * 
	FROM Parts
	WHERE in_stock = 0
	) Used_parts

	INNER JOIN Part_Kinds
		ON Part_Kinds.id = Used_parts.part_kind_id
	INNER JOIN Jobs
		ON Jobs.repair_id = Used_parts.repair_id
	INNER JOIN Cars
		ON Cars.registration_number = Jobs.repaired_registration_number
WHERE
	Cars.registration_number = 'KR82WA'


-- Display the list of car models that have been repaired within the last 6 months.
-- For each model, provide the types and prices of parts available in the warehouse,
-- the number of units, and the manufacturers.
-- Also include missing parts for those models (quantity in stock = 0).

-- implementation without the list of parts
-- (the list of parts cannot be displayed in a single row of the table, therefore I implement the query without it)
-- separately, you can query the list of parts compatible with a given model – implemented below

-- Due to the data, I extended the repair period considered



SELECT
	Cars.model_name
FROM Cars
	INNER JOIN (
		SELECT *
		FROM Jobs
		WHERE
			Jobs.return_date > '2023-01-01'
			OR Jobs.roll_in_date > '2023-01-01'
				) Lately_done_repairs
		ON Lately_done_repairs.repaired_registration_number = Cars.registration_number

	
-- Show garage's income for each month since the beginning of its operation
-- And sort them in descending order

SELECT 
	MONTH(Billed_invoices.creation_date) as month_,
	YEAR(Billed_invoices.creation_date) as year_,
	SUM(Billed_invoices.billed_sum) as income
FROM 
	(
	SELECT
	Invoices.*,
	Mechanics.hourly_wage * Jobs.work_hours + ISNULL(Part_Kinds.price , 0) as billed_sum
	FROM Invoices
	INNER JOIN Jobs
		ON Jobs.repair_id = Invoices.repair_id
	INNER JOIN Mechanics
		ON Mechanics.phone_number = Jobs.mechanics_phone_number
	LEFT JOIN Parts
		ON Jobs.repair_id = Parts.repair_id
	LEFT JOIN Part_Kinds
		ON Part_Kinds.id = Parts.part_kind_id
	) as Billed_invoices
WHERE 
	Billed_invoices.is_paid = 1
GROUP BY 
	MONTH(Billed_invoices.creation_date),
	YEAR(Billed_invoices.creation_date)
ORDER BY
	SUM(Billed_invoices.billed_sum) DESC

