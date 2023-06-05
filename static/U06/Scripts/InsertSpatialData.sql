CREATE TABLE vrs.shelve (
    shelve_id INT PRIMARY KEY,
    shelve_geo GEOMETRY,
	store_id INT,
	[description] NVARCHAR(255)
    );

ALTER TABLE vrs.shelve
	ADD CONSTRAINT FK_Shelve_Store FOREIGN KEY (store_id)
		REFERENCES vrs.store (store_id);

INSERT INTO vrs.shelve (shelve_id, shelve_geo, store_id)
VALUES
(1, geometry::STPolyFromText('POLYGON((1 1, 10 1, 10 2, 1 2, 1 1))', 4326), 1),
(2, geometry::STPolyFromText('POLYGON((12 1, 22 1, 22 2, 12 2, 12 1))', 4326), 1),
(3, geometry::STPolyFromText('POLYGON((1 3, 10 3, 10 4, 1 4, 1 3))', 4326), 1),
(4, geometry::STPolyFromText('POLYGON((12 3, 22 3, 22 4, 12 4, 12 3))', 4326), 1),
(5, geometry::STPolyFromText('POLYGON((1 5, 10 5, 10 6, 1 6, 1 5))', 4326), 1),
(6, geometry::STPolyFromText('POLYGON((12 5, 22 5, 22 6, 12 6, 12 5))', 4326), 1),
(7, geometry::STPolyFromText('POLYGON((1 7, 10 7, 10 8, 1 8, 1 7))', 4326), 1),
(8, geometry::STPolyFromText('POLYGON((12 7, 22 7, 22 8, 12 8, 12 7))', 4326), 1),
(9, geometry::STPolyFromText('POLYGON((1 10, 2 10, 2 20, 1 20, 1 10))', 4326), 1),
(10, geometry::STPolyFromText('POLYGON((3 10, 4 10, 4 20, 3 20, 3 10))', 4326), 1),
(11, geometry::STPolyFromText('POLYGON((5 10, 6 10, 6 20, 5 20, 5 10))', 4326), 1),
(12, geometry::STPolyFromText('POLYGON((7 10, 8 10, 8 20, 7 20, 7 10))', 4326), 1);

ALTER TABLE vrs.inventory ADD shelve_id INT NULL;

ALTER TABLE vrs.inventory
	ADD CONSTRAINT FK_Inventory_Shelve FOREIGN KEY (shelve_id)
		REFERENCES vrs.shelve (shelve_id);

UPDATE i
   SET i.shelve_id = t.shelve_id 
  FROM vrs.inventory i
  JOIN (
	SELECT	t2.inventory_id,
			NTILE(12) OVER(ORDER BY t2.film_id DESC) AS shelve_id
	  FROM vrs.inventory t2
	 WHERE t2.store_id = 1
  ) t
    ON t.inventory_id = i.inventory_id;