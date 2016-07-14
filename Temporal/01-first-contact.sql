use DemoTemporal
go

alter table dbo.OrderInfo set ( system_versioning = off )
go

drop table if exists dbo.OrderInfo
drop table if exists dbo.OrderInfoHistory
go

create table dbo.OrderInfo
(
	id int not null primary key,
	[description] nvarchar(1000) not null,
	[value] money not null,
	[received_on] datetime2 not null,
	[status] varchar(100) not null,
	customer_id char(2) not null,
	valid_from datetime2 generated always as row start hidden not null,  
	valid_to datetime2 generated always as row end hidden not null,  
	period for system_time (valid_from, valid_to)     
)    
with (system_versioning = on (history_table = dbo.OrderInfoHistory)  )   
go

insert into dbo.OrderInfo values 
(1, 'My first order', 100, sysdatetime(), 'in-progress', 'DM'),
(2, 'Another Other', 200, sysdatetime(), 'in-progress', 'GH')
go

select * from dbo.OrderInfo
go

select *, valid_from, valid_to from dbo.OrderInfo
go

update dbo.OrderInfo set [status] = 'completed'
where id = 1
go

select * from dbo.OrderInfo
go

select *, valid_from, valid_to from dbo.OrderInfo
go

select * from [dbo].[OrderInfoHistory]
go

select *, valid_from, valid_to from dbo.OrderInfo for system_time all order by id, valid_from 
go

begin tran

insert into dbo.OrderInfo values 
(3, 'Another one', 300, sysdatetime(), 'in-progress', 'FC')

delete from dbo.OrderInfo where id = 2

commit tran
go

select *, valid_from, valid_to from dbo.OrderInfo
go

select * from [dbo].[OrderInfoHistory]
go

select *, valid_from, valid_to from dbo.OrderInfo for system_time all order by id, valid_from
go

alter table dbo.OrderInfo set ( system_versioning = off )
go

update [dbo].[OrderInfoHistory] set valid_from = '20100701', received_on = '20100701' where id  in (1, 2) and [status] != 'completed'
go

alter table dbo.OrderInfo set ( system_versioning = on (history_table = [dbo].[OrderInfoHistory], data_consistency_check = on ))
go

select *, valid_from, valid_to from dbo.OrderInfo for system_time all order by id, valid_from
go

select *, valid_from, valid_to from dbo.OrderInfo for system_time as of '2016-07-03 15:00:00'
go
