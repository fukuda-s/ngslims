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

<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Oligobarcodes</li>
    </ol>
    {{ flashSession.output() }}

    {% include 'partials/handsontable-toolbar.volt' %}

    <div id="handsontable-editOligobarcodes-body" style="overflow: scroll"></div>
  </div>
</div>
<script>
    /*
     * Construct Handsontable
     */
    // Make handsontable renderer and dropdown lists
    var oligobarcodeSchemeAr = [];
    var oligobarcodeSchemeDrop = [];

    $(document).ready(function () {

        function getOligobarcodeSchemeAr(data) {
            //console.log("stringified:"+JSON.stringify(data));
            var parseAr = JSON.parse(JSON.stringify(data));
            //alert(parseAr);
            $.each(parseAr, function (key, value) {
                //alert(value["id"]+" : "+value["name"]);
                var oligobarcode_scheme_id = value["id"];
                var oligobarcode_scheme_name = value["name"];
                oligobarcodeSchemeAr[oligobarcode_scheme_id] = oligobarcode_scheme_name;
                oligobarcodeSchemeDrop.push(value["name"]);
            });
        }

        $.getJSON(
            '{{ url("oligobarcodeschemes/loadjson/") }}',
            {},
            function (data, status, xhr) {
                getOligobarcodeSchemeAr(data);
            }
        );

        (function (Handsontable) {
            function barcodeSeqRenderer(instance, td, row, col, prop, value, cellProperties) {
                var escaped = Handsontable.helper.stringify(value);
                td.innerHTML = escaped;
                td.className = "barcode-seq";

                return td;
            }

            Handsontable.renderers.registerRenderer('barcodeSeqRenderer', barcodeSeqRenderer);

            function oligobarcodeSchemeRenderer(instance, td, row, col, prop, value, cellProperties) {
                var escaped = Handsontable.helper.stringify(value);
                var oligobarcodeSchemeStr = oligobarcodeSchemeAr[escaped];
                if (oligobarcodeSchemeStr !== undefined) {
                    td.innerHTML = oligobarcodeSchemeAr[escaped];
                } else {
                    td.innerHTML = escaped;
                }

                return td;
            }

            Handsontable.renderers.registerRenderer('oligobarcodeSchemeRenderer', oligobarcodeSchemeRenderer);

            function activeRenderer(instance, td, row, col, prop, value, cellProperties) {
                var escaped = Handsontable.helper.stringify(value);
                td.innerHTML = escaped;
                if (escaped === 'N') {
                    td.style.background = '#f2dede';
                }

                return td;
            }

            Handsontable.renderers.registerRenderer('activeRenderer', activeRenderer);

        })(Handsontable);

        /*
         * Integrate 'changes' on handsontable, because editor can change same cell at several times.
         */
        var isDirtyAr = Object();

        function integrateIsDirtyAr(changes) {
            //for (var i = 0; i < changes.length; i++) {
            $.each(changes, function (key, value) {
                if (value) {
                    var rowNumToChange = value[0];
                    var columnToChange = value[1];
                    var valueChangeTo = value[3];
                    var rowData = hot.getDataAtRow(rowNumToChange);
                    var oligobarcode_id = rowData[0];
                    if (!oligobarcode_id) {
                        oligobarcode_id = 10000000 + rowNumToChange;
                    }
                    if (!isDirtyAr[oligobarcode_id]) {
                        isDirtyAr[oligobarcode_id] = Object();
                    }
                    isDirtyAr[oligobarcode_id][columnToChange] = valueChangeTo; //Over write isDirtyAr with current changes.
                }
            });
            //console.log(isDirtyAr);
            //console.log(changes);
        }

        // Construct handsontable
        //var $container = $("#handsontable-editSeqlibs-body");
        var $container = document.getElementById('handsontable-editOligobarcodes-body');
        var $console = $("#handsontable-console");
        var $toolbar = $("#handsontable-toolbar");
        var autosaveNotification = String();

        var hot = new Handsontable($container, {
            licenseKey: 'non-commercial-and-evaluation',
            stretchH: 'all',
            height: 500,
            rowHeaders: false,
            minSpareCols: 0,
            minSpareRows: 1,
            contextMenu: false,
            columnSorting: true,
            manualColumnResize: true,
            manualRowResize: true,
            autoColumnSize: true,
            fixedColumnsLeft: 2,
            currentRowClassName: 'currentRow',
            autoWrapRow: true,
            search: true,
            columns: [
                {data: "id", title: "ID", editor: false, type: 'numeric'},
                {data: "name", title: "Barcode Name"},
                {
                    data: "barcode_seq",
                    title: "Barcode Sequence",
                    renderer: "barcodeSeqRenderer"
                },
                {
                    data: "oligobarcode_scheme_id",
                    title: "Oligobarcode Scheme",
                    //editor: "select",
                    //selectOptions: oligobarcodeSchemeDrop,
                    editor: "dropdown",
                    source: oligobarcodeSchemeDrop,
                    renderer: "oligobarcodeSchemeRenderer"
                },
                {data: "sort_order", title: "Sort Order", type: 'numeric', format: '0'},
                {
                    data: "active",
                    title: "Active",
                    type: "dropdown",
                    source: ['Y', 'N'],
                    renderer: "activeRenderer"
                }
            ],
            afterChange: function (changes, source) {
                if (source === 'loadData') {
                    return; // don't save this change
                }
                else {
                    // Enable "Save", "Undo" link on toolbar above of table
                    // after editting.
                    // alert("afterEdit");
                    $toolbar.find("#save, #undo, #clear").removeClass("disabled");
                    $console.text('Click "Save" to save data to server').removeClass().addClass("alert alert-info");
                    integrateIsDirtyAr(changes);

                    // Show alert dialog when this page moved before save.
                    $(window).on('beforeunload', function () {
                        return 'CAUTION! You have not yet saved. Are you sure you want to leave?';
                    });
                }

                if ($('#handsontable-autosave').find('input').is(':checked')) {
                    clearTimeout(autosaveNotification);
                    $.ajax({
                        url: '{{ url("setting/Oligobarcodes") }}',
                        dataType: "json",
                        type: "POST",
                        data: {changes: isDirtyAr} // returns "data" as all data and "changes" as changed data
                    })
                        .done(function () {
                            $console.text('Autosaved (' + changes.length + ' cell' + (changes.length > 1 ? 's' : '') + ')')
                                .removeClass().addClass("alert alert-success");
                            autosaveNotification = setTimeout(function () {
                                $console.text('Changes will be autosaved').removeClass().addClass("alert alert-success");
                            }, 1000);
                        })
                        .fail(function () {
                            $console.text('Autosaved (' + changes.length + ' cell' + (changes.length > 1 ? 's' : '') + ') is Failed')
                                .removeClass().addClass("alert alert-danger");
                        });
                }

            }
        });

        function loadData() {
            $.ajax({
                url: '{{ url("oligobarcodes/loadjson") }}', //0 is step_id (not indicate in this case.
                dataType: 'json',
                type: 'POST'
            })
                .done(function (data) {
                    //alert(data);
                    //alert(location.href);
                    //console.log(data);
                    //$container.handsontable("loadData", data);
                    hot.loadData(data);
                });
        }

        loadData(); // loading data at first.

        $toolbar.find('#save').click(function () {
            //alert("save! "+handsontable.getData());
            $.ajax({
                url: '{{ url("setting/oligobarcodes") }}',
                data: {changes: isDirtyAr}, // returns all cells
                dataType: 'text',
                type: 'POST'
            })
                .done(function () {
                    //alert(status.toString());
                    $console.text('Save success').removeClass().addClass("alert alert-success");
                    $toolbar.find("#save").addClass("disabled");
                    isDirtyAr = Object(); //Clear isDirtyAr

                    loadData(); //Refresh with saved data.
                    // Disable alert dialog when this page is saved.
                    $(window).off('beforeunload');
                })
                .fail(function (error) {
                    //alert(status.toString());
                    $console.text('Save error').removeClass().addClass("alert alert-danger");
                });
        });

        $toolbar.find('#undo').click(function () {
            // alert("undo! "+handsontable.isUndoAvailable()+"
            // "+handsontable.isRedoAvailable())
            hot.undo();
            // $console.text('Undo!');
            if (hot.isUndoAvailable()) {
                $toolbar.find("#undo").removeClass("disabled");
            } else {
                $toolbar.find("#undo").addClass("disabled");
            }

            if (hot.isRedoAvailable()) {
                $toolbar.find("#redo").removeClass("disabled");
            } else {
                $toolbar.find("#redo").addClass("disabled");
            }
        });

        $toolbar.find('#redo').click(function () {
            // alert("redo! "+handsontable.isUndoAvailable()+"
            // "+handsontable.isRedoAvailable());
            hot.redo();
            // $console.text('Redo!');
            if (hot.isUndoAvailable()) {
                $toolbar.find("#undo").removeClass("disabled");
            } else {
                $toolbar.find("#undo").addClass("disabled");
            }

            if (hot.isRedoAvailable()) {
                $toolbar.find("#redo").removeClass("disabled");
            } else {
                $toolbar.find("#redo").addClass("disabled");
            }
        });

        $toolbar.find('#clear').click(function () {
            loadData();
            $toolbar.find("#save, #undo, #redo, #clear").addClass("disabled");
            $console.text('All changes is discarded').removeClass().addClass("alert alert-success");
            // Disable alert dialog when this page is cleard.
            $(window).off('beforeunload');
        });


        $('#handsontable-autosave').find('input').click(function () {
            if ($(this).is(':checked')) {
                $console.text('Changes will be autosaved').removeClass().addClass("alert alert-success");
            }
            else {
                $console.text('Changes will not be autosaved').removeClass().addClass("alert alert-warning");
            }
        });

        /*
         * Set up search function.
         */
        var searchFiled = document.getElementById('search_field');
        Handsontable.dom.addEvent(searchFiled, 'keyup', function (event) {
            var queryResult = hot.search.query(this.value);

            console.log(queryResult);
            hot.render();
        });


    });
</script>