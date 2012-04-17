% Module definition
-module(bson).

% Exported functions for the bson parser
-export ([serialize/1, deserialize/1]).
-export ([utf8/1]).

% Exporting all availble types
-export_type ([utf8/0]).

% Include the macros for writing code
-include ("bson.hrl").

% Serialize document
serialize(Doc) ->
	% erlang:display("-------------------------------------------------- PRE DOC"),
	% erlang:display(Doc),
	BinDoc = serialize_doc(Doc),
	% erlang:display("-------------------------------------------------- POST DOC"),
	% erlang:display(BinDoc),
	BinDoc.
	
serialize_doc(Doc) ->
	erlang:display("----------------------------------------------- serialize_doc"),
	% Create final binary
	Bin = list_to_binary(serialize_doc_objects(Doc)),
	% Add document header
	list_to_binary([<<?put_int32(byte_size(Bin) + 4 + 1)>>, Bin, <<0>>]).

serialize_doc_objects([Head|Tail]) ->	
	case Head of
		{Name, [Value]} when is_binary(Name), is_binary(Value) -> 			
			erlang:display("================================== serialize string"),
			[list_to_binary([<<02>>, Name, <<0>>, <<?put_int32(byte_size(Value) + 1)>>, Value, <<0>>])];
		{Name, [Value]} when is_binary(Name), is_float(Value) -> 			
			erlang:display("================================== serialize float"),
			[list_to_binary([<<16#01>>, Name, <<0>>, <<?put_float(Value)>>])];
		{Name, [Value]} when is_binary(Name), is_integer(Value), ?fits_int32(Value) -> 			
			erlang:display("================================== serialize 32 bit integer"),
			[list_to_binary([<<16#10>>, Name, <<0>>, <<?put_int32(Value)>>])];
		{Name, [Value]} when is_binary(Name), is_integer(Value), ?fits_int64(Value) -> 			
			erlang:display("================================== serialize 64 bit integer"),
			[list_to_binary([<<16#12>>, Name, <<0>>, <<?put_int64(Value)>>])];
		{Name, [[Value]]} when is_binary(Name), is_tuple(Value) -> 			
			erlang:display("================================== serialize object"),			
			% trigger serialization of all the values
			[Object] = serialize_doc_objects([Value]),
			[list_to_binary([<<16#03>>, Name, <<0>>, <<?put_int32(4 + byte_size(Object) + 1)>>, Object, <<0>>])];
		{Name, [Value]} when is_binary(Name), is_list(Value) -> 			
			erlang:display("================================== serialize array"),
			% Serialize the array
			BinDoc = serialize_array(0, Value),			
			% trigger serialization of all the values
			[list_to_binary([<<16#04>>, Name, <<0>>, <<?put_int32(4 + byte_size(BinDoc) + 1)>>, BinDoc, <<0>>])];
		_ -> 
			erlang:display("================================== serialize done"),			
			serialize_doc_objects(Tail)
	end;
serialize_doc_objects([]) -> [].

% Serialize an array of values using the code for all the other types
serialize_array(Number, [Head|Tail]) ->
	list_to_binary([serialize_doc_objects([{utf8(integer_to_list(Number)), [Head]}]), serialize_array(Number + 1, Tail)]);
serialize_array(_, []) -> [].

% Deserialize document
deserialize(BinDoc) ->
	[].
	
%
%	String representation
%
	
% All types used in the bson parser
-type utf8() :: unicode:unicode_binary().
% Conversion method for string to utf8 binary, bson required utf8 strings
-spec utf8 (unicode:chardata()) -> utf8().
%@doc Convert string to utf8 binary. string() is a subtype of unicode:chardata().
utf8 (CharData) -> case unicode:characters_to_binary (CharData) of
	{error, _Bin, _Rest} -> erlang:error (unicode_error, [CharData]);
	{incomplete, _Bin, _Rest} -> erlang:error (unicode_incomplete, [CharData]);
	Bin -> Bin end.

