{{ content() }}
{{ flashSession.output() }}
{% for step in steps %}
  {% if loop.first %}
    <!--
  ~ (The MIT License)
  ~
  ~ Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining
  ~ a copy of this software and associated documentation files (the
  ~ 'Software'), to deal in the Software without restriction, including
  ~ without limitation the rights to use, copy, modify, merge, publish,
  ~ distribute, sublicense, and/or sell copies of the Software, and to
  ~ permit persons to whom the Software is furnished to do so, subject to
  ~ the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be
  ~ included in all copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  ~ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  ~ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  ~ IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  ~ CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  ~ TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  ~ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  -->

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
          {% if step.step_phase_code === 'MULTIPLEX' or step.step_phase_code === 'DUALMULTIPLEX' %}
            <div class="col-md-8">{{ link_to("tracker/multiplexCandidates/" ~ step.id, step.name) }}</div>
          {% elseif step.step_phase_code === 'FLOWCELL' %}
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
