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
  <div class="row tube">
    <div class="col-md-3 col-sm-10">Sample Name</div>
    <div class="col-md-1 col-sm-2">#used</div>
    <div class="col-md-2">Barcode</div>
    <div class="col-md-2">Protocol</div>
    <div class="col-md-3">
      <!--
      <button type="button" class="btn btn-default btn-xs" id="show-inactive-tube"
              style="max-height: 25px; min-width: 87px">Show Inactive
      </button>
      <input id="tube-filter" type="search" class="form-control input-xs" placeholder="Filtering Search">
      -->
      {{ text_field('tube-filter', 'class': "form-control input-sm", 'placeholder': 'Search Seqlibs') }}
    </div>
    <div class="col-md-1">
      <button type="button" class="clearfix btn btn-default btn-sm pull-right" id="select-all">Select All</button>
    </div>
  </div>
  {% if seqlibs|length > 300 %}
    <div class="alert alert-danger" role="alert">
      {{ seqlibs|length }} of seqlibs. Too long!
    </div>
  {% else %}
    {% for seqlib in seqlibs %}
      {% if loop.first %}
        <div class="tube-list" id="sample-holder">
      {% endif %}
      <div
          class="tube
          {% if seqlib.se.status === 'Completed' and seqlib.sta_count == 0 %}
            tube-active
          {% else %}
            tube-inactive
          {% endif %}"
          {% if seqlib.sta_count == 0 or search_query %}
            style=""
          {% else %}
            style="display: none;"
          {% endif %}
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
  {% endif %}
</div>