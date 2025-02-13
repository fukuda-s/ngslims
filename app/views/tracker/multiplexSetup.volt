{# Begin #seqlibs-nobarcode-holder part. #}
<!--
  ~ (The MIT License)
  ~
  ~ Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining
  ~ a copy of this software and associated documentation files (the
  ~ 'Software'), to deal in the Software without restriction, including
  ~ without limitation the rights to use, copy, modify, merge, publish,
  ~ distribute, sublicense, and/or sell copies of the Software, and to
  ~ permit persons to whom the Software is furnished to do so, subject to
  ~ the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be
  ~ included in all copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  ~ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  ~ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  ~ IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  ~ CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  ~ TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  ~ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  -->

<div class="row">
  <div class="col-md-12">
    <ul class="tube-list" id="seqlibs-nobarcode-holder">
      {% for seqlib in seqlibs_no_barcode %}
        {% if seqlib.se.status == 'Completed' and seqlib.sta_count === 0 %}
          {% set tube_class = "tube-active" %}
        {% else %}
          {% set tube_class = "tube-inactive" %}
        {% endif %}
        <li class="tube tube-sm {{ tube_class }}" id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}</li>
        {% elsefor %} No records on seqlibs_no_barcode
      {% endfor %}
    </ul>
  </div>
</div>
{# End #seqlibs-nobarcode-holder part. #}
<hr>
<button type="button" id="confirm-seqtemplate-button" class="btn btn-primary pull-right">Confirm &raquo;</button>
<br>
<br>
{# @TODO Following 'if' phrase is necessary because of bug? If the if is not used, then the include is changed to the partial function. #}
{% if step.step_phase_code == 'MULTIPLEX' %}
  {% include 'tracker/multiplexSetupMULTIPLEX.volt' %}
{% elseif step.step_phase_code == 'DUALMULTIPLEX' %}
  {% include 'tracker/multiplexSetupDUALMULTIPLEX.volt' %}
{% endif %}

<script>
  $(document).ready(function () {

    /*
     * Function of fix width of tubes with most longest tube.
     */
    function fixTubeWidth(target) {
      var multiplex_sortable_max_len = 0;
      $(target).each(function () {
        $(this).children('li:not(.tube-sm-header, .tube-empty)').each(function () {
          var textStrLen = this.offsetWidth;
          if (textStrLen > multiplex_sortable_max_len) {
            multiplex_sortable_max_len = textStrLen;
            //console.log(this.innerText + " : " + textStrLen);
          }
        });
      });
      $("li.tube").filter("li:not(.tube-sm-row-header)").css("width", multiplex_sortable_max_len + 20);
      return multiplex_sortable_max_len + 20;
    }

    var final_multiplex_sortable_max_len = fixTubeWidth($('ul.tube-list, ul.tube-list-col'));

    /*
     * Set function tube-close button on each seqlib tubes
     */
    function closeTube(e) {
      var clicked_li = $(e.target).parent('li');
      //@TODO The tube which clicked closed button should be back to #saqlibs-nobarcode-holder
      //$('#seqlibs-nobarcode-holder').append(clicked_td.html());
      clicked_li.replaceWith('<li class="tube tube-sm tube-empty" style="width: ' + final_multiplex_sortable_max_len + 'px"></li>');
    }

    $('button.tube-close').click(closeTube);

    /*
     * Set function tube-copy button on each seqlib tubes
     */
    function copyTube(e) {
      var clicked_li = $(e.target).closest('li');
      var replaced_li = clicked_li.nextAll('li.tube-empty').first();

      if (!replaced_li.length) {
        window.alert("Please add seqtemplate with + button before copy tube.");
      } else {
        replaced_li.replaceWith(clicked_li.clone('true')); //clone('true') : cloned with data and events.
      }
    }

    $('button.tube-copy').click(copyTube);

    /*
     * Function to add new column as new seqtemplate.
     *  It is used with #add-seqtemplate-button.
     */
    function addSeqtemplate() {
      $('#seqtemplate-matrix-header')
          .find('li[id^=seqtemplate_index_]')
          .filter(':last')
          .html(function () {
            var new_seqtemplate_index = $(this).attr('id').replace('seqtemplate_index_', '');
            new_seqtemplate_index++;
            var new_seqtemplate_num = new_seqtemplate_index + 1;

            //Add new column header with new_seqtemplate_index.
            $(this).after('<li id="seqtemplate_index_' + new_seqtemplate_index + '" class="tube tube-sm-header">' + new_seqtemplate_num + '</li>');
            //console.log(this);
          });
      $('#seqtemplate-matrix-body')
          .find('ul')
          .each(function () {
            //Check tube-collapse on previous tubes.
            tube_collapse_on = $(this).find('.tube-collapse').length;
            //Add new column with new_seqtemplate_index for each row.
            if (tube_collapse_on) {
              $(this).append('<li class="tube tube-sm tube-empty tube-collapse"></li>');
            } else {
              $(this).append('<li class="tube tube-sm tube-empty"></li>');
            }
          });

      $('li.tube').filter("li:not(.tube-sm-row-header)").css("width", final_multiplex_sortable_max_len);
    }

    $('#add-seqtemplate-button').click(addSeqtemplate);

    /*
     * Set jQuery-UI sortable to #seqlibs-nobarcode-holder
     */
    $('#seqlibs-nobarcode-holder').sortable({
      connectWith: "ul[id^=oligobarcodeA_id_], ul.tube-list-col[id^=oligobarcode_index_]",
      placeholder: "tube tube-sm tube-placeholder",
      revert: true,
      pointer: "move",
      opacity: 0.5,
      helper: "clone",
      remove: function (event, ui) {
        // Append close button on sorted seqlib tube
        //console.log(ui.item.find('button').length);
        if (!ui.item.find('button').length) {
          ui.item
              .append('<button type="button" class="tube-close pull-right">&times;</button>')
              //.append('<button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>')
              .find('button.tube-close').click(closeTube);
        }

        final_multiplex_sortable_max_len = fixTubeWidth($('ul.tube-list, ul.tube-list-col'));
      }
    });

    /*
     * Set jQuery-UI sortable to each rows on #seqtemplate-matrix table for MULTIPLEX
     */

    $('#seqtemplate-matrix-body > ul[id^=oligobarcodeA_id_]').sortable({
      items: "li:not(.sort-disabled)",
      placeholder: "tube tube-sm tube-placeholder",
      opacity: 0.5,
      axis: "x",
      //revert: true,
      pointer: "move",
      tolerance: "pointer",
      cursorAt: {left: 10},
      receive: function (event, ui) {
        // Append close button on sorted seqlib tube from #seqlibs-nobarcode-holder'
        ui.item
            .append('<button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>')
            .find('button.tube-copy').click(copyTube);

        final_multiplex_sortable_max_len = fixTubeWidth($('ul.tube-list'));

        // Remove tube-empty which dragged seqlib tube from #seqlibs-nobarcode-holder
        if (ui.item.next('li.tube-empty').length) {
          ui.item.next('li.tube-empty').remove();
        } else {
          ui.item.prev('li.tube-empty').remove();
        }

        // Add new seqtemplate if the seqtemplate+oligobarcode doesn't have tube-empty.
        var num_of_column = $('#seqtemplate-matrix-header').children('li.tube').length;
        var num_of_column_dropped = $(event.target).children('li.tube').siblings().length;
        if (num_of_column !== num_of_column_dropped) {
          addSeqtemplate();
          $(event.target).children('li.tube-empty').remove();
        }
        //console.log(event.target);
        //console.log(num_of_column + " : " + num_of_column_dropped);

      },
      start: function (event, ui) {
        //console.log(ui.placeholder.css());
        ui.placeholder.css("width", final_multiplex_sortable_max_len);
      }
    }).disableSelection();


    /*
     * Set jQuery-UI sortable between .tube-dualmultiplex matrices to #seqtemplate_index_XX matrix table for DUALMULTIPLEX
     */

    //if($('.tube-dualmultiplex').length > 1) {
    $('ul.tube-list-col[id^=oligobarcode_index_]').each(function () {
      var oligobarcode_index = $(this).attr('id');
      var oligobarcode_index_top = oligobarcode_index.replace(/\d+$/, '');
      $(this).sortable({
        items: "li:not(.sort-disabled)",
        connectWith: "[id^=" + oligobarcode_index_top,
        revert: true,
        cursor: 'move',
        placeholder: "tube tube-sm tube-placeholder",
        opacity: 0.5,
        start: function (event, ui) {
          ui.placeholder.css("width", final_multiplex_sortable_max_len);
        },
        over: function (event, ui) {
          if (!ui.sender.filter('ul#seqlibs-nobarcode-holder').length) {
            $(event.target).children(':not(.tube-placeholder)').hide();
          }
        },
        receive: function (event, ui) {
          ui.item.siblings().appendTo(ui.sender).show('slow');
        }
      }).disableSelection();
    });
    //}

    /*
     * Build function to save setting values (and redirected to confirm view) #seqtemplate-matrix table
     * @TODO Is is possible to use sortable('serialize' or 'toArray') function for following codes?
     */
    $('#confirm-seqtemplate-button').click(function () {
      /*
       * Set seqtemplates array
       */
      var seqtemplates = [];
      //For MULTIPLEX
      $('#seqtemplate-matrix-header').find('li').each(function () {
        var seqtemplate_index = $(this).attr('id');
        if (seqtemplate_index) {
          seqtemplates.push(seqtemplate_index.replace('seqtemplate_index_', ''));
        }
      });
      //For DUALMULTIPLEX
      $('div[id^=seqtemplate_index_]').each(function () {
        var seqtemplate_index = $(this).attr('id');
        if (seqtemplate_index) {
          seqtemplates.push(seqtemplate_index.replace('seqtemplate_index_', ''));
        }
      });
      var oligobarcodeAs = [];
      $('li[id^=oligobarcodeA_id_]').each(function () {
        var oligobarcodeA_id = $(this).attr('id');
        if (oligobarcodeA_id) {
          oligobarcodeAs.push(oligobarcodeA_id.replace('oligobarcodeA_id_', ''));
        }
      });

      /*
       * Set seqlibs array
       */
      var seqlibs = {};
      //For MULTIPLEX
      $('ul[id^=oligobarcodeA_id_]').each(function () {
        var oligobarcodeA_id = $(this).attr('id').replace('oligobarcodeA_id_', '');
        //$(this).find('li[id^=seqlib_id_]').each(function (index) {
        $(this).find("li:not('.tube-sm-header')").each(function (index) {
          var seqtemplate_index = seqtemplates[index];
          //console.log(oligobarcodeA_id + ' : ' + seqtemplate_index + " : " + index);
          if (!seqlibs[seqtemplate_index]) {
            seqlibs[seqtemplate_index] = {};
          }
          if ($(this).is('li[id^=seqlib_id_]')) {
            var seqlib_id = $(this).attr('id').replace('seqlib_id_', '');
            seqlibs[seqtemplate_index][seqlib_id] = {
              seqlib_id: seqlib_id,
              oligobarcodeA_id: oligobarcodeA_id,
              seqtemplate_index: seqtemplate_index
            };
          }
        })
      });


      //For DUALMULTIPLEX
      $('div[id^=seqtemplate_index_]').each(function () {
        var seqtemplate_index = $(this).attr('id').replace('seqtemplate_index_', '');
        if (!seqlibs[seqtemplate_index]) {
          seqlibs[seqtemplate_index] = {};
        }
        $(this).find('ul[id^=oligobarcodeB_id_]').each(function () {
          var oligobarcodeB_id = $(this).attr('id').replace('oligobarcodeB_id_', '');
          $(this).find('ul[id^=oligobarcode_index_]').each(function (index) {
            $(this).find('li[id^=seqlib_id_]').each(function () {
              var seqlib_id = $(this).attr('id').replace('seqlib_id_', '');
              seqlibs[seqtemplate_index][seqlib_id] = {
                seqlib_id: seqlib_id,
                oligobarcodeA_id: oligobarcodeAs[index],
                oligobarcodeB_id: oligobarcodeB_id,
                seqtemplate_index: seqtemplate_index
              };
            })
          })
        })
      });

      /*
       * Send seqlibs and seqtemplates to save session value via Ajax and change to confirm view.
       */
      if (Object.keys(seqlibs).length) {
        $.ajax({
          url: '{{ url("tracker/multiplexSetSession") }}',
          dataType: 'json',
          type: 'POST',
          data: {indexedSeqlibs: seqlibs, seqtemplates: seqtemplates}
        })
            .done(function () {
              //console.log(seqlibs);
              window.location = "{{ url("tracker/multiplexSetupConfirm/") ~ step.id }}"
            });
      }
    });

    /*
     * Toggle unused barcode row
     */
    $('#toggole-barcode-button').click(function () {
      $('.tube-collapse').toggleClass('tube-in');
      $(this)
          .children('i')
          .toggleClass('fa-arrow-down fa-arrow-up')
    });

  });
</script>
