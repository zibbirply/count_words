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
      value(rv_count) TYPE i.
PROTECTED SECTION.
PRIVATE SECTION.
    METHODS calculate_count.

    DATA: gv_sentence type string
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

    DATA: lt_letters TYPE char1.

       gv_count = 1 + count_any_of( val = gv_sentence sub = | | ).

  ENDMETHOD.

ENDCLASS.
