{{ content() }}
{% for selected_seqtemplate_index in selected_seqtemplates %}
  <div class="panel panel-default">
    <div class="panel-heading">#{{ selected_seqtemplate_index }}</div>
    {% for selected_seqlib in selected_seqlibs[selected_seqtemplate_index] %}
      {% if loop.first %}
        <div class="panel-body">
          <form class="form-horizontal" role="form">
            <div class="form-group">
              <label class="col-sm-2 control-label">Multiplex</label>

              <div class="col-sm-10" style="line-height: 2.5;">
                {{ loop.length }}
              </div>
            </div>
            <div class="form-group">
              <label for="target_conc" class="col-sm-2 control-label">Target Conc. (nM)</label>

              <div class="col-sm-1">
                <input type="text" class="form-control" id="target_conc" value="1.052">
              </div>
              <label for="target_vol" class="col-sm-2 control-label">Target Vol. (uL)</label>

              <div class="col-sm-1">
                <input type="text" class="form-control" id="target_vol" value="19.00">
              </div>
            </div>
          </form>
        </div>
        <table class="table table-condensed">
        <thead>
        <tr>
          <th>SeqLib Name</th>
          <th>Oligobarcode Name</th>
          <th>Oligobarcode Seq</th>
          <th>Conc. (nmol/L)</th>
          <th>Conc. Factor</th>
          <th>Stocked Vol. (uL)</th>
          <th>Fragment Size (bp)</th>
          <th>Input Vol. (uL)</th>
        </tr>
        </thead>
        <tbody>
      {% endif %}
      {% set seqlib = seqlibs[selected_seqlib['seqlib_id']] %}
      {% set oligobarcodeA = oligobarcodes[selected_seqlib['oligobarcodeA_id']] %}
      {% set oligobarcodeName = oligobarcodeA.name %}
      {% set oligobarcodeSeq = oligobarcodeA.barcode_seq %}
      {% if selected_seqlib['oligobarcodeB_id'] is defined %}
        {% set oligobarcodeB = oligobarcodes[selected_seqlib['oligobarcodeB_id']] %}
        {% set oligobarcodeName = oligobarcodeName ~ '-' ~ oligobarcodeB.name %}
        {% set oligobarcodeSeq = oligobarcodeSeq ~ '-' ~ oligobarcodeB.barcode_seq %}
      {% endif %}
      <tr>
        <td>{{ seqlib.name }}</td>
        <td>{{ oligobarcodeName }}</td>
        <td style="font-family: Consolas, 'Courier New', Courier, Monaco, monospace;">{{ oligobarcodeSeq }}</td>
        <td>{{ seqlib.concentration }}</td>
        <td><input type="text" value="1.000"></td>
        <td>{{ seqlib.stock_seqlib_volume }}</td>
        <td>{{ seqlib.fragment_size }}</td>
        <td></td>
      </tr>
      {% if loop.last %}
        </tbody>
        </table>
      {% endif %}
    {% endfor %}
  </div>
{% endfor %}