*"* use this source file for your ABAP unit test classes
CLASS ltcl_count_words DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
  DATA: cut TYPE REF TO zcl_count_words.

    METHODS:
      setup,
      test_output FOR TESTING RAISING cx_static_check,
      input_hello_darling_output_2 FOR TESTING RAISING cx_static_check,
      input_fcfs_count_4 FOR TESTING RAISING cx_static_check,
      unnecessary_spaces FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_count_words IMPLEMENTATION.

  METHOD setup.

    cut = NEW zcl_count_words(  ).

  ENDMETHOD.

  METHOD test_output.
    cl_abap_unit_assert=>assert_equals( msg = 'Initialize input of sentence and output of count'
                                        exp = 0
                                        act = cut->count_words( '' ) ).
  ENDMETHOD.

  METHOD input_hello_darling_output_2.
    cl_abap_unit_assert=>assert_equals( msg = 'Do the first test of input-output relation'
                                        exp = 2
                                        act = cut->count_words( 'hello darling' ) ).
  ENDMETHOD.

  METHOD input_fcfs_count_4.
    cl_abap_unit_assert=>assert_equals( msg = 'second test'
                                        exp = 4
                                        act = cut->count_words( 'first come first served' ) ).
  ENDMETHOD.

  METHOD unnecessary_spaces.
    cl_abap_unit_assert=>assert_equals( msg = 'unnecessary spaces at the beginning and ending of the sentence'
                                        exp = 3
                                        act = cut->count_words( ' this is unnecessary ' ) ).
  ENDMETHOD.



ENDCLASS.
