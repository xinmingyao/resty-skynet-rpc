local ngx_socket_tcp = ngx.socket.tcp
local ngx_req = ngx.req
local ngx_req_socket = ngx_req.socket
local ngx_req_get_headers = ngx_req.get_headers
local ngx_req_get_method = ngx_req.get_method
local str_gmatch = string.gmatch
local str_lower = string.lower
local str_upper = string.upper
local str_find = string.find
local str_sub = string.sub
local tbl_concat = table.concat
local tbl_insert = table.insert
local ngx_encode_args = ngx.encode_args
local ngx_re_match = ngx.re.match
local ngx_re_gsub = ngx.re.gsub
local ngx_re_find = ngx.re.find
local ngx_log = ngx.log
local ngx_DEBUG = ngx.DEBUG
local ngx_ERR = ngx.ERR
local ngx_var = ngx.var
local ngx_print = ngx.print
local co_yield = coroutine.yield
local co_create = coroutine.create
local co_status = coroutine.status
local co_resume = coroutine.resume
local setmetatable = setmetatable
local tonumber = tonumber
local tostring = tostring
local unpack = unpack
local rawget = rawget
local select = select
local ipairs = ipairs
local pairs = pairs
local pcall = pcall
local type = type
local cluster = require "cluster.core"

local _M = {
	_VERSION = '0.10',
}

function _M.new(self)
	local sock, err = ngx_socket_tcp()
	if not sock then
		ngx_log(ngx_ERR,"open socket error!")
		return nil, err
	end
	return setmetatable({ sock = sock,sid=1},{__index=_M})
end

function _M.set_timeout(self, timeout)
	local sock = self.sock
	if not sock then
		return nil, "not initialized"
	end
	return sock:settimeout(timeout)
end


function _M.set_timeouts(self, connect_timeout, send_timeout, read_timeout)
	local sock = self.sock
	if not sock then
		return nil, "not initialized"
	end
	return sock:settimeouts(connect_timeout, send_timeout, read_timeout)
end

function _M.set_keepalive(self, ...)
	local sock =  self.sock
	if not sock then
		return nil, "not initialized"
	end
	return sock:setkeepalive(...)
end

function _M.connect(self, ...)
	local sock = self.sock
	if not sock then
		return nil, "not initialized"
	end
	self.host = select(1, ...)
	self.port = select(2, ...)
	-- If port is not a number, this is likely a unix domain socket connection.
	if type(self.port) ~= "number" then
		self.port = nil
	end
	self.keepalive = true
	return sock:connect(...)
end

function _M.close(self)
	local sock = self.sock
	if not sock then
		return nil, "not initialized"
	end		
	sock:close()
	return true
end

function _M.send_request(self,addr,...)
	local req,sid =  cluster.pack(addr,self.sid,...)
	self.sid = sid
	self.sock:send(req)
	local head,err = self.sock:receive(2)
	if not head then
		ngx_log(ngx_ERR,"socket read error:=====",msg)
		return nil,err
	end
	local sz = cluster.header(head)
	local msg,err = self.sock:receive(sz)
	if not msg then
		ngx_log(ngx_ERR,"socket read error:====",msg)
		return nil,err
	end
	local sid,ok,data,padding = cluster.unpackresponse(msg)	-- session, ok, data, padding --todo fix this version not support padding for big data
	if ok then
		return cluster.unpack(data)
	else
		ngx_log(ngx_ERR,data) 
		return nil,data
	end
end

function _M.call(self, ...)
	return  self:send_request(...)
end

return _M