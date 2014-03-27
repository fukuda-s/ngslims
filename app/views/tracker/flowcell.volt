{{ content() }}
{% for instrument_type in instrument_types %}
  {% if loop.first %}
    <div class="panel-group" id="accordion">
    <div class="panel panel-default">
      <div class="panel-heading">
        <div class="row">
          <div class="col-md-8">Instrument Type</div>
          <div class="col-md-1">
            <small>#project</small>
          </div>
          <div class="col-md-1">
            <small>#sample</small>
          </div>
          <div class="col-md-2">
          </div>
        </div>
      </div>
    </div>
  {% endif %}
  <div class="panel panel-success">
    <div class="panel-heading" id="StepList">
      <h4 class="panel-title">
        <div class="row">
          <div class="col-md-8">{{ link_to('tracker/flowcellDetails/' ~ instrument_type.id, instrument_type.name) }}</div>
          <div class="col-md-1">
            <span class="badge">0</span>
          </div>
          <div class="col-md-1">
            <span class="badge">0</span>
          </div>
          <div class="col-md-2">
            <a rel="tooltip" data-placement="right" data-original-title="Configure Experiment Step"> <i
                  class="glyphicon glyphicon-pencil pull-right"></i>
            </a>
          </div>
        </div>
      </h4>
    </div>
    </a>
  </div>
  {% if loop.last %}
    </div>
  {% endif %}
  {% elsefor %} No platforms are recorded {% endfor %}
