begin;

alter table orders
alter column creation_time
type timestamp(0)
using to_timestamp(creation_time, 'DD-MM-YY HH24:MI')::timestamp(0)

end;
