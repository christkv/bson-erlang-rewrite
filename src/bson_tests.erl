-module(bson_tests).

-include_lib("eunit/include/eunit.hrl").

%%
%%	Serialization tests
%%

% simple_single_level_two_attribute_serialization_test() ->
% 	% Build a simple string key-value dict and serialize the doc
% 	Doc = orddict:append(bson:utf8("b"), 2, orddict:append(bson:utf8("name"), bson:utf8("value"), orddict:new())),
% 	BinDoc = bson:serialize(Doc),	
% 	erlang:display(binary_to_list(BinDoc)),	
% 	<<28,0,0,0,16,98,0,2,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,0>> = BinDoc,
% 	% Build a simple string key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("name"), bson:utf8("value")}, {bson:utf8("b"), 2}],
% 	BinDocProp = bson:serialize(DocProp),
% 	erlang:display(binary_to_list(BinDocProp)),
% 	<<28,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,16,98,0,2,0,0,0,0>> = BinDocProp,
% 	% Build a simple string key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("b"), 2, dict:append(bson:utf8("name"), bson:utf8("value"), dict:new())),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<28,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,16,98,0,2,0,0,0,0>> = BinDocDict.
% 
% simple_single_level_float_doc_serialization_test() ->
% 	% Build a simple float key-value dict and serialize the doc
% 	Doc = orddict:append(bson:utf8("name"), 1.34, orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<19,0,0,0,1,110,97,109,101,0,113,61,10,215,163,112,245,63,0>> = BinDoc,
% 	% Build a simple float key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("name"), 1.34}],
% 	BinDocProp = bson:serialize(DocProp),	
% 	<<19,0,0,0,1,110,97,109,101,0,113,61,10,215,163,112,245,63,0>> = BinDocProp,
% 	% Build a simple float key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("name"), 1.34, dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<19,0,0,0,1,110,97,109,101,0,113,61,10,215,163,112,245,63,0>> = BinDocDict.
% 
% simple_single_level_32_bit_integer_doc_serialization_test() ->
% 	% Build a simple integer key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("name"), 1000, orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<15,0,0,0,16,110,97,109,101,0,232,3,0,0,0>> = BinDoc,
% 	% Build a simple integer key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("name"), 1000}],
% 	BinDocProp = bson:serialize(DocProp),	
% 	<<15,0,0,0,16,110,97,109,101,0,232,3,0,0,0>> = BinDocProp,
% 	% Build a simple integer key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("name"), 1000, dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<15,0,0,0,16,110,97,109,101,0,232,3,0,0,0>> = BinDocDict.
% 
% simple_single_level_64_bit_integer_doc_serialization_test() ->
% 	% Build a simple integer key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("name"), 16#7000000000000000, orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<19,0,0,0,18,110,97,109,101,0,0,0,0,0,0,0,0,112,0>> = BinDoc,
% 	% Build a simple integer key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("name"), 16#7000000000000000}],
% 	BinDocProp = bson:serialize(DocProp),	
% 	<<19,0,0,0,18,110,97,109,101,0,0,0,0,0,0,0,0,112,0>> = BinDocProp,
% 	% Build a simple integer key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("name"), 16#7000000000000000, dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<19,0,0,0,18,110,97,109,101,0,0,0,0,0,0,0,0,112,0>> = BinDocDict.
% 	
% simple_two_level_document_with_values_test() ->
% 	% Build a simple integer key-value doc and serialize the doc
% 	InnerDoc = orddict:append(bson:utf8("integer"), 16#7000000000000000, orddict:new()),
% 	Doc = orddict:append(bson:utf8("name"), InnerDoc, orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<33,0,0,0,3,110,97,109,101,0,22,0,0,0,18,105,110,116,101,103,101,114,0,0,0,0,0,0,0,0,112,0,0>> = BinDoc,
% 	% Build a simple integer key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("name"), {bson:utf8("integer"), 16#7000000000000000}}],
% 	BinDocProp = bson:serialize(DocProp),	
% 	<<33,0,0,0,3,110,97,109,101,0,22,0,0,0,18,105,110,116,101,103,101,114,0,0,0,0,0,0,0,0,112,0,0>> = BinDocProp,
% 	% Build a simple integer key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("name"), dict:append(bson:utf8("integer"), 16#7000000000000000, dict:new()), dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<33,0,0,0,3,110,97,109,101,0,22,0,0,0,18,105,110,116,101,103,101,114,0,0,0,0,0,0,0,0,112,0,0>> = BinDocDict.
% 
% simple_document_with_array_of_integers_test() ->
% 	% Build a simple integer key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("integers"), [1,2,3,4], orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<48,0,0,0,4,105,110,116,101,103,101,114,115,0,33,0,0,0,16,48,0,1,0,0,0,16,49,0,2,0,0,0,16,50,0,3,0,0,0,16,51,0,4,0,0,0,0,0>> = BinDoc,
% 	% Build a simple integer key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("integers"), [1,2,3,4]}],
% 	BinDocProp = bson:serialize(DocProp),	
% 	<<48,0,0,0,4,105,110,116,101,103,101,114,115,0,33,0,0,0,16,48,0,1,0,0,0,16,49,0,2,0,0,0,16,50,0,3,0,0,0,16,51,0,4,0,0,0,0,0>> = BinDocProp,
% 	% Build a simple integer key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("integers"), [1,2,3,4], dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<48,0,0,0,4,105,110,116,101,103,101,114,115,0,33,0,0,0,16,48,0,1,0,0,0,16,49,0,2,0,0,0,16,50,0,3,0,0,0,16,51,0,4,0,0,0,0,0>> = BinDocDict.
% 	
% simple_document_with_regexp_test() ->
% 	% Build a simple regexp key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("regexp"), bson:regexp("test", "s"), orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<20,0,0,0,11,114,101,103,101,120,112,0,116,101,115,116,0,115,0,0>> = BinDoc,
% 	% Build a simple regexp key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("regexp"), bson:regexp("test", "s")}],
% 	BinDocProp = bson:serialize(DocProp),
% 	<<20,0,0,0,11,114,101,103,101,120,112,0,116,101,115,116,0,115,0,0>> = BinDocProp,
% 	% Build a simple regexp key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("regexp"), bson:regexp("test", "s"), dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<20,0,0,0,11,114,101,103,101,120,112,0,116,101,115,116,0,115,0,0>> = BinDocDict.
% 
% simple_document_with_objectid_test() ->
% 	% Generate ObjectId from hex string
% 	ObjectId = bson:objectid("4f8d7e1f95f13b4370000000"),
% 	% Build a simple integer key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("objectid"), ObjectId, orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<27,0,0,0,7,111,98,106,101,99,116,105,100,0,79,141,126,31,149,241,59,67,112,0,0,0,0>> = BinDoc,
% 	% Build a simple objectid key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("objectid"), ObjectId}],
% 	BinDocProp = bson:serialize(DocProp),
% 	<<27,0,0,0,7,111,98,106,101,99,116,105,100,0,79,141,126,31,149,241,59,67,112,0,0,0,0>> = BinDocProp,
% 	% Build a simple objectid key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("objectid"), ObjectId, dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<27,0,0,0,7,111,98,106,101,99,116,105,100,0,79,141,126,31,149,241,59,67,112,0,0,0,0>> = BinDocDict.
% 
% simple_document_with_boolean_test() ->
% 	% Build a simple integer key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("bool"), true, orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<12,0,0,0,8,98,111,111,108,0,1,0>> = BinDoc,
% 	Doc2 = orddict:append(bson:utf8("bool"), false, orddict:new()),
% 	BinDoc2 = bson:serialize(Doc2),
% 	<<12,0,0,0,8,98,111,111,108,0,0,0>> = BinDoc2,
% 	% Build a simple boolean key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("bool"), true}],
% 	BinDocProp = bson:serialize(DocProp),
% 	<<12,0,0,0,8,98,111,111,108,0,1,0>> = BinDocProp,
% 	DocProp2 = [{bson:utf8("bool"), false}],
% 	BinDocProp2 = bson:serialize(DocProp2),
% 	<<12,0,0,0,8,98,111,111,108,0,0,0>> = BinDocProp2,
% 	% Build a simple boolean key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("bool"), true, dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<12,0,0,0,8,98,111,111,108,0,1,0>> = BinDocDict,
% 	DocDict2 = dict:append(bson:utf8("bool"), false, dict:new()),
% 	BinDocDict2 = bson:serialize(DocDict2),
% 	<<12,0,0,0,8,98,111,111,108,0,0,0>> = BinDocDict2.
% 
% simple_document_with_null_or_undefined_test() ->
% 	% Build a simple null/undefined key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("bool"), undefined, orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<11,0,0,0,10,98,111,111,108,0,0>> = BinDoc,
% 	Doc2 = orddict:append(bson:utf8("bool"), null, orddict:new()),
% 	BinDoc2 = bson:serialize(Doc2),
% 	<<11,0,0,0,10,98,111,111,108,0,0>> = BinDoc2,
% 	% Build a simple null/undefined key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("bool"), undefined}],
% 	BinDocProp = bson:serialize(DocProp),
% 	<<11,0,0,0,10,98,111,111,108,0,0>> = BinDocProp,
% 	DocProp2 = [{bson:utf8("bool"), null}],
% 	BinDocProp2 = bson:serialize(DocProp2),
% 	<<11,0,0,0,10,98,111,111,108,0,0>> = BinDocProp2,
% 	% Build a simple null/undefined key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("bool"), null, dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<11,0,0,0,10,98,111,111,108,0,0>> = BinDocDict,
% 	DocDict2 = dict:append(bson:utf8("bool"), undefined, dict:new()),
% 	BinDocDict2 = bson:serialize(DocDict2),
% 	<<11,0,0,0,10,98,111,111,108,0,0>> = BinDocDict2.
% 
% simple_document_with_datetime_test() ->
% 	% Build a simple datetime key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("date"), bson:bsom_time_to_timestamp(1334686404073), orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<19,0,0,0,9,100,97,116,101,0,233,77,130,193,54,1,0,0,0>> = BinDoc,
% 	% Build a simple datetime key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("date"), bson:bsom_time_to_timestamp(1334686404073)}],
% 	BinDocProp = bson:serialize(DocProp),
% 	<<19,0,0,0,9,100,97,116,101,0,233,77,130,193,54,1,0,0,0>> = BinDocProp,
% 	% Build a simple datetime key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("date"), bson:bsom_time_to_timestamp(1334686404073), dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<19,0,0,0,9,100,97,116,101,0,233,77,130,193,54,1,0,0,0>> = BinDocDict.
% 
% simple_document_with_symbol_test() ->
% 	% Build a simple symbol key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("symbol"), atom, orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<22,0,0,0,14,115,121,109,98,111,108,0,5,0,0,0,97,116,111,109,0,0>> = BinDoc,
% 	% Build a simple symbol key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("symbol"), atom}],
% 	BinDocProp = bson:serialize(DocProp),
% 	<<22,0,0,0,14,115,121,109,98,111,108,0,5,0,0,0,97,116,111,109,0,0>> = BinDocProp,
% 	% Build a simple symbol key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("symbol"), atom, dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<22,0,0,0,14,115,121,109,98,111,108,0,5,0,0,0,97,116,111,109,0,0>> = BinDocDict.
% 
% simple_document_with_minkey_test() ->
% 	% Build a simple symbol key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("key"), bson:minkey(), orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<10,0,0,0,255,107,101,121,0,0>> = BinDoc,
% 	% Build a simple symbol key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("key"), bson:minkey()}],
% 	BinDocProp = bson:serialize(DocProp),
% 	<<10,0,0,0,255,107,101,121,0,0>> = BinDocProp,
% 	% Build a simple symbol key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("key"), bson:minkey(), dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<10,0,0,0,255,107,101,121,0,0>> = BinDocDict.
% 
% simple_document_with_maxkey_test() ->
% 	% Build a simple symbol key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("key"), bson:maxkey(), orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<10,0,0,0,127,107,101,121,0,0>> = BinDoc,
% 	% Build a simple symbol key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("key"), bson:maxkey()}],
% 	BinDocProp = bson:serialize(DocProp),
% 	<<10,0,0,0,127,107,101,121,0,0>> = BinDocProp,
% 	% Build a simple symbol key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("key"), bson:maxkey(), dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<10,0,0,0,127,107,101,121,0,0>> = BinDocDict.
% 
% simple_document_with_javascript_test() ->
% 	% Build a simple symbol key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("code"), bson:javascript(bson:utf8("function(){}")), orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<28,0,0,0,13,99,111,100,101,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,0>> = BinDoc,
% 	% Build a simple symbol key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("code"), bson:javascript(bson:utf8("function(){}"))}],
% 	BinDocProp = bson:serialize(DocProp),
% 	<<28,0,0,0,13,99,111,100,101,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,0>> = BinDocProp,
% 	% Build a simple symbol key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("code"), bson:javascript(bson:utf8("function(){}")), dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<28,0,0,0,13,99,111,100,101,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,0>> = BinDocDict.
% 
% simple_document_with_javascript_code_test() ->
% 	% Build a simple symbol key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("code"), bson:javascript(bson:utf8("function(){}"), orddict:append(bson:utf8("v"), 1, orddict:new())), orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<44,0,0,0,15,99,111,100,101,0,33,0,0,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,12,0,0,0,16,118,0,1,0,0,0,0,0>> = BinDoc,
% 	% Build a simple symbol key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("code"), bson:javascript(bson:utf8("function(){}"), [{bson:utf8("v"), 1}])}],
% 	BinDocProp = bson:serialize(DocProp),
% 	<<44,0,0,0,15,99,111,100,101,0,33,0,0,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,12,0,0,0,16,118,0,1,0,0,0,0,0>> = BinDocProp,
% 	% Build a simple symbol key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("code"), bson:javascript(bson:utf8("function(){}"), dict:append(bson:utf8("v"), 1, dict:new())), dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<44,0,0,0,15,99,111,100,101,0,33,0,0,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,12,0,0,0,16,118,0,1,0,0,0,0,0>> = BinDocDict.
% 	
% simple_document_with_binary_test() ->
% 	% Build a simple symbol key-value doc and serialize the doc
% 	Doc = orddict:append(bson:utf8("bin"), bson:bin(list_to_binary("hello")), orddict:new()),
% 	BinDoc = bson:serialize(Doc),
% 	<<20,0,0,0,5,98,105,110,0,5,0,0,0,0,104,101,108,108,111,0>> = BinDoc,
% 	Doc2 = orddict:append(bson:utf8("bin"), bson:bin(1, list_to_binary("hello")), orddict:new()),
% 	BinDoc2 = bson:serialize(Doc2),
% 	<<20,0,0,0,5,98,105,110,0,5,0,0,0,1,104,101,108,108,111,0>> = BinDoc2,
% 	% Build a simple symbol key-value proplist and serialize the doc
% 	DocProp = [{bson:utf8("bin"), bson:bin(list_to_binary("hello"))}],
% 	BinDocProp = bson:serialize(DocProp),
% 	<<20,0,0,0,5,98,105,110,0,5,0,0,0,0,104,101,108,108,111,0>> = BinDocProp,
% 	% Build a simple symbol key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("bin"), bson:bin(list_to_binary("hello")), dict:new()),
% 	BinDocDict = bson:serialize(DocDict),
% 	<<20,0,0,0,5,98,105,110,0,5,0,0,0,0,104,101,108,108,111,0>> = BinDocDict.

%%
%%	Deserialization tests
%%

deserialize_simple_string_key_value_test() ->
	Bin = <<21,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,0>>,
	% Unpack the binary
	[{Key, Value}] = bson:deserialize(Bin, pl),
	% Verify the correctness of the values
	"name" = binary_to_list(Key),
	"value" = binary_to_list(Value).

deserialize_simple_two_attribute_object_test() ->
	Bin = <<19,0,0,0,16,97,0,1,0,0,0,16,98,0,2,0,0,0,0>>,
	[{Key1, Value1}, {Key2, Value2}] = bson:deserialize(Bin, pl),
	% Verify the correctness of the values
	"a" = binary_to_list(Key1),
	1 = Value1,
	"b" = binary_to_list(Key2),
	2 = Value2.

deserialize_simple_float_key_value_test() ->
	Bin = <<19,0,0,0,1,110,97,109,101,0,113,61,10,215,163,112,245,63,0>>,
	% Unpack the binary
	[{Key, Value}] = bson:deserialize(Bin, pl),
	% Verify the correctness of the values
	"name" = binary_to_list(Key),
	1.34 = Value.

deserialize_simple_32_bit_integer_key_value_test() ->
	Bin = <<15,0,0,0,16,110,97,109,101,0,232,3,0,0,0>>,
	% Unpack the binary
	[{Key, Value}] = bson:deserialize(Bin, pl),
	% Verify the correctness of the values
	"name" = binary_to_list(Key),
	1000 = Value.

deserialize_simple_64_bit_integer_key_value_test() ->
	Bin = <<19,0,0,0,18,110,97,109,101,0,0,0,0,0,0,0,0,112,0>>,
	% Unpack the binary
	[{Key, Value}] = bson:deserialize(Bin, pl),
	% Verify the correctness of the values
	"name" = binary_to_list(Key),
	16#7000000000000000 = Value.

deserialize_simple_two_layer_document_test() ->
	Bin = <<33,0,0,0,3,110,97,109,101,0,22,0,0,0,18,105,110,116,101,103,101,114,0,0,0,0,0,0,0,0,112,0,0>>,
	% Unpack the binary
	[{Key, [{Key2, Integer}]}] = bson:deserialize(Bin, pl),
	% Verify the correctness of the values
	"name" = binary_to_list(Key),
	"integer" = binary_to_list(Key2),
	16#7000000000000000 = Integer.

% %
% % Simple benchmark
% %
% simple_perf_test_off() ->
% 	erlang:statistics(runtime),
% 	pl_test(200000),
% 	{_, PLElapsed} = erlang:statistics(runtime),
% 	?debugFmt("~p~n", [PLElapsed]).
% 	
% pl_test(0) ->
% 	ok;
% pl_test(N) ->
% 	% Doc = orddict:append(bson:utf8("name"), bson:utf8("value"), orddict:new()),
% 	% _BinDoc = bson:serialize(Doc),	
% 	% DocProp = [{bson:utf8("name"), bson:utf8("value")}],
% 	% _BinDocProp = bson:serialize(DocProp),
% 	% Build a simple string key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("name"), bson:utf8("value"), dict:new()),
% 	_BinDocDict = bson:serialize(DocDict),
% 	pl_test(N - 1).


















	