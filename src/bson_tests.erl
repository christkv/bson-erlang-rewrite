-module(bson_tests).

-include_lib("eunit/include/eunit.hrl").

%%
%%  Serialization tests
%%

simple_single_level_two_attribute_serialization_test() ->
  % Build a simple string key-value dict and serialize the doc
  Doc = orddict:append(bson:utf8("b"), 2, orddict:append(bson:utf8("name"), bson:utf8("value"), orddict:new())),
  BinDoc = bson:serialize(Doc),
  <<28,0,0,0,16,98,0,2,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,0>> = BinDoc,
  % Build a simple string key-value proplist and serialize the doc
  DocProp = [{bson:utf8("name"), bson:utf8("value")}, {bson:utf8("b"), 2}],
  BinDocProp = bson:serialize(DocProp),
  <<28,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,16,98,0,2,0,0,0,0>> = BinDocProp,
  % Build a simple string key-value dict and serialize the doc
  DocDict = dict:append(bson:utf8("b"), 2, dict:append(bson:utf8("name"), bson:utf8("value"), dict:new())),
  BinDocDict = bson:serialize(DocDict),
  <<28,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,16,98,0,2,0,0,0,0>> = BinDocDict.

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

simple_two_level_document_with_multiple_values_test() ->
  % Build a simple integer key-value proplist and serialize the doc
  DocProp = [{bson:utf8("name"), [{bson:utf8("integer"), 16#7000000000000000}, {bson:utf8("bool"), true}]}],
  BinDocProp = bson:serialize(DocProp),
  <<40,0,0,0,3,110,97,109,101,0,29,0,0,0,18,105,110,116,101,103,101,114,0,0,0,0,0,0,0,0,112,8, 98,111,111,108,0,1,0,0>> = BinDocProp.

deserialize_simple_two_level_document_with_multiple_values_test() ->
  Bin = <<40,0,0,0,3,110,97,109,101,0,29,0,0,0,18,105,110,116,101,103,101,114,0,0,0,0,0,0,0,0,112,8, 98,111,111,108,0,1,0,0>>,
  % Unpack the binary
  _Values = bson:deserialize(Bin, pl),
  [{Key, Value}] = bson:deserialize(Bin, pl),
  % Verify the correctness of the values
  "name" = binary_to_list(Key),
  16#7000000000000000 = proplists:get_value(<<"integer">>, Value),
  true = proplists:get_value(<<"bool">>, Value).

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
  Doc = orddict:append(bson:utf8("date"), bson:bson_time_to_timestamp(1334686404073), orddict:new()),
  BinDoc = bson:serialize(Doc),
  <<19,0,0,0,9,100,97,116,101,0,233,77,130,193,54,1,0,0,0>> = BinDoc,
  % Build a simple datetime key-value proplist and serialize the doc
  DocProp = [{bson:utf8("date"), bson:bson_time_to_timestamp(1334686404073)}],
  BinDocProp = bson:serialize(DocProp),
  <<19,0,0,0,9,100,97,116,101,0,233,77,130,193,54,1,0,0,0>> = BinDocProp,
  % Build a simple datetime key-value dict and serialize the doc
  DocDict = dict:append(bson:utf8("date"), bson:bson_time_to_timestamp(1334686404073), dict:new()),
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

simple_document_with_minkey_test() ->
  % Build a simple symbol key-value doc and serialize the doc
  Doc = orddict:append(bson:utf8("key"), bson:minkey(), orddict:new()),
  BinDoc = bson:serialize(Doc),
  <<10,0,0,0,255,107,101,121,0,0>> = BinDoc,
  % Build a simple symbol key-value proplist and serialize the doc
  DocProp = [{bson:utf8("key"), bson:minkey()}],
  BinDocProp = bson:serialize(DocProp),
  <<10,0,0,0,255,107,101,121,0,0>> = BinDocProp,
  % Build a simple symbol key-value dict and serialize the doc
  DocDict = dict:append(bson:utf8("key"), bson:minkey(), dict:new()),
  BinDocDict = bson:serialize(DocDict),
  <<10,0,0,0,255,107,101,121,0,0>> = BinDocDict.

simple_document_with_maxkey_test() ->
  % Build a simple symbol key-value doc and serialize the doc
  Doc = orddict:append(bson:utf8("key"), bson:maxkey(), orddict:new()),
  BinDoc = bson:serialize(Doc),
  <<10,0,0,0,127,107,101,121,0,0>> = BinDoc,
  % Build a simple symbol key-value proplist and serialize the doc
  DocProp = [{bson:utf8("key"), bson:maxkey()}],
  BinDocProp = bson:serialize(DocProp),
  <<10,0,0,0,127,107,101,121,0,0>> = BinDocProp,
  % Build a simple symbol key-value dict and serialize the doc
  DocDict = dict:append(bson:utf8("key"), bson:maxkey(), dict:new()),
  BinDocDict = bson:serialize(DocDict),
  <<10,0,0,0,127,107,101,121,0,0>> = BinDocDict.

simple_document_with_javascript_test() ->
  % Build a simple symbol key-value doc and serialize the doc
  Doc = orddict:append(bson:utf8("code"), bson:javascript(bson:utf8("function(){}")), orddict:new()),
  BinDoc = bson:serialize(Doc),
  <<28,0,0,0,13,99,111,100,101,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,0>> = BinDoc,
  % Build a simple symbol key-value proplist and serialize the doc
  DocProp = [{bson:utf8("code"), bson:javascript(bson:utf8("function(){}"))}],
  BinDocProp = bson:serialize(DocProp),
  <<28,0,0,0,13,99,111,100,101,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,0>> = BinDocProp,
  % Build a simple symbol key-value dict and serialize the doc
  DocDict = dict:append(bson:utf8("code"), bson:javascript(bson:utf8("function(){}")), dict:new()),
  BinDocDict = bson:serialize(DocDict),
  <<28,0,0,0,13,99,111,100,101,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,0>> = BinDocDict.

simple_document_with_javascript_code_test() ->
  % Build a simple symbol key-value doc and serialize the doc
  Doc = orddict:append(bson:utf8("code"), bson:javascript(bson:utf8("function(){}"), orddict:append(bson:utf8("v"), 1, orddict:new())), orddict:new()),
  BinDoc = bson:serialize(Doc),
  <<44,0,0,0,15,99,111,100,101,0,33,0,0,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,12,0,0,0,16,118,0,1,0,0,0,0,0>> = BinDoc,
  % Build a simple symbol key-value proplist and serialize the doc
  DocProp = [{bson:utf8("code"), bson:javascript(bson:utf8("function(){}"), [{bson:utf8("v"), 1}])}],
  BinDocProp = bson:serialize(DocProp),
  <<44,0,0,0,15,99,111,100,101,0,33,0,0,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,12,0,0,0,16,118,0,1,0,0,0,0,0>> = BinDocProp,
  % Build a simple symbol key-value dict and serialize the doc
  DocDict = dict:append(bson:utf8("code"), bson:javascript(bson:utf8("function(){}"), dict:append(bson:utf8("v"), 1, dict:new())), dict:new()),
  BinDocDict = bson:serialize(DocDict),
  <<44,0,0,0,15,99,111,100,101,0,33,0,0,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,12,0,0,0,16,118,0,1,0,0,0,0,0>> = BinDocDict.

simple_document_with_binary_test() ->
  % Build a simple symbol key-value doc and serialize the doc
  Doc = orddict:append(bson:utf8("bin"), bson:bin(list_to_binary("hello")), orddict:new()),
  BinDoc = bson:serialize(Doc),
  <<20,0,0,0,5,98,105,110,0,5,0,0,0,0,104,101,108,108,111,0>> = BinDoc,
  Doc2 = orddict:append(bson:utf8("bin"), bson:bin(1, list_to_binary("hello")), orddict:new()),
  BinDoc2 = bson:serialize(Doc2),
  <<20,0,0,0,5,98,105,110,0,5,0,0,0,1,104,101,108,108,111,0>> = BinDoc2,
  % Build a simple symbol key-value proplist and serialize the doc
  DocProp = [{bson:utf8("bin"), bson:bin(list_to_binary("hello"))}],
  BinDocProp = bson:serialize(DocProp),
  <<20,0,0,0,5,98,105,110,0,5,0,0,0,0,104,101,108,108,111,0>> = BinDocProp,
  % Build a simple symbol key-value dict and serialize the doc
  DocDict = dict:append(bson:utf8("bin"), bson:bin(list_to_binary("hello")), dict:new()),
  BinDocDict = bson:serialize(DocDict),
  <<20,0,0,0,5,98,105,110,0,5,0,0,0,0,104,101,108,108,111,0>> = BinDocDict.

%%
%%  Deserialization tests
%%

deserialize_simple_string_key_value_test() ->
  Bin = <<21,0,0,0,2,110,97,109,101,0,6,0,0,0,118,97,108,117,101,0,0>>,
  % Unpack the binary as propertylist
  [{Key, Value}] = bson:deserialize(Bin, pl),
  % Verify the correctness of the values
  "name" = binary_to_list(Key),
  "value" = binary_to_list(Value),
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  "value" = binary_to_list(dict:fetch(bson:utf8("name"), Dict)),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  "value" = binary_to_list(orddict:fetch(bson:utf8("name"), OrdDict)).

deserialize_simple_two_attribute_object_test() ->
  Bin = <<19,0,0,0,16,97,0,1,0,0,0,16,98,0,2,0,0,0,0>>,
  [{Key1, Value1}, {Key2, Value2}] = bson:deserialize(Bin, pl),
  % Verify the correctness of the values
  "a" = binary_to_list(Key1),
  1 = Value1,
  "b" = binary_to_list(Key2),
  2 = Value2,
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  1 = dict:fetch(bson:utf8("a"), Dict),
  2 = dict:fetch(bson:utf8("b"), Dict),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  1 = orddict:fetch(bson:utf8("a"), OrdDict),
  2 = orddict:fetch(bson:utf8("b"), OrdDict).

deserialize_simple_float_key_value_test() ->
  Bin = <<19,0,0,0,1,110,97,109,101,0,113,61,10,215,163,112,245,63,0>>,
  % Unpack the binary
  [{Key, Value}] = bson:deserialize(Bin, pl),
  % Verify the correctness of the values
  "name" = binary_to_list(Key),
  1.34 = Value,
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  1.34 = dict:fetch(bson:utf8("name"), Dict),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  1.34 = orddict:fetch(bson:utf8("name"), OrdDict).

deserialize_simple_32_bit_integer_key_value_test() ->
  Bin = <<15,0,0,0,16,110,97,109,101,0,232,3,0,0,0>>,
  % Unpack the binary
  [{Key, Value}] = bson:deserialize(Bin, pl),
  % Verify the correctness of the values
  "name" = binary_to_list(Key),
  1000 = Value,
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  1000 = dict:fetch(bson:utf8("name"), Dict),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  1000 = orddict:fetch(bson:utf8("name"), OrdDict).

deserialize_simple_64_bit_integer_key_value_test() ->
  Bin = <<19,0,0,0,18,110,97,109,101,0,0,0,0,0,0,0,0,112,0>>,
  % Unpack the binary
  [{Key, Value}] = bson:deserialize(Bin, pl),
  % Verify the correctness of the values
  "name" = binary_to_list(Key),
  16#7000000000000000 = Value,
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  16#7000000000000000 = dict:fetch(bson:utf8("name"), Dict),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  16#7000000000000000 = orddict:fetch(bson:utf8("name"), OrdDict).

deserialize_simple_two_layer_document_test() ->
  Bin = <<33,0,0,0,3,110,97,109,101,0,22,0,0,0,18,105,110,116,101,103,101,114,0,0,0,0,0,0,0,0,112,0,0>>,
  % Unpack the binary
  [{Key, [{Key2, Integer}]}] = bson:deserialize(Bin, pl),
  % Verify the correctness of the values
  "name" = binary_to_list(Key),
  "integer" = binary_to_list(Key2),
  16#7000000000000000 = Integer,
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  Dict2 = dict:fetch(bson:utf8("name"), Dict),
  16#7000000000000000 = dict:fetch(bson:utf8("integer"), Dict2),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  OrdDict2 = orddict:fetch(bson:utf8("name"), OrdDict),
  16#7000000000000000 = orddict:fetch(bson:utf8("integer"), OrdDict2).

deserialize_simple_array_of_integers_document_test() ->
  Bin = <<48,0,0,0,4,105,110,116,101,103,101,114,115,0,33,0,0,0,16,48,0,1,0,0,0,16,49,0,2,0,0,0,16,50,0,3,0,0,0,16,51,0,4,0,0,0,0,0>>,
  % Upack the binary
  Doc = bson:deserialize(Bin, pl),
  [{Key, Value}] = Doc,
  % Verify the correctness of the values
  "integers" = binary_to_list(Key),
  [1,2,3,4] = Value,
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  [1,2,3,4] = dict:fetch(bson:utf8("integers"), Dict),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  [1,2,3,4] = orddict:fetch(bson:utf8("integers"), OrdDict).

deserialize_simple_regexp_document_test() ->
  Bin = <<20,0,0,0,11,114,101,103,101,120,112,0,116,101,115,116,0,115,0,0>>,
  % Upack the binary
  Doc = bson:deserialize(Bin, pl),
  [{Key, Value}] = Doc,
  % Verify the correctness of the values
  "regexp" = binary_to_list(Key),
  regexp = element(1, Value),
  "test" = binary_to_list(element(2, Value)),
  "s" = binary_to_list(element(3, Value)),
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  Regexp = dict:fetch(bson:utf8("regexp"), Dict),
  regexp = element(1, Regexp),
  "test" = binary_to_list(element(2, Regexp)),
  "s" = binary_to_list(element(3, Regexp)),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  Regexp2 = orddict:fetch(bson:utf8("regexp"), OrdDict),
  regexp = element(1, Regexp2),
  "test" = binary_to_list(element(2, Regexp2)),
  "s" = binary_to_list(element(3, Regexp2)).

deserialize_simple_objectid_document_test() ->
  Bin = <<27,0,0,0,7,111,98,106,101,99,116,105,100,0,79,141,126,31,149,241,59,67,112,0,0,0,0>>,
  % Upack the binary
  Doc = bson:deserialize(Bin, pl),
  [{Key, Value}] = Doc,
  % Verify the correctness of the values
  "objectid" = binary_to_list(Key),
  objectid = element(1, Value),
  <<79,141,126,31,149,241,59,67,112,0,0,0>> = element(2, Value),
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  ObjectId = dict:fetch(bson:utf8("objectid"), Dict),
  objectid = element(1, ObjectId),
  <<79,141,126,31,149,241,59,67,112,0,0,0>> = element(2, ObjectId),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  ObjectId2 = orddict:fetch(bson:utf8("objectid"), OrdDict),
  objectid = element(1, ObjectId2),
  <<79,141,126,31,149,241,59,67,112,0,0,0>> = element(2, ObjectId2).

deserialize_simple_boolean_document_test() ->
  Bin = <<12,0,0,0,8,98,111,111,108,0,1,0>>,
  % Upack the binary
  Doc = bson:deserialize(Bin, pl),
  [{Key, Value}] = Doc,
  % Verify the correctness of the values
  "bool" = binary_to_list(Key),
  true = Value,
  % Verify a false value
  Bin2 = <<12,0,0,0,8,98,111,111,108,0,0,0>>,
  Doc2 = bson:deserialize(Bin2, pl),
  [{Key2, Value2}] = Doc2,
  "bool" = binary_to_list(Key2),
  false = Value2,
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  true = dict:fetch(bson:utf8("bool"), Dict),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  true = orddict:fetch(bson:utf8("bool"), OrdDict).

deserialize_simple_null_document_test() ->
  Bin = <<11,0,0,0,10,98,111,111,108,0,0>>,
  % Upack the binary
  Doc = bson:deserialize(Bin, pl),
  [{Key, Value}] = Doc,
  % Verify the correctness of the values
  "bool" = binary_to_list(Key),
  null = Value,
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  null = dict:fetch(bson:utf8("bool"), Dict),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  null = orddict:fetch(bson:utf8("bool"), OrdDict).

deserialize_simple_datetime_document_test() ->
  Bin = <<19,0,0,0,9,100,97,116,101,0,233,77,130,193,54,1,0,0,0>>,
  % Upack the binary
  Doc = bson:deserialize(Bin, pl),
  [{Key, Value}] = Doc,
  % Verify the correctness of the values
  "date" = binary_to_list(Key),
  {1,334686,404073} = Value,
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  {1,334686,404073} = dict:fetch(bson:utf8("date"), Dict),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  {1,334686,404073} = orddict:fetch(bson:utf8("date"), OrdDict).

deserialize_simple_symbol_document_test() ->
  Bin = <<22,0,0,0,14,115,121,109,98,111,108,0,5,0,0,0,97,116,111,109,0,0>>,
  % Upack the binary
  Doc = bson:deserialize(Bin, pl),
  [{Key, Value}] = Doc,
  % Verify the correctness of the values
  "symbol" = binary_to_list(Key),
  atom = Value,
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  atom = dict:fetch(bson:utf8("symbol"), Dict),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  atom = orddict:fetch(bson:utf8("symbol"), OrdDict).

deserialize_simple_minkey_document_test() ->
  Bin = <<10,0,0,0,255,107,101,121,0,0>>,
  % Upack the binary
  Doc = bson:deserialize(Bin, pl),
  [{Key, Value}] = Doc,
  % Verify the correctness of the values
  "key" = binary_to_list(Key),
  {minkey} = Value,
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  {minkey} = dict:fetch(bson:utf8("key"), Dict),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  {minkey} = orddict:fetch(bson:utf8("key"), OrdDict).

deserialize_simple_maxkey_document_test() ->
  Bin = <<10,0,0,0,127,107,101,121,0,0>>,
  % Upack the binary
  Doc = bson:deserialize(Bin, pl),
  [{Key, Value}] = Doc,
  % Verify the correctness of the values
  "key" = binary_to_list(Key),
  {maxkey} = Value,
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  {maxkey} = dict:fetch(bson:utf8("key"), Dict),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  {maxkey} = orddict:fetch(bson:utf8("key"), OrdDict).

deserialize_simple_javascript_document_test() ->
  Bin = <<28,0,0,0,13,99,111,100,101,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,0>>,
  % Upack the binary
  Doc = bson:deserialize(Bin, pl),
  [{Key, Value}] = Doc,
  % Verify the correctness of the values
  "code" = binary_to_list(Key),
  js = element(1, Value),
  <<"function(){}">> = element(2, Value),
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  Code = dict:fetch(bson:utf8("code"), Dict),
  js = element(1, Code),
  <<"function(){}">> = element(2, Code),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  Code2 = orddict:fetch(bson:utf8("code"), OrdDict),
  js = element(1, Code2),
  <<"function(){}">> = element(2, Code2).

deserialize_simple_javascript_scope_document_test() ->
  Bin = <<44,0,0,0,15,99,111,100,101,0,33,0,0,0,13,0,0,0,102,117,110,99,116,105,111,110,40,41,123,125,0,12,0,0,0,16,118,0,1,0,0,0,0,0>>,
  % Upack the binary
  Doc = bson:deserialize(Bin, pl),
  [{Key, Value}] = Doc,
  % Verify the correctness of the values
  "code" = binary_to_list(Key),
  js = element(1, Value),
  <<"function(){}">> = element(2, Value),
  [{<<"v">>,1}] = element(3, Value),
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  Code = dict:fetch(bson:utf8("code"), Dict),
  js = element(1, Code),
  <<"function(){}">> = element(2, Code),
  1 = dict:fetch(bson:utf8("v"), element(3, Code)),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  Code2 = orddict:fetch(bson:utf8("code"), OrdDict),
  js = element(1, Code2),
  <<"function(){}">> = element(2, Code2),
  1 = orddict:fetch(bson:utf8("v"), element(3, Code2)).

deserialize_simple_binary_document_test() ->
  Bin = <<20,0,0,0,5,98,105,110,0,5,0,0,0,0,104,101,108,108,111,0>>,
  % Upack the binary
  Doc = bson:deserialize(Bin, pl),
  [{Key, Value}] = Doc,
  % Verify the correctness of the values
  "bin" = binary_to_list(Key),
  bin = element(1, Value),
  0 = element(2, Value),
  <<"hello">> = element(3, Value),
  % Unpack as binary dictionary
  Dict = bson:deserialize(Bin, dict),
  Binary = dict:fetch(bson:utf8("bin"), Dict),
  bin = element(1, Binary),
  0 = element(2, Binary),
  <<"hello">> = element(3, Binary),
  % Unpack as ordered dictionary
  OrdDict = bson:deserialize(Bin, orddict),
  Binary2 = orddict:fetch(bson:utf8("bin"), OrdDict),
  bin = element(1, Binary2),
  0 = element(2, Binary2),
  <<"hello">> = element(3, Binary2).

%%
%%  Scan for key and deserialize tests
%%
deserialize_first_level_key_test() ->
  % Build a simple integer key-value doc and serialize the doc
  InnerDoc = orddict:append(bson:utf8("integer"), 16#7000000000000000, orddict:new()),
  Doc = orddict:append(bson:utf8("name"), InnerDoc, orddict:new()),
  BinDoc = bson:serialize(Doc),

  % Fetch the doc based on the top level name tag
  SelectedDoc = bson:deserialize(BinDoc, [<<"name">>], pl),
  [{<<"name">>,[{<<"integer">>,8070450532247928832}]}] = SelectedDoc,

  % Fetch the doc based on the name.integer level tag
  SelectedDoc2 = bson:deserialize(BinDoc, [<<"name">>, <<"integer">>], pl),
  [{<<"integer">>,8070450532247928832}] = SelectedDoc2,

  % No match found
  {err, nomatch} = bson:deserialize(BinDoc, [<<"name2">>], pl).

%%
%%	Throw due to illegal keys
%%

throws_error_during_serialization_due_to_illegal_key_test() ->
	% Build a simple string key-value proplist and serialize the doc
	DocProp = [{bson:utf8("$name"), bson:utf8("value")}, {bson:utf8("b"), 2}],
  ?assertThrow({key_check_error, <<"$name">>}, bson:serialize(DocProp, true)),
	DocProp2 = [{bson:utf8("name.test"), bson:utf8("value")}, {bson:utf8("b"), 2}],
  ?assertThrow({key_check_error, <<"name.test">>}, bson:serialize(DocProp2, true)).

% %
% % Simple serialize benchmark
% %
% simple_perf_pl_test() ->
% 	erlang:statistics(runtime),
% 	pl_test(200000),
% 	{_, PLElapsed} = erlang:statistics(runtime),
% 	?debugFmt("~p~n", [PLElapsed]).
%
% simple_perf_dict_test() ->
% 	erlang:statistics(runtime),
% 	dict_test(200000),
% 	{_, PLElapsed} = erlang:statistics(runtime),
% 	?debugFmt("~p~n", [PLElapsed]).
%
% simple_perf_orddict_test() ->
% 	erlang:statistics(runtime),
% 	orddict_test(200000),
% 	{_, PLElapsed} = erlang:statistics(runtime),
% 	?debugFmt("~p~n", [PLElapsed]).
%
% simple_perf_match_test() ->
% 	% Serialize the doc
% 	DocDict = [{bson:utf8("name"), {bson:utf8("integer"), 16#7000000000000000}}],
% 	Bin = bson:serialize(DocDict),
% 	% Start test 1
% 	erlang:statistics(runtime),
% 	bson:test1(200000, Bin),
% 	{_, PLElapsed} = erlang:statistics(runtime),
% 	?debugFmt("simple_perf_scan_vs_whole_doc_test :: ~p~n", [PLElapsed]).
%
% simple_perf_scan_vs_whole_doc_test() ->
% 	% Serialize the doc
% 	DocDict = [{bson:utf8("name"), {bson:utf8("integer"), 16#7000000000000000}}],
% 	Bin = bson:serialize(DocDict),
% 	% Start test 1
% 	erlang:statistics(runtime),
% 	scan_test(200000, Bin),
% 	{_, PLElapsed} = erlang:statistics(runtime),
% 	?debugFmt("simple_perf_scan_vs_whole_doc_test :: ~p~n", [PLElapsed]).
%
% simple_perf_scan_vs_whole_doc_2_test() ->
% 	% Serialize the doc
% 	DocDict = [{bson:utf8("name"), {bson:utf8("integer"), 16#7000000000000000}}],
% 	Bin = bson:serialize(DocDict),
% 	% Start test 1
% 	erlang:statistics(runtime),
% 	scan_test_2(200000, Bin),
% 	{_, PLElapsed} = erlang:statistics(runtime),
% 	?debugFmt("simple_perf_scan_vs_whole_doc_2_test :: ~p~n", [PLElapsed]).
%
% scan_test(0, _) -> ok;
% scan_test(N, Bin) ->
% 	_DocProp = bson:deserialize(Bin, pl),
% 	scan_test(N - 1, Bin).
%
% scan_test_2(0, _) -> ok;
% scan_test_2(N, Bin) ->
% 	_DocProp = bson:deserialize(Bin, [<<"name">>, <<"integer">>], pl),
% 	scan_test_2(N - 1, Bin).
%
% pl_test(0) -> ok;
% pl_test(N) ->
% 	DocProp = [{bson:utf8("name"), bson:utf8("value")}],
% 	_BinDocProp = bson:serialize(DocProp),
% 	_DocProp = bson:deserialize(_BinDocProp, pl),
% 	pl_test(N - 1).
%
% dict_test(0) -> ok;
% dict_test(N) ->
% 	% Build a simple string key-value dict and serialize the doc
% 	DocDict = dict:append(bson:utf8("name"), bson:utf8("value"), dict:new()),
% 	_BinDocDict = bson:serialize(DocDict),
% 	_DocProp = bson:deserialize(_BinDocDict, dict),
% 	dict_test(N - 1).
%
% orddict_test(0) -> ok;
% orddict_test(N) ->
% 	Doc = orddict:append(bson:utf8("name"), bson:utf8("value"), orddict:new()),
% 	_BinDoc = bson:serialize(Doc),
% 	_DocProp = bson:deserialize(_BinDoc, orddict),
% 	orddict_test(N - 1).


















