CLASS zcl_count_words_ze DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.
  METHODS:   count_words
                IMPORTING   iv_sentence             TYPE string
                            iv_taboo_words          TYPE string OPTIONAL
                            iv_dict                 TYPE string OPTIONAL
                RETURNING VALUE(rv_count)           TYPE i,
             check_dict
                RETURNING VALUE(rv_dict_counter)    TYPE i,
             count_unique_words
                RETURNING VALUE(rv_unique)          TYPE i,
             count_average_word_length
                RETURNING VALUE(rv_average)         TYPE string
             .

PROTECTED SECTION.

PRIVATE SECTION.
  METHODS:  check_taboo
                RETURNING VALUE(rv_taboo_counter)   TYPE i,
            calculate_count
            .

  DATA: gv_sentence         TYPE string
        , gt_sentence       TYPE TABLE OF string
        , gv_taboo_words    TYPE string
        , gv_dict           TYPE string
        , gv_count          TYPE i
        .

ENDCLASS.



CLASS zcl_count_words_ze IMPLEMENTATION.

  METHOD count_words.

      IF iv_sentence CO '0123456789!"#$%&/()=?¡*¨][_:;^`~|°¬ÁÉÍÓÚ´ '.
        rv_count = 0.
      ELSE.
        gv_sentence = iv_sentence.
        TRANSLATE gv_sentence TO LOWER CASE.

        SPLIT gv_sentence AT ' ' INTO TABLE gt_sentence.

        IF iv_taboo_words IS NOT INITIAL.
            gv_taboo_words = iv_taboo_words.
            TRANSLATE gv_taboo_words TO LOWER CASE.
        ENDIF.

        IF iv_dict IS NOT INITIAL.
            gv_dict = iv_dict.
            TRANSLATE gv_dict TO LOWER CASE.
        ENDIF.

        me->calculate_count(  ).
        rv_count = gv_count.

        IF iv_taboo_words IS NOT INITIAL.
        rv_count -= me->check_taboo(  ).
        ENDIF.

      ENDIF.

  ENDMETHOD.


  METHOD calculate_count.

      gv_count = 1.

      gv_sentence = condense( gv_sentence ).

      gv_count += count_any_of( val = gv_sentence sub = | | ).

  ENDMETHOD.


  METHOD check_taboo.

      SPLIT gv_taboo_words AT ' ' INTO TABLE DATA(lt_taboo_words).
      DO lines( gt_sentence ) TIMES.
          FIND FIRST OCCURRENCE OF gt_sentence[ sy-index ] IN TABLE lt_taboo_words.
          IF sy-subrc = 0.
            rv_taboo_counter += 1.
          ENDIF.
      ENDDO.

  ENDMETHOD.

  METHOD check_dict.

      SPLIT gv_dict AT ' ' INTO TABLE DATA(lt_dict).

      rv_dict_counter = lines( gt_sentence ).

      DO lines( gt_sentence ) TIMES.
          FIND FIRST OCCURRENCE OF gt_sentence[ sy-index ] IN TABLE lt_dict.
          IF sy-subrc = 0.
            rv_dict_counter -= 1.
          ENDIF.
      ENDDO.

  ENDMETHOD.

  METHOD count_unique_words.

    DATA: lv_appearance     TYPE i
          , lv_actual_word  TYPE string
          .

    DO lines( gt_sentence ) TIMES.

        CLEAR lv_actual_word.
        CLEAR lv_appearance.
        lv_actual_word = gt_sentence[ sy-index ].

        DO lines( gt_sentence ) TIMES.
            IF lv_actual_word = gt_sentence[ sy-index ].
            lv_appearance += 1.
            ENDIF.
        ENDDO.

        IF lv_appearance = 1.
            rv_unique += 1.
        ENDIF.

    ENDDO.


  ENDMETHOD.

  METHOD count_average_word_length.

    DATA: lv_average    TYPE p LENGTH 16 DECIMALS 2.

    DO lines( gt_sentence ) TIMES.
        lv_average += strlen( gt_sentence[ sy-index ] ).
    ENDDO.

    rv_average = lv_average / lines( gt_sentence ).

  ENDMETHOD.

ENDCLASS.
