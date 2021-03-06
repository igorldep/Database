﻿-- 				Igor Luciano de Paula - Lab 8


------------------------------------------- 1 ------------------------------------------

CREATE SEQUENCE quest1 INCREMENT BY 2 START WITH 2

select * from quest1

-----------------------------------------------------------------------------------------


------------------------------------------- 2 ------------------------------------------

CREATE OR REPLACE FUNCTION NumProxSequencia_Quest1()
RETURNS VOID AS
$$ 
	DECLARE
		reg RECORD;
		next_value bigint;
		max_value bigint;
	BEGIN
		FOR reg IN SELECT * from quest1
		LOOP
			next_value = reg.last_value + reg.increment_by;
			max_value = reg.max_value;
		END LOOP;
		IF (next_value > max_value)
		THEN
			RAISE NOTICE 'O próximo (%) passa do limite da sequência (%)', next_value, max_value ;
		ELSE
			RAISE NOTICE 'O próximo valor da sequência é: %', next_value ;
		END IF;
		
		
	END;
$$
LANGUAGE 'plpgsql'

select * from NumProxSequencia_Quest1()

--------------------------------------------------------------------------------------------------


------------------------------------------- 3 ------------------------------------------
 
CREATE OR REPLACE FUNCTION NumAtualSeq_Quest1()
RETURNS VOID AS
$$ 
	DECLARE
		reg RECORD;
		current_value bigint;
	BEGIN
		FOR reg IN SELECT * from quest1
		LOOP
			current_value = reg.last_value;
		END LOOP;
		
		RAISE NOTICE 'O atual valor da sequência é: %', current_value ;		
	END;
$$
LANGUAGE 'plpgsql'

select * from NumAtualSeq_Quest1()

----------------------------------------------------------------------------------------


------------------------------------------- 4 ------------------------------------------

pg_dump lab6 > bkp1.out

----------------------------------------------------------------------------------------


------------------------------------------- 5 ------------------------------------------

pg_restore -d banco_restaurado bkp1.out

----------------------------------------------------------------------------------------


------------------------------------------- 6 ------------------------------------------

CREATE OR REPLACE VIEW quest6 AS
select a.nm_autor, sum(vl_quantidade) from encomenda_livro el
inner join autor_livro al ON el.id_isbn = al.id_isbn
inner join autor a ON a.id_autor = al.id_autor
inner join encomenda e ON e.id_encomenda = el.id_encomenda
group by (a.id_autor)
order by 2 desc
limit 3

select * from quest6;

------------------------------------------------------------------------------------


------------------------------------------- 7 ------------------------------------------

CREATE EXTENSION dblink;

 select * from dblink
 (
 	'
 	dbname=livraria
 	hostaddr=172.16.2.44
 	user=igor
 	password=igorviado
 	port=5432',
 	'select nm_autor
 	from questaoseis
 	'
 ) as t1(nm_autor varchar(40));

----------------------------------------------------------------------------------------


------------------------------------------- 8 ------------------------------------------

DROP table autor cascade;

----------------------------------------------------------------------------------------


------------------------------------------- 9 ------------------------------------------

select * from dblink
(
	'
	dbname=livraria
	hostaddr=172.16.2.44
	user=igor
	password=igorviado
	port=5432',
	'
	CREATE OR REPLACE VIEW quest9 AS
	select * from autor
	'
) as t1(nm_autor varchar(40));

----------------------------------------------------------------------------------------


------------------------------------------- 10 ------------------------------------------

select * from dblink
(
	'
	dbname=livraria
	hostaddr=172.16.2.44
	user=igor
	password=igorviado
	port=5432',
	'
	select * from quest9
	'
) as t1(nm_autor varchar(40));

----------------------------------------------------------------------------------------
