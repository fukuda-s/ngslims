<div class="tube-group">
  <div class="tube tube-header">
    <div class="row">
      <div class="col-md-4">Sample Name</div>
      <div class="col-md-4"></div>
      <div class="col-md-4">
        <button type="button" class="btn btn-default btn-xs" id="show-inactive"
                style="max-height: 25px; min-width: 87px">Show Inactive
        </button>
        <button type="button" class="btn btn-default btn-xs pull-right" id="add-all-to-icebox">Select All</button>
      </div>
    </div>
  </div>
  {% for seqlib in seqlibs %}
    {% if loop.first %}
      <div class="tube-list" id="sample-holder">
    {% endif %}
    {% if seqlib.se.status == 'Completed' %}
      <div class="tube tube-active" id="seqlib-id-{{ seqlib.sl.id }}">
        <div class="row">
          <div class="col-md-4">
            {{ seqlib.sl.name }}
          </div>
          <div class="col-md-4">
            {{ seqlib.pt.name }}
          </div>
          <div class="col-md-4">
            {{ seqlib.it.name ~ ' ' ~ seqlib.srmt.name ~ ' ' ~ seqlib.srct.name ~ seqlib.srrt.name }}
          </div>
        </div>
      </div>
    {% else %}
      <div class="tube tube-inactive" id="seqlib-id-{{ seqlib.sl.id }}">{{ seqlib.sl.name }}</div>
    {% endif %}
    {% if loop.last %}
      </div>
    {% endif %}
    {% elsefor %} No seqlibs are recorded
  {% endfor %}
</div>