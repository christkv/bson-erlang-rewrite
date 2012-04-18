-module(bson_tests).

-include_lib("eunit/include/eunit.hrl").

simple_single_level_string_doc_serialization_test() ->
	% Build a simple string key-value dict and serialize the doc
	Doc = orddict:append(bson:utf8("name"), bson:utf8("value"), orddict:new()),
	BinDoc = bson:serialize(Doc),	
	<<21,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,0>> = BinDoc,
	% Build a simple string key-value proplist and serialize the doc
	DocProp = [{bson:utf8("name"), bson:utf8("value")}],
	BinDocProp = bson:serialize(DocProp),
	<<21,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,0>> = BinDocProp,
	% Build a simple string key-value dict and serialize the doc
	DocDict = dict:append(bson:utf8("name"), bson:utf8("value"), dict:new()),
	BinDocDict = bson:serialize(DocDict),
	<<21,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,0>> = BinDocDict.

simple_single_level_float_doc_serialization_test() ->
	% Build a simple float key-value dict and serialize the doc
	Doc = orddict:append(bson:utf8("name"), 1.34, orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<19,0,0,0,1,110,97,109,101,0,113,61,10,215,163,112,245,63,0>> = BinDoc,
	% Build a simple float key-value proplist and serialize the doc
	DocProp = [{bson:utf8("name"), 1.34}],
	BinDocProp = bson:serialize(DocProp),	
	<<19,0,0,0,1,110,97,109,101,0,113,61,10,215,163,112,245,63,0>> = BinDocProp,
	% Build a simple float key-value dict and serialize the doc
	DocDict = dict:append(bson:utf8("name"), 1.34, dict:new()),
	BinDocDict = bson:serialize(DocDict),
	<<19,0,0,0,1,110,97,109,101,0,113,61,10,215,163,112,245,63,0>> = BinDocDict.

simple_single_level_32_bit_integer_doc_serialization_test() ->
	% Build a simple integer key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("name"), 1000, orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<15,0,0,0,16,110,97,109,101,0,232,3,0,0,0>> = BinDoc,
	% Build a simple integer key-value proplist and serialize the doc
	DocProp = [{bson:utf8("name"), 1000}],
	BinDocProp = bson:serialize(DocProp),	
	<<15,0,0,0,16,110,97,109,101,0,232,3,0,0,0>> = BinDocProp,
	% Build a simple integer key-value dict and serialize the doc
	DocDict = dict:append(bson:utf8("name"), 1000, dict:new()),
	BinDocDict = bson:serialize(DocDict),
	<<15,0,0,0,16,110,97,109,101,0,232,3,0,0,0>> = BinDocDict.

simple_single_level_64_bit_integer_doc_serialization_test() ->
	% Build a simple integer key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("name"), 16#7000000000000000, orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<19,0,0,0,18,110,97,109,101,0,0,0,0,0,0,0,0,112,0>> = BinDoc,
	% Build a simple integer key-value proplist and serialize the doc
	DocProp = [{bson:utf8("name"), 16#7000000000000000}],
	BinDocProp = bson:serialize(DocProp),	
	<<19,0,0,0,18,110,97,109,101,0,0,0,0,0,0,0,0,112,0>> = BinDocProp,
	% Build a simple integer key-value dict and serialize the doc
	DocDict = dict:append(bson:utf8("name"), 16#7000000000000000, dict:new()),
	BinDocDict = bson:serialize(DocDict),
	<<19,0,0,0,18,110,97,109,101,0,0,0,0,0,0,0,0,112,0>> = BinDocDict.
	
simple_two_level_document_with_values_test() ->
	% Build a simple integer key-value doc and serialize the doc
	InnerDoc = orddict:append(bson:utf8("integer"), 16#7000000000000000, orddict:new()),
	Doc = orddict:append(bson:utf8("name"), InnerDoc, orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<33,0,0,0,3,110,97,109,101,0,22,0,0,0,18,105,110,116,101,103,101,114,0,0,0,0,0,0,0,0,112,0,0>> = BinDoc,
	% Build a simple integer key-value proplist and serialize the doc
	DocProp = [{bson:utf8("name"), {bson:utf8("integer"), 16#7000000000000000}}],
	BinDocProp = bson:serialize(DocProp),	
	<<33,0,0,0,3,110,97,109,101,0,22,0,0,0,18,105,110,116,101,103,101,114,0,0,0,0,0,0,0,0,112,0,0>> = BinDocProp,
	% Build a simple integer key-value dict and serialize the doc
	DocDict = dict:append(bson:utf8("name"), dict:append(bson:utf8("integer"), 16#7000000000000000, dict:new()), dict:new()),
	BinDocDict = bson:serialize(DocDict),
	<<33,0,0,0,3,110,97,109,101,0,22,0,0,0,18,105,110,116,101,103,101,114,0,0,0,0,0,0,0,0,112,0,0>> = BinDocDict.

simple_document_with_array_of_integers_test() ->
	% Build a simple integer key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("integers"), [1,2,3,4], orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<48,0,0,0,4,105,110,116,101,103,101,114,115,0,33,0,0,0,16,48,0,1,0,0,0,16,49,0,2,0,0,0,16,50,0,3,0,0,0,16,51,0,4,0,0,0,0,0>> = BinDoc,
	% Build a simple integer key-value proplist and serialize the doc
	DocProp = [{bson:utf8("integers"), [1,2,3,4]}],
	BinDocProp = bson:serialize(DocProp),	
	<<48,0,0,0,4,105,110,116,101,103,101,114,115,0,33,0,0,0,16,48,0,1,0,0,0,16,49,0,2,0,0,0,16,50,0,3,0,0,0,16,51,0,4,0,0,0,0,0>> = BinDocProp,
	% Build a simple integer key-value dict and serialize the doc
	DocDict = dict:append(bson:utf8("integers"), [1,2,3,4], dict:new()),
	BinDocDict = bson:serialize(DocDict),
	<<48,0,0,0,4,105,110,116,101,103,101,114,115,0,33,0,0,0,16,48,0,1,0,0,0,16,49,0,2,0,0,0,16,50,0,3,0,0,0,16,51,0,4,0,0,0,0,0>> = BinDocDict.
	
simple_document_with_regexp_test() ->
	% Build a simple regexp key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("regexp"), bson:regexp("test", "s"), orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<20,0,0,0,11,114,101,103,101,120,112,0,116,101,115,116,0,115,0,0>> = BinDoc,
	% Build a simple regexp key-value proplist and serialize the doc
	DocProp = [{bson:utf8("regexp"), bson:regexp("test", "s")}],
	BinDocProp = bson:serialize(DocProp),
	<<20,0,0,0,11,114,101,103,101,120,112,0,116,101,115,116,0,115,0,0>> = BinDocProp,
	% Build a simple regexp key-value dict and serialize the doc
	DocDict = dict:append(bson:utf8("regexp"), bson:regexp("test", "s"), dict:new()),
	BinDocDict = bson:serialize(DocDict),
	<<20,0,0,0,11,114,101,103,101,120,112,0,116,101,115,116,0,115,0,0>> = BinDocDict.
	% erlang:display("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"),
	% ?debugFmt("~p~n", [BinDoc]),
	% erlang:display("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"),
	% ?debugFmt("~p~n", [BinDocProp]),
	% erlang:display("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"),
	% ?debugFmt("~p~n", [BinDocDict]).

simple_document_with_objectid_test() ->
	% Generate ObjectId from hex string
	ObjectId = bson:objectid("4f8d7e1f95f13b4370000000"),
	% Build a simple integer key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("objectid"), ObjectId, orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<27,0,0,0,7,111,98,106,101,99,116,105,100,0,79,141,126,31,149,241,59,67,112,0,0,0,0>> = BinDoc,
	% Build a simple objectid key-value proplist and serialize the doc
	DocProp = [{bson:utf8("objectid"), ObjectId}],
	BinDocProp = bson:serialize(DocProp),
	<<27,0,0,0,7,111,98,106,101,99,116,105,100,0,79,141,126,31,149,241,59,67,112,0,0,0,0>> = BinDocProp,
	% Build a simple objectid key-value dict and serialize the doc
	DocDict = dict:append(bson:utf8("objectid"), ObjectId, dict:new()),
	BinDocDict = bson:serialize(DocDict),
	<<27,0,0,0,7,111,98,106,101,99,116,105,100,0,79,141,126,31,149,241,59,67,112,0,0,0,0>> = BinDocDict.

simple_document_with_boolean_test() ->
	% Build a simple integer key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("bool"), true, orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<12,0,0,0,8,98,111,111,108,0,1,0>> = BinDoc,
	Doc2 = orddict:append(bson:utf8("bool"), false, orddict:new()),
	BinDoc2 = bson:serialize(Doc2),
	<<12,0,0,0,8,98,111,111,108,0,0,0>> = BinDoc2,
	% Build a simple boolean key-value proplist and serialize the doc
	DocProp = [{bson:utf8("bool"), true}],
	BinDocProp = bson:serialize(DocProp),
	<<12,0,0,0,8,98,111,111,108,0,1,0>> = BinDocProp,
	DocProp2 = [{bson:utf8("bool"), false}],
	BinDocProp2 = bson:serialize(DocProp2),
	<<12,0,0,0,8,98,111,111,108,0,0,0>> = BinDocProp2,
	% Build a simple boolean key-value dict and serialize the doc
	DocDict = dict:append(bson:utf8("bool"), true, dict:new()),
	BinDocDict = bson:serialize(DocDict),
	<<12,0,0,0,8,98,111,111,108,0,1,0>> = BinDocDict,
	DocDict2 = dict:append(bson:utf8("bool"), false, dict:new()),
	BinDocDict2 = bson:serialize(DocDict2),
	<<12,0,0,0,8,98,111,111,108,0,0,0>> = BinDocDict2.

simple_document_with_null_or_undefined_test() ->
	% Build a simple null/undefined key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("bool"), undefined, orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<11,0,0,0,10,98,111,111,108,0,0>> = BinDoc,
	Doc2 = orddict:append(bson:utf8("bool"), null, orddict:new()),
	BinDoc2 = bson:serialize(Doc2),
	<<11,0,0,0,10,98,111,111,108,0,0>> = BinDoc2,
	% Build a simple null/undefined key-value proplist and serialize the doc
	DocProp = [{bson:utf8("bool"), undefined}],
	BinDocProp = bson:serialize(DocProp),
	<<11,0,0,0,10,98,111,111,108,0,0>> = BinDocProp,
	DocProp2 = [{bson:utf8("bool"), null}],
	BinDocProp2 = bson:serialize(DocProp2),
	<<11,0,0,0,10,98,111,111,108,0,0>> = BinDocProp2,
	% Build a simple null/undefined key-value dict and serialize the doc
	DocDict = dict:append(bson:utf8("bool"), null, dict:new()),
	BinDocDict = bson:serialize(DocDict),
	<<11,0,0,0,10,98,111,111,108,0,0>> = BinDocDict,
	DocDict2 = dict:append(bson:utf8("bool"), undefined, dict:new()),
	BinDocDict2 = bson:serialize(DocDict2),
	<<11,0,0,0,10,98,111,111,108,0,0>> = BinDocDict2.

simple_document_with_datetime_test() ->
	% Build a simple datetime key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("date"), bson:bsom_time_to_timestamp(1334686404073), orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<19,0,0,0,9,100,97,116,101,0,233,77,130,193,54,1,0,0,0>> = BinDoc,
	% Build a simple datetime key-value proplist and serialize the doc
	DocProp = [{bson:utf8("date"), bson:bsom_time_to_timestamp(1334686404073)}],
	BinDocProp = bson:serialize(DocProp),
	<<19,0,0,0,9,100,97,116,101,0,233,77,130,193,54,1,0,0,0>> = BinDocProp,
	% Build a simple datetime key-value dict and serialize the doc
	DocDict = dict:append(bson:utf8("date"), bson:bsom_time_to_timestamp(1334686404073), dict:new()),
	BinDocDict = bson:serialize(DocDict),
	<<19,0,0,0,9,100,97,116,101,0,233,77,130,193,54,1,0,0,0>> = BinDocDict.

simple_document_with_symbol_test() ->
	% Build a simple symbol key-value doc and serialize the doc
	Doc = orddict:append(bson:utf8("symbol"), atom, orddict:new()),
	BinDoc = bson:serialize(Doc),
	<<22,0,0,0,14,115,121,109,98,111,108,0,5,0,0,0,97,116,111,109,0,0>> = BinDoc,
	% Build a simple symbol key-value proplist and serialize the doc
	DocProp = [{bson:utf8("symbol"), atom}],
	BinDocProp = bson:serialize(DocProp),
	<<22,0,0,0,14,115,121,109,98,111,108,0,5,0,0,0,97,116,111,109,0,0>> = BinDocProp,
	% Build a simple symbol key-value dict and serialize the doc
	DocDict = dict:append(bson:utf8("symbol"), atom, dict:new()),
	BinDocDict = bson:serialize(DocDict),
	<<22,0,0,0,14,115,121,109,98,111,108,0,5,0,0,0,97,116,111,109,0,0>> = BinDocDict.
	



















	