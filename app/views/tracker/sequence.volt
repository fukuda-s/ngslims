{{ content() }}
{% for instrument_type in instrument_types %}
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
    {{ link_to("summary/projectPi") }}
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
