-module(bson_tests).

-include_lib("eunit/include/eunit.hrl").

simple_bson_serialization_test() ->
	% Build a simple string key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("name"), bson:utf8("value"), orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<21,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,0>> = BinDoc,
	erlang:display("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"),
	?debugFmt("~p~n", [BinDoc]).
	
	% erlang:display(BinDoc).
