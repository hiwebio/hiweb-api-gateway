--Gọi API convert name sang Store_ID 
--Get domain

local res = ngx.location.capture('/stores', { 
  method = ngx.HTTP_GET, 
  args = {
    storename = ngx.var.host;
  } 
});
ngx.log(ngx.ERR, res.status);
if res.status == ngx.HTTP_OK then
  ngx.var.store_id = res.body;
else
  ngx.exit(403);
end
