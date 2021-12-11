file_line(File, Line) :-
    setup_call_cleanup(open(File, read, In),
        stream_line(In, Line),
        close(In)).

stream_line(In, Line) :-
    repeat,
    (   read_line_to_string(In, Line0),
        Line0 \== end_of_file
    ->  Line0 = Line
    ;   !,
        fail
    ).

sub_const([], _, []).
sub_const([X | List], C, [Y | Res]):-
	sub_const(List, C, Res),
	Y is X - C.

string_list(Line, List):-
	string_to_list(Line, Letters),
	sub_const(Letters, 48, List).

add_list([], [], []).
add_list([X | Xs], [Y | Ys], [Z | Zs]):-
	add_list(Xs, Ys, Zs),
	Z is X + Y.

count([], Length, Xs):-
	length(Xs, Length),
	fill_me(Xs).
count([X | Lines], Length, Eps):-
	count(Lines, Length, Eps1),
	string_list(X, Xs),
	
	add_list(Xs, Eps1, Eps).

fill_me([]).
fill_me([X | Xs]):-
	X = 0,
	fill_me(Xs).

list_to_Eps(Epsilon, Epsilon, _, []).
list_to_Eps(Epsilon, Temp, Thresshold, [X | Eps]):-
	X > Thresshold,
	
	length(Eps, Power),
	pow(2, Power, Res),
	Temp1 is Temp + Res,
	
	list_to_Eps(Epsilon, Temp1, Thresshold, Eps).
list_to_Eps(Epsilon, Temp, Thresshold, [_ | Eps]):-
	list_to_Eps(Epsilon, Temp, Thresshold, Eps).

epsilon(Epsilon, Lines):-
	length(Lines, Length),
	Thresshold is Length / 2,
	
	Lines = [LLine | _],
	string_to_list(LLine, Xs),
	length(Xs, LL),

	count(Lines, LL, Counter),
	list_to_Eps(Epsilon, 0, Thresshold, Counter).

charles_part1(X):-
	findall(Line, file_line("Day3Input.txt", Line), Lines),
	epsilon(Epsilon, Lines),
	
	Lines = [LLine | _],
	string_to_list(LLine, Xs),
	length(Xs, LL),
	pow(2, LL, Temp),
	Max is Temp - 1,
	
	Gamma is Max - Epsilon,
	X is Gamma * Epsilon.



charles_part2(X):-
	findall(Line, file_line("Day3Input.txt", Line), Lines),
	oxygen_level(Oxygen, Lines),
	co2_level(Co2, Lines),
	X is Co2 * Oxygen.

oxygen_level(Oxygen, Lines):-
	el(Lines, 0, 0, Final_line),
	string_to_list(Final_line, List),
	sub_const(List, 48, List1),
	write(Final_line), nl,
	list_to_Eps(Oxygen, 0, 0, List1).

co2_level(Co2, Lines):-
	el(Lines, 0, 1, Final_line),
	string_to_list(Final_line, List),
	sub_const(List, 48, List1),
	write(Final_line), nl,
	list_to_Eps(Co2, 0, 0, List1).

el([Line], _, _, Line).
el(Lines, Index, Direction, Line):-
	Lines = [LLine | _],
	string_to_list(LLine, Xs),
	length(Xs, LL),

	length(Lines, Length),
	Thresshold is Length / 2,

	count(Lines, LL, Counter),
	find_goals(Counter, Direction, Thresshold, Goals),
	nth0(Index, Goals, Goal),

	find_fits(Lines, Index, Goal, Fits),
	
	Index2 is Index + 1,
	el(Fits, Index2, Direction, Line).

find_goals([], _, _, []).
find_goals([C | Cs], D, Thresshold, [G | Gs]):-
	D =:= 0,
	C >= Thresshold,
	G is 1,
	find_goals(Cs, D, Thresshold, Gs).
find_goals([C | Cs], D, Thresshold, [G | Gs]):-
	D =:= 1,
	C < Thresshold,
	G is 1,
	find_goals(Cs, D, Thresshold, Gs).
find_goals([_ | Cs], D, Thresshold, [G | Gs]):-
	G is 0,
	find_goals(Cs, D, Thresshold, Gs).

find_fits([], _, _, []).
find_fits([Line | Lines], Index, Goal, [Fit | Fits]):-
	string_list(Line, List),
	nth0(Index, List, Element),
	Element =:= Goal,
	Fit = Line,
	find_fits(Lines, Index, Goal, Fits).
find_fits([_ | Lines], Index, Goal, Fits):-
	find_fits(Lines, Index, Goal, Fits).