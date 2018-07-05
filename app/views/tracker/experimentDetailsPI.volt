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
  <li class="active"><a href="#">PI</a></li>
  <li>{{ link_to('tracker/experimentDetails/' ~ step.id ~ '?view_type=PJ', 'Project') }}</li>
  <li>{{ link_to('tracker/experimentDetails/' ~ step.id ~ '?view_type=CP', 'Cherry Picking') }}</li>
</ul>
<div class="panel-group" id="projectOverview">
  {% for user in pi_users %}
    {% if loop.first %}
      <div class="panel panel-default">
        <div class="panel-heading">
          <div class="row">
            <div class="col-md-8">PI name</div>
            <div class="col-md-1">
              <small>#project</small>
            </div>
            <div class="col-md-1">
              <small>#sample</small>
            </div>
            <div class="col-md-2">
              <button type="button" class="btn btn-default btn-xs" id="show-inactive" data-toggle="collapse"
                      data-target="[id^=inactives]">
                Show Completed/On Hold
              </button>
            </div>
          </div>
        </div>
      </div>
    {% endif %}

    {% if user.status is empty or user.status is 'In Progress' %}
      {% set active_status = 'active' %}
    {% else %}
      {% set active_status = 'inactive' %}
    {% endif %}

    <div {% if active_status is 'active' %} class="panel panel-info" id="pi_user_id_{{ user.u.id }}"
    {% else %} class="panel panel-default collapse" id="inactives-{{ user.u.id }}" {% endif %}>
      <div class="panel-heading" data-toggle="collapse"
           data-target="#list_user_id_{{ user.u.id }}[status='{{ user.status }}']" id="OwnerList">
        <h4 class="panel-title">
          <div class="row">
            <div class="col-md-8">
              <div class="">{{ user.u.getFullname() }}</div>
            </div>
            <div class="col-md-1">
          <span
              class="badge">{{ user.project_count }}</span>
            </div>
            <div class="col-md-1">
          <span
              class="badge">{{ user.sample_count }}</span>
            </div>
            <div class="col-md-1">
              {{ user.status }}
            </div>
            <div class="col-md-1">
              <i class="indicator glyphicon glyphicon-chevron-right pull-right"></i>
            </div>
          </div>
        </h4>
      </div>
      <ul class="list-group collapse" id="list_user_id_{{ user.u.id }}" status="{{ user.status }}">
        {{ elements.getTrackerExperimentDetailProjectList( user.u.id, step.step_phase_code, step.id, user.status ) }}
      </ul>
    </div>
    {% elsefor %} No projects are recorded
  {% endfor %}
</div>