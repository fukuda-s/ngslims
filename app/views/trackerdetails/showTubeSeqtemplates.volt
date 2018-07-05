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
  <div class="tube tube-header">
    <div class="row">
      <div class="col-md-4">Lane #</div>
      <div class="col-md-4">Seqtemplate Name</div>
      <div class="col-md-4"></div>
    </div>
  </div>
  {% for seqlane_index in seqlane_indexes %}
  {% set seqlane = seqlanes[seqlane_index] %}
  {% if loop.first %}
  <div class="tube-list" id="seqlane-holder">
  {% endif %}
  {% if seqlane is empty %}
    <div class="tube tube-empty">
  {% elseif seqlane.sl.is_control == 'Y' %}
    <div class="tube tube-empty" id="seqlane-tube-seqlane-id-{{ seqlane.sl.id }}">
  {% else %}
    <div class="tube tube-active" id="seqlane-tube-seqlane-id-{{ seqlane.sl.id }}"
         onclick="showPopoverTableSeqlibs(this, {{ seqlane.st.id }}, '{{ seqlane.st.name }}', {{ seqlane.sl.id }})">
  {% endif %}
      <div class="tube-heading">
        <div class="row">
          <div class="col-md-4">
            {{ seqlane_index + 1 }}
          </div>
          <div class="col-md-8">
            {% if seqlane is empty %}
              n/a
            {% elseif seqlane.sl.is_control == 'Y' %}
              {{ seqlane.ct.name }}
            {% else %}
              {{ seqlane.st.name }}
            {% endif %}
          </div>
        </div>
     </div>
    </div>
  {% if loop.last %}
  </div>
  {% endif %}
  {% elsefor %} No seqtemplates are recorded
  {% endfor %}
</div>