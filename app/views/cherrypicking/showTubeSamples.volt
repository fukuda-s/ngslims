<div class="tube-group">
  <div class="tube tube-header">
    <div class="row">
      <div class="col-md-3 col-sm-10">Sample Name</div>
      <div class="col-md-1 col-sm-2">#used</div>
      <div class="col-md-2">Sample Type</div>
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
  {% for sample in samples %}
    {% if loop.first %}
      <div class="tube-list" id="sample-holder">
    {% endif %}
    <div
        class="tube {% if sample.sse.status === 'Completed' %}tube-active{% else %}tube-inactive{% endif %}"
        id="sample-id-{{ sample.s.id }}">
      <div class="row">
        <div class="col-md-3 col-sm-10">
          {{ sample.s.name }}
        </div>
        <div class="col-md-1 col-sm-2">
          {{ sample.sl_count }}
        </div>
        <div class="col-md-2">
          {{ sample.st.name }}
        </div>
        <div class="col-md-2">
        </div>
        <div class="col-md-4">
        </div>
      </div>
    </div>
    {% if loop.last %}
      </div>
    {% endif %}
    {% elsefor %} No samples are recorded
  {% endfor %}
</div>