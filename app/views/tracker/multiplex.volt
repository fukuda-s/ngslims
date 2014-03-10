{{ content() }}
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

      {% for oligobarcode in oligobarcodes %}
        {% if loop.first %}
          <table class="tube-matrix table table-hover table-condensed">
          <thead id="seqtemplate-matrix-header">
          <tr>
            <td class="tube tube-sm-header">OligoBarcode</td>
            {% for seqtemplate_id, seqtempalte in seqtemplates %}
              <td id="seqtemplate_id_{{ seqtemplate_id }}" class="tube tube-sm-header">{{ seqtemplate_id }}</td>
              {% if loop.last %}
                <td>
                  <button type="button" id="add-seqtemplate-button" class="btn btn-default btn-xs pull-left"><span
                        class="glyphicon glyphicon-plus"></span></button>
                </td>
              {% else %}
              {% endif %}
            {% endfor %}
          </tr>
          </thead>
          <tbody id="seqtemplate-matrix-body">
        {% endif %}
        <tr id="oligobarcode_id_{{ oligobarcode.o.id }}">
          <td class="tube tube-sm tube-sm-header sort-disabled">{{ oligobarcode.o.name }}
            : {{ oligobarcode.o.barcode_seq }}</td>
          {% for seqtemplate_id, seqtemplate in seqtemplates %}
            {% set oligobarcode_used = 0 %}
            {% for oligobarcode_id, seqlibs in seqlibs_inbarcode %}
              {% if oligobarcode_id == oligobarcode.o.id and seqlibs[seqtemplate_id] is defined %}
                {% set oligobarcode_used = 1 %}
                {% set seqlib = seqlibs[seqtemplate_id] %}
                <td id="seqlib_id_{{ seqlib.sl.id }}" class="tube tube-sm tube-active">{{ seqlib.sl.name }}</td>
              {% endif %}
            {% endfor %}
            {% if oligobarcode_used == 0 %}
              <td class="tube tube-sm tube-empty"></td>
            {% endif %}
          {% endfor %}
        </tr>
        {% if loop.last %}
          </tbody>
          </table>
        {% endif %}
      {% endfor %}

    {% endif %}
  </div>
</div>
<script>
  $(function () {
    /*
     * Set jQuery-UI sortable to #seqlibs-nobarcode-holder
     */
    $('#seqlibs-nobarcode-holder').sortable({
      connectWith: "tr[id^=oligobarcode_id_]",
      placeholder: "tube-placeholder",
      opacity: 0.5
    });

    /*
     * Set jQuery-UI sortable to each rows on #seqtemplate-matrix table
     */
    $('tr[id^=oligobarcode_id_]').sortable({
      items: "td:not(.sort-disabled)",
      placeholder: "tube-placeholder",
      opacity: 0.5
    });

    /*
     * Build function to save setting values (and redirected to confirm view) #seqtemplate-matrix table
     * @TODO Is is possible to use sortable('serialize' or 'toArray') function for following codes?
     */
    $('#confirm-seqtemplate-button').click(function () {
      var seqtemplates = [];
      $('#seqtemplate-matrix-header').find('td').each(function () {
        var seqtemplate_id = $(this).attr('id');
        if (seqtemplate_id) {
          seqtemplates.push(seqtemplate_id.replace('seqtemplate_id_',''));
        }
      });

      var seqlibs = [];
      $('tr[id^=oligobarcode_id_]').each(function () {
        var oligobarcodeA_id = $(this).attr('id').replace('oligobarcode_id_', '');
        $(this).find('td[id^=seqlib_id_]').each(function (index) {
          var seqlib_id = $(this).attr('id').replace('seqlib_id_', '');
          seqlibs.push({seqlib_id: seqlib_id, oligobarcodeA_id: oligobarcodeA_id, seqtemplate_id: seqtemplates[index]});
        })
      });
      console.log(seqlibs);
    });
  });
</script>
