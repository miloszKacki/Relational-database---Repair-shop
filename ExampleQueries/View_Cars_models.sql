CREATE VIEW View_Cars_Models AS
SELECT 
	Car_Models.*,
	Parts.*,
	Rodzaje_Czesci.*
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
