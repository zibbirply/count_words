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

      " So if there are only hieroglyphs in the input, dont count it
      IF iv_sentence CO '0123456789!"#$%&/()=?¡*¨][_:;^`~|°¬ÁÉÍÓÚ´ '.
        rv_count = 0.
      ELSE.
        gv_sentence = iv_sentence.
        TRANSLATE gv_sentence TO LOWER CASE. " We never know, where inconsistencies could happen
        gv_sentence = condense( gv_sentence ).

        SPLIT gv_sentence AT ' ' INTO TABLE gt_sentence. " We will need the input-sentence stored as table in several methods so...

        IF iv_taboo_words IS NOT INITIAL. " No need to do anything if there are no taboo words
            gv_taboo_words = iv_taboo_words.
            TRANSLATE gv_taboo_words TO LOWER CASE.
        ENDIF.

        IF iv_dict IS NOT INITIAL. " see 52, same for dictionary words
            gv_dict = iv_dict.
            TRANSLATE gv_dict TO LOWER CASE.
        ENDIF.

        me->calculate_count(  ). " Do the calculation and fill our...
        rv_count = gv_count.     " ... result value. Thank youuuuu..

        IF iv_taboo_words IS NOT INITIAL.
        rv_count -= me->check_taboo(  ). " Oh and if there were any taboo words, substract them from our result value
        ENDIF.

      ENDIF.

  ENDMETHOD.


  METHOD calculate_count.

      gv_count = 1. " You will understand why, as soon as you're in 80...

      gv_sentence = condense( gv_sentence ).

      gv_count += count_any_of( val = gv_sentence sub = | | ). " Yes we count the spaces instead of the words. "But one space is always missing, blah blah" hmmmm...

  ENDMETHOD.


  METHOD check_taboo.

      SPLIT gv_taboo_words AT ' ' INTO TABLE DATA(lt_taboo_words).
      DO lines( gt_sentence ) TIMES.
          FIND FIRST OCCURRENCE OF gt_sentence[ sy-index ] IN TABLE lt_taboo_words. " If the current word is in our taboo word list, then push up the counter, fella
          IF sy-subrc = 0.
            rv_taboo_counter += 1.
          ENDIF.
      ENDDO.

  ENDMETHOD.

  METHOD check_dict.

      SPLIT gv_dict AT ' ' INTO TABLE DATA(lt_dict).

      rv_dict_counter = lines( gt_sentence ).

      DO lines( gt_sentence ) TIMES.
          FIND FIRST OCCURRENCE OF gt_sentence[ sy-index ] IN TABLE lt_dict. " Same system like 'check_taboo' ...
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

        lv_actual_word = gt_sentence[ sy-index ]. " We can't use the sy-index for inner AND outer DO-Loop, so we make an extra variable for the outer loop

        DO lines( gt_sentence ) TIMES.
            IF lv_actual_word = gt_sentence[ sy-index ]. " So all we do here, is comparing the sentence with itself. 1st word & 1st word; 1st word & 2nd word; ... ; last word & last word.
            lv_appearance += 1. "Every appearance pushes the counter up by one => So the counter always be at least 1, thats why we...
            ENDIF.
        ENDDO.

        IF lv_appearance = 1.   "... say, if the only clone of a word, is itself, then we have a unique word. Push the unique counter up, then.
            rv_unique += 1.
        ENDIF.

        CLEAR lv_actual_word.
        CLEAR lv_appearance.

    ENDDO.


  ENDMETHOD.

  METHOD count_average_word_length.

    DATA: lv_average    TYPE p LENGTH 16 DECIMALS 2.

    DO lines( gt_sentence ) TIMES.
        lv_average += strlen( gt_sentence[ sy-index ] ). " Sum op the whole length of all words...
    ENDDO.

    rv_average = lv_average / lines( gt_sentence ).      "... and divide it by amount of words = average word length, voilá.
    rv_average = condense( rv_average ).

  ENDMETHOD.

ENDCLASS.
