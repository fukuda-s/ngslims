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
    <table class="table table-bordered table-hover table-condensed" id="overall_table">
      <thead>
      <tr>
        <th>Project Name</th>
        <th>Run ID</th>
        <th>Run Date</th>
        <th>Machine</th>
        <th>FCID</th>
        <th>Lane #</th>
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
      </tr>
      </thead>
      <tbody>
      {% for d in overall %}
        <tr id="seqlib_id_{{ d.sl.id }}">
          <td>{{ d.sl.Projects.name }}</td>
          <td>{{ d.fc.run_number }}</td>
          <td>{{ date('Y-m-d', strtotime(d.fc.run_started_date)) }}</td>
          <td>{{ d.fc.Instruments.instrument_number ~ d.fc.side }}</td>
          <td>{{ d.fc.name }}</td>
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
    $('#overall_table').dataTable({
      scrollX: true,
      responsive: true,
      order: [
        [ 2, 'asc' ],
        [ 5, 'asc' ],
        [17, 'asc'],
        [18, 'asc']
      ] // fc.un_started_date > slane.number > sl.oligobarcodeA.name > sl.oligobarcodeB.name
    });
  });
</script>