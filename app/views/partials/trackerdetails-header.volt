{% if type == 'SHOW' %}
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

<ol class="breadcrumb">
    <li>{{ link_to("tracker", "Tracker") }}</li>
    <li>{{ link_to("summary/" ~ previousAction, "Project Overview") }}</li>
    {% if project.PIs is empty %}
      <li>(Undefined PI)</li>
    {% else %}
      <li>{{ linkTo("summary/projectPi#pi_user_id_" ~ project.PIs.id , project.PIs.getFullname() ) }}</li>
    {% endif %}
    <li class="active">{{ project.name }}</li>
  </ol>
{% elseif type == 'PICK' %}
  <ol class="breadcrumb">
    <li>{{ link_to("tracker", "Tracker") }}</li>
    <li>{{ cherrypicking.name ~ ' (' ~ cherrypicking.cherryPickingSchemes|length ~ ') -- ' ~ cherrypicking.created_at }}</li>
  </ol>
{% else %}
  <ol class="breadcrumb">
    <li>{{ link_to("tracker", "Tracker") }}</li>
    <li>{{ link_to('tracker/experiments/' ~ step.step_phase_code , step.StepPhases.description ~ ' View' ) }}</li>
    <li>{{ link_to('tracker/experimentDetails/' ~ step.id , step.name ) }}</li>
    {% if project.PIs is empty %}
      <li>(Undefined PI)</li>
    {% else %}
      <li>{{ linkTo('tracker/experimentDetails/' ~ step.id ~ '?pi_user_id=' ~ project.PIs.id ~ '&status=' ~ status, project.PIs.getFullname() ) }}</li>
    {% endif %}
    <li class="active">{{ project.name }}</li>
  </ol>
{% endif %}
{{ content() }}
