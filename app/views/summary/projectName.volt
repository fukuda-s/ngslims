{{ content() }}
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

<div class="panel-group" id="projectOverview">
  <div class="panel panel-default">
    <div class="panel-heading">
      <div class="row">
        <div class="col-md-6">Project Name</div>
        <div class="col-md-3">PI Name</div>
        <div class="col-md-1">
          <small>#sample</small>
        </div>
        <div class="col-md-2">
        </div>
      </div>
    </div>
  </div>
  {% for project in projects %}
    {% if project.Samples|length == 0 %}
      {% continue %}
    {% endif %}
    <div class="panel panel-success">
      <div class="panel-heading" data-toggle="collapse" data-target="#project_panel_body_{{ project.id }}">
        <h4 class="panel-title">
          <div class="row">
            <div class="col-md-6">
              <div class="">{{ project.name }}</div>
            </div>
            <div class="col-md-3">
              {% if project.pi_user_id > 0 and project.PIs is defined %}
                <div class="">{{ project.PIs.getFullname() }}</div>
              {% else %}
                <div class="">(Undefined)</div>
              {% endif %}
            </div>
            <div class="col-md-1">
              <span class="badge">{{ project.Samples|length }}</span>
            </div>
            <div class="col-md-2">
              <a href="#" rel="tooltip" data-placement="right" data-original-title="Edit Project"><i
                    class="glyphicon glyphicon-pencil"></i></a> <i
                  class="indicator glyphicon glyphicon-chevron-right pull-right"></i>
            </div>
          </div>
        </h4>
      </div>
      <div class="panel-body collapse" id="project_panel_body_{{ project.id }}">
        <p>
          {{ link_to("trackerdetails/showTableSamples/" ~ project.id ~ "?pre_action=projectName", "» Link to detail of project samples") }}
        </p>
        <div id="project_progress_{{ project.id }}"></div>
      </div>
    </div>
    {% elsefor %} No projects are recorded
  {% endfor %}
</div>
<script>
  /*
   * Show Progress Bar on #project_progress_<project_id>
   */
  function showProgressBar(project_id) {
    var target_id = '#project_progress_' + project_id;
    $.ajax({
      url: '{{ url("summary/projectNameProgress") }}',
      dataType: 'html',
      type: 'POST',
      data: {
        project_id: project_id
      }
    })
        .done(function (data) {
          $(target_id).replaceWith(data);
        });
  }

  $(document).ready(function () {
    $("[id^=project_panel_body_]").each(function () {
      $(this).on('show.bs.collapse', function () {
        var project_id = $(this).attr("id").replace('project_panel_body_', '');
        showProgressBar(project_id);
      });
    });

  })
</script>
