{{ content() }}

<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to("tracker", "Tracker") }}</li>
      <li class="active">Instrument Overview</li>
    </ol>

    <ul class="nav nav-tabs">
      {% for instrument in instruments %}
        {% set instrument_name = instrument.name ~ ' (' ~ instrument.instrument_number ~ ' : ' ~ instrument.nickname ~ ')' %}
        {% if instrument.id is instrument_id %}
          <li role="presentation" class="active">{{ link_to('summary/instrument/' ~ instrument.id, instrument_name) }}</li>
        {% else %}
          <li role="presentation">{{ link_to('summary/instrument/' ~ instrument.id, instrument_name) }}</li>
        {% endif %}
        {% elsefor %}
        <h5>Error: Could not find any instruments</h5>
      {% endfor %}
    </ul>
    <table class="table table-bordered table-hover table-condensed" id="instrument_table" style="font-size: 80%">
      <thead>
      <tr>
        <th>Flowcell</th>
        <th>Run Started Date</th>
        <th>Run Finished Date</th>
        <th>Run Number</th>
        <th>Side</th>
        <th>Run Mode Type</th>
        <th>Run Read Type</th>
        <th>Run Cycle Type</th>
        <th>Data Directory</th>
        <th>Notes</th>
      </tr>
      </thead>
      <tbody>
      {% for flowcell in flowcells %}
        {% set run_started_date = (flowcell.fc.run_started_date is empty) ? '' : date('Y-m-d', strtotime(flowcell.fc.run_started_date)) %}
        {% set run_finished_date = (flowcell.fc.run_finished_date is empty) ? '' : date('Y-m-d', strtotime(flowcell.fc.run_finished_date)) %}
      <tr>
        <td>{{ flowcell.fc.name }}</td>
        <td>{{ run_started_date }}</td>
        <td>{{ run_finished_date }}</td>
        <td>{{ flowcell.fc.run_number }}</td>
        <td>{{ flowcell.fc.side }}</td>
        <td>{{ flowcell.srmt.name }}</td>
        <td>{{ flowcell.srrt.name }}</td>
        <td>{{ flowcell.srct.name }}</td>
        <td>{{ flowcell.fc.dirname }}</td>
        <td>{{ flowcell.fc.notes }}</td>
      </tr>
        {% elsefor %}
        <h5>Error: Could not find any flowcells</h5>
      {% endfor %}
      </tbody>

    </table>
  </div>
</div>
<script>
  /*
   * DataTables
   */
  $(document).ready(function () {
    var table = $('#instrument_table').DataTable({
      order: [],
      scrollX: true,
      responsive: true
    });

    var sFilenamePrefix = 'instrument';
    var tt = new $.fn.DataTable.TableTools(table, {
      "dom": 'T<"clear">lfrtip',
      "sSwfPath": "/ngsLIMS/js/DataTables-1.10.5/extensions/TableTools/swf/copy_csv_xls_pdf.swf",
      "sCharSet": "utf8",
      "aButtons": [
        {
          "sExtends": "xls",
          "sButtonText": "<i class='fa fa-file-excel-o'></i>&ensp;<strong>Excel</strong>",
          "sFileName": sFilenamePrefix + ".xls"
        },
        {
          "sExtends": "copy",
          "sButtonText": "<i class='fa fa-clipboard'></i>&ensp;<strong>Copy To Clipboard</strong>"
        },
        {
          "sExtends": "print",
          "sButtonText": "<i class='fa fa-print'></i>&ensp;<strong>Print</strong>",
          "sInfo": "Please press escape when done"
        }
      ]
    });

    $(tt.fnContainer()).insertBefore('div.dataTables_wrapper');
  });
</script>