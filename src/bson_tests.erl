-module(bson_tests).

-include_lib("eunit/include/eunit.hrl").

simple_bson_serialization_test() ->
	% Build a simple string key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("name"), bson:utf8("value"), orddict:new()),
	BinDoc = bson:serialize(Doc),	
	erlang:display(BinDoc).
