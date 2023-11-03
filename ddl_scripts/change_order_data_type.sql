begin;

alter table orders
alter column product_ids
type integer[]
using product_ids::integer[];

end;
