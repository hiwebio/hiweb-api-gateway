

local jwt_secret = 'tungnd14@123'
local jwt = require "resty.jwt"
local cjson = require "cjson"
local validators = require "resty.jwt-validators"--Goi thu vien jwt

if ngx.var.request_method ~= "OPTIONS" and not string.match(ngx.var.uri, "login") and not string.match(ngx.var.uri, "products") then--khong xu ly vs truong hop la login
  local jwtToken = ngx.var.http_Authorization
  if jwtToken == nil then
      ngx.status = ngx.HTTP_UNAUTHORIZED
      ngx.header.content_type = "application/json; charset=utf-8"
      ngx.say("{\"error\": \"Forbidden\"}")
      ngx.exit(ngx.HTTP_UNAUTHORIZED)
  end
  local claim_spec = {
      exp = validators.is_not_expired()--kiem tra expiry
  }
  jwtToken = string.gsub(jwtToken, "Bearer ", "")
  local jwt_obj = jwt:verify(jwt_secret, jwtToken, claim_spec)--Goi xac thuc
  ngx.log(ngx.ALERT , cjson.encode(jwt_obj))

  if not jwt_obj["verified"] then --Neu loi
      ngx.status = ngx.HTTP_UNAUTHORIZED
      ngx.header.content_type = "application/json; charset=utf-8"
      ngx.say("{\"error\": \"INVALID_JWT\"}")
      ngx.exit(ngx.HTTP_UNAUTHORIZED)
  end
end
--Gọi API convert name sang Store_ID 
--Get domain
function store()
    local res = ngx.location.capture('/stores', { 
        method = ngx.HTTP_GET, 
        args = {
        storename = ngx.var.host;
        } 
    });
    ngx.log(ngx.ERR, res.status);
    if res.status == ngx.HTTP_OK then
        ngx.var.store_id = res.body;
        return res.body;
    else
        ngx.exit(403);
    end
end
store()

