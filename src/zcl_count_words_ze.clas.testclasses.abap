*"* use this source file for your ABAP unit test classes
CLASS ltcl_count_words DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
  DATA: cut TYPE REF TO zcl_count_words_ze.

    METHODS:
      setup,
      iteration1_test_output FOR TESTING RAISING cx_static_check,
      iteration1_input_hello_darling FOR TESTING RAISING cx_static_check,
      iteration1_input_fcfs FOR TESTING RAISING cx_static_check,
      iteration1_unnecessary_spaces FOR TESTING RAISING cx_static_check,
      iteration2_all_taboo_words FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_count_words IMPLEMENTATION.

  METHOD setup.

    cut = NEW zcl_count_words_ze(  ).

  ENDMETHOD.

  METHOD iteration1_test_output.
    cut->count_words(
        EXPORTING
            iv_sentence     = ''
        RECEIVING
            rv_count        = DATA(lv_result)
        ).
    cl_abap_unit_assert=>assert_equals( msg = 'Initialize input of sentence and output of count'
                                        exp = 0
                                        act = lv_result ).
  ENDMETHOD.

  METHOD iteration1_input_hello_darling.
    cut->count_words(
        EXPORTING
            iv_sentence     = 'hello darling'
        RECEIVING
            rv_count        = DATA(lv_result)
        ).
    cl_abap_unit_assert=>assert_equals( msg = 'Do the first test of input-output relation'
                                        exp = 2
                                        act = lv_result ).
  ENDMETHOD.

  METHOD iteration1_input_fcfs.
    cut->count_words(
        EXPORTING
            iv_sentence     = 'first come first served'
        RECEIVING
            rv_count        = DATA(lv_result)
        ).
    cl_abap_unit_assert=>assert_equals( msg = 'second test'
                                        exp = 4
                                        act = lv_result ).
  ENDMETHOD.

  METHOD iteration1_unnecessary_spaces.
    cut->count_words(
        EXPORTING
            iv_sentence     = ' this is unnecessary '
        RECEIVING
            rv_count        = DATA(lv_result)
        ).
    cl_abap_unit_assert=>assert_equals( msg = 'unnecessary spaces at the beginning and ending of the sentence'
                                        exp = 3
                                        act = lv_result ).
  ENDMETHOD.

  METHOD iteration2_all_taboo_words.
    cut->count_words(
        EXPORTING
            iv_sentence     = 'Mary had a little lamb that was on the road and off his mind'
            iv_taboo_words  = |the a on off|
        RECEIVING
            rv_count        = DATA(lv_result)
        ).
    cl_abap_unit_assert=>assert_equals( msg = 'Mary(1) had(2) a little(3) lamb(4) that(5) was(6) on the road(7) and(8) off his(9) mind(10)'
                                        exp = 10
                                        act = lv_result ).
  ENDMETHOD.

ENDCLASS.
