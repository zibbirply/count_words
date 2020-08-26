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
      iteration2_all_taboo_words FOR TESTING RAISING cx_static_check,
      iteration4_unique_words FOR TESTING RAISING cx_static_check,
      iteration5_hypen FOR TESTING RAISING cx_static_check,
      iteration6_average_length FOR TESTING RAISING cx_static_check.
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

  METHOD iteration4_unique_words.
    cut->count_words(
        EXPORTING
            iv_sentence     = 'first come first served'
        RECEIVING
            rv_count        = DATA(lv_result)
        ).
    cl_abap_unit_assert=>assert_equals( msg = 'How many unique words'
                                        exp = 2
                                        act = cut->count_unique_words(  ) ).
  ENDMETHOD.

  METHOD iteration5_hypen.
    cut->count_words(
        EXPORTING
            iv_sentence     = 'Luftballon-Pumpen-Reduzierungs-Adapter-Dichtring'
        RECEIVING
            rv_count        = DATA(lv_result)
        ).
    cl_abap_unit_assert=>assert_equals( msg = 'Wow thats long word ... or 5 casual words?'
                                        exp = 1
                                        act = cut->count_unique_words(  ) ).
  ENDMETHOD.

    METHOD iteration6_average_length.
    cut->count_words(
        EXPORTING
            iv_sentence     = 'Im running out of words'
        RECEIVING
            rv_count        = DATA(lv_result)
        ).
    cl_abap_unit_assert=>assert_equals( msg = '19 / 5 = ?'
                                        exp = '3.8'
                                        act = cut->count_average_word_length(  ) ).
  ENDMETHOD.



ENDCLASS.
