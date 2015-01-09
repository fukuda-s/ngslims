{{ content() }}

<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to("tracker", "Tracker") }}</li>
      <li class="active">Overall</li>
    </ol>
    <hr>
    <button disabled type="button" class="btn btn-primary" onclick="location.href='{{ url("summary/overall/0/0") }}'">
      ALL&nbsp;
      <i class="glyphicon glyphicon-download"></i>
    </button>
    {% for run_year, run_month_array in run_year_month_array %}
      {% if run_year is empty %} {# Case for run_started_date is NULL #}
        {% continue %}
      {% endif %}
      <div class="btn-toolbar" role="toolbar">
        <div class="btn-group btn-group-sm" id="run_year_{{ run_year }}">
          <button disabled type="button" class="btn btn-info"
                  onclick="location.href='{{ url("summary/overall/" ~ run_year ~ '/0') }}'">{{ run_year }}&nbsp;<i
                class="glyphicon glyphicon-download"></i></button>
          {% for run_month, run_month_available in run_month_array %}
            {% if run_month_available == 2 %}
              <button type="button" class="btn btn-default active"
                      onclick="location.href='{{ url("summary/overall/" ~ run_year ~ '/' ~ run_month) }}'">{{ run_month }}</button>
            {% elseif run_month_available == 1 %}
              <button type="button" class="btn btn-default"
                      onclick="location.href='{{ url("summary/overall/" ~ run_year ~ '/' ~ run_month) }}'">{{ run_month }}</button>
            {% else %}
              <button disabled type="button" class="btn btn-default">{{ run_month }}</button>
            {% endif %}
          {% endfor %}
        </div>
      </div>
    {% endfor %}
    <hr>
    <table class="table table-bordered table-hover table-condensed" id="overall_table" style="font-size: 8pt">
      <thead>
      <tr>
        <th>Project Name</th>
        <th>Run ID</th>
        <th>Run Date</th>
        <th>Machine</th>
        <th>FCID</th>
        <th>Lane #</th>
        <th>Instrument Type</th>
        <th>Run Mode Type</th>
        <th>Run Read Type</th>
        <th>Run Cycle Type</th>
        <th>Seqlib Name</th>
        <th>Organism</th>
        <th>Index Seq</th>
        <th>Description</th>
        <th>Control</th>
        <th>Exp. Type</th>
        <th>PI Name</th>
        <th></th>
        <th>Protocol</th>
        <th></th>
        <th>Multiplex Lib. Name</th>
        <th>Index1</th>
        <th>Index2</th>
        <th></th>
        <th>Lane #</th>
        <th>Seqlib Name</th>
        <th>Total</th>
        <th>PF</th>
        <th>PF(%)</th>
      </tr>
      </thead>
      <tbody>
      {% for d in overall %}
        {% if fc_prev is defined and fc_prev.run_number !== d.fc.run_number %}
          {% set seqDemultiplexResults = fc_prev.getSeqDemultiplexResults("is_undetermined = 'Y'") %}
          {% for seqDemultiplexResult in seqDemultiplexResults %}
            <tr>
              <td></td>
              <td>{{ fc_prev.run_number }}</td>
              <td>{{ date('Y-m-d', strtotime(fc_prev.run_started_date)) }}</td>
              <td>{{ fc_prev.Instruments.instrument_number ~ fc_prev.side }}</td>
              <td>{{ fc_prev.name }}</td>
              <td>{{ seqDemultiplexResult.SeqLanes.number }}</td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td>{{ seqDemultiplexResult.SeqLanes.number }}</td>
              <td>Undet</td>
              <td>{{ number_format(seqDemultiplexResult.reads_total) }}</td>
              <td>{{ number_format(seqDemultiplexResult.reads_passedfilter) }}</td>
              <td>{{ round(seqDemultiplexResult.reads_passedfilter / seqDemultiplexResult.reads_total * 100, 2) ~ '%' }}</td>
            </tr>
          {% endfor %}
        {% endif %}
        <tr id="seqlib_id_{{ d.sl.id }}">
          <td>{{ d.sl.Projects.name }}</td>
          <td>{{ d.fc.run_number }}</td>
          <td>{{ date('Y-m-d', strtotime(d.fc.run_started_date)) }}</td>
          <td>{{ d.fc.Instruments.instrument_number ~ d.fc.side }}</td>
          <td>{{ d.fc.name }}</td>
          <td>{{ d.it.name }}</td>
          <td>{{ d.srmt.name }}</td>
          <td>{{ d.srrt.name }}</td>
          <td>{{ d.srct.name }}</td>
          <td>{{ d.slane.number }}</td>
          <td>{{ d.sl.name }}</td>
          <td>{{ d.sl.Samples.Organisms.name }}</td>
          {% if d.sl.oligobarcodeA_id is empty %}
            <td></td>
            <td></td>
          {% elseif d.sl.oligobarcodeB_id is empty %}
            <td>{{ d.sl.OligobarcodeA.barcode_seq }}</td>
            <td>{{ d.sta.Seqtemplates.name ~ d.sl.OligobarcodeA.name }}</td>
          {% else %}
            <td>{{ d.sl.OligobarcodeA.barcode_seq ~ '-' ~ d.sl.OligobarcodeB.barcode_seq }}</td>
            <td>{{ d.sta.Seqtemplates.name ~ d.sl.OligobarcodeA.name ~ d.sl.OligobarcodeB.name }}</td>
          {% endif %}
          <td>{{ d.slane.is_control }}</td>
          {% if d.sl.protocol_id is empty %}
            <td></td>
          {% else %}
            <td>{{ d.sl.Protocols.Steps.short_name }}</td>
          {% endif %}
          {% if d.sl.Projects.pi_user_id is 0 %}
            <td>(Undefined)</td>
          {% else %}
            <td>{{ d.sl.Projects.PIs.getFullName() }}</td>
          {% endif %}
          <td></td>
          {% if d.sl.protocol_id is empty %}
            <td></td>
          {% else %}
            <td>{{ d.sl.Protocols.name }}</td>
          {% endif %}
          <td></td>
          <td>{{ d.sta.Seqtemplates.name }}</td>
          {% if d.sl.oligobarcodeA_id is empty %}
            <td></td>
          {% else %}
            <td>{{ d.sl.OligobarcodeA.name }}</td>
          {% endif %}
          {% if d.sl.oligobarcodeB_id is empty %}
            <td></td>
          {% else %}
            <td>{{ d.sl.OligobarcodeB.name }}</td>
          {% endif %}
          <td></td>
          <td>{{ d.slane.number }}</td>
          <td>{{ d.sl.name }}</td>
          {% if d.slane.getSeqDemultiplexResults()|length === 0 %}
            <td></td>
            <td></td>
            <td></td>
          {% else %}
            {% set seqDemultiplexResults = d.slane.getSeqDemultiplexResults("is_undetermined = 'N'")[0] %}
            <td>{{ number_format(seqDemultiplexResults.reads_total) }}</td>
            <td>{{ number_format(seqDemultiplexResults.reads_passedfilter) }}</td>
            <td>{{ round(seqDemultiplexResults.reads_passedfilter / seqDemultiplexResults.reads_total * 100, 2) ~ '%' }}</td>
          {% endif %}
        </tr>
        {% if fc_prev is defined and loop.last %}
          {% set seqDemultiplexResults = fc_prev.getSeqDemultiplexResults("is_undetermined = 'Y'") %}
          {% for seqDemultiplexResult in seqDemultiplexResults %}
            <tr>
              <td></td>
              <td>{{ fc_prev.run_number }}</td>
              <td>{{ date('Y-m-d', strtotime(fc_prev.run_started_date)) }}</td>
              <td>{{ fc_prev.Instruments.instrument_number ~ fc_prev.side }}</td>
              <td>{{ fc_prev.name }}</td>
              <td>{{ seqDemultiplexResult.SeqLanes.number }}</td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td>{{ seqDemultiplexResult.SeqLanes.number }}</td>
              <td>Undet</td>
              <td>{{ number_format(seqDemultiplexResult.reads_total) }}</td>
              <td>{{ number_format(seqDemultiplexResult.reads_passedfilter) }}</td>
              <td>{{ round(seqDemultiplexResult.reads_passedfilter / seqDemultiplexResult.reads_total * 100, 2) ~ '%' }}</td>
            </tr>
          {% endfor %}
        {% endif %}
        {% set fc_prev = d.fc %}
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
     var table = $('#overall_table').DataTable({
      scrollX: true,
      responsive: true,
      paging: false,
      order: []
    });

    var sFilenamePrefix = 'overall';
    var tt = new $.fn.DataTable.TableTools(table, {
      "dom": 'T<"clear">lfrtip',
      "sSwfPath": "/ngsLIMS/js/DataTables-1.10.4/extensions/TableTools/swf/copy_csv_xls_pdf.swf",
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