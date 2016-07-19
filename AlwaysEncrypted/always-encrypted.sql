use tempdb
go

create column master key [cmkMain]
with
(
	key_store_provider_name = N'MSSQL_CERTIFICATE_STORE',
	key_path = N'CurrentUser/My/4D43015C9863CFB09521F3D91BE86C381DCD1130'
)
go

create column encryption key [cekMain]
with values
(
	column_master_key = [cmkMain],
	algorithm = 'RSA_OAEP',
	encrypted_value = 0x016e000001630075007200720065006e00740075007300650072002f006d0079002f0034006400340033003000310035006300390038003600330063006600620030003900350032003100660033006400390031006200650038003600630033003800310064006300640031003100330030007d5d429acd93b51265dbef254bd1f2252e30f14633eb3d2d7d5d81b5e4f236fb7f4142e738d04340ed6fc235a8e1000ec87ec7648c90b49562c6b1fcede7fe1e451f41b065b9c8c6ff0439f2fb54e97fe2734c3b020fba3ed6919cfd52c1d1de7717c71f93a967f96eb21b50989752ad5f15093344025909c768665f842130a23eadd0f17c5ea79b41f2bb67cb6cb3889fa2ef3a37f3cf1c7c8387b465ae018df24a74652482e36dcf4e316142dbc9e9f53f087c1c55528ef02bbe56894390cc973a4304eda99f58066da5f3370d2c3764a9cfeb174f6f73a96b44171f7b7589c768c0326aa7404b8e3d3e4892590535aba3ac1fbe7790aff6511383e6b87ba137b1bdf99a4cf5acecc28b9636e9e90ead9c2fbdb624261abee860cbc9f87d1e0b378805e9d9ca41a818701b325db8ab617c3eff292ae89a0b7e996eab4517f6fa419a339316054fe2898816f1f89951f97170842eddc878a629f7621cc1024f2365ece1424dae54cfb01258d6b21cd4712c55a945fbfa2ed59024310f84c1c4c5e31b4129345ba8f3ff500e8bef676bc9b9ff5b519bfe7b36f5be5992af9684fe3c33f80039297fedf11b7d8cd6f0352ff07ab57162a8862d96d205705394e63bb7d471a203bb75a24b9d4a23aebe8bcbc0772994dc40aa22326a8b53eb992822d13fdd7b3336f2d96bbad67c46c722414d22bbfbad823ebc412805d32f8cdf
)
go

drop table if exists dbo.Customers 
go

create table dbo.Customers 
(  
	id int not null identity primary key,
	first_name nvarchar(100) not null,
	last_name nvarchar(100) not null,
	ssn nvarchar(100) collate Latin1_General_BIN2  encrypted with (
			column_encryption_key = cekMain,  
			encryption_type = deterministic ,  
			algorithm = 'AEAD_AES_256_CBC_HMAC_SHA_256'
		) not null,
    birth_date datetime2 encrypted with (
			column_encryption_key = cekMain,  
			encryption_type = randomized ,  
			algorithm = 'AEAD_AES_256_CBC_HMAC_SHA_256'
		) not null
);  
go

select * from dbo.Customers
go

--truncate table dbo.Customers
--go
