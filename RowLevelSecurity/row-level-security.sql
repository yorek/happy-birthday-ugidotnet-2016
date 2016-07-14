use tempdb
go

drop user if exists user1;
drop user if exists user2;
drop function if exists dbo.FilterByUserName
drop security policy if exists dbo.UserNameSecurityPolicy
drop table if exists dbo.TableWithSecrets
go

create table dbo.TableWithSecrets
(
	id int not null primary key,
	secret_value varchar(100) not null,
	authorized_user sysname not null
)
go

insert into dbo.TableWithSecrets values
(1, 'User 1 Secret Value', 'user1'),
(2, 'User 2 Secret Value', 'user2')
go

select * from dbo.TableWithSecrets
go

create function dbo.FilterByUserName(@userName sysname)
	returns table
	with schemabinding
as
	return select 1 as accessresult
	where @username = user_name()
go

create security policy dbo.UserNameSecurityPolicy
	add filter predicate dbo.FilterByUserName(authorized_user) on dbo.TableWithSecrets,
	add block predicate dbo.FilterByUserName(authorized_user) on dbo.TableWithSecrets
go

select * from dbo.TableWithSecrets
go

create user user1 without login;
create user user2 without login;
go

grant select on schema::dbo to user1
grant select on schema::dbo to user2
go

execute as user = 'user1';
go

select user_name()
go

select * from dbo.TableWithSecrets
go

revert
go

execute as user = 'user2';
go

select user_name()
go

select * from dbo.TableWithSecrets
go

revert
go

alter security policy dbo.UserNameSecurityPolicy
with (state = off)
go

select * from dbo.TableWithSecrets
go
