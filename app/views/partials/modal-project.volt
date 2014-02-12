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
          <label for="project_name">Project Name</label>
          {{ form.render("project_name") }}
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          {{ submit_button("Save", "class": "btn btn-success") }}
        </div>
      </form>
    </div>
  </div>
</div>