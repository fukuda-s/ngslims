<!-- Modal -->
<div class="modal fade" id="modal-cherrypicking" tabindex="-1" role="dialog" aria-labelledby="modal-cherrypicking-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-cherrypicking-title">New Cherry Picing List</h4>
      </div>
      <form id="create_cherrypicking_form" method="post">
        <div class="modal-body">
          <div id="cherrypicking_name_form" class="form-group">
            <label for="cherrypicking_name">Cherrypicking List Name</label>
            {{ text_field('cherrypicking_name', 'class': "form-control") }}
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