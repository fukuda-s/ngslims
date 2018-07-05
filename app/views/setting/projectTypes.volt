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

<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Project Types</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="projectTypeEdit(-100, '', '', 'Y', '0')"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Project Type
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Project Types</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Project Types</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="project_type-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Project Type Name</th>
        <th>Description</th>
        <th>Created At</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for project_type in project_types %}
        {% set active = project_type.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ project_type.id }}</td>
          <td>{{ project_type.name }}</td>
          <td>{{ project_type.description }}</td>
          <td>{{ project_type.created_at }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set project_type_project_count = project_type.Projects|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="projectTypeEdit('{{ project_type.id }}', '{{ project_type.name }}', '{{ project_type.description }}', '{{ project_type.active }}', '{{ project_type_project_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {% if project_type_project_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="projectTypeRemove({{ project_type.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Project Type. This Project Type already has " ~ project_type_project_count ~ " projects." %}
              <a href="javascript:void(0)" data-toggle="tooltip" data-placement="bottom" title="{{ trash_message }}"
                 style="font-size: 9pt; color: #b9c4c8; cursor: not-allowed;" onclick="return false;">
                <span class="fa fa-trash"></span></a>
            {% endif %}
          </td>
        </tr>
      {% endfor %}
      </tbody>
    </table>
  </div>
</div>

<!-- Modal Confirm Copy-->
<div class="modal fade form-horizontal" id="modal-project_type-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-project_type-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-project_type-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-project_type_id') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Project Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-description" class="col-sm-3 control-label" style="font-size: 9pt">Description</label>
          <div class="col-sm-9">
            {{ text_field('modal-description', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-active" class="col-sm-3 control-label" style="font-size: 9pt">Active/In-active</label>
          <div class="col-sm-2">
            {{ select_static('modal-active', ['Y':'Y', 'N':'N'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
          <button type="button" id="modal-project_type-save" class="btn btn-primary pull-right disabled"
                  onclick="projectTypeSave()">
            Save
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>

  /**
   * Open modal window with filling values.
   */
  function projectTypeEdit(project_type_id, name, description, active, project_type_project_count) {

    $('#modal-project_type_id').val(project_type_id);
    $('#modal-name').val(name);
    $('#modal-description').val(description);
    $('#modal-active').val(active);

    if(project_type_project_count > 0) {
      $('#modal-active').prop('disabled', true);
    } else {
      $('#modal-active').prop('disabled', false);
    }


    $('#modal-project_type-save')
        .prop('disabled', true)
        .addClass('disabled');

    $('#modal-project_type-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function projectTypeSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input Project Type name.');
      return false;
    }

    $('#modal-lab-edit').modal('hide');

    var project_type_id = $('#modal-project_type_id').val();
    var name = $('#modal-name').val();
    var description = $('#modal-description').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/projectTypes',
      data: {
        project_type_id: project_type_id,
        name: name,
        description: description,
        active: active
      }
    })
        .done(function (data) {
          //console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete project_type record. (It will be soft-deleted (active=N).)
   * @param project_type_id
   * @returns {boolean}
   */
  function projectTypeRemove(project_type_id) {
    if (!project_type_id) {
      alert('Error: Could not found project_type_id value.');
      return false;
    }

    if (window.confirm("This Project will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/projectTypes',
        data: {
          project_type_id: project_type_id,
          active: 'N'
        }
      })
          .done(function () {
            window.location.reload(); // @TODO It should not be re-loaded.
          });
    }


  }

  /**
   * Show active=N rows function on button.
   */
  function showInactive(target) {
    $('.inactive').toggle();
    $(target).children('div').toggle();
  }

  /**
   * DataTables
   */
  $(document).ready(function () {
    $('#project_type-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-project_type-edit')
        .find('input, select')
        .change(function () {
          $('#modal-project_type-save')
              .prop('disabled', false)
              .removeClass('disabled');
        });

  });
</script>