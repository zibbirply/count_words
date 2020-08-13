CLASS zcl_count_words DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.
  METHODS input_sentence
    IMPORTING
      iv_sentence TYPE string.
  METHODS output_count
    RETURNING
      VALUE(rv_count) TYPE i.
PROTECTED SECTION.
PRIVATE SECTION.
    METHODS calculate_count.

    DATA: gv_sentence TYPE string
          , gv_count TYPE i.
ENDCLASS.



CLASS zcl_count_words IMPLEMENTATION.

  METHOD input_sentence.

    gv_sentence = iv_sentence.
    me->calculate_count(  ).

  ENDMETHOD.


  METHOD output_count.

    rv_count = gv_count.

  ENDMETHOD.

  METHOD calculate_count.

*    gv_count = 1.
*
*    REPLACE ALL OCCURRENCES OF '  ' IN gv_sentence WITH ' '.
*
*    find FIRST OCCURRENCE OF ' ' IN gv_sentence MATCH OFFSET data(lv_firstspace).
*
*    if lv_firstspace = 1.
*        gv_count -= 1.
*    ENDIF.
*
*       gv_count += count_any_of( val = gv_sentence sub = | | ).

    DATA: lt_letters TYPE TABLE OF string.

    lt_letters = VALUE #(
      FOR i = 0 UNTIL i >= strlen( gv_sentence ) (
        gv_sentence+i(1)
      )
    ).

    DATA(lv_last_letter_was_space) = abap_true.

    DO strlen( gv_sentence ) TIMES.

        IF lt_letters[ sy-index ] <> | |
        AND lv_last_letter_was_space = abap_true.
            gv_count += 1.
        ENDIF.

        IF lt_letters[ sy-index ] = | |.
            lv_last_letter_was_space = abap_true.
        ELSE.
            lv_last_letter_was_space = abap_false.
        ENDIF.

    ENDDO.

  ENDMETHOD.

ENDCLASS.
