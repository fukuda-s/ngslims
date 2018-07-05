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
      <li class="active">Organisms</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="organismsEdit(-1, '', '', '', '', 'Y', 0)"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Organism
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Organism</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Organism</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="organism-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Organism Name</th>
        <th>Taxonomy ID</th>
        <th>Taxonomy</th>
        <th>Sort Order</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for organism in organisms %}
        {% set active = organism.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ organism.id }}</td>
          <td>{{ organism.name }}</td>
          <td>{{ organism.taxonomy_id }}</td>
          <td>{{ organism.taxonomy }}</td>
          <td>{{ organism.sort_order }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set organism_sample_count = organism.Samples|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="organismsEdit('{{ organism.id }}', '{{ organism.name }}', '{{ organism.taxonomy_id }}', '{{ organism.taxonomy }}', '{{ organism.sort_order }}', '{{ organism.active }}', '{{ organism_sample_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {% if organism_sample_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="organismsRemove({{ organism.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Organism. This Organism is already used by " ~ organism_sample_count ~ " samples." %}
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
<div class="modal fade form-horizontal" id="modal-organism-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-organism-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-organism-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-organism_id', 'class': 'form-control') }}
        <div class="form-group form-group-sm">
          <label for="modal-taxonomy_id" class="col-sm-3 control-label" style="font-size: 9pt">Taxonomy ID</label>
          <div class="col-sm-9">
            {{ numeric_field('modal-taxonomy_id', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-taxonomy" class="col-sm-3 control-label" style="font-size: 9pt">Taxonomy</label>
          <div class="col-sm-9">
            {{ text_field('modal-taxonomy', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Organism Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-sort_order" class="col-sm-3 control-label" style="font-size: 9pt">Sort Order</label>
          <div class="col-sm-9">
            {{ numeric_field('modal-sort_order', 'class': 'form-control') }}
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
          <button type="button" id="modal-organism-save" class="btn btn-primary pull-right disabled"
                  onclick="organismsSave()">
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
  function organismsEdit(organism_id, name, taxonomy_id, taxonomy, sort_order, active, organism_sample_count) {

    $('#modal-organism_id').val(organism_id);
    $('#modal-name').val(name);
    $('#modal-taxonomy_id').val(taxonomy_id);
    $('#modal-taxonomy').val(taxonomy);
    $('#modal-sort_order').val(sort_order);
    $('#modal-active').val(active);


    // @TODO should be consider details condition of details
    if (organism_sample_count > 0) {
      $('#modal-taxonomy_id').prop('disabled', true);
      $('#modal-active').prop('disabled', true);
    } else {
      $('#modal-taxonomy_id').prop('disabled', false);
      $('#modal-active').prop('disabled', false);
    }

    $('#modal-organism-save')
        .prop('disabled', true)
        .addClass('disabled');

    $('#modal-organism-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function organismsSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input Organism name.');
      return false;
    }

    $('#modal-organism-edit').modal('hide');

    var organism_id = $('#modal-organism_id').val();
    var name = $('#modal-name').val();
    var taxonomy_id = $('#modal-taxonomy_id').val();
    var taxonomy = $('#modal-taxonomy').val();
    var sort_order = $('#modal-sort_order').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/organisms',
      data: {
        organism_id: organism_id,
        name: name,
        taxonomy_id: taxonomy_id,
        taxonomy: taxonomy,
        sort_order: sort_order,
        active: active
      }
    })
        .done(function (data) {
          //console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete organism record. (It will be soft-deleted (active=N).)
   * @param organism_id
   * @returns {boolean}
   */
  function organismsRemove(organism_id) {
    if (!organism_id) {
      alert('Error: Could not found organism_id value.');
      return false;
    }

    if (window.confirm("This Organism will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/organisms',
        data: {
          organism_id: organism_id,
          active: 'N'
        }
      })
          .done(function (data) {
            //console.log(data);
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
    $('#organism-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-organism-edit')
        .find('input, select')
        .change(function () {
          $('#modal-organism-save')
              .prop('disabled', false)
              .removeClass('disabled');
        });

  });
</script>