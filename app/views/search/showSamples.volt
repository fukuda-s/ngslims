{{ flashSession.output() }}

<div class="row">
  <div class="col-md-12">
    <table class="table table-bordered table-hover table-condensed" id="result_table" style="font-size: 8pt">
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
        <th>Sample Name</th>
        <th>Seqlib Name</th>
        <th>Organism</th>
        <th>Index Seq</th>
        <th>Description</th>
        <th>Control</th>
        <th>Exp. Type</th>
        <th>PI Name</th>
        <th>Protocol</th>
        <th>Multiplex Lib. Name</th>
        <th>Index1</th>
        <th>Index2</th>
        <th>Lane #</th>
        <th>Total</th>
        <th>PF</th>
        <th>PF(%)</th>
      </tr>
      </thead>
      <tbody>
      {% for d in result %}
        <tr id="seqlib_id_{{ d.sl.id }}">
          <td>{{ d.p.name }}</td>
          <td>{{ d.fc.run_number }}</td>
          <td>{{ date('Y-m-d', strtotime(d.fc.run_started_date)) }}</td>
          <td>{{ d.fc.Instruments.instrument_number ~ d.fc.side }}</td>
          <td>{{ d.fc.name }}</td>
          <td>{{ d.it.name }}</td>
          <td>{{ d.srmt.name }}</td>
          <td>{{ d.srrt.name }}</td>
          <td>{{ d.srct.name }}</td>
          <td>{{ d.slane.number }}</td>
          <td>{{ d.s.name }}</td>
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

          {% if d.sl.Projects.pi_user_id is 0 %}
            <td>(Undefined)</td>
          {% else %}
            <td>{{ d.sl.Projects.PIs.getFullName() }}</td>
          {% endif %}

          {% if d.sl.protocol_id is empty %}
            <td></td>
          {% else %}
            <td>{{ d.sl.Protocols.Steps.short_name }}</td>
          {% endif %}

          {% if d.sl.protocol_id is empty %}
            <td></td>
          {% else %}
            <td>{{ d.sl.Protocols.name }}</td>
          {% endif %}

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

          <td>{{ d.slane.number }}</td>

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
    var table = $('#result_table').DataTable({
      scrollX: true,
      responsive: true,
      paging: true,
      order: []
    });

    var sFilenamePrefix = 'search_result';
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
