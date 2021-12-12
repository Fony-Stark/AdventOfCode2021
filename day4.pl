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

	Lines = [Draw | Raw_input],
    Raw_input = [EmptyLine | Raw_boards],
	board_process(Raw_boards, [], Boards),
    Boards = [B | S],
    write(B).
	%winning_board(Boards, Draw, Score).

board_process([], CBoard, [CBoard]).
board_process([Raw | Raws], CBoard, [CBoard | Boards]):-
    Raw = "",
    board_process(Raws, [], Boards).
board_process([Raw | Raws], CBoard, Boards):-
    process_line(Raw, CB),
    append(CBoard, CB, CBBoard),
    board_process(Raws, CBBoard, Boards).

process_line(String, List):-
    split_string(String, " ", "", NString),
    delete(NString, "", LongList),
    length(LongList, LongLength),
    Raw_length is sqrt(LongLength),
    round(Raw_length, Length),
    space_out(LongList, 0, Length, List).