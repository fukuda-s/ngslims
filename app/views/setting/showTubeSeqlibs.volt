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

<div class="tube-group">
  <div class="tube tube-header" style="margin: 2px 0 2px 0 !important;">
    <div class="row">
      <div class="col-md-8 col-sm-10">Seqlib Name</div>
      <div class="col-md-1 col-sm-2">#used</div>
      <div class="col-md-3">Barcode</div>
    </div>
  </div>
  {% for seqlib in seqlibs %}
    {% if loop.first %}
      <div class="tube-list" id="seqlib_candidate_holder" style="max-height: 400px;overflow-y: scroll;">
    {% endif %}
    <div
        class="tube {% if seqlib.se.status == '' %}tube-active{% else %}tube-inactive{% endif %}"
        id="seqlib_id-{{ seqlib.sl.id }}" style="margin: 2px 0 2px 0 !important;">
      <div class="row">
        <div class="col-md-8 col-sm-10">
          {{ seqlib.sl.name }}
        </div>
        <div class="col-md-1 col-sm-2">
          {{ seqlib.sta_count }}
        </div>
        <div class="col-md-3" data-toggle="tooltip" data-placement="right" title="{{ seqlib.pt.name }}">
          {% if seqlib.sl.oligobarcodeA_id is empty %}
            (Undefined)
          {% elseif seqlib.sl.oligobarcodeB_id is empty %}
            {{ '(' ~ seqlib.sl.OligobarcodeA.name ~ ' : ' ~ seqlib.sl.OligobarcodeA.barcode_seq ~ ')' }}
          {% else %}
            {{ '(' ~ seqlib.sl.OligobarcodeA.name ~ '-' ~ seqlib.sl.OligobarcodeB.name ~ ' : ' ~ seqlib.sl.OligobarcodeA.barcode_seq ~ '-' ~ seqlib.sl.OligobarcodeB.barcode_seq ~ ')' }}
          {% endif %}
        </div>
      </div>
    </div>
    {% if loop.last %}
      </div>
    {% endif %}
    {% elsefor %} No seqlibs are recorded
  {% endfor %}
</div>
<script>
  $(document).ready(function () {
    $('[data-toggle="tooltip"]').tooltip();
  });
</script>