{{ content() }}
{% for step in steps %}
  {% if loop.first %}
    <div class="panel-group" id="accordion">
    <div class="panel panel-default">
      <div class="panel-heading">
        <div class="row">
          <div class="col-md-8">Experiment Step</div>
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
            <div class="col-sm-offset-2 col-sm-10">
              <button type="submit" class="btn btn-default">Submit</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  {% endif %}
  <div class="panel panel-success">
    <div class="panel-heading" id="StepList">
      <h4 class="panel-title">
        <div class="row">
          {% if step.step_phase_code == 'FLOWCELL' %}
            <div class="col-md-8">{{ link_to("tracker/flowcellSetupCandidates/" ~ step.id, step.name) }}</div>
          {% else %}
            <div class="col-md-8">{{ link_to("tracker/experimentDetails/" ~ step.id, step.name) }}</div>
          {% endif %}
          {% if step.step_phase_code === 'QC' %}
            <div class="col-md-1">
              <span class="badge">{{ step.sample_project_count }}</span>
            </div>
            <div class="col-md-1">
              <span class="badge">{{ step.sample_count }}</span>
            </div>
          {% elseif step.step_phase_code === 'PREP' %}
            <div class="col-md-1">
              <span class="badge">{{ step.seqlib_project_count }}</span>
            </div>
            <div class="col-md-1">
              <span class="badge">{{ step.seqlib_count }}</span>
            </div>
          {% endif %}
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
  {% elsefor %} No experiments are recorded {% endfor %}
