{{ content() }}
{% for instrument_type in instrument_types %}
  {% if loop.first %}
    <div class="panel-group" id="accordion">
    <div class="panel panel-default">
      <div class="panel-heading">
        <div class="row">
          <div class="col-md-9">Instrument Type</div>
          <div class="col-md-1">
            <small>#flowcells</small>
          </div>
          <div class="col-md-2">
            <a class="glyphicon glyphicon-plus pull-right" data-toggle="collapse" data-target="#addNewExperimentStep"
               href="#"></a>
          </div>
        </div>
      </div>
    </div>
  {% endif %}
  <div class="panel panel-success">
    {{ link_to("tracker/project") }}
    <div class="panel-heading" id="StepList">
      <h4 class="panel-title">
        <div class="row">
          <div class="col-md-9">{{ link_to("tracker/sequenceSetupCandidates/" ~ instrument_type.id, instrument_type.name) }}</div>
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
  </div>
  {% if loop.last %}
    </div>
  {% endif %}
{% elsefor %} No experiments are recorded {% endfor %}
