use tempdb
go

drop user if exists user1;
drop table if exists dbo.TableWithData
go

create table dbo.TableWithData
(
	id int not null primary key,
	name nvarchar(100) masked with (function = 'partial(1,"XXX",1)') not null,  
	surname nvarchar(100) not NULL,  
	phone varchar(20) masked with (function = 'default()') not null,  
	email varchar(1000) masked with (function = 'email()') not null,
	nickname nvarchar(100) masked with (function = 'default()') null,  
	income money masked with (function = 'default()') not null,
)
go

insert into dbo.TableWithData values
(1, 'John', 'Doe', '3358967123', 'johndoe@acme.com', 'nemo', 100000),
(2, 'Frank', 'Green', '4429678123', 'f.green@dummy.it', null, 50000),
(3, 'Lucy', 'May', '3397856127', 'lucym@mypersonalshop.co.uk', null, 100000)
go

select * from dbo.TableWithData
go

create user user1 without login;
go

grant select on schema::dbo to user1
go

execute as user = 'user1';
go

select * from dbo.TableWithData
go

revert
go

grant unmask to [user1]
go

execute as user = 'user1';
go

select * from dbo.TableWithData
go

revert
go

