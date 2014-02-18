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
            <a class="glyphicon glyphicon-plus pull-right" data-toggle="collapse" data-target="#addNewExperimentStep"
               href="#"></a>
          </div>
        </div>
      </div>
      <div id="addNewExperimentStep" class="panel-body panel-collapse collapse">
        <h4>Add New Experiment Step</h4>

        <form class="form-horizontal" role="form">
          <div class="form-group">
            <label for="inputStep" class="col-sm-2 control-label">Step Name</label>

            <div class="col-sm-10">
              <input type="text" class="form-control" id="inputStep" placeholder="Step Name"/>
            </div>
          </div>
          <div class="form-group">
            <label for="inputCodeNucleotide" class="col-sm-2 control-label">Nucleotide Type</label>

            <div class="col-sm-10">
              <select class="form-control">
                <option>DNA</option>
                <option>RNA</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label for="inputCodeStepPhase" class="col-sm-2 control-label">Step Phase</label>

            <div class="col-sm-10">
              <select class="form-control">
                <option>QC</option>
                <option>PREP</option>
                <option>MULTIPLEX</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
              <button type="submit" class="btn btn-default">Submit</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  {% endif %}
  <div class="panel panel-success">
    {{ link_to("tracker/project") }}
    <div class="panel-heading" id="StepList">
      <h4 class="panel-title">
        <div class="row">
          <div class="col-md-8">{{ instrument_type.name }}</div>
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
{% else %} No experiments are recorded {% endfor %}
