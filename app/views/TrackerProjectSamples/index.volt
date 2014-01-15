{{ content() }}

<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li><a href="#">{{ project.users.name }} </a></li>
      <li><a href="#">{{ project.name }} </a></li>
      <li class="active">Samples</li>
    </ol>
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
          <th>QC Date</th>
          <th>Lib Date</th>
          <!--
        <th>First Cycle Date</th>
        -->
          <th>Last Cycle Date</th>
        </tr>
      </thead>
      <tbody>
        {% for sample in samples %}
        {% for seqlib in sample.seqlibs %}
        <tr id="sample_id_{{ sample.id }}">
          <td>{{ sample.name }}</td>
          <td>{{ sample.sampletypes.name }}</td>
          <td></td>
          <td>{{ seqlib.name }}</td>
          <td>{{ seqlib.oligobarcodea.name }}</td>
          <td>{{ seqlib.oligobarcodea.barcode_seq }}</td>
          <td>{{ seqlib.oligobarcodeb.name }}</td>
          <td>{{ seqlib.oligobarcodeb.barcode_seq }}</td>
          <td></td>
          <td></td>
          <td></td>
        </tr>
        {% endfor %}
        {% endfor %}
      </tbody>
    </table>
  </div>
</div>