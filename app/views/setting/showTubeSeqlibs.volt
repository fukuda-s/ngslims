<div class="tube-group">
  <div class="tube tube-header" style="margin: 2px 0 2px 0 !important;">
    <div class="row">
      <div class="col-md-8 col-sm-10">Seqlib Name</div>
      <div class="col-md-1 col-sm-2">#used</div>
      <div class="col-md-3">Barcode</div>
    </div>
  </div>
  {% for seqlib in seqlibs %}
    {% if loop.first %}
      <div class="tube-list" id="seqlib_candidate_holder" style="max-height: 400px;overflow-y: scroll;">
    {% endif %}
    <div
        class="tube {% if seqlib.se.status == '' %}tube-active{% else %}tube-inactive{% endif %}"
        id="seqlib_id-{{ seqlib.sl.id }}" style="margin: 2px 0 2px 0 !important;">
      <div class="row">
        <div class="col-md-8 col-sm-10">
          {{ seqlib.sl.name }}
        </div>
        <div class="col-md-1 col-sm-2">
          {{ seqlib.sta_count }}
        </div>
        <div class="col-md-3" data-toggle="tooltip" data-placement="right" title="{{ seqlib.pt.name }}">
          {% if seqlib.sl.oligobarcodeA_id is empty %}
            (Undefined)
          {% elseif seqlib.sl.oligobarcodeB_id is empty %}
            {{ '(' ~ seqlib.sl.OligobarcodeA.name ~ ' : ' ~ seqlib.sl.OligobarcodeA.barcode_seq ~ ')' }}
          {% else %}
            {{ '(' ~ seqlib.sl.OligobarcodeA.name ~ '-' ~ seqlib.sl.OligobarcodeB.name ~ ' : ' ~ seqlib.sl.OligobarcodeA.barcode_seq ~ '-' ~ seqlib.sl.OligobarcodeB.barcode_seq ~ ')' }}
          {% endif %}
        </div>
      </div>
    </div>
    {% if loop.last %}
      </div>
    {% endif %}
    {% elsefor %} No seqlibs are recorded
  {% endfor %}
</div>
<script>
  $(document).ready(function () {
    $('[data-toggle="tooltip"]').tooltip();
  });
</script>