{# Begin #seqlibs-nobarcode-holder part. #}
{% for seqlib in seqlibs_nobarcode %}
  {% if loop.first %}
    <div class="row">
    <div class="col-md-12">

    <ul class="tube-list" id="seqlibs-nobarcode-holder">
  {% endif %}
  {% if seqlib.se.status == 'Completed' and seqlib.sta_count === 0 %}
    <li class="tube tube-sm tube-active" id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}</li>
  {% else %}
    <li class="tube tube-sm tube-inactive" id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}</li>
  {% endif %}
  {% if loop.last %}
    </ul>
    </div>
    </div>
  {% endif %}
  {% elsefor %} No records on seqlibs_nobarcode
{% endfor %}
{# End #seqlibs-nobarcode-holder part. #}
<hr>
<button type="button" id="confirm-seqtemplate-button" class="btn btn-primary pull-right">Confirm &raquo;</button>
<br>
<br>

{# Begin seqtemplate-matrix part. #}
  {% if step.step_phase_code == 'MULTIPLEX' %}
    <div class="tube-responsive">
      {% for index, oligobarcodeA in oligobarcodeAs %}
        {% if index == 0 %} {# @TODO loop.first couldn't use here, it is bug of phalcon. #}
          <ul class="tube-header-list" id="seqtemplate-matrix-header">
            <li class="tube tube-sm-header tube-sm-row-header">OligoBarcode</li>
            {% for seqtemplate_index, seqtempalte in seqtemplates %}
              <li id="seqtemplate_index_{{ seqtemplate_index }}"
                  class="tube tube-sm-header">{{ seqtemplate_index }}</li>
              {% elsefor %} No records on seqtemplates
            {% endfor %}
            <li class="" style="display: inline-block;">
              <button type="button" id="add-seqtemplate-button" class="btn btn-primary btn-xs"><i
                    class="glyphicon glyphicon-plus" style="min-height: 20px; padding: 2px 2px"></i></button>
            </li>
          </ul>
          <div id="seqtemplate-matrix-body">
          <ul class="tube-list" id="oligobarcodeA_id_null">
            <li class="tube tube-sm tube-sm-header sort-disabled tube-sm-row-header">No Barcode</li>
            {% for index in 1..seqtemplates|length %}
              <li class="tube tube-sm tube-empty"></li>
            {% endfor %}
          </ul>

        {% endif %}
        <ul class="tube-list" id="oligobarcodeA_id_{{ oligobarcodeA.o.id }}">
          <li class="tube tube-sm tube-sm-header sort-disabled tube-sm-row-header">{{ oligobarcodeA.o.name }}
            : {{ oligobarcodeA.o.barcode_seq }}</li>
          {% for seqtemplate_index, seqtemplate in seqtemplates %}
            {% if seqlibs_inbarcode[seqtemplate_index][oligobarcodeA.o.id] is defined %}
              {% set seqlib = seqlibs_inbarcode[seqtemplate_index][oligobarcodeA.o.id] %}
              {% if seqlib.se.status == 'Completed' and seqlib.sta_count === 0 %}
                <li class="tube tube-sm tube-active" id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}
                  <button type="button" class="tube-close pull-right">&times;</button>
                  <button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>
                  </button>
                </li>
              {% else %}
                <li class="tube tube-sm tube-inactive" id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}
                  <button type="button" class="tube-close pull-right">&times;</button>
                  <button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>
                  </button>
                </li>
              {% endif %}
            {% else %}
              <li class="tube tube-sm tube-empty"></li>
            {% endif %}
          {% endfor %}
        </ul>
        {% if loop.last %}
          </div>
        {% endif %}
        {% elsefor %} No records on oligobarcodeAs
      {% endfor %}
    </div>
  {% endif %}
  {# @TODO Could not use 'elseif' at here. Is it Bug? #}
  {% if step.step_phase_code == 'DUALMULTIPLEX' %}
    {% for seqtemplate_index, seqtemplate in seqtemplates %}
      <div class="tube-responsive tube-dualmultiplex" id="seqtemplate_index_{{ seqtemplate_index }}">
        {% for indexB, oligobarcodeB in oligobarcodeBs %}
          {% if indexB == 0 %} {# @TODO loop.first couldn't use here, it is bug of phalcon? #}
            <ul class="tube-header-list">
              <li class="tube tube-sm tube-sm-header tube-sm-row-header sort-disabled">{{ seqtemplate_index }}</li>
              {% for indexA, oligobarcodeA in oligobarcodeAs %}
                <li id="oligobarcodeA_id_{{ oligobarcodeA.o.id }}"
                    class="tube tube-sm tube-sm-header tube-sm-col-header sort-disabled">{{ oligobarcodeA.o.name }}
                  <br>{{ oligobarcodeA.o.barcode_seq }}</li>
              {% endfor %}
            </ul>
          {% endif %}
          <ul class="tube-list-row" id="oligobarcodeB_id_{{ oligobarcodeB.o.id }}">
            <ul class="tube-list-col">
              <li class="tube tube-sm tube-sm-header tube-sm-row-header sort-disabled">{{ oligobarcodeB.o.name }}
                : {{ oligobarcodeB.o.barcode_seq }}</li>
            </ul>
            {% for indexA, oligobarcodeA in oligobarcodeAs %}
              <ul class="tube-list-col"
                  id="{{ "oligobarcode_index_" ~ indexA ~ "_" ~ indexB ~ "_" ~ seqtemplate_index }}">
                {% if seqlibs_inbarcode[seqtemplate_index][oligobarcodeB.o.id][oligobarcodeA.o.id] is defined %}
                  {% set seqlib = seqlibs_inbarcode[seqtemplate_index][oligobarcodeB.o.id][oligobarcodeA.o.id] %}
                  {% if seqlib.se.status == 'Completed' and seqlib.sta_count === 0 %}
                    <li class="tube tube-sm tube-active sort-disabled"
                        id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}
                      <button type="button" class="tube-close pull-right">&times;</button>
                      <!--
                      <button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>
                      -->
                      </button>
                    </li>
                  {% else %}
                    <li class="tube tube-sm tube-inactive sort-disabled"
                        id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}
                      <button type="button" class="tube-close pull-right">&times;</button>
                      <!--
                      <button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>
                      -->
                      </button>
                    </li>
                  {% endif %}
                {% else %}
                  <li class="tube tube-sm tube-empty"></li>
                {% endif %}
              </ul>
            {% endfor %}
          </ul>
          {% if loop.last %}
          {% endif %}
          {% elsefor %} No records on oligobarcodeBs
        {% endfor %}
      </div>
    {% endfor %}
  {% endif %}
</div>

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
    $('#seqtemplate-matrix-header').find('li[id^=seqtemplate_index_]').filter(':last').html(function () {
      var new_seqtemplate_index = $(this).attr('id').replace('seqtemplate_index_', '');
      new_seqtemplate_index++;

      //Add new column header with new_seqtemplate_index.
      $(this).after('<li id="seqtemplate_index_' + new_seqtemplate_index + '" class="tube tube-sm-header">' + new_seqtemplate_index + '</li>');
      //console.log(this);
    })
    $('#seqtemplate-matrix-body').find('ul').each(function () {
      //Add new column with new_seqtemplate_index for each row.
      $(this).append('<li class="tube tube-sm tube-empty"></li>');
    })

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
          .append('<button type="button" class="tube-close pull-right">&times;</button>')
          .append('<button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>')
          .find('button.tube-close').click(closeTube);

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

  if($('.tube-dualmultiplex').length > 1) {
    $('ul.tube-list-col[id^=oligobarcode_index_]').each(function () {
      var oligobarcode_index = $(this).attr('id');
      var oligobarcode_index_top = oligobarcode_index.replace(/\d+$/, '');
      $(this).sortable({
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
  }

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
    var seqlibs = new Object();
    //For MULTIPLEX
    $('ul[id^=oligobarcodeA_id_]').each(function () {
      var oligobarcodeA_id = $(this).attr('id').replace('oligobarcodeA_id_', '');
      //$(this).find('li[id^=seqlib_id_]').each(function (index) {
      $(this).find("li:not('.tube-sm-header')").each(function (index) {
        var seqtemplate_index = seqtemplates[index];
        //console.log(oligobarcodeA_id + ' : ' + seqtemplate_index + " : " + index);
        if (!seqlibs[seqtemplate_index]) {
          seqlibs[seqtemplate_index] = new Object();
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
        seqlibs[seqtemplate_index] = new Object();
      }
      $(this).find('ul[id^=oligobarcodeB_id_]').each(function () {
        var oligobarcodeB_id = $(this).attr('id').replace('oligobarcodeB_id_', '');
        $(this).find('li[id^=seqlib_id_]').each(function (index) {
          var seqlib_id = $(this).attr('id').replace('seqlib_id_', '');
          seqlibs[seqtemplate_index][seqlib_id] = {
            seqlib_id: seqlib_id,
            oligobarcodeA_id: oligobarcodeAs[index],
            oligobarcodeB_id: oligobarcodeB_id,
            seqtemplate_index: seqtemplate_index
          };
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
            console.log(seqlibs);
            window.location = "{{ url("tracker/multiplexConfirm/") ~ step.id }}"
          });
    }
  });


})
;
</script>
