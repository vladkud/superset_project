begin;

update orders
set product_ids  = translate(product_ids, '][ ', '}{');

end;
