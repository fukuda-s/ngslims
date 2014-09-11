{# Begin #seqlibs-nobarcode-holder part. #}
{% for seqlib in seqlibs_nobarcode %}
  {% if loop.first %}
    <div class="row">
    <div class="col-md-12">
    <table>
    <tbody class="tube-list">
    <tr id="seqlibs-nobarcode-holder">
  {% endif %}
  {% if seqlib.se.status == 'Completed' %}
    <td class="tube tube-sm tube-active" id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}</td>
  {% else %}
    <td class="tube tube-sm tube-inactive" id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}</td>
  {% endif %}
  {% if loop.last %}
    </tr>
    </tbody>
    </table>
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
<div class="row">
  <div class="col-md-12">
    {% if step.step_phase_code == 'MULTIPLEX' %}
      {% for index, oligobarcodeA in oligobarcodeAs %}
        {% if index == 0 %} {# @TODO loop.first couldn't use here, it is bug of phalcon. #}
          <table class="tube-matrix table table-hover table-condensed">
          <thead id="seqtemplate-matrix-header">
          <tr>
            <th class="tube tube-sm-header">OligoBarcode</th>
            {% for seqtemplate_index, seqtempalte in seqtemplates %}
              <th id="seqtemplate_index_{{ seqtemplate_index }}"
                  class="tube tube-sm-header">{{ seqtemplate_index }}</th>
              {% if loop.last %}
                <th>
                  <button type="button" id="add-seqtemplate-button" class="btn btn-default btn-xs pull-left"><span
                        class="glyphicon glyphicon-plus"></span></button>
                </th>
              {% endif %}
              {% elsefor %} No records on seqtemplates
            {% endfor %}
          </tr>
          </thead>
          <tbody id="seqtemplate-matrix-body">
          <tr id="oligobarcodeA_id_null">
            <td class="tube tube-sm tube-sm-header sort-disabled">No Barcode</td>
            {% for index in 1..seqtemplates|length %}
              <td class="tube tube-sm tube-empty"></td>
            {% endfor %}
          </tr>
        {% endif %}
        <tr id="oligobarcodeA_id_{{ oligobarcodeA.o.id }}">
          <td class="tube tube-sm tube-sm-header sort-disabled">{{ oligobarcodeA.o.name }}
            : {{ oligobarcodeA.o.barcode_seq }}</td>
          {% for seqtemplate_index, seqtemplate in seqtemplates %}
            {% if seqlibs_inbarcode[seqtemplate_index][oligobarcodeA.o.id] is defined %}
              {% set seqlib = seqlibs_inbarcode[seqtemplate_index][oligobarcodeA.o.id] %}
              {% if seqlib.se.status == 'Completed' %}
                <td class="tube tube-sm tube-active" id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}
                  <button type="button" class="close pull-right">&times;</button>
                  <button type="button" class="copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i></button>
                </td>
              {% else %}
                <td class="tube tube-sm tube-inactive" id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}
                  <button type="button" class="close pull-right">&times;</button>
                  <button type="button" class="copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i></button>
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
                {% if seqlib.se.status == 'Completed' %}
                  <td class="tube tube-sm tube-active sort-disabled"
                      id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}
                    <button type="button" class="close pull-right">&times;</button>
                    <button type="button" class="copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i></button>
                  </td>
                {% else %}
                  <td class="tube tube-sm tube-inactive sort-disabled"
                      id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}
                    <button type="button" class="close pull-right">&times;</button>
                    <button type="button" class="copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i></button>
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
</div>
<script>
  $(document).ready(function () {
    /*
     * Set jQuery-UI sortable to #seqlibs-nobarcode-holder
     */
    $('#seqlibs-nobarcode-holder').sortable({
      connectWith: "tr[id^=oligobarcodeA_id_], tbody[id^=seqtemplate_index_]",
      placeholder: "tube-placeholder",
      opacity: 0.5
    });

    /*
     * Set jQuery-UI sortable to each rows on #seqtemplate-matrix table for MULTIPLEX
     */
    $('tr[id^=oligobarcodeA_id_]').sortable({
      items: "td:not(.sort-disabled)",
      //placeholder: "tube-placeholder",
      opacity: 0.5,
      axis: "x",
      //revert: true,
      tolerance: "point",
      cursorAt: { left: 10 },
      receive: function (event, ui) {
        // Append close button on sorted seqlib tube
        ui.item.append('<button type="button" class="close pull-right">&times;</button>');
        ui.item.find('button.close').click(function () {
          clicked_td = $(this).parent('td').remove('button.close');
          //@TODO The tube which clicked closed button should be back to #saqlibs-nobarcode-holder
          //clicked_td.clone(true).remove('button.close').appendTo('#seqlibs-nobarcode-holder');
          clicked_td.replaceWith('<td class="tube tube-sm tube-empty"></td>');
        });

        // Remove tube-empty which dragged seqlib tube from #seqlibs-nobarcode-holder
        if (ui.item.next('td.tube-empty').length) {
          ui.item.next('td.tube-empty').remove();
        } else {
          ui.item.prev('td.tube-empty').remove();
        }
      }
    });

    /*
     * Set jQuery-UI sortable to #seqtemplate_index_XX matrix table for DUALMULTIPLEX
     */
    $('tbody[id^=seqtemplate_index_]').sortable({
      items: "td:not(.sort-disabled)",
      placeholder: "tube-placeholder",
      opacity: 0.5,
      receive: function (event, ui) {
        // Append close button on sorted seqlib tube
        ui.item.append('<button type="button" class="close pull-right">&times;</button>');
        ui.item.find('button.close').click(function () {
          clicked_td = $(this).parent('td');
          //@TODO The tube which clicked closed button should be back to #saqlibs-nobarcode-holder
          //$('#seqlibs-nobarcode-holder').append(clicked_td.parent().html());
          clicked_td.replaceWith('<td class="tube tube-sm tube-empty"></td>');
        });

        // Remove tube-empty which dragged seqlib tube from #seqlibs-nobarcode-holder
        if (ui.item.next('td.tube-empty').length) {
          ui.item.next('td.tube-empty').remove();
        } else {
          ui.item.prev('td.tube-empty').remove();
        }
      }
    });


    /*
     * Set function close button on each seqlib tubes
     */
    $('button.close').click(function () {
      clicked_td = $(this).parent('td');
      //@TODO The tube which clicked closed button should be back to #saqlibs-nobarcode-holder
      //$('#seqlibs-nobarcode-holder').append(clicked_td.html());
      clicked_td.replaceWith('<td class="tube tube-sm tube-empty"></td>');
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
      $('#seqtemplate-matrix-header').find('th').each(function () {
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
      $('tr[id^=oligobarcodeA_id_]').each(function () {
        var oligobarcodeA_id = $(this).attr('id').replace('oligobarcodeA_id_', '');
        //$(this).find('td[id^=seqlib_id_]').each(function (index) {
        $(this).find("td:not('.tube-sm-header')").each(function (index) {
          var seqtemplate_index = seqtemplates[index];
          //console.log(oligobarcodeA_id + ' : ' + seqtemplate_index + " : " + index);
          if (!seqlibs[seqtemplate_index]) {
            seqlibs[seqtemplate_index] = new Object();
          }
          if ($(this).is('td[id^=seqlib_id_]')) {
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

    $('#add-seqtemplate-button').click(function () {
      $('#seqtemplate-matrix-header').find('th[id^=seqtemplate_index_]').filter(':last').html(function () {
        var new_seqtemplate_index = $(this).attr('id').replace('seqtemplate_index_', '');
        new_seqtemplate_index++;

        //Add new column header with new_seqtemplate_index.
        $(this).after('<th id="seqtemplate_index_' + new_seqtemplate_index + '" class="tube tube-sm-header">' + new_seqtemplate_index + '</th>');
        console.log(this);
      })
      $('#seqtemplate-matrix-body').find('tr').each(function () {
        //Add new column with new_seqtemplate_index for each row.
        $(this).append('<td class="tube tube-sm tube-empty"></td>');
      })
    });

  });
</script>
