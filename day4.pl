:- use_module(library(clpfd)).

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

	Lines = [Raw_draw | Raw_input],
    string_concat("2,", Raw_draw, Raw_draw_with_buffer),
    process_line(Raw_draw_with_buffer, ",", Draw),
    Raw_input = [_ | Raw_boards],

    board_process(Raw_boards, [], Boards),
	winning_board(Boards, Draw, Score).

board_process([], CBoard, [CBoard]).
board_process([Raw | Raws], CBoard, [CBoard | Boards]):-
    Raw = "",
    board_process(Raws, [], Boards).
board_process([Raw | Raws], CBoard, Boards):-
    process_line(Raw, " ", CB),
    append(CBoard, [CB], CBBoard),
    board_process(Raws, CBBoard, Boards).

process_line(String, Char, List):-
    split_string(String, Char, "", NString),
    delete(NString, "", Raw_List),
    process_list(Raw_List, List).

process_list([], []).
process_list([Raw | Raws], [L | List]):-
    process_list(Raws, List),
    atom_number(Raw, L).

winning_board(Boards, [Input], Score):-
    check_for_win(Boards, SumBoard),
    Score is SumBoard * Input.
winning_board(Boards, [Input | _], Score):-
    check_for_win(Boards, SumBoard),
    Score is SumBoard * Input.
winning_board(Boards, [_, Input | Inputs], Score):-
    take_input(Boards, Input, New_Boards),
    winning_board(New_Boards, [Input | Inputs], Score).

take_input([], _, []).
take_input([Board | Boards], Input, [Nboard | New_Boards]):-
    take_input(Boards, Input, New_Boards),
    take_input_board(Board, Input, Nboard).

take_input_board([], _, []).
take_input_board([Line | Lines], Input, [NLine | NLines]):-
    take_input_line(Line, Input, NLine),
    take_input_board(Lines, Input, NLines).

take_input_line([], _, []).
take_input_line([X | Xs], X, ["X" | Ys]):-
    take_input_line(Xs, X, Ys).
take_input_line([X | Xs], Input, [X | Ys]):-
    take_input_line(Xs, Input, Ys).

check_for_win([], _):-
    fail.
check_for_win([Board | _], Score):-
    check_win_row(Board),
    calc_board(Board, 0, Score).
check_for_win([Board | _], Score):-
    check_win_column(Board),
    calc_board(Board, 0, Score).
check_for_win([_ | Boards], Score):-
    check_for_win(Boards, Score).

check_win_row([]):-
    fail.
check_win_row([Line | _]):-
    check_row(Line).
check_win_row([_ | Lines]):-
    check_win_row(Lines).

check_row([]).
check_row(["X" | Xs]):-
    check_row(Xs).

check_win_column(Board):-
    transpose(Board, TBoard),
    check_win_row(TBoard).

calc_board([], Score, Score).
calc_board([Line | Lines], Temp, Score):-
    calc_line(Line, Temp, Temp1),
    calc_board(Lines, Temp1, Score).

calc_line([], Score, Score).
calc_line(["X" | Xs], Temp, Score):-
    calc_line(Xs, Temp, Score).
calc_line([X | Xs], Temp, Score):-
    Temp1 is X + Temp,
    calc_line(Xs, Temp1, Score).


charles_part2(Score):-
    findall(Line, file_line("Day4Input.txt", Line), Lines),

	Lines = [Raw_draw | Raw_input],
    string_concat("2,", Raw_draw, Raw_draw_with_buffer),
    process_line(Raw_draw_with_buffer, ",", Draw),
    Raw_input = [_ | Raw_boards],

    board_process(Raw_boards, [], Boards),
	winning_board2(Boards, Draw, Score).

winning_board2(Boards, Inputs, Score):-
    length(Boards, 1),
    winning_board(Boards, Inputs, Score).
winning_board2(Boards, [_, Input | Inputs], Score):-
    check_for_win2(Boards, NBoards),
    take_input(NBoards, Input, New_Boards),
    winning_board2(New_Boards, [Input | Inputs], Score).

check_for_win2([], []).
check_for_win2([Board | Boards], NBoards):-
    check_win_row(Board),
    check_for_win2(Boards, NBoards).
check_for_win2([Board | Boards], NBoards):-
    check_win_column(Board),
    check_for_win2(Boards, NBoards).
check_for_win2([Board | Boards], [Board | NBoards]):-
    check_for_win2(Boards, NBoards).