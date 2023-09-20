DO $$
	DECLARE
		arow			RECORD;
		userName		CHAR(6);
		sql_drop		TEXT;
    	sql_createdb	TEXT;
		sql_createuser	TEXT;
		sql_grantall	TEXT;
	BEGIN
		sql_drop		= 'DROP DATABASE IF EXISTS willibald_dm_bis2420%s'; 
    	sql_createdb	= 'CREATE DATABASE willibald_dm_bis2420%s';
		sql_createuser	= 'CREATE USER bis2420%s WITH ENCRYPTED PASSWORD ''%s''';
		sql_grantall	= 'GRANT ALL PRIVILEGES ON DATABASE willibald_dm_bis2420%s TO bis2420%s';
	
		FOR arow IN
			SELECT userNumber, userPassword FROM (
				VALUES	(0, 'MTjVV9wCuiggDV'),
						(1, '5CcivCVkMuoDGs'),
						(2, 'nzkLEjVHWTfp5n'),
						(3, 'aV6HcJUs8bmRfs'),
						(4, 'JqwpdapXMnaU8g'),
						(5, 'bCryexa66CRLne'),
						(6, 'insM6ZzGTaTVYU'),
						(7, 'MQoCSCTAg4btMT'),
						(8, 'gNxXBjwBVPLq2M')
			) AS t1(userNumber, userPassword)
		LOOP
			
			--EXECUTE FORMAT(sql_drop, arow.userNumber);
        	--EXECUTE FORMAT(sql_createdb, arow.userNumber);
			
			EXECUTE FORMAT(sql_createuser, arow.userNumber, arow.userPassword);
			
			--EXECUTE FORMAT(sql_grantall, arow.userNumber);
    
		END LOOP;
  END;
$$;