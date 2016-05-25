<ul class="nav nav-tabs">
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=PI', 'PI') }}</li>
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=PJ', 'Project') }}</li>
  <li class="active"><a href="#">Cherry Picking</a></li>
</ul>
<div class="panel-group" id="projectOverview">
  {% for cherry_picking in cherry_pickings %}
    {% if loop.first %}
      <div class="panel panel-default">
        <div class="panel-heading">
          <div class="row">
            <div class="col-md-7">Cherry Picking Name</div>
            <div class="col-md-2">User Name</div>
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

    {% if cherry_picking.status is empty or cherry_picking.status is 'In Progress' %}
      {% set active_status = 'active' %}
    {% else %}
      {% set active_status = 'inactive' %}
    {% endif %}

    <div {% if active_status is 'active' %} class="panel panel-info" id="cherry_picking_id_{{ cherry_picking.cp.id }}"
    {% else %} class="panel panel-default collapse" id="inactives-{{ cherry_picking.cp.id }}" {% endif %}>
      <div class="panel-heading" id="OwnerList">
        <h4 class="panel-title">
          <div class="row">
            <div class="col-md-7">
              {% if step.step_phase_code is 'QC' %}
                <div class="">{{ link_to('trackerdetails/editSamples/PICK/0/' ~ cherry_picking.cp.id, cherry_picking.cp.name ~ ' -- ' ~ cherry_picking.cp.created_at) }}</div>
              {% elseif step.step_phase_code is 'PREP' %}
                <div class="">{{ link_to('trackerdetails/editSeqlibs/PICK/0/' ~ cherry_picking.cp.id, cherry_picking.cp.name ~ ' -- ' ~ cherry_picking.cp.created_at) }}</div>
              {% endif %}
            </div>
            <div class="col-md-2">
              <div class="">{{ cherry_picking.u.getFullname() }}</div>
            </div>
            <div class="col-md-2">
              <span class="badge">{{ cherry_picking.sample_count }}</span>
            </div>
            <div class="col-md-1">
              <!--<i class="indicator glyphicon glyphicon-chevron-right pull-right"></i>-->
            </div>
          </div>
        </h4>
      </div>
    </div>
    {% elsefor %} No cherry_pickings are recorded
  {% endfor %}
</div>