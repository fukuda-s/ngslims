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

<ul class="nav nav-tabs">
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=PI', 'PI') }}</li>
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=PJ', 'Project') }}</li>
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=CP', 'Cherry Picking') }}</li>
  <li class="active"><a href="#">Search Picking</a></li>
</ul>

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">
      <h5>Pickup Seqlibs</h5>
    </div>
  </div>
  <div class="panel-body">
    <div class="tube-group">
      <div class="tube-list" id="pickup-holder">
        <div class="row tube" id="unsortable-tube-header">
          <div class="col-md-3 col-sm-10">Sample Name</div>
          <div class="col-md-1 col-sm-2">#used</div>
          <div class="col-md-2">Barcode</div>
          <div class="col-md-2">Protocol</div>
          <div class="col-md-3"></div>
          <div class="col-md-1"></div>
        </div>
      </div>
    </div>
  </div>
</div>
<div class="text-center">
  <i class="fa fa-arrow-up fa-4x"></i>
</div>
<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">
      <h5>Search Seqlibs</h5>
    </div>
  </div>
  <div class="panel-body">
    <div class="row">
      <div class="col-sm-3">
        <form id="search_form" method="post">
          <div class="form-group">
            <label for="search_query">Search Seqlibs</label>
            {{ text_field('search_query', 'size': "30", 'class': "form-control") }}
            {{ hidden_field('step_id', 'value': step.id) }}
          </div>
        </form>
      </div>
    </div>
    <div id="pick_search_result_seqlibs"></div>
  </div>
</div>

<script>
    /**
     * Search and display seqlibs which searched from #search_query
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
            //url: 'showTubeSamples',
            url: '/ngsLIMS/trackerdetails/showTubeSeqlibs',
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

                $pick_search_result_seqlibs = $('#pick_search_result_seqlibs');
                //$('#pick_search_result_samples').html(data);
                $pick_search_result_seqlibs.html(data);

                /*
                 * Add selectable function to seqlib tubes.
                 */
                $pick_search_result_seqlibs
                    .find("#sample-holder")
                    .selectable({
                        cancel: '.sort-handle, .ui-selected',
                        filter: '> .tube'
                    })
                    .sortable({
                        connectWith: "#pickup-holder",
                        placeholder: "tube tube-placeholder",
                        revert: true,
                        pointer: "move",
                        opacity: 0.5,
                        handle: 'div, .sort-handle, .ui-selected',
                        //ヘルパー生成時（ドラッグ時）処理
                        helper: function (e, item) {
                            if (!item.hasClass('ui-selected')) {
                                item.parent().children('.ui-selected').removeClass('ui-selected');
                                item.addClass('ui-selected');
                            }
                            var selected = item.parent().children('.ui-selected').clone();
                            //placeholder用の高さを取得しておく
                            ph = item.outerHeight() * selected.length;
                            item.data('multidrag', selected).siblings('.ui-selected').remove();
                            return $('<li/>').append(selected);
                        },
                        //ドラッグした時にplaceholderの高さを選択要素分取る
                        start: function (e, ui) {
                            //console.log(ph);
                            //console.log(ui.placeholder);
                            ui.placeholder.css({'height': ph});
                        },
                        //ドロップ時処理
                        stop: function (event, ui) {
                            var selected = ui.item.data('multidrag');
                            ui.item.after(selected);
                            ui.item.remove();
                        },
                        remove: function (event, ui) {
                            // Append close button on sorted seqlib tube
                            //console.log(ui.item.find('button').length);
                            //console.log(ui.item.data('multidrag'));
                            ui.item.data('multidrag')
                                .each(function (i, domEle) {
                                    if (!$(domEle).find('button').length) {
                                        $(domEle)
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
                                });

                        }
                    });

                /*
                 * put function to "Show inactive" button.
                 */
                $pick_search_result_seqlibs
                    .find('button#show-inactive-tube').click(function (e) {
                    // @TODO 'Show/Hide Inactive' button should be hidden if .tube-inactive(s) are not exist.
                    if ($(e.target).hasClass('active') == false) {
                        $pick_search_result_seqlibs
                            .find('.tube-inactive')
                            .show('slow');
                        $(e.target)
                            .addClass('active')
                            .text('Hide Inactive');
                    } else {
                        $pick_search_result_seqlibs
                            .find('.tube-inactive')
                            .hide('slow');
                        $(e.target)
                            .removeClass('active')
                            .text('Show Inactive');
                    }

                });
                /*
                 * put function to "Select all" button.
                 */
                $pick_search_result_seqlibs
                    .find('button#select-all').click(function (e) {

                    if ($(e.target).hasClass('active') == false) {
                        $pick_search_result_seqlibs
                            .find('.tube.ui-selectee')
                            .filter(function () {
                                var css_display = $(this).css('display');
                                return css_display != 'none';
                            })
                            .addClass('ui-selected');
                        $(e.target)
                            .addClass('active')
                            .text('Un-select all');
                    } else {
                        $pick_search_result_seqlibs
                            .find('.tube.ui-selectee')
                            .filter(function () {
                                var css_display = $(this).css('display');
                                return css_display != 'none';
                            })
                            .removeClass('ui-selected');
                        $(e.target)
                            .removeClass('active')
                            .text('Select all');
                    }

                });

                /*
                 * Put function to 'Search' form on tube list header.
                 */
                function tubeFilter(queryStr) {
                    $('.tube.ui-selectee')
                        .filter(function () {
                            var css_display = $(this).css('display');
                            var tube_textStr = $(this).text().toString();
                            //console.log(index + ":" + css_display != 'none' && ! queryStr.test(tube_textStr));
                            return css_display != 'none' && !queryStr.test(tube_textStr);
                        })
                        .addClass('tube-hidden');

                    $('.tube-hidden')
                        .filter(function () {
                            var tube_textStr = $(this).text().toString();
                            return queryStr.test(tube_textStr);
                        })
                        .removeClass('tube-hidden');
                }

                $('#tube-filter').on('keyup', function (event) {
                    var queryStr = new RegExp(event.target.value);
                    //console.log(queryStr);
                    tubeFilter(queryStr);
                });

                if (location.search) {
                    var query = $.getUrlVar('q_f');
                    if (query) {
                        $('#tube-filter').val(query);
                        var queryStr = new RegExp(query);
                        //console.log(queryStr);
                        tubeFilter(queryStr);
                    }
                }


                function getPickedSeqlibs() {
                    var seqlibs = [];
                    $('#pick_search_result_seqlibs')
                        .find('.tube.ui-selected')
                        .each(function () {
                            var seqlib_id = this.id.replace("seqlib-id-", "");
                            seqlibs.push(seqlib_id);
                        });

                    //console.log(seqlibs);
                    $('#cherrypick-seqlibs').val(seqlibs);
                    $('#pick_query_hidden').val($('#pick_query').val());
                    $('#tube-filter_hidden').val($('#tube-filter').val());
                    if (seqlibs.length > 0) {
                        return true;
                    } else {
                        return false;
                    }
                }

                $('#pick_result').submit(function () {
                    return getPickedSeqlibs();
                });
            })

            /*
             * 通信失敗時の処理
             */
            .fail(function (xhr, textStatus, error) {
            });
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

    $(document).ready(function () {
        $('#search_form').submit(function (event) {
            showTubeSeqlibsWithSearch(event)
        });

        $('#mixup-seqlibs-button').prop('disabled', true);

        $('#pickup-holder').sortable({
            items: '> [id!="unsortable-tube-header"]',
            update: function (event, ui) {
                var item = ui.item.parent();
                var funcSort = function (a, b) {
                    var compA = $(a).text().trim();
                    var compB = $(b).text().trim();
                    return (compA < compB) ? -1 : (compA > compB) ? 1 : 0;
                };
                var listItems = item.children('div[id!="unsortable-tube-header"]').get();
                listItems.sort(funcSort);
                $.each(listItems, function (i, itm) {
                    item.append(itm);
                });

                $('#mixup-seqlibs-button').prop('disabled', false);
            }
        });

        /*
         * If URL has #pi_user_id_ then open collapsed panel-body
         */
        if (location.search) {
            var query = $.getUrlVar('q');
            if (query) {
                $('#search_query').val(query);
                $('#pick_form').submit(); //showTubeSeqLibsWithSearch()が実行される
            }
        }


    });
</script>
