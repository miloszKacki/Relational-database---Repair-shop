--List of parts for selected car model
--along with number of them in stock and number of their manufacturers

SELECT 
	View_Cars_Models.model_name,
	View_Cars_Models.part_kind_type,
	count(View_Cars_Models.manufacturer) as number_of_manufacturers,
	count(CASE WHEN View_Cars_Models.in_stock = 1 THEN 1 END) as number_available
FROM 
	View_Cars_Models
GROUP BY 
	View_Cars_Models.part_kind_type,
	View_Cars_Models.model_name

-- List of parts of type X compatible with car Y
-- X = ED battery (Bateria napêdowa)
-- Y = Car with GWE88KH plate number
SELECT 
	View_Cars_Parts.registration_number,
	View_Cars_Parts.part_kind_type,
	View_Cars_Parts.price
FROM View_Cars_Parts
WHERE
	View_Cars_Parts.part_kind_type = 'Bateria napêdowa'
	AND View_Cars_Parts.registration_number = 'GWE88KH'
