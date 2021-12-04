file_line(File, Integer) :-
    setup_call_cleanup(open(File, read, In),
        stream_line(In, Line),
        close(In)),
		atom_number(Line, Integer).

stream_line(In, Line) :-
    repeat,
    (   read_line_to_string(In, Line0),
        Line0 \== end_of_file
    ->  Line0 = Line
    ;   !,
        fail
    ).

differences([_], X, Y, X, Y).
differences([X, Y | Xs], Temp_incress, Temp_decress, Incress, Decress):-
	X < Y,
	Temp_incress_new is Temp_incress + 1,
	differences([Y | Xs], Temp_incress_new, Temp_decress, Incress, Decress).
differences([X, Y | Xs], Temp_incress, Temp_decress, Incress, Decress):-
	X > Y,
	Temp_decress_new is Temp_decress + 1,
	differences([Y | Xs], Temp_incress, Temp_decress_new, Incress, Decress).

charles_part1(Incress, Decress):-
	findall(Line, file_line("Day1Input.txt", Line), Lines),
	differences(Lines, 0, 0, Incress, Decress).



differences_part2([_, _, _], X, Y, X, Y).
differences_part2([X, Y, Z, M | Xs], Temp_incress, Temp_decress, Incress, Decress):-
	Sum1 is X + Y + Z,
	Sum2 is Y + Z + M,
	Sum1 < Sum2,
	Temp_incress_new is Temp_incress + 1,
	differences_part2([Y, Z, M | Xs], Temp_incress_new, Temp_decress, Incress, Decress).
differences_part2([X, Y, Z, M | Xs], Temp_incress, Temp_decress, Incress, Decress):-
	Sum1 is X + Y + Z,
	Sum2 is Y + Z + M,
	Sum1 > Sum2,
	Temp_decress_new is Temp_decress + 1,
	differences_part2([Y, Z, M | Xs], Temp_incress, Temp_decress_new, Incress, Decress).
differences_part2([X, Y, Z, M | Xs], Temp_incress, Temp_decress, Incress, Decress):-
	Sum1 is X + Y + Z,
	Sum2 is Y + Z + M,
	Sum1 =:= Sum2,
	differences_part2([Y, Z, M | Xs], Temp_incress, Temp_decress, Incress, Decress).


charles_part2(Incress, Decress):-
	findall(Line, file_line("Day1Input.txt", Line), Lines),
	differences_part2(Lines, 0, 0, Incress, Decress).