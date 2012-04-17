-module(bson_tests).

-include_lib("eunit/include/eunit.hrl").

simple_single_level_string_doc_serialization_test() ->
	% Build a simple string key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("name"), bson:utf8("value"), orddict:new()),
	BinDoc = bson:serialize(Doc),	
	<<21,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,0>> = BinDoc.

simple_single_level_float_doc_serialization_test() ->
	% Build a simple float key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("name"), 1.34, orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<19,0,0,0,1,110,97,109,101,0,113,61,10,215,163,112,245,63,0>> = BinDoc.

simple_single_level_32_bit_integer_doc_serialization_test() ->
	% Build a simple integer key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("name"), 1000, orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<15,0,0,0,16,110,97,109,101,0,232,3,0,0,0>> = BinDoc.

simple_single_level_64_bit_integer_doc_serialization_test() ->
	% Build a simple integer key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("name"), 16#7000000000000000, orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<19,0,0,0,18,110,97,109,101,0,0,0,0,0,0,0,0,112,0>> = BinDoc.
	
simple_two_level_document_with_values_test() ->
	% Build a simple integer key-value doc and serialize the doc
	InnerDoc = orddict:append(bson:utf8("integer"), 16#7000000000000000, orddict:new()),
	Doc = orddict:append(bson:utf8("name"), InnerDoc, orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<33,0,0,0,3,110,97,109,101,0,22,0,0,0,18,105,110,116,101,103,101,114,0,0,0,0,0,0,0,0,112,0,0>> = BinDoc.

simple_document_with_array_of_integers_test() ->
	% Build a simple integer key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("integers"), [1,2,3,4], orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<48,0,0,0,4,105,110,116,101,103,101,114,115,0,33,0,0,0,16,48,0,1,0,0,0,16,49,0,2,0,0,0,16,50,0,3,0,0,0,16,51,0,4,0,0,0,0,0>> = BinDoc,
	erlang:display("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"),
	?debugFmt("~p~n", [BinDoc]).
	