% Module definition
-module(bson).

% Exported functions for the bson parser
-export ([serialize/1, deserialize/1]).
-export ([utf8/1, regexp/2, gen_objectid/1, objectid/1, objectid/3, timestamp_to_bson_time/1, bsom_time_to_timestamp/1]).

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
			list_to_binary([<<?put_int32(byte_size(Bin) + 4 + 1)>>, Bin, <<0>>]);
		_ ->
			% Create final binary
			Bin = list_to_binary(serialize_doc_objects(Doc)),
			% Add document header
			list_to_binary([<<?put_int32(byte_size(Bin) + 4 + 1)>>, Bin, <<0>>])
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
	case FinalHeadValue of				
		{Name, {regexp, RegExp, Options}} when is_binary(Name) ->
			% erlang:display("================================== serialize regexp"),
			[list_to_binary([<<16#0B>>, Name, <<0>>, RegExp, <<0>>, Options, <<0>>])];
		{Name, {objectid, ObjectId}} when is_binary(Name), is_binary(ObjectId) ->
			% erlang:display("================================== serialize objectid"),
			[list_to_binary([<<16#07>>, Name, <<0>>, ObjectId])];
		{Name, undefined} when is_binary(Name) ->
			% erlang:display("================================== serialize undefined"),
			[list_to_binary([<<16#0A>>, Name, <<0>>])];
		{Name, null} when is_binary(Name) ->
			% erlang:display("================================== serialize null"),
			[list_to_binary([<<16#0A>>, Name, <<0>>])];
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
			[list_to_binary([<<16#0E>>, Name, <<0>>, <<?put_int32(byte_size(ValueBin) + 1)>>, ValueBin, <<0>>])];
		{Name, [[Value]]} when is_binary(Name), is_tuple(Value) -> 			
			% erlang:display("================================== serialize object"),			
			% trigger serialization of all the values
			[Object] = serialize_doc_objects([Value]),
			[list_to_binary([<<16#03>>, Name, <<0>>, <<?put_int32(4 + byte_size(Object) + 1)>>, Object, <<0>>])];
		{Name, [Value]} when is_binary(Name), is_list(Value) -> 			
			% erlang:display("================================== serialize array"),
			% Serialize the array
			BinDoc = serialize_array(0, Value),			
			% trigger serialization of all the values
			[list_to_binary([<<16#04>>, Name, <<0>>, <<?put_int32(4 + byte_size(BinDoc) + 1)>>, BinDoc, <<0>>])];
		{Name, Value} when is_binary(Name), is_binary(Value) ->
			[list_to_binary([<<16#02>>, Name, <<0>>, <<?put_int32(byte_size(Value) + 1)>>, Value, <<0>>])];			
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
			[list_to_binary([<<16#03>>, Name, <<0>>, <<?put_int32(4 + byte_size(Object) + 1)>>, Object, <<0>>])];
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
			[list_to_binary([<<16#02>>, Name, <<0>>, <<?put_int32(byte_size(Value) + 1)>>, Value, <<0>>])];
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
			[list_to_binary([<<16#0E>>, Name, <<0>>, <<?put_int32(byte_size(ValueBin) + 1)>>, ValueBin, <<0>>])];
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
			[list_to_binary([<<16#04>>, Name, <<0>>, <<?put_int32(4 + byte_size(BinDoc) + 1)>>, BinDoc, <<0>>])];
		_ -> 
			% erlang:display("================================== serialize done"),			
			serialize_doc_objects(Tail)
	end;
serialize_doc_objects([]) -> [].

% Serialize an array of values using the code for all the other types
serialize_array(Number, [Head|Tail]) ->
	list_to_binary([serialize_doc_objects([{utf8(integer_to_list(Number)), [Head]}]), serialize_array(Number + 1, Tail)]);
serialize_array(_, []) -> [].

% Deserialize document
deserialize(_BinDoc) ->
	[].

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



