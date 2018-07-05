{{ content() }}
{{ flashSession.output() }}
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

<div class="col-md-12">
  <div class="panel panel-default">
    <div class="panel-heading">
      Your Order
    </div>
    <ul class="list-group">
      <li class="list-group-item text-info">User & Project
        <ul id="user_project_selected" class="text-muted">
          <li id="lab_name_selected">{{ lab.name }}</li>
          <li id="pi_user_name_selected">{{ pi_user.name }}</li>
          <li id="project_name_selected">{{ project.name }}</li>
        </ul>
      </li>
      <li class="list-group-item text-info">Sample
        <ul id="sample_selected" class="text-muted">
          <li id="sample_type_name_selected">{{ sample_type.name }}</li>
          <li id="organism_name_selected">{{ organism.name }}</li>
          <li id="sample_count">{{ sample_count }} sample(s)</li>
        </ul>
      </li>
      <li class="list-group-item text-info">Seqlib & Multiplex
        <ul id="seqlib_selected" class="text-muted">
          {% if seqlib_undecided.name === "true" %}
            <li class="text-warning">Undecided</li>
          {% else %}
            <li id="step_name_selected">{{ step.name }}</li>
            <li id="protocol_name_selected">{{ protocol.name }}</li>
            {% if samples_per_seqtemplate.name is defined %}
              <li id="samples_per_seqtemplate">{{ samples_per_seqtemplate.name }} sample(s)/1 seqtemplate</li>
            {% else %}
              <li id="samples_per_seqtemplate"># of sample(s)/1 seqtemplate is undefined</li>
            {% endif %}
          {% endif %}
        </ul>
      </li>
      <li class="list-group-item text-info">Sequencing
        <ul id="seqrun_selected" class="text-muted">
          {% if seqrun_undecided.name === "true" %}
            <li class="text-warning">Undecided</li>
          {% else %}
            <li id="instrument_type_name_selected">{{ instrument_type.name }}</li>
            <li id="seq_runmode_type_name_selected">{{ seq_runmode_type.name }}</li>
            <li id="seq_runread_type_name_selected">{{ seq_runread_type.name }}</li>
            <li id="seq_runcycle_type_name_selected">{{ seq_runcycle_type.name }}</li>
            {% if lanes_per_seqtemplate.name is defined %}
              <li id="lanes_per_seqtemplate">{{ lanes_per_seqtemplate.name }} lane(s)/1 seqtemplate</li>
            {% else %}
              <li id="lanes_per_seqtemplate"># of lane(s)/1 seqtemplate is undefined</li>
            {% endif %}
          {% endif %}
        </ul>
      </li>
      <li class="list-group-item text-info">Pipeline
        <ul id="pipeline_selected" class="text-muted">
        </ul>
      </li>
    </ul>
    <div class="panel-footer">
      <div class="btn-group pull-left">
        <button type="button" class="btn btn-default" id="checkout"
                onclick="location.href='{{ url("order/newOrder") }}'"><span
              class="glyphicon glyphicon-chevron-left"></span> Back To Order Form
        </button>
        <button type="button" class="btn btn-default" id="saveorder"
                onclick="location.href='{{ url("order/saveOrder") }}'"><span
              class="glyphicon glyphicon-floppy-disk"></span> Save Order
        </button>
      </div>
      <button type="button" class="btn btn-info pull-right" id="checkout"
              onclick="location.href='{{ url("order/checkout") }}'"> Check Out <span
            class="glyphicon glyphicon-chevron-right"></span>
      </button>
      <div class="clearfix"></div>
    </div>
  </div>
</div>
