% Module definition
-module(bson).

% Exported functions for the bson parser
-export ([serialize/1, deserialize/1, deserialize/2, deserialize/3]).
-export ([utf8/1, bin/1, bin/2, minkey/0, maxkey/0, javascript/1, javascript/2, regexp/2, gen_objectid/1, objectid/1, objectid/3, timestamp_to_bson_time/1, bsom_time_to_timestamp/1]).
-export ([hexstr_to_bin/1]).

% Exporting all availble types
-export_type ([utf8/0]).

% Include the macros for writing code
-include ("bson.hrl").

% Serialize document
serialize(Doc) ->
	serialize_doc(Doc).
	
serialize_doc(Doc) ->
	% erlang:display("----------------------------------------------- serialize_doc"),
	% erlang:display(Doc),

	case Doc of
		Doc when is_tuple(Doc), element(1, Doc) == dict ->
			% Create final binary
			Bin = list_to_binary(serialize_doc_objects(dict:to_list(Doc))),
			% Add document header
			list_to_binary([<<?put_int32u(byte_size(Bin) + 4 + 1)>>, Bin, <<0>>]);
		_ ->
			% Create final binary
			Bin = list_to_binary(serialize_doc_objects(Doc)),
			% Add document header
			list_to_binary([<<?put_int32u(byte_size(Bin) + 4 + 1)>>, Bin, <<0>>])
	end.

serialize_doc_objects([Head|Tail]) ->		
	% Handle the situation where the value is a dict
	FinalHeadValue = case Head of
		{HeadName, [HeadValue]} when is_tuple(HeadValue), element(1, HeadValue) == dict ->
			% erlang:display("=================================================== DICT"),
			{HeadName, [dict:to_list(HeadValue)]};
		_ ->
			% erlang:display("=================================================== NOT DICT"),
			Head
	end,

	% erlang:display("================================================================== HEADVALUE"),
	% erlang:display(FinalHeadValue),

	% Match the case of the Head
	BinaryList = case FinalHeadValue of				
		{Name, {maxkey}} when is_binary(Name) ->
			% erlang:display("================================== serialize maxkey"),
			[list_to_binary([<<16#7f>>, Name, <<0>>])];
		{Name, [{maxkey}]} when is_binary(Name) ->
			% erlang:display("================================== serialize maxkey"),
			[list_to_binary([<<16#7f>>, Name, <<0>>])];
		{Name, {minkey}} when is_binary(Name) ->
			% erlang:display("================================== serialize minkey"),
			[list_to_binary([<<16#ff>>, Name, <<0>>])];
		{Name, [{minkey}]} when is_binary(Name) ->
			% erlang:display("================================== serialize minkey"),
			[list_to_binary([<<16#ff>>, Name, <<0>>])];
		{Name, {regexp, RegExp, Options}} when is_binary(Name) ->
			% erlang:display("================================== serialize regexp"),
			[list_to_binary([<<16#0B>>, Name, <<0>>, RegExp, <<0>>, Options, <<0>>])];
		{Name, [{bin, SubType, Binary}]} when is_binary(Name), is_integer(SubType), is_binary(Binary) ->
			% erlang:display("================================== serialize binary"),
			[list_to_binary([<<16#05>>, Name, <<0>>, <<?put_int32u(byte_size(Binary))>>, <<?put_int8(SubType)>>, Binary])];
		{Name, {bin, SubType, Binary}} when is_binary(Name), is_integer(SubType), is_binary(Binary) ->
			% erlang:display("================================== serialize binary"),
			[list_to_binary([<<16#05>>, Name, <<0>>, <<?put_int32u(byte_size(Binary))>>, <<?put_int8(SubType)>>, Binary])];
		{Name, {objectid, ObjectId}} when is_binary(Name), is_binary(ObjectId) ->
			% erlang:display("================================== serialize objectid"),
			[list_to_binary([<<16#07>>, Name, <<0>>, ObjectId])];
		{Name, undefined} when is_binary(Name) ->
			% erlang:display("================================== serialize undefined"),
			[list_to_binary([<<16#0A>>, Name, <<0>>])];
		{Name, null} when is_binary(Name) ->
			% erlang:display("================================== serialize null"),
			[list_to_binary([<<16#0A>>, Name, <<0>>])];
		{Name, {js, Code}} when is_binary(Name), is_binary(Code) ->
			% erlang:display("================================== serialize code"),
			[list_to_binary([<<16#0D>>, Name, <<0>>, <<?put_int32u(byte_size(Code) + 1)>>, Code, <<0>>])];
		{Name, [{js, Code, Scope}]} when is_binary(Name), is_binary(Code), element(1, Scope) == dict ->
			% erlang:display("================================== serialize code w scope"),
			[Object] = serialize_doc_objects(dict:to_list(Scope)),
			TotalLength = 4 + (byte_size(Code) + 1) + 4 + (4 + byte_size(Object) + 1),
			[list_to_binary([<<16#0F>>, Name, <<0>>, <<?put_int32u(TotalLength)>>, <<?put_int32u(byte_size(Code) + 1)>>, Code, <<0>>, <<?put_int32u(4 + byte_size(Object) + 1)>>, Object, <<0>>])];
		{Name, [{js, Code, Scope}]} when is_binary(Name), is_binary(Code) ->
			% erlang:display("================================== serialize code w scope"),
			[Object] = serialize_doc_objects(Scope),
			TotalLength = 4 + (byte_size(Code) + 1) + 4 + (4 + byte_size(Object) + 1),
			[list_to_binary([<<16#0F>>, Name, <<0>>, <<?put_int32u(TotalLength)>>, <<?put_int32u(byte_size(Code) + 1)>>, Code, <<0>>, <<?put_int32u(4 + byte_size(Object) + 1)>>, Object, <<0>>])];
		{Name, {js, Code, Scope}} when is_binary(Name), is_binary(Code) ->
			% erlang:display("================================== serialize code w scope"),
			[Object] = serialize_doc_objects(Scope),
			TotalLength = 4 + (byte_size(Code) + 1) + 4 + (4 + byte_size(Object) + 1),
			[list_to_binary([<<16#0F>>, Name, <<0>>, <<?put_int32u(TotalLength)>>, <<?put_int32u(byte_size(Code) + 1)>>, Code, <<0>>, <<?put_int32u(4 + byte_size(Object) + 1)>>, Object, <<0>>])];
		{Name, [{js, Code}]} when is_binary(Name), is_binary(Code) ->
			% erlang:display("================================== serialize code"),
			[list_to_binary([<<16#0D>>, Name, <<0>>, <<?put_int32u(byte_size(Code) + 1)>>, Code, <<0>>])];
		{Name, {MegaSecs, Seconds, Micro}} ->
			% erlang:display("================================== serialize date"),
			[list_to_binary([<<16#09>>, Name, <<0>>, <<?put_int64(timestamp_to_bson_time({MegaSecs, Seconds, Micro}))>>])];
		{Name, Value} when is_binary(Name), is_boolean(Value) -> 			
			% erlang:display("================================== serialize boolean"),
			case Value of
				true->
					[list_to_binary([<<16#08>>, Name, <<0>>, <<1>>])];
				_ ->
					[list_to_binary([<<16#08>>, Name, <<0>>, <<0>>])]
			end;
		{Name, Value} when is_binary(Name), is_atom(Value) ->
			% erlang:display("================================== serialize symbol"),			
			ValueBin = atom_to_binary(Value, utf8),			
			[list_to_binary([<<16#0E>>, Name, <<0>>, <<?put_int32u(byte_size(ValueBin) + 1)>>, ValueBin, <<0>>])];
		{Name, [[Value]]} when is_binary(Name), is_tuple(Value) -> 			
			% erlang:display("================================== serialize object"),			
			% trigger serialization of all the values
			[Object] = serialize_doc_objects([Value]),
			[list_to_binary([<<16#03>>, Name, <<0>>, <<?put_int32u(4 + byte_size(Object) + 1)>>, Object, <<0>>])];
		{Name, [Value]} when is_binary(Name), is_list(Value) -> 			
			% erlang:display("================================== serialize array"),
			% Serialize the array
			BinDoc = serialize_array(0, Value),			
			% trigger serialization of all the values
			[list_to_binary([<<16#04>>, Name, <<0>>, <<?put_int32u(4 + byte_size(BinDoc) + 1)>>, BinDoc, <<0>>])];
		{Name, Value} when is_binary(Name), is_binary(Value) ->
			[list_to_binary([<<16#02>>, Name, <<0>>, <<?put_int32u(byte_size(Value) + 1)>>, Value, <<0>>])];			
		{Name, Value} when is_binary(Name), is_float(Value) -> 			
			% erlang:display("================================== serialize float"),
			[list_to_binary([<<16#01>>, Name, <<0>>, <<?put_float(Value)>>])];
		{Name, Value} when is_binary(Name), is_integer(Value), ?fits_int32(Value) -> 			
			% erlang:display("================================== serialize 32 bit integer"),
			[list_to_binary([<<16#10>>, Name, <<0>>, <<?put_int32(Value)>>])];
		{Name, Value} when is_binary(Name), is_integer(Value), ?fits_int64(Value) -> 			
			% erlang:display("================================== serialize 64 bit integer"),
			[list_to_binary([<<16#12>>, Name, <<0>>, <<?put_int64(Value)>>])];
		{Name, Value} when is_binary(Name), is_tuple(Value) -> 			
			% erlang:display("================================== serialize object"),			
			% trigger serialization of all the values
			[Object] = serialize_doc_objects([Value]),
			[list_to_binary([<<16#03>>, Name, <<0>>, <<?put_int32u(4 + byte_size(Object) + 1)>>, Object, <<0>>])];
		{Name, [{regexp, RegExp, Options}]} when is_binary(Name) ->
			% erlang:display("================================== serialize regexp"),
			[list_to_binary([<<16#0B>>, Name, <<0>>, RegExp, <<0>>, Options, <<0>>])];
		{Name, [undefined]} when is_binary(Name) ->
			% erlang:display("================================== serialize undefined"),
			[list_to_binary([<<16#0A>>, Name, <<0>>])];
		{Name, [null]} when is_binary(Name) ->
			% erlang:display("================================== serialize null"),
			[list_to_binary([<<16#0A>>, Name, <<0>>])];
		{Name, [{MegaSecs, Seconds, Micro}]} ->
			% erlang:display("================================== serialize date"),
			[list_to_binary([<<16#09>>, Name, <<0>>, <<?put_int64(timestamp_to_bson_time({MegaSecs, Seconds, Micro}))>>])];
		{Name, [{objectid, ObjectId}]} when is_binary(Name), is_binary(ObjectId) ->
			% erlang:display("================================== serialize objectid"),
			[list_to_binary([<<16#07>>, Name, <<0>>, ObjectId])];
		{Name, [Value]} when is_binary(Name), is_binary(Value) -> 			
			% erlang:display("================================== serialize string"),
			[list_to_binary([<<16#02>>, Name, <<0>>, <<?put_int32u(byte_size(Value) + 1)>>, Value, <<0>>])];
		{Name, [Value]} when is_binary(Name), is_boolean(Value) -> 			
			% erlang:display("================================== serialize boolean"),
			case Value of
				true->
					[list_to_binary([<<16#08>>, Name, <<0>>, <<1>>])];
				_ ->
					[list_to_binary([<<16#08>>, Name, <<0>>, <<0>>])]
			end;
		{Name, [Value]} when is_binary(Name), is_atom(Value) ->
			% erlang:display("================================== serialize symbol"),			
			ValueBin = atom_to_binary(Value, utf8),			
			[list_to_binary([<<16#0E>>, Name, <<0>>, <<?put_int32u(byte_size(ValueBin) + 1)>>, ValueBin, <<0>>])];
		{Name, [Value]} when is_binary(Name), is_float(Value) -> 			
			% erlang:display("================================== serialize float"),
			[list_to_binary([<<16#01>>, Name, <<0>>, <<?put_float(Value)>>])];
		{Name, [Value]} when is_binary(Name), is_integer(Value), ?fits_int32(Value) -> 			
			% erlang:display("================================== serialize 32 bit integer"),
			[list_to_binary([<<16#10>>, Name, <<0>>, <<?put_int32(Value)>>])];
		{Name, [Value]} when is_binary(Name), is_integer(Value), ?fits_int64(Value) -> 			
			% erlang:display("================================== serialize 64 bit integer"),
			[list_to_binary([<<16#12>>, Name, <<0>>, <<?put_int64(Value)>>])];
		{Name, [Value|_]} when is_binary(Name), is_tuple(Value) == false, is_list(Value) == false ->
			% erlang:display("================================== serialize array"),
			{_, ArrayValue} = Head,
			% Serialize the array
			BinDoc = serialize_array(0, ArrayValue),
			% trigger serialization of all the values
			[list_to_binary([<<16#04>>, Name, <<0>>, <<?put_int32u(4 + byte_size(BinDoc) + 1)>>, BinDoc, <<0>>])];
		_ -> 
			% erlang:display("================================== serialize done"),			
			serialize_doc_objects(Tail)
	end,	
	% erlang:display("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"),
	% erlang:display(Tail),
	
	% Process next document
	BinaryList ++ serialize_doc_objects(Tail);
serialize_doc_objects([]) -> [].

% Serialize an array of values using the code for all the other types
serialize_array(Number, [Head|Tail]) ->
	list_to_binary([serialize_doc_objects([{utf8(integer_to_list(Number)), [Head]}]), serialize_array(Number + 1, Tail)]);
serialize_array(_, []) -> [].

% Deserialize document
deserialize(BinDoc) when is_binary(BinDoc) ->
	deserialize(BinDoc, pl).

deserialize(BinDoc, Type) when is_binary(BinDoc) and is_atom(Type) ->
	deserialize_doc(BinDoc, Type, doc).

deserialize(BinDoc, KeyToScanFor, Type) when is_binary(BinDoc), is_binary(KeyToScanFor), is_atom(Type) ->
	% Binary length
	Length = byte_size(BinDoc),
	% Split the binary info search key parts
	Keys = binary:split(KeyToScanFor, <<".">>, [global]),
	% Search for the object and return it deserialized
	FoundIndex = search_for_object(Keys, BinDoc, 0, Length, Type),
	% Build the end Object type based on the provided type
	FinalObject = case Type of
			pl ->
				[];
			dict ->
				dict:new();
			orddict ->
				orddict:new()
		end,
	% Verify that we found an index
	case is_number(FoundIndex) of
		true ->
			% Actual start of the element
			ActualIndex = FoundIndex - 1,
			% Cut out from this point
			deserialize_elements_pl(binary:part(BinDoc, ActualIndex, Length - ActualIndex), FinalObject, Type, doc, single);
		_ -> {err, nomatch}
	end.

search_for_object([Head|Tail], BinDoc, Index, Length, Type) ->
	% erlang:display(binary_to_list(Head)),
	Match = binary:match(BinDoc, Head, [{scope, {Index, Length - Index}}]),
	% Ensure we error on no match found
	case Match of
		nomatch -> {err, nomatch};
		{NewIndex, NewLength} -> 
			search_for_object(Tail, BinDoc, NewIndex, Length - NewIndex, Type)
	end;
search_for_object([], _, FoundIndex, _, _) -> FoundIndex.
	
deserialize_doc(BinDoc, Type, DocType) when is_binary(BinDoc), is_atom(Type), is_atom(DocType) ->
	% Grab the size of the doc
	<<NumberOfBytes:32/unsigned-little,Rest/binary>> = BinDoc,
	% Build the end Object type based on the provided type
	FinalObject = case Type of
			pl ->
				[];
			dict ->
				dict:new();
			orddict ->
				orddict:new()
		end,
	
	% Ensure the correct size
	if
		NumberOfBytes /= byte_size(BinDoc) ->
			% Illegal sized doc return error
			{err, illegalDocumentSize};
		true ->
			% Legaly sized document start parsing
			deserialize_elements_pl(Rest, FinalObject, Type, DocType, multi)
	end.		

% Deserialize all the elements
deserialize_elements_pl(Rest, Object, ResultType, DocType, Single) ->
	% Unpack the type of object parameter
	<<Type:8/unsigned-little, DocRest/binary>> = Rest,	
	
	% erlang:display("deserialize_elements_pl=============================="),
	% erlang:display(Type),	
	
	% Switch on type
	CurrentObject = case Type of
		16#2 ->
			% erlang:display("============================== String"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, Rest1/binary>> = DocRest,
			% Unpack the size of the string
			<<0, Size:32/unsigned-little, Rest2/binary>> = Rest1,
			% Remove 0 padding from cstring
			SSize = Size - 1,
			% Unpack the actual string
			<<String:SSize/binary, 0, FinalRest/binary>> = Rest2,
			% Create result depending on type
			pack_object(ResultType, Object, utf8(Name), utf8(String), DocType);
		16#E ->
			% erlang:display("============================== Symbol"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, Rest1/binary>> = DocRest,
			% Unpack the size of the string
			<<0, Size:32/unsigned-little, Rest2/binary>> = Rest1,
			% Remove 0 padding from cstring
			SSize = Size - 1,
			% Unpack the actual string
			<<String:SSize/binary, 0, FinalRest/binary>> = Rest2,
			% Create result depending on type
			pack_object(ResultType, Object, utf8(Name), binary_to_atom(String, utf8), DocType);
		16#1 ->
			% erlang:display("============================== Float"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, Rest1/binary>> = DocRest,
			% Read the float string
			<<0, Float:64/float-little, FinalRest/binary>> = Rest1,
			% Create result depending on type
			pack_object(ResultType, Object, utf8(Name), Float, DocType);
		16#10 ->
			% erlang:display("============================== 32 bit Integer"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, Rest1/binary>> = DocRest,
			% Read the float string
			<<0, Integer:32/signed-little, FinalRest/binary>> = Rest1,
			% Create result depending on type
			pack_object(ResultType, Object, utf8(Name), Integer, DocType);
		16#12 ->
			% erlang:display("============================== 64 bit Integer"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, Rest1/binary>> = DocRest,
			% Read the float string
			<<0, Integer:64/signed-little, FinalRest/binary>> = Rest1,
			% Create result depending on type
			pack_object(ResultType, Object, utf8(Name), Integer, DocType);
		16#03 ->
			% erlang:display("============================== Document"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, Rest1/binary>> = DocRest,
			% Read the document size
			<<0, Size:32/unsigned-little, _/binary>> = Rest1,
			% Unpack the actual doc
			<<0, DocBin:Size/binary, FinalRest/binary>> = Rest1,
			% Unpack the document
			Doc = deserialize_doc(DocBin, ResultType, doc),
			% Pack up the result
			pack_object(ResultType, Object, utf8(Name), Doc, DocType);
		16#04 ->
			% erlang:display("============================== Array"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, Rest1/binary>> = DocRest,
			% Read the document size
			<<0, Size:32/unsigned-little, _/binary>> = Rest1,
			% Unpack the actual doc
			<<0, DocBin:Size/binary, FinalRest/binary>> = Rest1,
			% Unpack the document
			Doc = deserialize_doc(DocBin, pl, array),
			% Pack up the result
			pack_object(ResultType, Object, utf8(Name), Doc, DocType);
		16#07 ->
			% erlang:display("============================== ObjectId"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, Rest1/binary>> = DocRest,
			% Read the document size
			<<0, ObjectId:12/binary, FinalRest/binary>> = Rest1,			
			% Pack up the result
			pack_object(ResultType, Object, utf8(Name), {objectid, ObjectId}, DocType);
		16#08 ->
			% erlang:display("============================== Boolean"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, Rest1/binary>> = DocRest,
			% Read the document size
			<<0, Boolean:1/binary, FinalRest/binary>> = Rest1,			
			% Set up the value
			if 
				Boolean == <<1>> ->
					BooleanValue = true;
				true ->
					BooleanValue = false
			end,			
			% Pack up the result
			pack_object(ResultType, Object, utf8(Name), BooleanValue, DocType);
		16#0A ->
			% erlang:display("============================== Null"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, 0, FinalRest/binary>> = DocRest,
			% Pack up the result
			pack_object(ResultType, Object, utf8(Name), null, DocType);
		16#09 ->
			% erlang:display("============================== Datetime"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, 0, Rest1/binary>> = DocRest,
			% Read the datetime 64bit value
			<<IntegerDateTime:64/unsigned-little, FinalRest/binary>> = Rest1,
			% Pack up the result
			pack_object(ResultType, Object, utf8(Name), bsom_time_to_timestamp(IntegerDateTime), DocType);
		16#0B ->
			% erlang:display("============================== Regexp"),
			% Locate the position of the cstring
			{Pos, _} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, 0, Rest1/binary>> = DocRest,
			% Locate the Regular expression text
			{RPos, _} = binary:match (Rest1, <<0>>),
			% Grab the Regular expression CString name
			<<RegExp:RPos/binary, 0, Rest2/binary>> = Rest1,
			% Locate the Regular switches
			{RSPos, _} = binary:match (Rest2, <<0>>),
			% Grab the Regular expression CString options
			<<RegExpOptions:RSPos/binary, 0, FinalRest/binary>> = Rest2,
			pack_object(ResultType, Object, utf8(Name), {regexp, utf8(RegExp), utf8(RegExpOptions)}, DocType);
		16#D ->
			% erlang:display("============================== Javascript"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, Rest1/binary>> = DocRest,
			% Unpack the size of the string
			<<0, Size:32/unsigned-little, Rest2/binary>> = Rest1,
			% Remove 0 padding from cstring
			SSize = Size - 1,
			% Unpack the actual string
			<<Javascript:SSize/binary, 0, FinalRest/binary>> = Rest2,
			% Create result depending on type
			pack_object(ResultType, Object, utf8(Name), javascript(utf8(Javascript)), DocType);
		16#5 ->
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, Rest1/binary>> = DocRest,
			% Unpack the size of the binary
			<<0, BinarySize:32/unsigned-little, SubType:8/unsigned-little, Rest2/binary>> = Rest1,
			% Read the actual binary data
			<<BinaryData:BinarySize/binary, FinalRest>> = Rest2,			
			% Create result depending on type
			pack_object(ResultType, Object, utf8(Name), bin(SubType, BinaryData), DocType);
		16#F ->
			% erlang:display("============================== Javascript with Scope"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, Rest1/binary>> = DocRest,
			% Unpack the size of the document with 
			<<0, Size:32/unsigned-little, _/binary>> = Rest1,
			% Grab the actual doc
			<<0, JsDoc:Size/binary, FinalRest/binary>> = Rest1,
			% Let's pull apart the JsDoc
			<<_:32, JSSize:32/unsigned-little, Rest3/binary>> = JsDoc,
			% Remove trailing CString 0
			JSSizeFinal = JSSize - 1,
			% Let's grab the javascript
			<<Javascript:JSSizeFinal/binary, 0, ScopeDocBin/binary>> = Rest3, 
			% Grab the scope bson document
			ScopeDoc = deserialize_doc(ScopeDocBin, ResultType, doc),
			% Create result depending on type
			pack_object(ResultType, Object, utf8(Name), javascript(utf8(Javascript), ScopeDoc), DocType);
		16#FF ->
			% erlang:display("============================== MinKey"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, 0, FinalRest/binary>> = DocRest,
			% Pack up the result
			pack_object(ResultType, Object, utf8(Name), minkey(), DocType);
		16#7F ->
			% erlang:display("============================== MaxKey"),
			% Locate the position of the cstring
			{Pos, _Len} = binary:match (DocRest, <<0>>),
			% Grab the CString name
			<<Name:Pos/binary, 0, FinalRest/binary>> = DocRest,
			% Pack up the result
			pack_object(ResultType, Object, utf8(Name), maxkey(), DocType);
		_ ->
			FinalRest = <<>>,
			[]
	end,

	% Keep parsing if we have more data left, we check against > 1 as the last byte is padding for the doc
	if
		(byte_size(FinalRest) > 1) and (Single == multi) ->
			% Keep processing
			deserialize_elements_pl(FinalRest, CurrentObject, ResultType, DocType, Single);
		true ->
			CurrentObject
	end.

pack_object(Type, Object, Key, Value, DocType) ->
	% erlang:display("=================================== pack_object"),
	% erlang:display(DocType),
	
	case Type of
		pl ->
			case DocType of
				array ->
					lists:merge([Value], Object);
				_ ->				
					lists:merge([{Key, Value}], Object)
			end;
		dict ->
			case DocType of
				array ->
					dict:append(Key, Value, Object);
				_ ->
					dict:store(Key, Value, Object)
			end;
		orddict ->
			case DocType of
				array ->
					orddict:append(Key, Value, Object);
				_ ->
					orddict:store(Key, Value, Object)
			end;			
		_ ->
			[]
	end.

%
% Utility methods
%
unixtime_to_secs({MegaSecs, Secs, _}) -> MegaSecs * 1000000 + Secs.
timenow() ->
	{MegaSecs, Secs, MicroSecs} = os:timestamp(),
	{MegaSecs, Secs, MicroSecs div 1000 * 1000}.

%@doc Fetch hostname and os pid and compress into a 5 byte id
oid_machineprocid() ->
	OSPid = list_to_integer (os:getpid()),
	{ok, Hostname} = inet:gethostname(),
	<<MachineId:3/binary, _/binary>> = erlang:md5 (Hostname),
	<<MachineId:3/binary, OSPid:16/big>>.

% Hex manipulation tools
hexstr_to_bin(S) ->
  hexstr_to_bin(S, []).
hexstr_to_bin([], Acc) ->
  list_to_binary(lists:reverse(Acc));
hexstr_to_bin([X,Y|T], Acc) ->
  {ok, [V], []} = io_lib:fread("~16u", [X,Y]),
  hexstr_to_bin(T, [V | Acc]).

% Timestamp conversions
timestamp_to_bson_time({MegaSecs, Seconds, MicroSec}) ->
	MegaSecs * 1000000 * 1000000 + Seconds * 1000000 + MicroSec.

bsom_time_to_timestamp(Timestamp) ->
	{Timestamp div 1000000000000, Timestamp div 1000000 rem 1000000, Timestamp rem 1000000}.

%
%	Types
%
	
% Utf8 string representation
-type utf8() :: unicode:unicode_binary().
% Conversion method for string to utf8 binary, bson required utf8 strings
-spec utf8 (unicode:chardata()) -> utf8().
%@doc Convert string to utf8 binary. string() is a subtype of unicode:chardata().
utf8 (CharData) -> case unicode:characters_to_binary (CharData) of
	{error, _Bin, _Rest} -> erlang:error (unicode_error, [CharData]);
	{incomplete, _Bin, _Rest} -> erlang:error (unicode_incomplete, [CharData]);
	Bin -> Bin end.

% Regular expression type
-type regexp() :: {regexp, utf8(), utf8()}.
% Create Regular expression function
-spec regexp (unicode:chardata(), unicode:chardata()) -> regexp().
%@doc Convert regular expression to regexp object
regexp (CharData, OptionData) -> {regexp, utf8(CharData), utf8(OptionData)}.

% Maxkey expression type
-type maxkey() :: {maxkey}.
% Create Regular expression function
-spec maxkey () -> maxkey().
%@doc Convert maxkey to maxkey expression
maxkey () -> {maxkey}.

% Minkey expression type
-type minkey() :: {minkey}.
% Create Regular expression function
-spec minkey () -> minkey().
%@doc Convert maxkey to maxkey expression
minkey () -> {minkey}.

% Binary expression type
-type bin() :: {bin, integer(), binary()}.
% Create Binary function with subtype
-spec bin (integer(), binary()) -> bin().
%@doc Create Binary type with user decided subtype
bin (SubType, Binary) -> {bin, SubType, Binary}.
% Create Binary function with default subtype
-spec bin(binary()) -> bin().
%@doc Create Binary type with default subtype
bin (Binary) -> {bin, 0, Binary}.

% Javascript expression type
-type javascript() :: {js, utf8()}.
% Create Regular expression function
-spec javascript (unicode:chardata()) -> javascript().
%@doc Convert maxkey to maxkey expression
javascript (Code) -> {js, Code}.

% Javascript expression type
-type javascript_w_scope() :: {js, utf8(), _}.
% Create Regular expression function
-spec javascript (unicode:chardata(), _) -> javascript_w_scope().
%@doc Convert maxkey to maxkey expression
javascript (Code, Scope) -> {js, Code, Scope}.

% ObjectId type
-type objectid() :: {objectid, <<_:96>>}.
% Create objectid
-spec objectid(integer(), <<_:40>>, integer()) -> objectid().
%@doc Create objectid
objectid(UnixSeconds, MachineAndProcId, Count) ->
	{objectid, <<UnixSeconds :32/big, MachineAndProcId :5/binary, Count :24/big>>}.

-spec objectid(string()) -> objectid().
objectid(HexString) ->
	{objectid, hexstr_to_bin(HexString)}.

%@doc Fresh object id
-spec gen_objectid(fun()) -> objectid().
gen_objectid(CounterFun) ->
	Now = unixtime_to_secs(timenow()),
	MPid = oid_machineprocid(),
	N = CounterFun(),
	objectid (Now, MPid, N).



