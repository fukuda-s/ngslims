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
    <div class="col-md-9">Seqtemplate Name</div>
    <div class="col-md-2"></div>
    <div class="col-md-1 text-right"># used</div>
    <div class="clearfix"></div>
  </div>
  <div class="tube-list" style="max-height: 400px;overflow-y: scroll;">
    {% for seqtemplate in seqtemplates %}
      <div
          class="tube {% if seqtemplate.se.status == '' %}tube-active{% else %}tube-inactive{% endif %}"
          id="seqtemplate_id-{{ seqtemplate.st.id }}" style="margin: 2px 0 2px 0 !important;">
        <div class="col-md-9">
          {{ seqtemplate.st.name }}
        </div>
        <div class="col-md-2">
          {{ text_field('apply_conc_seqtemplate_id-' ~ seqtemplate.st.id, 'class': 'form-control input-xs', 'style': 'display: none;' ) }}
        </div>
        <div class="col-md-1 text-right">
          <span class="badge">{{ seqtemplate.sl_count }}</span>
        </div>
      </div>
      {% elsefor %} No seqtemplates are recorded
    {% endfor %}
    {% for control in controls %}
      <div class="tube tube-placeholder" id="control_id-{{ control.id }}" style="margin: 2px 0 2px 0 !important;">
        <div class="col-md-9">
          {{ control.name ~ ' (Control Lane)' }}
        </div>
        <div class="col-md-2">
          {{ text_field('apply_conc_control_id-' ~ seqtemplate.st.id, 'class': 'form-control input-xs', 'style': 'display: none;' ) }}
        </div>
        <div class="col-md-1 text-right">
          <span class="badge"></span>
        </div>
      </div>
    {% endfor %}
  </div>
</div>
