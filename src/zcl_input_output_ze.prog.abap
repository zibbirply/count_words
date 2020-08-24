*&---------------------------------------------------------------------*
*& Report zcl_input_output_ze
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcl_input_output_ze.

DATA: lv_input          TYPE string
      , lv_taboo_string  TYPE string
      , cut             TYPE REF TO zcl_count_words_ze
      , lt_read_out_txt TYPE TABLE OF string
      .

cut = NEW zcl_count_words_ze(  ).

      CALL METHOD cl_gui_frontend_services=>gui_upload
        EXPORTING
          filename                = 'C:\USERS\Z.ELBOUJATTOUI\DOCUMENTS\TABOO_WORDS.TXT'
        CHANGING
          data_tab                = lt_read_out_txt
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
          DO lines( lt_read_out_txt ) TIMES.
            lv_taboo_string = |{ lv_taboo_string } { lt_read_out_txt[ sy-index ] }|.
          ENDDO.
          lv_taboo_string = condense( lv_taboo_string ).
      ENDIF.

cl_demo_input=>request(
  EXPORTING
    text        = |Type a random sentence (dont get too corny):|
    as_checkbox = abap_false
  CHANGING
    field       = lv_input
).

cut->count_words(
EXPORTING
    iv_sentence     = lv_input
    iv_taboo_words  = lv_taboo_string
RECEIVING
    rv_count        = DATA(lv_result)
).

WRITE: | The amount of words in '{ lv_input }' is: { lv_result } |.
