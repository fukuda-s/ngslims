<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li>{{ link_to('setting/seqtemplates', 'Seqtemplates') }}</li>
      <li>{{ seqtemplate.name }}</li>
      <li class="active">Seqtemplate Assoc. (Seqlibs)</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}
  </div>
</div>

{{ hidden_field('seqtemplate_id', 'value': seqtemplate.id) }}

<div class="row">
  <div class="col-md-6">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">Candidate Seqlib List</h3>
      </div>
      <div class="panel-body">
        <form id="pick_form" method="post">
          <div class="form-group">
            {{ text_field('pick_query', 'class': "form-control", 'placeholder': 'Search Seqlibs') }}
          </div>
        </form>
        <div class="tube-group">
          <div class="tube-list" id="seqlib_candidate_holder"
               style="font-family: Consolas, 'Courier New', Courier, Monaco, monospace;">
          </div>
        </div>
        <button type="button" id="seqtemplate_candidate_move" class="btn btn-primary pull-right"
                disabled="disabled">Move All &raquo;
        </button>
      </div>
    </div>
  </div>
  <div class="col-md-6">
    <div class="panel panel-default">
      <div class="panel-heading">
        <div class="row">
          <div class="col-sm-10">
            <h3 class="panel-title col-sm-10">Seqtemplate Assoc. Seqlibs List</h3>
          </div>
          <div class="col-sm-2">
            <button type="button" id="seqtemplate_assoc_seqlibs_save" class="btn btn-primary pull-right"
                    disabled="disabled">Save
            </button>
          </div>
        </div>
      </div>
      <div class="panel-body">
        <div class="form-group">
          {{ text_field('seqtemplate_assoc_seqlibs_filter', 'class': "form-control", 'placeholder': 'Search Seqlibs') }}
        </div>
        <div class="tube-group">
          <div class="tube-list" id="seqtemplate_assoc_seqlibs_holder"
               style="font-family: Consolas, 'Courier New', Courier, Monaco, monospace;">
            {% for seqtemplate_assoc in seqtemplate_assocs %}
              {% set seqtemplate_assoc_seqlib = seqtemplate_assoc.Seqlibs %}
              <div class="tube row" id="seqlib_id-{{ seqtemplate_assoc_seqlib.id }}" data-toggle="tooltip"
                   data-placement="right" title="{{ seqtemplate_assoc_seqlib.Protocols.name }}"
                   style="margin: 2px 0 2px 0 !important;">
                <div class="col-md-6">
                  {{ seqtemplate_assoc_seqlib.name }}
                </div>
                <div class="col-md-6">
                  {% if seqtemplate_assoc_seqlib.OligobarcodeA is empty %}
                    (Undefined)
                  {% elseif seqtemplate_assoc_seqlib.OligobarcodeB is empty %}
                    {{ '(' ~ seqtemplate_assoc_seqlib.OligobarcodeA.name ~ ' : ' ~ seqtemplate_assoc_seqlib.OligobarcodeA.barcode_seq ~ ')' }}
                  {% else %}
                    {{ '(' ~ seqtemplate_assoc_seqlib.OligobarcodeA.name ~ '-' ~ seqtemplate_assoc_seqlib.OligobarcodeB.name ~ ' : ' ~ seqtemplate_assoc_seqlib.OligobarcodeA.barcode_seq ~ '-' ~ seqtemplate_assoc_seqlib.OligobarcodeB.barcode_seq ~ ')' }}
                  {% endif %}
                  <a href="javascript:void(0)" class="tube-close pull-right" onclick="tubeCloseToggle(this)">
                    <i class="fa fa-times" aria-hidden="true"></i>
                    <i class="fa fa-repeat" aria-hidden="true" style="display: none"></i>
                  </a>
                </div>
              </div>
              {% elsefor %} No Seqlibs are recorded
            {% endfor %}
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
    /**
     * Filter tube from 'queryStr' which placed in 'target'.
     * @param queryStr
     * @param target
     */
    function tubeFilter(queryStr, target) {
        $(target)
            .find('.tube')
            .filter(function () {
                var css_display = $(this).css('display');
                var tube_textStr = $(this).text().toString();
                //console.log(index + ":" + css_display != 'none' && ! queryStr.test(tube_textStr));
                return css_display != 'none' && !queryStr.test(tube_textStr);
            })
            .addClass('tube-hidden');

        $(target)
            .find('.tube-hidden')
            .filter(function () {
                var tube_textStr = $(this).text().toString();
                return queryStr.test(tube_textStr);
            })
            .removeClass('tube-hidden');
    }

    /**
     * Toggle button icon and tube class
     */
    function tubeCloseToggle(target) {
        $(target)
            .parents('.tube')
            .toggleClass('tube-inactive');
        $(target)
            .find('i')
            .toggle();

        var seqtemplate_assoc_seqlibs_holder = $('#seqtemplate_assoc_seqlibs_holder');
        var seqtemplate_assoc_seqlibs_save = $('#seqtemplate_assoc_seqlibs_save');
        if (seqtemplate_assoc_seqlibs_holder.find('div.tube-active:not(.tube-inactive)').length //For dragged seqtemplate_assocs
            || seqtemplate_assoc_seqlibs_holder.find('div.tube-inactive:not(.tube-active)').length) { //For original seqtemplate_assocs
            seqtemplate_assoc_seqlibs_save.prop('disabled', false);
        } else {
            seqtemplate_assoc_seqlibs_save.prop('disabled', true);
        }
    }

    /**
     * Search and display seqlibs which searched from #pick_query
     */
    function showTubeSeqlibsWithSearch(event) {
        // Cancel HTML submit
        event.preventDefault();

        // 操作対象のフォーム要素を取得
        var $form = $(event.target);

        // 送信ボタンを取得
        // （後で使う: 二重送信を防止する。）
        var $button = $form.find('button');

        // 送信
        $.ajax({
            url: '/ngsLIMS/setting/showTubeSeqlibs',
            type: $form.attr('method'),
            data: $form.serialize(),
            dataType: 'html',
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
                //$form[0].reset();

                $('#seqlib_candidate_holder')
                    .siblings('.tube-header')
                    .remove();

                $('#seqlib_candidate_holder')
                    .replaceWith(data);

                var seqlib_candidate_holder = $('#seqlib_candidate_holder');

                $('#seqtemplate_candidate_move')
                    .removeAttr('disabled')
                    .click(function () {
                    seqlib_candidate_holder
                        .find('.tube')
                        .each(function(){
                            if (!$(this).find('button').length) {
                                $(this)
                                    .removeClass('tube-inactive')
                                    .addClass('tube-active')
                                    .find('div[class^=col-]:last')
                                    .append('<button type="button" class="tube-close pull-right">' +
                                        '<i class="fa fa-times" aria-hidden="true"></i>' +
                                        '<i class="fa fa-repeat" aria-hidden="true" style="display: none"></i>' +
                                        '</button>')
                                    .find('button.tube-close')
                                    .click(function () {
                                        tubeCloseToggle(this)
                                    });
                            }
                            $('#seqtemplate_assoc_seqlibs_holder')
                                .find('.tube:last')
                                .after(this);
                        });
                });


                seqlib_candidate_holder
                    .sortable({
                        connectWith: "#seqtemplate_assoc_seqlibs_holder",
                        placeholder: "tube tube-placeholder",
                        revert: true,
                        pointer: "move",
                        opacity: 0.5,
                        helper: "clone",
                        remove: function (event, ui) {
                            // Append close button on sorted seqlib tube
                            //console.log(ui.item.find('button').length);
                            if (!ui.item.find('button').length) {
                                ui.item
                                    .removeClass('tube-inactive')
                                    .addClass('tube-active')
                                    .find('div[class^=col-]:last')
                                    .append('<button type="button" class="tube-close pull-right">' +
                                        '<i class="fa fa-times" aria-hidden="true"></i>' +
                                        '<i class="fa fa-repeat" aria-hidden="true" style="display: none"></i>' +
                                        '</button>')
                                    .find('button.tube-close')
                                    .click(function () {
                                        tubeCloseToggle(this)
                                    });
                            }
                        }

                    });

            })
            /*
             * 通信失敗時の処理
             */
            .fail(function (xhr, textStatus, error) {
            });
    }

    $(document).ready(function () {

        $('[data-toggle="tooltip"]').tooltip();

        $('#seqtemplate_assoc_seqlibs_holder').sortable({
            update: function (event, ui) {
                var item = ui.item.parent();
                var funcSort = function (a, b) {
                    var compA = $(a).text().trim();
                    var compB = $(b).text().trim();
                    return (compA < compB) ? -1 : (compA > compB) ? 1 : 0;
                };
                var listItems = item.children('div').get();
                listItems.sort(funcSort);
                $.each(listItems, function (i, itm) {
                    item.append(itm);
                });

                $('#seqtemplate_assoc_seqlibs_save').prop('disabled', false);
            }
        });

        $('#seqtemplate_assoc_candidate_filter').on('keyup', function (event) {
            var queryStr = new RegExp(event.target.value, 'i');
            //console.log(queryStr);
            tubeFilter(queryStr, '#seqtemplate_assoc_candidate_holder');
        });
        $('#seqtemplate_assoc_seqlibs_filter').on('keyup', function (event) {
            var queryStr = new RegExp(event.target.value, 'i');
            //console.log(queryStr);
            tubeFilter(queryStr, '#seqtemplate_assoc_seqlibs_holder');
        });


        $('#seqtemplate_assoc_seqlibs_save').click(function () {
            var seqtemplate_assoc_seqlibs_holder = $('#seqtemplate_assoc_seqlibs_holder');
            var new_seqlib_id_array = seqtemplate_assoc_seqlibs_holder
                .find('.tube-active:not(.tube-inactive)')
                .map(function () {
                    return $(this).attr('id').replace('seqlib_id-', '');
                }).get();
            var del_seqlib_id_array = seqtemplate_assoc_seqlibs_holder
                .find('.tube-inactive:not(.tube-active)')
                .map(function () {
                    return $(this).attr('id').replace('seqlib_id-', '');
                }).get();

            var seqtemplate_id = $('#seqtemplate_id').val();
            $.ajax({
                type: 'POST',
                url: '/ngsLIMS/setting/seqtemplateAssocs/' + seqtemplate_id,
                data: {
                    new_seqlib_id_array: new_seqlib_id_array,
                    del_seqlib_id_array: del_seqlib_id_array
                }
            })
                .done(function (data) {
                    //console.log(data);
                    window.location.reload();  // @TODO It should not be re-loaded.
                });

        });

        $('#pick_form').submit(function (event) {
            showTubeSeqlibsWithSearch(event)
        });
    });
</script>
