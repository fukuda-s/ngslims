{{ content() }}

{% for user in users %} {% if loop.first %}
<div class="panel-group" id="projectOverview">
  <div class="panel panel-default">
    <div class="panel-heading">
      <div class="row">
        <div class="col-md-8">PI</div>
        <div class="col-md-1">
          <small>#project</small>
        </div>
        <div class="col-md-1">
          <small>#sample</small>
        </div>
        <div class="col-md-2">
          <a class="glyphicon glyphicon-plus pull-right" data-toggle="collapse" data-target="#addNewPI" href="#"></a>
        </div>
      </div>
    </div>
  </div>
  <div class="panel panel-default">
    <div id="addNewPI" class="panel-body panel-collapse collapse">
      <form class="form-horizontal" role="form">
        <div class="form-group">
          <label for="inputLastName" class="col-sm-2 control-label">Last Name</label>
          <div class="col-sm-10">
            <input type="text" class="form-control" id="inputLastName" placeholder="Last Name" />
          </div>
        </div>
        <div class="form-group">
          <label for="inputFirstName" class="col-sm-2 control-label">First Name</label>
          <div class="col-sm-10">
            <input type="text" class="form-control" id="inputFirstName" placeholder="First Name" />
          </div>
        </div>
        <div class="form-group">
          <label for="inputEmail" class="col-sm-2 control-label">Email</label>
          <div class="col-sm-10">
            <input type="email" class="form-control" id="inputEmail" placeholder="Email" />
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
  <div class="panel panel-info">
    <div class="panel-heading" data-toggle="collapse" href="#user_id_{{ user.id }}" id="OwnerList">
      <h4 class="panel-title">
        <div class="row">
          <div class="col-md-8">
            <div class="">{{ user.name }}</div>
          </div>
          <div class="col-md-1">
            <span class="badge">{{ user.project_count }}</span>
          </div>
          <div class="col-md-1">
            <span class="badge">{{ user.sample_count }}</span>
          </div>
          <div class="col-md-2">
            <a href="#" rel="tooltip" data-placement="right" data-original-title="Edit PI name"><i class="glyphicon glyphicon-pencil"></i></a> <i
              class="indicator glyphicon glyphicon-chevron-right pull-right"></i>
          </div>

      </h4>
    </div>
    <ul class="list-group">
      <div id="user_id_{{ user.id }}" class="panel-body panel-collapse collapse">
        <button class="btn btn-success btn-add-panel" data-toggle="collapse" data-target="#addNewProject">
          <i class="glyphicon glyphicon-plus"></i> Add new Project
        </button>
        <div class="panel panel-default">
          <div id="addNewProject" class="panel-body panel-collapse collapse">
            <form class="form-inline" role="form">
              <div class="form-group">
                <label class="sr-only" for="inputProjectName">Project Name</label> <input type="text" class="form-control" id="inputProjectName" placeholder="Project Name" />
              </div>
              <button type="submit" class="btn btn-default">Submit</button>
            </form>
          </div>
        </div>
        {{ elements.getTrackerProjectList( user.id ) }}
      </div>
    </ul>
  </div>
  {% if loop.last %}
</div>
{% endif %} {% else %} No projects are recorded {% endfor %}
