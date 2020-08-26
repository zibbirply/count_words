*&---------------------------------------------------------------------*
*& Report zcl_input_output_ze
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_input_output_ze.

******************************************************************************************************
**                                        DATA DECLARATION                                          **
******************************************************************************************************
DATA: cut                   TYPE REF TO zcl_count_words_ze

      " Taboo words
      , lt_read_taboo_txt   TYPE TABLE OF string
      , lv_taboo_string     TYPE string

      " Dictionary words
      , lt_read_dict_txt    TYPE TABLE OF string
      , lv_dict_string      TYPE string

      " And our input
      , lt_read_input_txt   TYPE TABLE OF string
      , lv_input            TYPE string
      , lt_input            TYPE TABLE OF string

      " ... oh and these are necessary in general, whenever you use the 'gui_upload' method :)
      , gt_filetable        TYPE filetable
      , gv_return           TYPE i

      .

SELECTION-SCREEN BEGIN OF BLOCK eins.
    PARAMETERS p_fname      TYPE string.
SELECTION-SCREEN END OF BLOCK eins.

cut = NEW zcl_count_words_ze(  ).
******************************************************************************************************
**                                    END OF DATA DECLARATION                                       **
******************************************************************************************************


******************************************************************************************************
**                                 READ TABOO & DICTIONARY WORDS                                    **
******************************************************************************************************
CALL METHOD cl_gui_frontend_services=>gui_upload
  EXPORTING
    filename                = 'C:\USERS\Z.ELBOUJATTOUI\DOCUMENTS\ABAP_CODING_DOJO\TABOO_WORDS.TXT'
  CHANGING
    data_tab                = lt_read_taboo_txt
  EXCEPTIONS
    file_open_error         = 1
    file_read_error         = 2
    no_batch                = 3
    gui_refuse_filetransfer = 4
    invalid_type            = 5
    no_authority            = 6
    unknown_error           = 7
    bad_data_format         = 8
    header_not_allowed      = 9
    separator_not_allowed   = 10
    header_too_long         = 11
    unknown_dp_error        = 12
    access_denied           = 13
    dp_out_of_memory        = 14
    disk_full               = 15
    dp_timeout              = 16
    not_supported_by_gui    = 17
    error_no_gui            = 18
    OTHERS                  = 19
.

IF sy-subrc <> 0.
  " Error Handling
ELSE.
    DO lines( lt_read_taboo_txt ) TIMES.
      lv_taboo_string = |{ lv_taboo_string } { lt_read_taboo_txt[ sy-index ] }|.
    ENDDO.
    lv_taboo_string = condense( lv_taboo_string ).
ENDIF.


CALL METHOD cl_gui_frontend_services=>gui_upload
  EXPORTING
    filename                = 'C:\USERS\Z.ELBOUJATTOUI\DOCUMENTS\ABAP_CODING_DOJO\DICT.TXT'
  CHANGING
    data_tab                = lt_read_dict_txt
  EXCEPTIONS
    file_open_error         = 1
    file_read_error         = 2
    no_batch                = 3
    gui_refuse_filetransfer = 4
    invalid_type            = 5
    no_authority            = 6
    unknown_error           = 7
    bad_data_format         = 8
    header_not_allowed      = 9
    separator_not_allowed   = 10
    header_too_long         = 11
    unknown_dp_error        = 12
    access_denied           = 13
    dp_out_of_memory        = 14
    disk_full               = 15
    dp_timeout              = 16
    not_supported_by_gui    = 17
    error_no_gui            = 18
    OTHERS                  = 19
.

IF sy-subrc <> 0.
  " Error Handling
ELSE.
    DO lines( lt_read_dict_txt ) TIMES.
      lv_dict_string = |{ lv_dict_string } { lt_read_dict_txt[ sy-index ] }|.
    ENDDO.
    lv_dict_string = condense( lv_dict_string ).
ENDIF.
******************************************************************************************************
**                             END OF READ TABOO & DICTIONARY WORDS                                 **
******************************************************************************************************


******************************************************************************************************
**                                      SELECTION SCREEN                                            **
******************************************************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fname.

" 1st Screen: select a file with your input sentence
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    CHANGING
      file_table              = gt_filetable
      rc                      = gv_return
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.

  READ TABLE gt_filetable INTO DATA(gv_filetable) INDEX 1.
  p_fname = gv_filetable.

START-OF-SELECTION.

" If no file was chosen, then...
" 2nd Screen: Type in your sentence
IF p_fname IS INITIAL.

    cl_demo_input=>request(
        EXPORTING
            text        = |Type a random sentence (dont get too corny):|
            as_checkbox = abap_false
        CHANGING
            field       = lv_input
    ).
    APPEND lv_input TO lt_input.
    CLEAR lv_input.

" Iteration 9: Infinity Input
    WHILE p_fname IS INITIAL.
        cl_demo_input=>request(
            EXPORTING
                text        = |Type a random sentence (dont get too corny):|
                as_checkbox = abap_false
            CHANGING
                field       = lv_input
        ).

        IF lv_input IS INITIAL.
            EXIT. " Stopped by an empty box
        ELSE.
            APPEND lv_input TO lt_input. " Otherwise store it in a table with all our inputs
            CLEAR lv_input.
        ENDIF.
    ENDWHILE.

" But if a file was chosen in the 1st screen, then then will be no entering of a text
ELSE.
    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = p_fname
      CHANGING
        data_tab                = lt_read_input_txt
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19
    .

    IF sy-subrc <> 0.
        " Error Handling
    ELSE.
        " Put the sentence, which is currently stored word by word in a table, in one string variable
        DO lines( lt_read_input_txt ) TIMES.
          lv_input = |{ lv_input } { lt_read_input_txt[ sy-index ] }|.
        ENDDO.
        lv_input = condense( lv_input ). " We don't need any unnecessary spaces in our string value.
        APPEND lv_input TO lt_input.
    ENDIF.

ENDIF.
******************************************************************************************************
**                                     END OF SELECTION SCREEN                                      **
******************************************************************************************************


******************************************************************************************************
**                                             OUTPUT                                               **
******************************************************************************************************
" Now we need to do something with all our cool sentences:
LOOP AT lt_input INTO lv_input. " Everything from now on will, be done once for every sentence in our table

    WRITE: |Input NO. { sy-tabix }|.

    " Here we call the method, which is doing all the cool calculation stuff
    cut->count_words(
        EXPORTING
            iv_sentence     = lv_input
            iv_taboo_words  = lv_taboo_string
            iv_dict         = lv_dict_string
        RECEIVING
            rv_count        = DATA(lv_result)
    ).

    WRITE: / | Input: '{ lv_input }' |.
    WRITE: / | Amount of words: { lv_result } |.
    WRITE: / | Unique: { cut->count_unique_words(  ) } |.
    WRITE: / | Average word length: { cut->count_average_word_length(  ) } |.

    " We'll need it as a table for the index output
    SPLIT lv_input AT | | INTO TABLE DATA(lt_index).

    " indexes are usually sorted by alphabet :)
    SORT lt_index.

    WRITE / | Index (Unknown: { cut->check_dict(  ) }): |. " The check-dictionary-method knows our sentence(s), because its sister-method 'count_words' was already called
    DO lines( lt_index ) TIMES.
        WRITE: / |   { lt_index[ sy-index ] } |. " Which round of our do-loop is now? Nevermind, I think I'll check the sy-index. He's always counting. :)
    ENDDO.

    " Clearing the variables during a loop, is not always necessary, but a good thing to avoid inconsistency in general :)
    CLEAR lt_index.
    CLEAR lv_input.
    CLEAR lv_result.
    " Just for the visual paragraph
    SKIP.
    SKIP.
    SKIP.

ENDLOOP.

CLEAR lt_input.
******************************************************************************************************
**                                        END OF OUTPUT                                             **
******************************************************************************************************
