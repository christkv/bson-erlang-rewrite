% Module definition
-module(bson).

% Exported functions for the bson parser
-export ([serialize/1, deserialize/1]).
-export ([utf8/1]).

% Exporting all availble types
-export_type ([utf8/0]).

% Calculate the size of the document so we can do a single allocation of a binary
calculate_document_size(Doc) -> 
	% Return the size of the document we passed in
	4 + 1 + calculate_document_size_objects(Doc).

calculate_document_size_objects([Head|Tail]) ->
	erlang:display("================================== calculate_document_size"),
	erlang:display(Head),
	
	case Head of
		{Name, [Value]} when is_binary(Name), is_binary(Value) -> 			
			erlang:display("================================== calculate_document_size string"),
			% "\x02" cstring int32 cstring"
			1 + (byte_size(Name) + 1) + 4 + (byte_size(Value) + 1);
		_ -> calculate_document_size(Tail)
	end;
calculate_document_size_objects([]) ->
	erlang:display("================================== calculate_document_size end"),
	0.
	% % Keys = orddict:keys(Doc),
	% Sizes = orddict:map(fun(X, Y) -> 
	% 	X
	% end, Doc),
	% erlang:display(Sizes),
	% 0.

% Serialize document
serialize(Doc) ->
	erlang:display(Doc),
	Size = calculate_document_size(Doc),
	erlang:display(Size),
	<<>>.
	
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
