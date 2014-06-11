<!-- Modal -->
<div class="modal fade" id="modal-project" tabindex="-1" role="dialog" aria-labelledby="modal-project-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-project-title">New Project</h4>
      </div>
      <form method="post" action="{{ url("order/saveProject") }}">
        <div class="modal-body">
          <ul>
            <li id="modal_project_lab_name"></li>
            <li id="modal_project_pi_user_name"></li>
          </ul>
          <div id="project_type_select" class="form-group">
            <label for="project_type_id" class="control-label">Project Type
            </label>
            {{ select('project_type_id', project_types, 'using': ['id', 'name'], 'useEmpty': true, 'emptyText': 'Please, choose Project Type...', 'emptyValue': '-1', 'class': 'form-control input-sm') }}
          </div>
          <div id="project_name_form" class="form-group">
            <label for="project_name">Project Name</label>
            {{ form.render("project_name") }}
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          {{ submit_button("Save", "class": "btn btn-success") }}
        </div>
      </form>
    </div>
  </div>
</div>