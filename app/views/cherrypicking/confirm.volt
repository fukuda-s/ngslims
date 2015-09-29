{{ flashSession.output() }}
{{ content() }}

<form id="pick_form" method="post">
  <div class="row">
    <div class="col-sm-3">
      <div class="form-group">
        <label for="cherry_pickings">Cherry Picking List</label>
        <span></span>
        <button type="button" class="btn btn-default btn-xs" data-toggle="modal" data-target="#modal-cherrypicking">
          <span class="fa fa-plus"></span>
        </button>
        {{ select('cherry_pickings', [] , 'class': "form-control") }}
      </div>
      <div class="clearfix"></div>
    </div>
  </div>
</form>

{% include 'partials/modal-cherrypicking.volt' %}

<div class="tube-group">
  <div class="tube tube-header">
    <div class="row">
      <div class="col-md-3 col-sm-10">Seqlib Name</div>
      <div class="col-md-1 col-sm-2">#used</div>
      <div class="col-md-2">Barcode</div>
      <div class="col-md-2">Protocol</div>
      <div class="col-md-4">Requested Sequence Run Type</div>
    </div>
  </div>
  {% for seqlib in seqlibs %}
    {% if loop.first %}
      <div class="tube-list" id="picked-tube-holder">
    {% endif %}
    <div
        class="tube {% if seqlib.se.status == '' %}tube-active{% else %}tube-inactive" style="display: block{% endif %}"
        id="seqlib-id-{{ seqlib.sl.id }}">
      <div class="row">
        <div class="col-md-3 col-sm-10">
          {{ seqlib.sl.name }}
        </div>
        <div class="col-md-1 col-sm-2">
          {{ seqlib.sta_count }}
        </div>
        <div class="col-md-2">
          {% if seqlib.sl.oligobarcodeA_id is empty %}
            (Undefined)
          {% elseif seqlib.sl.oligobarcodeB_id is empty %}
            {{ seqlib.sl.OligobarcodeA.barcode_seq }}
          {% else %}
            {{ seqlib.sl.OligobarcodeA.barcode_seq ~ '-' ~ seqlib.sl.OligobarcodeB.barcode_seq }}
          {% endif %}
        </div>
        <div class="col-md-2">
          {{ seqlib.pt.name }}
        </div>
        <div class="col-md-4">
          {{ seqlib.it.name ~ ' ' ~ seqlib.srmt.name ~ ' ' ~ seqlib.srct.name ~ seqlib.srrt.name }}
        </div>
      </div>
    </div>
    {% if loop.last %}
      </div>
    {% endif %}
    {% elsefor %} No seqlibs are recorded
  {% endfor %}
</div>

<hr>

<h4>Selected Cherry Picking List</h4>
<h5 id="prev_cherry_picking_list_title"></h5>
<div id="prev_cherry_picking_tube_list"></div>

<div class="row">
  <div class="col-md-2">
    <button type="button" class="btn btn-info pull-left" onclick="location.href='{{ previous_page }}'">&laquo; Back
    </button>
  </div>
  <div class="col-md-8">
  </div>
  <div class="col-md-2">
    <button type="button" class="btn btn-primary pull-right" onclick="saveCherryPicking()">Save &raquo;</button>
  </div>
</div>

<script>
  function saveCherryPicking() {
    var cherry_picking_id = $('#cherry_pickings').val();
    var seqlib_id_str =
        $('#picked-tube-holder')
            .find('.tube')
            .not('.tube-warning')
            .map(function () {
              return this.id.replace('seqlib-id-', '');
            })
            .get()
            .join(',');

    //console.log(cherry_picking_id);
    //console.log(seqlib_id_str);

    if (!cherry_picking_id) {
      alert('Please create new Cherrypicing List.');
      return false;
    }

    $.ajax({
      url: 'saveCherrypicking',
      type: 'post',
      data: {cherry_picking_id: cherry_picking_id, seqlib_id_str: seqlib_id_str}
    })
        .done(function () {
          document.location = 'index';
        });

  }

  function createCherrypicking(event) {
    // Cancel HTML submit
    event.preventDefault();

    // 操作対象のフォーム要素を取得
    var $form = $(event.target);

    // 送信ボタンを取得
    // （後で使う: 二重送信を防止する。）
    var $button = $form.find('button');

    // 送信
    $.ajax({
      url: 'createCherrypicking',
      type: $form.attr('method'),
      data: $form.serialize(),
      timeout: 10000,  // 単位はミリ秒
      // 送信前
      beforeSend: function (xhr, settings) {
        // ボタンを無効化し、二重送信を防止
        $button.attr('disabled', true);
      }
    })

      // 応答後
        .always(function (xhr, textStatus) {
          // ボタンを有効化し、再送信を許可
          $button.attr('disabled', false);
        })

      // 通信成功時の処理
        .done(function (data) {
          // 入力値を初期化
          $form[0].reset();
          //console.log(data);
          alert(data);
          getCherryPickingSelectList();
          $('#modal-cherrypicking').modal('hide');
        })
        .fail(function (xhr, textStatus, error) {
          console.log(xhr);
          console.log(textStatus);
          console.log(error);
        });
  }

  function getCherryPickingSelectList() {
    $.ajax({
      url: 'cherryPickingSelectList',
      type: 'post',
      dataType: 'html'
    })
        .done(function (data) {
          $('#cherry_pickings').html($(data).children());
          showTubeSeqlibs(); //show tube-list in current cherry_picking.
        });
  }

  function showTubeSeqlibs() {
    var cherry_picking_id = $('#cherry_pickings').val();
    //console.log(cherry_picking_id);
    $.ajax({
      url: 'showTubeSeqlibs',
      type: 'post',
      dataType: 'html',
      data: {cherry_picking_id: cherry_picking_id}
    })
        .done(function (data) {
          $('#prev_cherry_picking_tube_list').html(data);
          $('.tube-inactive').css('display', 'block');
          $('#prev_cherry_picking_list_title').text($('#cherry_pickings option:selected').text());

          $('#picked-tube-holder')
              .find('.tube')
              .each(function () {
                $(this).removeClass('tube-warning');
              });

          $(data)
              .find('.tube-list')
              .children('.tube')
              .each(function () {
                var seqlib_id = this.id;
                //console.log(seqlib_id);
                $('#picked-tube-holder')
                    .find('#' + seqlib_id)
                    .each(function () {
                      $(this).addClass('tube-warning');
                    });
              });
        });
  }

  $(document).ready(function () {
    getCherryPickingSelectList(); //Replace select list at first;

    $('#create_cherrypicking_form').submit(function (event) {
      createCherrypicking(event)
    });

    $('#cherry_pickings').change(function () {
      //console.log('change');
      showTubeSeqlibs(); //show tube-list in current cherry_picking.
    })

  });
</script>