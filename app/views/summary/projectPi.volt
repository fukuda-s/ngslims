{{ content() }}
{% for user in pi_users %}
  {% if user.PiProjects|length < 1 %}
    {% continue %}
  {% endif %}
  {% if loop.first %}
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
      <div id="addNewPI" class="panel-body panel-collapse collapse">
        <h4>Add New Project User</h4>

        <form class="form-horizontal" role="form">
          <div class="form-group">
            <label for="inputLastName" class="col-sm-2 control-label">Last Name</label>

            <div class="col-sm-10">
              <input type="text" class="form-control" id="inputLastName" placeholder="Last Name"/>
            </div>
          </div>
          <div class="form-group">
            <label for="inputFirstName" class="col-sm-2 control-label">First Name</label>

            <div class="col-sm-10">
              <input type="text" class="form-control" id="inputFirstName" placeholder="First Name"/>
            </div>
          </div>
          <div class="form-group">
            <label for="inputEmail" class="col-sm-2 control-label">Email</label>

            <div class="col-sm-10">
              <input type="email" class="form-control" id="inputEmail" placeholder="Email"/>
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
  <div class="panel panel-info" id="pi_user_id_{{ user.id }}">
    <div class="panel-heading" data-toggle="collapse" href="#list_user_id_{{ user.id }}" id="OwnerList">
      <h4 class="panel-title">
        <div class="row">
          <div class="col-md-8">
            <div class="">{{ user.getFullname() }}</div>
          </div>
          <div class="col-md-1">
            <span class="badge">{{ user.getPiProjects("active = 'Y'")|length }}</span>
          </div>
          <div class="col-md-1">
            <span class="badge">{{ user.PiSamples|length }}</span>
          </div>
          <div class="col-md-2">
            <a href="#" rel="tooltip" data-placement="right" data-original-title="Edit PI name"><i
                  class="glyphicon glyphicon-pencil"></i></a> <i
                class="indicator glyphicon glyphicon-chevron-right pull-right"></i>
          </div>

      </h4>
    </div>
    <ul class="list-group collapse" id="list_user_id_{{ user.id }}">
      {{ elements.getTrackerProjectSummaryProjectList( user.id ) }}
    </ul>
  </div>
  {% if loop.last %}
    </div>
  {% endif %}
  {% elsefor %} No projects are recorded {% endfor %}
<script>
  $(document).ready(function () {
    if (location.hash) {
      var list_user_id = location.hash.replace('pi_', 'list_');
      $(list_user_id).addClass('in');
      //console.log(list_user_id);
    }
  });
</script>
