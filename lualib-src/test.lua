local cluster = require "cluster.core"
local msg,session ,tt = cluster.pack("abc3",1,string.rep("1",5),{},{},"aaa","bbb",1,2,3,{})
local name ,s1,data = cluster.unpackrequest(string.sub(msg,3))
print(name,s1)
print(cluster.unpack(data))

