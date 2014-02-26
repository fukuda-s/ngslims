<div class="tube-group">
  <div class="tube">
    <div class="row">
      <div class="col-md-8"> Sample Name</div>
      <div class="col-md-4">
        <button type="button" class="btn btn-default btn-xs" id="show-inactive" style="min-width: 87px">Show inactive
        </button>
        <button type="button" class="btn btn-default btn-xs pull-right" id="add-all-to-icebox">Add all</button>
      </div>
    </div>
  </div>
  {% for seqlib in seqlibs %}
    {% if loop.first %}
      <div class="tube-list" id="SampleHolder">
    {% endif %}
    <div class="tube tube-active">{{ seqlib.sl.name }}</div>
    {% if loop.last %}
      </div>
    {% endif %}
  {% else %} No seqlibs are recorded
  {% endfor %}
</div>
</div>