--Tarea 4
--Alejandra Arredondo Hernandez 189744
--NOTA: como se recomendo en clase, Alejandra, Elisa y Yuliana compartimos nuestros conocimientos 
--después de haber elaborado de manera individual nuestra tarea, cada una sabe como hacer cada pregunta, 
--sin embargo, intercambiamos opiniones y formas de hacerlo para enriquecer nuestro conocimiento en la materia.

--Pregunta 1, ¿Cuál es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?
select concat(c.first_name, ' ', c.last_name) as nombre_completo_cliente, 
(max(p.payment_date)-min(p.payment_date))/(count(*)) as promedio
from payment p join customer c using(customer_id)
group by customer_id order by 2 desc;


--Pregunta 2, ¿Sigue una distribución normal?
CREATE OR REPLACE FUNCTION histogram(table_name_or_subquery text, column_name text)
RETURNS TABLE(bucket int, "range" numrange, freq bigint, bar text)
AS $func$
BEGIN
RETURN QUERY EXECUTE format('
  WITH
  source AS (
    SELECT * FROM %s
  ),
  min_max AS (
    SELECT min(%s) AS min, max(%s) AS max FROM source
  ),
  histogram AS (
    SELECT
      width_bucket(%s, min_max.min, min_max.max, 20) AS bucket,
      numrange(min(%s)::numeric, max(%s)::numeric, ''[]'') AS "range",
      count(%s) AS freq
    FROM source, min_max
    WHERE %s IS NOT NULL
    GROUP BY bucket
    ORDER BY bucket
  )
  SELECT
    bucket,
    "range",
    freq::bigint,
    repeat(''*'', (freq::float / (max(freq) over() + 1) * 15)::int) AS bar
  FROM histogram',
  table_name_or_subquery,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name
  );
END
$func$ LANGUAGE plpgsql;

--Query
select * from histogram('(select extract(epoch from (max(p.payment_date) - min(p.payment_date))/(count(*))) as promedio
from payment p group by customer_id order by promedio) as histoprom' ,'promedio');


--Pregunta 3, ¿Qué tanto difiere ese promedio del tiempo entre rentas por cliente?
select concat( c.first_name, ' ', c.last_name ) as nombre_completo_cliente, 
(max(r.rental_date) - min(r.rental_date))/(count(*)) as rentas_promedio,  
(max(p.payment_date) - min(p.payment_date))/(count(*)) as pagos_promedio, 
(max(r.rental_date) - min(r.rental_date))/(count(*)) - 
(max(p.payment_date) - min(p.payment_date))/(count(*)) as diferencia_promedio
from payment p join customer c using(customer_id) join rental r using(customer_id)
group by customer_id order by 2 desc;








