Name
====

resty-skynet-rpc - Lua skynet rpc driver for the ngx_lua based on the cosocket API

Table of Contents
=================

* [Name](#name)
* [Status](#status)
* [Description](#description)
* [Synopsis](#synopsis)
* [Methods](#methods)
    * [new](#new)
    * [connect](#connect)
    * [set_timeout](#set_timeout)
    * [set_keepalive](#set_keepalive)
    * [close](#close)
    * [call](#call)
* [Check List for Issues](#check-list-for-issues)
* [Limitations](#limitations)
* [Installation](#installation)
* [TODO](#todo)
* [Community](#community)
    * [English Mailing List](#english-mailing-list)
    * [Chinese Mailing List](#chinese-mailing-list)
* [Bugs and Patches](#bugs-and-patches)
* [Author](#author)
* [Copyright and License](#copyright-and-license)
* [See Also](#see-also)

Status
======

This library is on dev.

Description
===========

This Lua library is a skynet rpc  driver for the ngx_lua nginx module:

https://github.com/openresty/lua-nginx-module/#readme

This Lua library takes advantage of ngx_lua's cosocket API, which ensures
100% nonblocking behavior.

Note that at least [ngx_lua 0.5.14](https://github.com/chaoslawful/lua-nginx-module/tags) or [OpenResty 1.2.1.14](http://openresty.org/#Download) is required.

Synopsis
========

```lua
    # you do not need the following line if you are using
    # the OpenResty bundle:
    lua_package_path "/path/to/lua-resty-redis/lib/?.lua;;";
    server {				 
        location /test {
            content_by_lua_block {
						local rpc = require "resty.skynet_rpc"
            local r= rpc.new()	
						r:set_timeout(1000)
						r:connect("127.0.0.1",2528)
						local v = r:call("SIMPLEDB","GET","a")
      			ngx.say(v)
						r:set_keepalive(5000)

          }
     }
```

[Back to TOC](#table-of-contents)

Methods
=======
[Back to TOC](#table-of-contents)

new
---
`syntax: r, err = rpc:new()`

Creates a rpc object. In case of failures, returns `nil` and a string describing the error.

[Back to TOC](#table-of-contents)

connect
-------
`syntax: ok, err = r:connect(host, port, options_table?)`

Attempts to connect to the remote host and port that the skynet server is listened by the skynet server .

Before actually resolving the host name and connecting to the remote backend, this method will always look up the connection pool for matched idle connections created by previous calls of this method.

[Back to TOC](#table-of-contents)

set_timeout
----------
`syntax: r:set_timeout(time)`

Sets the timeout (in ms) protection for subsequent operations, including the `connect` method.

[Back to TOC](#table-of-contents)

set_keepalive
------------
`syntax: ok, err = r:set_keepalive(max_idle_timeout, pool_size)`

Puts the current connection immediately into the ngx_lua cosocket connection pool.

You can specify the max idle timeout (in ms) when the connection is in the pool and the maximal size of the pool every nginx worker process.

In case of success, returns `1`. In case of errors, returns `nil` with a string describing the error.

Only call this method in the place you would have called the `close` method instead. Calling this method will immediately turn the current redis object into the `closed` state. Any subsequent operations other than `connect()` on the current object will return the `closed` error.

[Back to TOC](#table-of-contents)

close
-----
`syntax: ok, err = rpc:close()`

Closes the current rpc connection and returns the status.

In case of success, returns `1`. In case of errors, returns `nil` with a string describing the error.

[Back to TOC](#table-of-contents)

call
-------------
`syntax: r:call(service_name,method,...)`
 service_name:skynet service name
 method:skynet service  method fro rpc
 ...:paras for the skynet service method,cannot be point and function,it cannot be serialize
 
[Back to TOC](#table-of-contents)


[Back to TOC](#table-of-contents)

Installation
============
1.install skynet first: https://github.com/cloudwu/skynet
2.configue skynet cluster:https://github.com/cloudwu/skynet/wiki/Cluster
3.cd lualib-src && make cluster.so
4.copy resty/skynet_rpc.lua and cluster.so to openresty lib

[Back to TOC](#table-of-contents)

TODO
====

[Back to TOC](#table-of-contents)

Community
=========

[Back to TOC](#table-of-contents)

English Mailing List
--------------------
[Back to TOC](#table-of-contents)

Chinese Mailing List
--------------------
[Back to TOC](#table-of-contents)

Bugs and Patches
================

[Back to TOC](#table-of-contents)

Author
======

yaoxinming

[Back to TOC](#table-of-contents)

Copyright and License
=====================

This module is licensed under the BSD license.

Copyright (C) 2012-2016, by Yichun Zhang (agentzh) <agentzh@gmail.com>, CloudFlare Inc.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[Back to TOC](#table-of-contents)

See Also
========
* the ngx_lua module: https://github.com/openresty/lua-nginx-module/#readme
* the [lua-resty-mysql](https://github.com/agentzh/lua-resty-mysql) library

[Back to TOC](#table-of-contents)