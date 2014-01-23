{{ content() }}

<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to("tracker/project", "Project Overview") }}</li>
      <li>{{ project.users.name }}</li>
      <li class="active">{{ project.name }}</li>
    </ol>
    <div align="right">{{ link_to("trackerProjectSamples/editSamples/" ~ project.id, "Edit Sample Info >>", "class": "btn btn-primary") }}</div>
    <hr>
    <table class="table table-bordered table-hover table-condensed" id="sampleInfo_table">
      <thead>
        <tr>
          <th>Sample Name</th>
          <th>Sample Type</th>
          <th>Multiplex Lib Name</th>
          <th>Lib Name</th>
          <th>Index A</th>
          <th>Index Seq A</th>
          <th>Index B</th>
          <th>Index Seq B</th>
          <th>Flowcell</th>
          <th>Lane #</th>
          <th>QC Date</th>
          <th>Lib Date</th>
          <th>Last Cycle Date</th>
        </tr>
      </thead>
      <tbody>
      {% for data in datas %}
        <tr id="sample_id_{{ data.sample_id }}">
          <td>{{ data.sample_name }}</td>
          <td>{{ data.sample_type }}</td>
          <td>{{ data.seqtemplate_name }}</td>
          <td>{{ data.seqlib_name }}</td>
          <td>{{ data.oligobarcodeA_name }}</td>
          <td>{{ data.oligobarcodeA_seq }}</td>
          <td>{{ data.oligobarcodeB_name }}</td>
          <td>{{ data.oligobarcodeB_seq }}</td>
          <td>{{ data.flowcell_name }}</td>
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
        {% if data.last_cycle_date is defined %}
          <td>{{ date('Y-m-d', strtotime(data.last_cycle_date)) }}</td>
        {% else %}
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
$(document).ready(function() {
	$('#sampleInfo_table').dataTable({
		"sScrollY" : "400px",
		"bPaginate" : false,
		"bScrollCollapse" : true
	});
});
</script>