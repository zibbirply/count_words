CLASS zcl_count_words_ze DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.
  METHODS:   count_words
                IMPORTING   iv_sentence             TYPE string
                            iv_taboo_words          TYPE string
                RETURNING VALUE(rv_count)           TYPE i,
             count_unique_words
                RETURNING VALUE(rv_unique)          TYPE i
             .

PROTECTED SECTION.

PRIVATE SECTION.
  METHODS:  check_up_file
                RETURNING VALUE(rv_taboo_counter)   TYPE i,
            calculate_count
            .

  DATA: gv_sentence         TYPE string
        , gv_taboo_words    TYPE string
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
        gv_taboo_words = iv_taboo_words.
        TRANSLATE gv_taboo_words TO LOWER CASE.
        me->calculate_count(  ).
        rv_count = gv_count - me->check_up_file(  ).
      ENDIF.

  ENDMETHOD.


  METHOD calculate_count.

      gv_count = 1.

      gv_sentence = condense( gv_sentence ).

      gv_count += count_any_of( val = gv_sentence sub = | | ).

  ENDMETHOD.


  METHOD check_up_file.

      SPLIT gv_taboo_words AT ' ' INTO TABLE DATA(lt_taboo_words).
      SPLIT gv_sentence AT ' ' INTO TABLE DATA(lt_check_sentence).
      DO lines( lt_check_sentence ) TIMES.
          FIND FIRST OCCURRENCE OF lt_check_sentence[ sy-index ] IN TABLE lt_taboo_words.
          IF sy-subrc = 0.
            rv_taboo_counter += 1.
          ENDIF.
      ENDDO.

  ENDMETHOD.

  METHOD count_unique_words.
    DATA: lv_appearance     TYPE i
          , lv_actual_word  TYPE string
          .
    SPLIT gv_sentence AT ' ' INTO TABLE DATA(lt_check_sentence).

    DO lines( lt_check_sentence ) TIMES.

        CLEAR lv_actual_word.
        CLEAR lv_appearance.
        lv_actual_word = lt_check_sentence[ sy-index ].

        DO lines( lt_check_sentence ) TIMES.
            IF lv_actual_word = lt_check_sentence[ sy-index ].
            lv_appearance += 1.
            ENDIF.
        ENDDO.

        IF lv_appearance = 1.
            rv_unique += 1.
        ENDIF.

    ENDDO.


  ENDMETHOD.

ENDCLASS.
