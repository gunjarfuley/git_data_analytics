#-------------------QUESTION-7-------------------#

alter table carton
add carton_vol integer

select ci.CARTON_ID, ci.LEN*ci.WIDTH*ci.HEIGHT as carton_vol
from carton ci
where ci.carton_vol > ( select sum(pr.len*pr.width*pr.height*oi3.product_quantity) as pro_vol
	from product pr join order_items oi3
	on pr.product_id = oi3.product_id
    where oi3.order_id = 10006
)

#-------------------QUESTION-8-------------------#

select oh.order_id, oh.customer_id, concat(oc.customer_fname,' ',oc.customer_lname), sum(oi.PRODUCT_QUANTITY)
from order_header oh join online_customer oc
on oh.CUSTOMER_ID = oc.CUSTOMER_ID
join order_items oi
on oi.ORDER_ID = oh.ORDER_ID
#where sum(oi.PRODUCT_QUANTITY)>10
where oh.ORDER_STATUS = 'Shipped'
group by oh.customer_id, concat(oc.customer_fname,' ',oc.customer_lname)
having sum(oi.PRODUCT_QUANTITY)>10

#-------------------QUESTION-9-------------------#

select oh.order_id, oh.customer_id, concat(oc.customer_fname,' ',oc.customer_lname)
from order_header oh inner join online_customer oc
on oh.CUSTOMER_ID = oc.CUSTOMER_ID
inner join order_items oi
on oi.ORDER_ID = oh.ORDER_ID
where oi.ORDER_ID > 10060 AND oh.ORDER_STATUS = 'Shipped'
group by ORDER_ID;

#-------------------QUESTION-10-------------------#

CREATE TEMPORARY TABLE MY_PROJECT( PRODUCT_CLASS_DESC VARCHAR(40) NOT NULL, Total_Quantity INTEGER,  Total_value DECIMAL(12,2) NOT NULL DEFAULT 0.0); 
INSERT  INTO MY_PROJECT  

select pc.PRODUCT_CLASS_DESC, sum(oi.PRODUCT_QUANTITY) as 'Total_Quantity',
 (oi.PRODUCT_QUANTITY*p.product_price) as 'Total Value'
from product_class pc join product p on pc.PRODUCT_CLASS_CODE = p.PRODUCT_CLASS_CODE
join order_items oi on oi.PRODUCT_ID = p.PRODUCT_ID
join order_header oh on oh.ORDER_ID = oi.ORDER_ID
join online_customer oc on oc.CUSTOMER_ID = oh.CUSTOMER_ID
join address ad on ad.ADDRESS_ID = oc.ADDRESS_ID
where oh.ORDER_STATUS = 'Shipped'
AND ad.country NOT IN ('India','USA')
group by pc.PRODUCT_CLASS_DESC;

select * from MY_PROJECT order by Total_Quantity desc limit 1;
DROP temporary TABLE MY_PROJECT;