{{ content() }}

<div class="row">
  <div class="col-md-12">
    {{ partial('partials/trackerdetails-header') }}
    <div
        align="right">{{ link_to("trackerdetails/editSamples/SHOW/0/" ~ project.id ~ "?pre_action=" ~ previousAction, "Edit Sample Info >>", "class": "btn btn-primary") }}</div>
    <hr>
    <table class="table table-bordered table-hover table-condensed" id="sampleInfo_table" style="font-size: 9pt">
      <thead>
      <tr>
        <th>Sample Name</th>
        <th>Sample Type</th>
        <th>Cell Type</th>
        <th>Tissue/Organ</th>
        <th>Multiplex Lib Name</th>
        <th>Lib Name</th>
        <th>Protocol Name</th>
        <th>Index A</th>
        <th>Index Seq A</th>
        <th>Index B</th>
        <th>Index Seq B</th>
        <th>Flowcell</th>
        <th>Lane #</th>
        <th>QC Date</th>
        <th>Lib Date</th>
        <th>Run Started Date</th>
        <th>Run Finished Date</th>
        <th>Total</th>
        <th>PF</th>
        <th>PF(%)</th>
      </tr>
      </thead>
      <tbody>
      {% for data in datas %}
        <tr id="sample_id_{{ data.sample_id }}">
          <td>{{ data.sample_name }}</td>
          <td>{{ data.sample_type }}</td>
          <td>{{ data.cell_type }}</td>
          <td>{{ data.tissue }}</td>
          <td>{{ data.seqtemplate_name }}</td>
          <td>{{ data.seqlib_name }}</td>
          <td>{{ data.protocol_name }}</td>
          <td>{{ data.oligobarcodeA_name }}</td>
          <td>{{ data.oligobarcodeA_seq }}</td>
          <td>{{ data.oligobarcodeB_name }}</td>
          <td>{{ data.oligobarcodeB_seq }}</td>
          <td>{{ link_to('trackerdetails/showTableSeqlanes/' ~ data.flowcell_name, data.flowcell_name ) }}</td>
          <td>{{ data.seqlane_num }}</td>
          {% if data.qual_date is defined %}
            <td>{{ date('Y-m-d', strtotime(data.qual_date)) }}</td>
          {% else %}
            <td></td>
          {% endif %}
          {% if data.seqlib_date is defined %}
            <td>{{ date('Y-m-d', strtotime(data.seqlib_date)) }}</td>
          {% else %}
            <td></td>
          {% endif %}
          {% if data.run_started_date is defined %}
            <td>{{ date('Y-m-d', strtotime(data.run_started_date)) }}</td>
          {% else %}
            <td></td>
          {% endif %}
          {% if data.run_finished_date is defined %}
            <td>{{ date('Y-m-d', strtotime(data.run_finished_date)) }}</td>
          {% else %}
            <td></td>
          {% endif %}
          {% if data.sdr is defined %}
            {% set reads_total = (data.sdr.reads_total is empty) ? '' : number_format(data.sdr.reads_total) %}
            <td>{{ reads_total }}</td>
            {% set reads_passedfilter = (data.sdr.reads_passedfilter is empty) ? '' : number_format(data.sdr.reads_passedfilter) %}
            <td>{{ reads_passedfilter }}</td>
            {% set reads_passedfilter_percent = (data.sdr.reads_total > 0) ? round(data.sdr.reads_passedfilter / data.sdr.reads_total * 100, 2) ~ '%' : '' %}
            <td>{{ reads_passedfilter_percent }}</td>
          {% else %}
            <td></td>
            <td></td>
            <td></td>
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
    var table = $('#sampleInfo_table').DataTable({
      scrollX: true,
      responsive: true
    });

    var sFilenamePrefix = 'sample';
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