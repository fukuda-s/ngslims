<div class="tube-group">
  <div class="tube tube-header">
    <div class="row">
      <div class="col-sm-3">Sample Name</div>
      <div class="col-sm-1">#used</div>
      <div class="col-sm-4"></div>
      <div class="col-sm-4">
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
    {% if seqlib.se.status == 'Completed' and seqlib.sta_count === 0 %}
    <div class="tube tube-active" id="seqlib-id-{{ seqlib.sl.id }}">
      {% else %}
      <div class="tube tube-inactive" id="seqlib-id-{{ seqlib.sl.id }}">
        {% endif %}
        <div class="row">
          <div class="col-sm-3">
            {{ seqlib.sl.name }}
          </div>
          <div class="col-sm-1">
            {{ seqlib.sta_count }}
          </div>
          <div class="col-sm-4">
            {{ seqlib.pt.name }}
          </div>
          <div class="col-sm-4">
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