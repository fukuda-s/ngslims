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

<ul class="nav nav-tabs">
  <li>{{ link_to('tracker/experimentDetails/' ~ step.id ~ '?view_type=PI', 'PI') }}</li>
  <li class="active"><a href="#">Project</a></li>
  <li>{{ link_to('tracker/experimentDetails/' ~ step.id ~ '?view_type=CP', 'Cherry Picking') }}</li>
</ul>
<div class="panel-group" id="projectOverview">
  {% for project in projects %}
    {% if loop.first %}
      <div class="panel panel-default">
        <div class="panel-heading">
          <div class="row">
            <div class="col-md-6">Project Name</div>
            <div class="col-md-2">PI Name</div>
            <div class="col-md-1">
              <small>#seqlib</small>
            </div>
            <div class="col-md-2">
              <button type="button" class="btn btn-default btn-xs" id="show-inactive-panel" data-toggle="collapse"
                      data-target="[id^=inactives]">
                Show Completed/On Hold
              </button>
            </div>
          </div>
        </div>
      </div>
    {% endif %}

    {% if project.status is empty or project.status is 'In Progress' %}
      {% set active_status = 'active' %}
    {% else %}
      {% set active_status = 'inactive' %}
    {% endif %}

    <div {% if active_status is 'active' %} class="panel panel-info" id="project_id_{{ project.p.id }}"
    {% else %} class="panel panel-default collapse" id="inactives-{{ project.p.id }}" {% endif %}>
      <div class="panel-heading" id="OwnerList">
        <h4 class="panel-title">
          <div class="row">
            <div class="col-md-6">
              {% if step.step_phase_code is 'QC' %}
                <div
                    class="">{{ link_to('trackerdetails/editSamples/QC/' ~ step.id ~ '/' ~ project.p.id ~ '/NULL', project.p.name) }}</div>
              {% elseif step.step_phase_code is 'PREP' %}
                <div
                    class="">{{ link_to('trackerdetails/editSeqlibs/PREP/' ~ step.id ~ '/' ~ project.p.id ~ '/NULL', project.p.name) }}</div>
              {% endif %}
            </div>
            <div class="col-md-2">
              <div class="">{{ project.u.getFullname() }}</div>
            </div>
            <div class="col-md-2">
              <span class="badge">{{ project.sample_count }}</span>
            </div>
            <div class="col-md-1">
              <!--<i class="indicator glyphicon glyphicon-chevron-right pull-right"></i>-->
            </div>
          </div>
        </h4>
      </div>
    </div>
    {% elsefor %} No projects are recorded
  {% endfor %}
</div>