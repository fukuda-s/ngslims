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
            {% for seqtemplate in seqlib.seqtemplates %}
        <tr id="sample_id_{{ sample.id }}">
          <td>{{ sample.name }}</td>
          <td>{{ sample.sampletypes.name }}</td>
          <td>{{ seqtemplate.name }}</td>
          <td>{{ seqlib.name }}</td>
          <td>{{ seqlib.oligobarcodea.name }}</td>
          <td>{{ seqlib.oligobarcodea.barcode_seq }}</td>
          <td>{{ seqlib.oligobarcodeb.name }}</td>
          <td>{{ seqlib.oligobarcodeb.barcode_seq }}</td>
          {% if sample.qual_date is defined %}
          <td>{{ date('Y-m-d', strtotime(sample.qual_date)) }}</td>
          {% else %}
          <td></td>
          {% endif %}
          {% if seqlib.create_at is defined %}
          <td>{{ date('Y-m-d', strtotime(seqlib.create_at)) }}</td>
          {% else %}
          <td></td>
          {% endif %}
          <td></td>
        </tr>
            {% endfor %}
          {% endfor %}
        {% endfor %}
      </tbody>
    </table>
  </div>
</div>