*&---------------------------------------------------------------------*
*& Report zcl_input_output_ze
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcl_input_output_ze.

DATA: lv_input TYPE string
      , cut TYPE REF TO zcl_count_words.

cut = NEW zcl_count_words(  ).

cl_demo_input=>request(
  EXPORTING
    text        = |Type a random sentence:|
    as_checkbox = abap_false
  CHANGING
    field       = lv_input
).

WRITE: | The amount words in '{ lv_input }' is { cut->count_words( lv_input ) } |.
