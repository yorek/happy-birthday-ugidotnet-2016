select
	Color,
	TotalQty = sum(d.OrderQty),
	TotalValue = sum(d.LineTotal),
	Distinctcount = count(distinct d.ProductID)
from
	[Sales].[SalesOrderHeader] h
inner join
	(select s.* from [Sales].[SalesOrderDetail] s cross join sys.objects) d on h.SalesOrderID = d.SalesOrderID
inner join
	[Production].[Product] p on d.ProductID = p.ProductID
inner join
	[Sales].[Customer] c on c.CustomerID = h.CustomerID
--where
	--c.AccountNumber like '%123%'
group by
	p.Color

