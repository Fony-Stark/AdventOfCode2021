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

charles_part1(Score):-
	findall(Line, file_line("Day4Input.txt", Line), Lines),
	
	Lines = [Draw | Raw_boards],
	board_process(Raw_boards, Boards),

	winning_board(Boards, Draw, Score).