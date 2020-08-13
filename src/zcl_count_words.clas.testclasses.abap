*"* use this source file for your ABAP unit test classes
CLASS ltcl_count_words DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
  DATA: cut TYPE REF TO zcl_count_words.

    METHODS:
      setup,
      test_output FOR TESTING RAISING cx_static_check,
      input_hello_darling_output_2 FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_count_words IMPLEMENTATION.

  METHOD setup.

    cut = NEW zcl_count_words(  ).

  ENDMETHOD.

  METHOD test_output.
    cl_abap_unit_assert=>assert_equals( msg = 'Initialize input of sentence and output of count'
                                        exp = 0
                                        act = cut->output_count(  ) ).
  ENDMETHOD.

  METHOD input_hello_darling_output_2.
    cut->input_sentence( 'hello darling' ).
    cl_abap_unit_assert=>assert_equals( msg = 'Do the first test of input-output relation'
                                        exp = 2
                                        act = cut->output_count(  ) ).
  ENDMETHOD.



ENDCLASS.
