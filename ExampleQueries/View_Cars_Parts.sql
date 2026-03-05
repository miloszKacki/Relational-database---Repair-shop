CREATE VIEW View_Cars_Parts AS
SELECT 
	Cars.*,
	Parts.*,
	Part_Kinds.*
FROM Parts
	INNER JOIN 
		Part_Kinds
		ON Parts.part_kind_id = Part_Kinds.id
	INNER JOIN
		Compatibility
		ON Compatibility.part_kind_id = Part_Kinds.id
	INNER JOIN
		Car_Models
		ON Car_Models.model_name = Compatibility.model_name
	INNER JOIN
		Cars
		ON Cars.model_name = Car_Models.model_name
