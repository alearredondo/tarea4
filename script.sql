--Pregunta 1, ¿Cuál es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?
select concat(c.first_name, ' ', c.last_name) as nombre_completo_cliente, 
(max(p.payment_date)-min(p.payment_date))/(count(*)) as promedio
from payment p join customer c using(customer_id)
group by customer_id order by 2 desc;





