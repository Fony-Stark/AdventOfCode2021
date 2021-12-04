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

change(Instrunction, Change, Depth, Forward, Depth, TForward):-
	sub_string(Instrunction, _, _, _, "forward"),
	TForward is Forward + Change, !.
change(Instrunction, Change, Depth, Forward, TDepth, Forward):-
	sub_string(Instrunction, _, _, _, "up"),
	TDepth is Depth - Change, !.
change(Instrunction, Change, Depth, Forward, TDepth, Forward):-
	sub_string(Instrunction, _, _, _, "down"),
	TDepth is Depth + Change, !.

direction([], Depth, Forward, Depth, Forward).
direction([Line | Lines], Temp_depth, Temp_forward, Depth, Forward):-
	split_string(Line, " ", "", X),
	[Intrstuction, Number] = X,
	atom_number(Number, Change),
	change(Intrstuction, Change, Temp_depth, Temp_forward, Temp_depth_change, Temp_forward_change),
	direction(Lines, Temp_depth_change, Temp_forward_change, Depth, Forward).

charles_part1(X):-
	findall(Line, file_line("Day2Input.txt", Line), Lines),
	direction(Lines, 0, 0, Depth, Forward),
	X is Depth * Forward.



change_part2(Instrunction, Change, Depth, Forward, Aim, TDepth, TForward, Aim):-
	sub_string(Instrunction, _, _, _, "forward"),
	TForward is Forward + Change, 
	TDepth is Change * Aim + Depth,
	!.
change_part2(Instrunction, Change, Depth, Forward, Aim, Depth, Forward, New_aim):-
	sub_string(Instrunction, _, _, _, "up"),
	New_aim is Aim - Change, !.
change_part2(Instrunction, Change, Depth, Forward, Aim, Depth, Forward, New_aim):-
	sub_string(Instrunction, _, _, _, "down"),
	New_aim is Aim + Change, !.

direction_part2([], Depth, Forward, _, Depth, Forward).
direction_part2([Line | Lines], Temp_depth, Temp_forward, Aim, Depth, Forward):-
	split_string(Line, " ", "", X),
	[Intrstuction, Number] = X,
	atom_number(Number, Change),
	change_part2(Intrstuction, Change, Temp_depth, Temp_forward, Aim, Temp_depth_change, Temp_forward_change, New_aim),
	direction_part2(Lines, Temp_depth_change, Temp_forward_change, New_aim, Depth, Forward).

charles_part2(X):-
	findall(Line, file_line("Day2Input.txt", Line), Lines),
	direction_part2(Lines, 0, 0,0, Depth, Forward),
	X is Depth * Forward.