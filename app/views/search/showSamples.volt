{{ flashSession.output() }}

<div class="row">
  <div class="col-md-12">
    <table class="table table-bordered table-hover table-condensed" id="result_table" style="font-size: 8pt">
      <thead>
      <tr>
        <th>Project Name</th>
        <th>PI Name</th>

        <th>Sample Name</th>
        <th>Sample Type</th>
        <th>Organism</th>

        <th>Seqlib Name</th>
        <th>Exp. Type</th>
        <th>Protocol</th>
        <th>Index Seq</th>
        <th>Index1</th>
        <th>Index2</th>

        <th>Multiplex Lib. Name</th>

        <th>Run ID</th>
        <th>Run Date</th>
        <th>Instrument Type</th>
        <th>Machine</th>
        <th>FCID</th>
        <th>Run Mode Type</th>
        <th>Run Read Type</th>
        <th>Run Cycle Type</th>
        <th>Lane #</th>
        <th>Control</th>

        <th>Total</th>
        <th>PF</th>
        <th>PF(%)</th>
      </tr>
      </thead>
      <tbody>
      {% for d in result %}
        <tr id="seqlib_id_{{ d.sl.id }}">
          <td>{{ link_to("trackerdetails/showTableSamples/" ~ d.p.id ~ "?pre_action=projectName", d.p.name) }}</td>

          {% if d.p.pi_user_id is 0 %}
            <td>(Undefined)</td>
          {% else %}
            <td>{{ link_to("summary/projectPi/#pi_user_id_" ~ d.p.PIs.id, d.p.PIs.getFullName()) }}</td>
          {% endif %}

          <td>{{ d.s.name }}</td>
          <td>{{ d.s.SampleTypes.name }}</td>
          <td>{{ d.s.Organisms.name }}</td>

          {% if d.sl is defined %}
            <td>{{ d.sl.name }}</td>

            {% if d.sl.protocol_id is empty %}
              <td></td>
              <td></td>
            {% else %}
              <td>{{ d.sl.Protocols.Steps.short_name }}</td>
              <td>{{ d.sl.Protocols.name }}</td>
            {% endif %}

            {% if d.sl.oligobarcodeA_id is empty %}
              <td></td>
              <td></td>
              <td></td>
            {% elseif d.sl.oligobarcodeB_id is empty %}
              <td>{{ d.sl.OligobarcodeA.barcode_seq }}</td>
              <td>{{ d.sl.OligobarcodeA.name }}</td>
              <td></td>
            {% else %}
              <td>{{ d.sl.OligobarcodeA.barcode_seq ~ '-' ~ d.sl.OligobarcodeB.barcode_seq }}</td>
              <td>{{ d.sl.OligobarcodeA.name }}</td>
              <td>{{ d.sl.OligobarcodeB.name }}</td>
            {% endif %}
          {% endif %}

          {% if d.st is defined %}
            <td>{{ d.st.name }}</td>
          {% else %}
            <td></td>
          {% endif %}


          {% if not d.fc.id is empty %}
            {% set run_started_date = (d.fc.run_started_date is empty) ? '' : date('Y-m-d', strtotime(d.fc.run_started_date)) %}
            <td>{{ d.fc.run_number }}</td>
            <td>{{ run_started_date }}</td>
            <td>{{ d.it.name }}</td>
            {% if not d.fc.instrument_id is empty %}
              <td>{{ d.fc.Instruments.instrument_number ~ d.fc.side }}</td>
            {% else %}
              <td></td>
            {% endif %}
            <td>{{ link_to('trackerdetails/showTableSeqlanes/' ~ d.fc.name, d.fc.name ) }}</td>
            <td>{{ d.srmt.name }}</td>
            <td>{{ d.srrt.name }}</td>
            <td>{{ d.srct.name }}</td>
            <td>{{ d.slane.number }}</td>
            <td>{{ d.slane.is_control }}</td>
            {% if d.sdr is defined %}
              {% set reads_total = (d.sdr.reads_total is empty) ? '' : number_format(d.sdr.reads_total) %}
              <td>{{ reads_total }}</td>
              {% set reads_passedfilter = (d.sdr.reads_passedfilter is empty) ? '' : number_format(d.sdr.reads_passedfilter) %}
              <td>{{ reads_passedfilter }}</td>
              {% set reads_passedfilter_percent = (d.sdr.reads_total > 0) ? round(d.sdr.reads_passedfilter / d.sdr.reads_total * 100, 2) ~ '%' : '' %}
              <td>{{ reads_passedfilter_percent }}</td>
            {% else %}
              <td></td>
              <td></td>
              <td></td>
            {% endif %}
          {% else %}
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
    $('#result_table').DataTable({
      scrollX: true,
      responsive: true,
      paging: true,
      order: [],
      dom: 'Bfrtip',
      buttons: [
        'pageLength',
        {
          extend: "excelHtml5",
          text: "<i class='fa fa-file-excel-o'></i>&ensp;<strong>Excel</strong>"
        },
        {
          extend: 'copyHtml5',
          text: "<i class='fa fa-clipboard'></i>&ensp;<strong>Copy To Clipboard</strong>"
        }
      ]
    });
  });
</script>
