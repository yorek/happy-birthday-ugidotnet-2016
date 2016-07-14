

declare @dummy nvarchar(1000) = 'this is just something to split';
select * from string_split(@dummy, ' ')

select id, string_agg(letter, ',') from (values(1, 'a'), (1, 'b'), (2, 'c')) v(id, letter) group id
