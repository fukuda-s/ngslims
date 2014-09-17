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
<div class="tube-responsive">
  {% if step.step_phase_code == 'MULTIPLEX' %}
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
  {% endif %}
  {# @TODO Could not use 'elseif' at here. Is it Bug? #}
  {% if step.step_phase_code == 'DUALMULTIPLEX' %}
    {% for seqtemplate_index, seqtemplate in seqtemplates %}
      {% for indexB, oligobarcodeB in oligobarcodeBs %}
        {% if indexB == 0 %} {# @TODO loop.first couldn't use here, it is bug of phalcon. #}
          <table class="tube-matrix table table-hover table-condensed">
          <thead>
          <tr>
            <td class="tube tube-sm-header">{{ seqtemplate_index }}</td>
            {% for oligobarcodeA in oligobarcodeAs %}
              <td id="oligobarcodeA_id_{{ oligobarcodeA.o.id }}"
                  class="tube tube-sm tube-sm-header sort-disabled">{{ oligobarcodeA.o.name }}
                <br>{{ oligobarcodeA.o.barcode_seq }}</td>
            {% endfor %}
          </tr>
          </thead>
          <tbody id="seqtemplate_index_{{ seqtemplate_index }}">
        {% endif %}
        <tr id="oligobarcodeB_id_{{ oligobarcodeB.o.id }}">
          <td class="tube tube-sm tube-sm-header sort-disabled">{{ oligobarcodeB.o.name }}
            : {{ oligobarcodeB.o.barcode_seq }}</td>
          {% for oligobarcodeA in oligobarcodeAs %}
            {% if seqlibs_inbarcode[seqtemplate_index][oligobarcodeB.o.id][oligobarcodeA.o.id] is defined %}
              {% set seqlib = seqlibs_inbarcode[seqtemplate_index][oligobarcodeB.o.id][oligobarcodeA.o.id] %}
              {% if seqlib.se.status == 'Completed' and seqlib.sta_count === 0 %}
                <td class="tube tube-sm tube-active sort-disabled"
                    id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}
                  <button type="button" class="tube-close pull-right">&times;</button>
                  <!--
                  <button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>
                  -->
                  </button>
                </td>
              {% else %}
                <td class="tube tube-sm tube-inactive sort-disabled"
                    id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}
                  <button type="button" class="tube-close pull-right">&times;</button>
                  <!--
                  <button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>
                  -->
                  </button>
                </td>
              {% endif %}
            {% else %}
              <td class="tube tube-sm tube-empty"></td>
            {% endif %}
          {% endfor %}
        </tr>
        {% if loop.last %}
          </tbody>
          </table>
        {% endif %}
        {% elsefor %} No records on oligobarcodeBs
      {% endfor %}
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
      $(this).children('li:not(.sort-disabled, .tube-empty)').each(function () {
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

  var final_multiplex_sortable_max_len = fixTubeWidth($('ul[id^=oligobarcodeA_id_]'));

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
   * Set jQuery-UI sortable to #seqlibs-nobarcode-holder
   */
  $('#seqlibs-nobarcode-holder').sortable({
    connectWith: "ul[id^=oligobarcodeA_id_], tbody[id^=seqtemplate_index_]",
    placeholder: "tube-placeholder",
    opacity: 0.5
  });

  /*
   * Set jQuery-UI sortable to each rows on #seqtemplate-matrix table for MULTIPLEX
   */
  $('ul[id^=oligobarcodeA_id_]').sortable({
    items: "li:not(.sort-disabled)",
    placeholder: "tube tube-sm tube-placeholder",
    opacity: 0.5,
    axis: "x",
    //revert: true,
    tolerance: "pointer",
    cursorAt: { left: 10 },
    receive: function (event, ui) {
      // Append close button on sorted seqlib tube from #seqlibs-nobarcode-holder'
      ui.item
          .append('<button type="button" class="tube-close pull-right">&times;</button>')
          .append('<button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>')
          .find('button.tube-close').click(closeTube);

      // Remove tube-empty which dragged seqlib tube from #seqlibs-nobarcode-holder
      if (ui.item.next('li.tube-empty').length) {
        ui.item.next('li.tube-empty').remove();
      } else {
        ui.item.prev('li.tube-empty').remove();
      }
    },
    start: function (event, ui) {
      //console.log(ui.placeholder.css());
      ui.placeholder.css("width", final_multiplex_sortable_max_len);
    }
  }).disableSelection();


  /*
   * Set jQuery-UI sortable to #seqtemplate_index_XX matrix table for DUALMULTIPLEX
   */
  $('tbody[id^=seqtemplate_index_]').sortable({
    items: "li:not(.sort-disabled)",
    placeholder: "tube tube-sm tube-placeholder",
    opacity: 0.5,
    receive: function (event, ui) {
      // Append close button on sorted seqlib tube
      ui.item
          .append('<button type="button" class="tube-close pull-right">&times;</button>')
          .append('<button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>')
          .find('button.tube-close').click(closeTube);
      // Remove tube-empty which dragged seqlib tube from #seqlibs-nobarcode-holder
      if (ui.item.next('td.tube-empty').length) {
        ui.item.next('td.tube-empty').remove();
      } else {
        ui.item.prev('td.tube-empty').remove();
      }
    }
  });


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
    $('tbody[id^=seqtemplate_index_]').each(function () {
      var seqtemplate_index = $(this).attr('id');
      if (seqtemplate_index) {
        seqtemplates.push(seqtemplate_index.replace('seqtemplate_index_', ''));
      }
    });
    var oligobarcodeAs = [];
    $('td[id^=oligobarcodeA_id_]').each(function () {
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
          seqlibs[seqtemplate_index][seqlib_id] = {seqlib_id: seqlib_id, oligobarcodeA_id: oligobarcodeA_id, seqtemplate_index: seqtemplate_index};
        }
      })
    });

    //For DUALMULTIPLEX
    $('tbody[id^=seqtemplate_index_]').each(function () {
      var seqtemplate_index = $(this).attr('id').replace('seqtemplate_index_', '');
      if (!seqlibs[seqtemplate_index]) {
        seqlibs[seqtemplate_index] = new Object();
      }
      $(this).find('tr[id^=oligobarcodeB_id_]').each(function () {
        var oligobarcodeB_id = $(this).attr('id').replace('oligobarcodeB_id_', '');
        $(this).find('td[id^=seqlib_id_]').each(function (index) {
          var seqlib_id = $(this).attr('id').replace('seqlib_id_', '');
          seqlibs[seqtemplate_index][seqlib_id] = {seqlib_id: seqlib_id, oligobarcodeA_id: oligobarcodeAs[index], oligobarcodeB_id: oligobarcodeB_id, seqtemplate_index: seqtemplate_index};
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
        data: { indexedSeqlibs: seqlibs, seqtemplates: seqtemplates}
      })
          .done(function () {
            console.log(seqlibs);
            window.location = "{{ url("tracker/multiplexConfirm/") ~ step.id }}"
          });
    }
  });

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

});
</script>
