{% for seqlib in seqlibs %}
  {% if loop.first %}
    <table class="table table-bordered table-hover table-condensed table-responsive collapse in"
    id="seqtemplate-table-{{ seqlib.st.id }}">
    <thead>
    <tr>
      <th>Project Name</th>
      <th>PI Name</th>
      <th>Seqlib Name</th>
      <th>Sample Name</th>
      <th>Index A</th>
      <th>Index A Seq</th>
      {% if oligobarcodeB_exists == true %}
        <th>Index B</th>
        <th>Index B Seq</th>
      {% endif %}
      <th>Protocol</th>
      <th>Required Seq Run Type</th>
    </tr>
    </thead>
    <tbody>
  {% endif %}
  <tr id="seqlib_id_{{ seqlib.sl.id }}">
    <td>{{ seqlib.p.name }}</td>
    <td>{{ seqlib.u.getFullname() }}</td>
    <td>{{ seqlib.sl.name }}</td>
    <td>{{ seqlib.s.name }}</td>
    <td>{{ seqlib.sl.getOligobarcodeA().name }}</td>
    <td>{{ seqlib.sl.getOligobarcodeA().barcode_seq }}</td>
    {% if oligobarcodeB_exists == true %}
      {% if seqlib.sl.oligobarcodeB_id != null %}
        <td>{{ seqlib.sl.getOligobarcodeB().name }}</td>
        <td>{{ seqlib.sl.getOligobarcodeB().barcode_seq }}</td>
      {% else %}
        <td></td>
        <td></td>
      {% endif %}
    {% endif %}
    <td>{{ seqlib.pt.name }}</td>
    <td>{{ seqlib.it.name ~ ' ' ~ seqlib.srct.name ~ ' ' ~ seqlib.srrt.name ~ ' ' ~ seqlib.srmt.name }}</td>
  </tr>
  {% if loop.last %}
    </tbody>
    </table>
  {% endif %}
  {% elsefor %} No seqlib recorded
{% endfor %}
