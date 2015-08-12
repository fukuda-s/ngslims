<div class="tube-group">
  <div class="tube tube-header">
    <div class="row">
      <div class="col-md-3 col-sm-10">Seqlib Name</div>
      <div class="col-md-1 col-sm-2">#used</div>
      <div class="col-md-2">Barcode</div>
      <div class="col-md-2"></div>
      <div class="col-md-4">
        <button type="button" class="btn btn-default btn-xs" id="show-inactive-tube"
                style="max-height: 25px; min-width: 87px">Show Inactive
        </button>
        <input id="tube-filter" type="search" class="form-control input-xs" placeholder="Filtering Search">
        <button type="button" class="btn btn-default btn-xs pull-right" id="select-all">Select All
        </button>
      </div>
    </div>
  </div>
  {% for seqlib in seqlibs %}
    {% if loop.first %}
      <div class="tube-list" id="sample-holder">
    {% endif %}
    <div
        class="tube {% if seqlib.se.status == '' %}tube-active{% else %}tube-inactive{% endif %}"
        id="seqlib-id-{{ seqlib.sl.id }}">
      <div class="row">
        <div class="col-md-3 col-sm-10">
          {{ seqlib.sl.name }}
        </div>
        <div class="col-md-1 col-sm-2">
          {{ seqlib.sta_count }}
        </div>
        <div class="col-md-2">
          {% if seqlib.sl.oligobarcodeA_id is empty %}
            (Undefined)
          {% elseif seqlib.sl.oligobarcodeB_id is empty %}
            {{ seqlib.sl.OligobarcodeA.barcode_seq }}
          {% else %}
            {{ seqlib.sl.OligobarcodeA.barcode_seq ~ '-' ~ seqlib.sl.OligobarcodeB.barcode_seq }}
          {% endif %}
        </div>
        <div class="col-md-2">
          {{ seqlib.pt.name }}
        </div>
        <div class="col-md-4">
          {{ seqlib.it.name ~ ' ' ~ seqlib.srmt.name ~ ' ' ~ seqlib.srct.name ~ seqlib.srrt.name }}
        </div>
      </div>
    </div>
    {% if loop.last %}
      </div>
    {% endif %}
    {% elsefor %} No seqlibs are recorded
  {% endfor %}
</div>